Feature: Tests para la home page

Background: Definir url
    Given url apiUrl

Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags contains ['YouTube', 'Blog'] //contiene esos tags
    And match response.tags !contains 'avión' //no contiene el tag avión
    And match response.tags == "#array" //comprobar que devuelve un array, no un objeto
    And match response.tags != "#string" //comprobar que no devuelve un string (irrelevante pero por tenerlo como referencia)
    And match each response.tags == "#string" //comprobar que cada valor del array es un string

Scenario: Get 10 articles from the page
    Given params {limit:10, offset:0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles == "#[10]" //comprobar que el tamaño del array devuelto es 10
    And match response.articlesCount == 10 //comprobar que el numero de articulos es 10 (cuidado porque en Postman esta devolviendo un number, no un string, por eso se pone sin comillas)