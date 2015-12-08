@time_freeze
Feature: As a user
  I want to see all commits

Scenario:
  Given I have the following commits
  | Message  | Committer  | Committed At        |
  | message 1| commiter 1 | 2015-12-12 01:12:00 |
  And I am on the commits page
  When I click on 'message 1'
  Then I should see all the following
  | Content             |
  | message 1           |
  | Author committer 1  |
