
Feature: Tests para la home page

Background: Definir url
    Given url apiUrl

Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    # And match response.tags contains ['YouTube', 'Blog'] //contiene esos tags
    # And match response.tags !contains 'avión' //no contiene el tag avión
    # And match response.tags contains any ['Zoom', 'GitHub', 'Twitch'] //contiene al menos alguno (OR)
    # And match response.tags contains only [] Para comprobar que SOLO contiene lo que se especifica
    And match response.tags == "#array" //comprobar que devuelve un array, no un objeto
    And match response.tags != "#string" //comprobar que no devuelve un string (irrelevante pero por tenerlo como referencia)
    And match each response.tags == "#string" //comprobar que cada valor del array es un string

Scenario: Get 10 articles from the page

    * def timeValidator = read('classpath:helpers/timeValidator.js') //para importar el archivo javascript y guardarlo en la variable.

    Given params {limit:10, offset:0}
    Given path 'articles'
    When method Get
    Then status 200
    # And match response.articles == "#[10]" //comprobar que el tamaño del array devuelto es 10
    # And match response.articlesCount == 16 //comprobar que el numero de articulos es 10 (cuidado porque en Postman esta devolviendo un number, no un string, por eso se pone sin comillas)
    # And match response.articlesCount != 500 //comprobar que el número de artículos no es 500
    And match response == {"articles": "#[10]", "articlesCount": 16}
    # And match response == {"articles": "#array", "articlesCount": 16} //comprueba la respuesta, en este caso que articles es un array y articlesCount devuelve 16
    # And match response.articles[6].createdAt contains "2024" //comprobamos que el artículo 7 (posición 6 array) fue creado en 2024 (contiene 2024 en el string)
    # And match response.articles[*].favoritesCount contains 0 //con * no se especifica la posición del array, pero hace que Karate busque en todo el array
    # # And match response.articles[*].author.bio contains null //comprobamos que en cualquiera de los artículos, la biografía del autor es null (no es string, cuidado)
    # And match response..bio contains null //igual que el ejemplo de arriba, pero es un shortcut para paths muy largos. Karate mira el response y encuentra todos los bio, asegurándose de que al menos uno es null
    # And match each response..following == false //verificamos que CADA objeto del array, su "following" es false
    # And match each response..following == "#boolean" //verificamos que devuelve un booleano
    # And match each response..favoritesCount == "#number" //verificamos que devuelve un number
    # And match each response..bio == "##string" //con doble "##" verifica que bio devuelve un string OR null

    
    #Comprobamos que cada artículo no tiene errores comprobando tipos y formatos, todo de una sola vez, sin tanto test individual.
    And match each response.articles == 
    """
    {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": "#array",
            "createdAt": "#? timeValidator(_)", //Esto y lo de abajo se podria comprobar poniendo que es string, pero no es lo correcto porque no comprueba si el formato está bien devuelto.
            "updatedAt": "#? timeValidator(_)",
            "favorited": "#boolean",
            "favoritesCount": "#number",
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": "#boolean"
            }
        }
    """