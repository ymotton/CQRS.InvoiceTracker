Feature: Account Management
	In order for users to use the system
	As a user
	I want to be able to register an account

Scenario: Going to the "Register" page
	Given I am on the "/" page
	When I click the "Register" link
	Then I should see the "Register" page show up

Scenario: Creating an account
	Given I am on the "/" page
	When I click the "Register" link
	And I input "validusername" into the "UserName" field
	And I input "valid@email.com" into the "Email" field
	And I input "validpassword" into the "Password" field
	And I input "validpassword" into the "ConfirmPassword" field
	And I click the "Register" button
	Then I should see the "Home Page" page show up
	And I click the "Log Off" link

Scenario: Going to the "LogOn" page
	Given I am on the "/" page
	When I click the "Log On" link
	Then I should see the "Log On" page show up

Scenario: Login On with the newly created account
	Given I am on the "/" page
	When I click the "Log On" link
	And I input "validusername" into the "UserName" field
	And I input "validpassword" into the "Password" field
	And I click the "Log On" button
	Then I should see the "Home Page" page show up
	And I click the "Log Off" link