@ignore
Feature: Hooks

    Background: hooks
        * def result = call read('classpath:helpers/Dummy.feature')
        * def username = result.username

        #after hooks
        # * configure afterScenario = function(){karate.call('classpath:helpers/Dummy.feature')}

    Scenario: First Scenario
        * print username
        * print 'This is first scenario'

    Scenario: Second Scenario
        * print username
        * print 'This is second scenario'