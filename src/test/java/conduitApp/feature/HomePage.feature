
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
    # And match response == {"articles": "#[10]", "articlesCount": 16}
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
            "createdAt": "#? timeValidator(_)",
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

Scenario: Conditional logic para darle like al primer artículo
    Given params {limit:10, offset:0}
    Given path 'articles'
    When method Get
    Then status 200

    * def favoritesCount = response.articles[0].favoritesCount
    * def article = response.articles[0]

    # Solo si el contador de favoritos es 0, le da un like
    * if (favoritesCount == 0) karate.call('classpath:helpers/AddLikes.feature', article)

    Given params {limit:10, offset:0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].favoritesCount == 1

Scenario: Retry call
    #en este scenario, va a commprobar 10 veces cada 5 segundos que el artículo 1 tiene al menos 1 corazón(favorito). Para sistemas lentos o inestables.

    * configure retry = { count:10, interval: 5000}

    Given params {limit:10, offset:0}
    Given path 'articles'
    #aquí va la condición
    And retry until response.articles[0].favoritesCount == 1
    When method Get
    Then status 200


Scenario: Sleep call
    #simplemente añade una pausa de 5 segundos para evaluar el test. La función está sacada de la página de Karate (buscando sleep).

    * def sleep = function(pause){ java.lang.Thread.sleep(pause) }

    Given params {limit:10, offset:0}
    Given path 'articles'    
    When method Get
    * eval sleep(5000)
    Then status 200