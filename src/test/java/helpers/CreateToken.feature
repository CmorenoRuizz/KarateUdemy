Feature: Crear Token

Scenario: Crear Token login
    Given url 'https://conduit-api.bondaracademy.com/api/'

    Given path 'users/login'
    And request {"user": {"email": "#(email)","password": "#(password)"}}
    When method Post
    Then status 200
    * def authToken = response.user.token