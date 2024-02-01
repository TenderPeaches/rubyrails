#* What kind of tests are there, and what's the purpose of each?

# The question of framework: RSpec or Minitest?
    # RSpec is the more widely used option

# Different RSpec tests & suggested frequency of use:
    # Model tests - always
    # System tests - always
    # Request/controller tests - rarely
    # Helper tests - rarely
    # View tests - rarely
    # Routing tests - never
    # Mailing tests - never
    # Job tests - never

# System tests are heavy and test complete user workflows by simulating a browser and user inputs
# Model tests are lighter, and should mostly be used for non-trivial model functions
# Controller tests are used situationally:
    # 1) On legacy projects with fat controllers
    # 2) On API applications
    # 3) If system cases are too awkward/expensive for a given scenario
# Helper tests are proportional to the use of Helpers overall
# View tests/routing tests should be caught by system tests
# Jobs, mailing sohuld be simple enough on their own to not warrant tests

#* What are all the Rails testing tools?

# RSpec
    # Testing framework
    # Most popular for testing projects

# FactoryBot
    # Concept of generating test data
    # Fixtures use YAML file with hardcoded data, translated into DB records, used, then deleted
    # Factories generate data specifically for each test, the data is inserted before and deleted after each test
    # Factories are recommended

# Capybara
    # Library that uses Ruby to wrap a driver (usually Selenium) in order to simulate user input

# VCR
    # Captures 3rd party responses and uses them to run deterministic local tests

# WebMock
    # Enforce that the tests don't make any network requests

#* RSpec vs Minitest

# They differ syntaxically but don't differ much mechanically

#* How to make testing a habit?

# Testing indulges laziness:
    # The alternative is to manually test everything, or let stuff break and have the users find out
# Testing indulges fear:
    # Fear of failure, of reputation loss, of wage loss

#* Application setup for testing

gem_group :development, :test do
    gem 'rspec-rails'           # RSpec for Rails
    gem 'factory_bot_rails'     # FactoryBot for rails
    gem 'capybara'              # For system tests
    gem 'webdrivers'            # To keep Selenium drivers up to date
    gem 'faker'                 # To help with generated test data in edge cases
end

# only generate the tests that are used so as to avoid clutter
initializer 'generators.rb', <<-CODE
Rails.application.config.generators do |g|
g.test_framework :rspec,
fixtures: false,
view_specs: false,
helper_specs: false,
routing_specs: false,
request_specs: false,
controller_specs: false
end
CODE

# add RSpec config files
#> rails g rspec:install