Feature: Tests para la home page

Background: Definir url
    Given url 'https://conduit-api.bondaracademy.com/api/'

Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200

Scenario: Get 10 articles from the page
    Given params {limit:10, offset:0}
    Given path 'articles'
    When method Get
    Then status 200