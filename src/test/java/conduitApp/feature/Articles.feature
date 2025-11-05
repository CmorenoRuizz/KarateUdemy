Feature: Articles

Background: Definir url
    Given url apiUrl

    # Given path 'users/login'
    # And request {"user": {"email": "zanahorio@karate.com","password": "vf3hUL@fMpL6U3N"}} //body del método post (cuidado con el formateo al pegar, hay que ponerlo en línea...)
    # When method Post
    # Then status 200
    # * def token = response.user.token //define una variable para guardar la información del token de inicio de sesión para usarlo más tarde, con '* def'



    # Llama a 'CreateToken.feature' UNA SOLA VEZ (callonce) para obtener el token de autenticación.
    # Pasa las credenciales (email y password) como argumentos al feature llamado.
    # Guarda la respuesta completa devuelta por CreateToken.feature en la variable 'tokenResponse'.
    # * def tokenResponse = callonce read('classpath:helpers/CreateToken.feature') {"email": "zanahorio@karate.com","password": "vf3hUL@fMpL6U3N"}

    # Ya no es necesario porque lo hemos configurado en karate-config.js
    # * def tokenResponse = callonce read('classpath:helpers/CreateToken.feature')

    # Extrae el valor de la variable 'authToken' (definida dentro de CreateToken.feature)
    # de la respuesta guardada en 'tokenResponse', y lo almacena en la variable 'token'
    # para poder usarla en los escenarios de este feature (Articles.feature). 
    # Ya no es necesario porque lo hemos configurado en karate-config.js
    # * def token = tokenResponse.authToken

@ignore
Scenario: Crear nuevo artículo
    
    # aquí iba el login antes pero se ha subido arriba para poder ser reutilizado más adelante

    Given header Authorization = 'Token ' + token //igual que al crear el articulo en postman, se necesitaba un header con 'token ' + valor del token para ser autorizados
    Given path 'articles'
    And request {"article": {"title": "postman3","description": "sfasfsaf","body": "fsafasfsaf","tagList": []}} //body necesario para crear el articulo, como en Postman (formateo...)
    When method Post
    Then status 201
    And match response.article.title == 'postman3' //debe ser unico por ahora o da error por el diseño de la api, hasta que se pueda hacer con un generador aleatorio


Scenario: Crear y borrar un artículo

    #Configuramos la cabecera Authorization una sola vez para todo el escenario. Ya no es necesario porque lo hemos configurado en karate-config.js
    # * configure headers = { Authorization: '#("Token " + token)' }

    
    #Creamos el artículo
    
    # Given header Authorization = 'Token ' + token
    Given path 'articles'
    And request {"article": {"title": "Bla bla","description": "más blabla","body": "contenido del body","tagList": []}}
    When method Post
    Then status 201
    * def articleId = response.article.slug //variable para usar porque el valor de slug es requerido en el path para borrar el artículo

    
    #Comprobamos que el artículo se ha creado correctamente mediante el título
    
    # Given header Authorization = 'Token ' + token
    Given params {limit:10, offset:0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title == 'Bla bla'

    
    #Borrar el artículo
    
    # Given header Authorization = 'Token ' + token
    Given path 'articles',articleId
    When method Delete
    Then status 204

    
    #Comprobamos que el artículo ha sido borrado correctamente, es la manera porque no devolvía información el método Delete
    
    # Given header Authorization = 'Token ' + token
    Given params {limit:10, offset:0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title != 'Bla bla'