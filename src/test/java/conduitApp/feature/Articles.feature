Feature: Articles

Background: Definir url
    Given url 'https://conduit-api.bondaracademy.com/api/'

Scenario: Crear nuevo artículo
    Given path 'users/login'
    And request {"user": {"email": "zanahorio@karate.com","password": "vf3hUL@fMpL6U3N"}} //body del método post (cuidado con el formateo al pegar, hay que ponerlo en línea...)
    When method Post
    Then status 200
    * def token = response.user.token //define una variable para guardar la información del token de inicio de sesión para usarlo más tarde, con '* def'

    Given header Authorization = 'Token ' + token //igual que al crear el articulo en postman, se necesitaba un header con 'token ' + valor del token para ser autorizados
    Given path 'articles'
    And request {"article": {"title": "postman3","description": "sfasfsaf","body": "fsafasfsaf","tagList": []}} //body necesario para crear el articulo, como en Postman (formateo...)
    When method Post
    Then status 201
    And match response.article.title == 'postman3' //debe ser unico por ahora o da error por el diseño de la api, hasta que se pueda hacer con un generador aleatorio
