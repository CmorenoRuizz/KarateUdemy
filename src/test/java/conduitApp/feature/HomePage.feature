Feature: Tests para la home page

Scenario: Get all tags
    Given url 'https://conduit-api.bondaracademy.com/api/tags'
    When method Get
    Then status 200

Scenario: Get 10 articles from the page
    Given params {limit:10, offset:0}
    Given url 'https://conduit-api.bondaracademy.com/api/articles'
    When method Get
    Then status 200