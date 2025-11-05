@debug2
Feature: Sign Up new user

Background: Precondición
    # Define la URL base para todas las peticiones en este 'feature'.
    # 'apiUrl' es una variable global definida en 'karate-config.js'.
    
    #para importar el archivo java con la libreria maven de "java faker"
    * def dataGenerator = Java.type('helpers.DataGenerator')

    Given url apiUrl

# --- EJEMPLO ANTIGUO (Hardcodeado) ---
# Este es el método antiguo, con el JSON en una sola línea.
# Es menos legible y más difícil de mantener.

# Scenario: New user Sign Up
#     Given path 'users'
#     And request {"user": {"email":"zanahoriopostman1@karate.com","password":"K!HP3xz7UXgsLn9","username":"zanahoriopostman1"}}
#     When method Post
#     Then status 201
# --- FIN EJEMPLO ANTIGUO ---


Scenario: New user Sign Up
    # --- PASO 1: DEFINIR LOS DATOS ---
    # Define una variable 'userData' que contiene un objeto JSON.
    # Esto es una buena práctica para separar los datos de la prueba (el 'qué')
    # de la lógica de la prueba (el 'cómo').
    # Given def userData = {"email":"zanahoriopostman3@karate.com","username":"zanahoriopostman3"}

    #variables para generar random email y random username
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()

    # --- PASO 2: CONSTRUIR LA PETICIÓN ---
    # Establece la ruta de la API que se añadirá a la 'apiUrl' del Background.
    Given path 'users'
    # 'request' indica que el siguiente bloque es el 'body' o 'payload' de la petición.
    # Se usan triples comillas (""") para definir un 'string multi-línea'.
    # Esto te permite escribir el JSON de forma legible, tal como se vería en un editor.
    And request
    """
        {
            "user": {
                "email": #(randomEmail),
                "password": "K!HP3xz7UXgsLn9",
                "username": #(randomUsername)
            }
        }
    """
    # --- PASO 3: EJECUTAR Y VALIDAR ---
    # Ejecuta la petición HTTP con el método POST.
    When method Post
    # Valida que el código de estado de la respuesta del servidor sea 201 (Created).
    Then status 201

    #validación del json
    And match response == 
    """
    {
        "user": {
            "id": "#number",
            "email": #(randomEmail),
            "username": #(randomUsername),
            "bio": null,
            "image": "##string",
            "token": "#string"
        }
    }
    """