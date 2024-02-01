runtime_configuration = "information rails cannot determine on its own but is critical for the app to start up and run"
    # tends to be different from one environment to the other (dev, prod, etc.)
    # by default, 3 ways to manage it: UNIX environment, config/database.yml and config/credentials.yml.enc
    # for simplicity and to reduce potential discrepencies, let's use UNIX environment 
    # this means the other files should be removed: config/database.yml and config/credentials.yml.enc
unix_environment = "set of key/value pairs provided from the system to the app"
    # in ruby app, can be accessed via the ENV hash
        # ENV behaves like an hash but it's special and can only contain strings
    # to manage unix environment for a local app, use dotenv https://github.com/bkeepers/dotenv
        # dotenv merges existing UNIX environment with a set of key/values pairs stored in files, like .env.development
    # in gemfile:
    → # All runtime config comes from the UNIX environment
    → # but we use dotenv to store that in files for
    → # development and testing
    → gem "dotenv-rails", groups: [:development, :test]
    # then create .env.development and .env.test which define DATABASE_URL and SECRET_KEY_BASE
    # add to .gitignore: .env (used in all environments), .env.development.local and .env.test.local, since these two might contain secrets
        # add comments to gitignore!

#* bin/setup
    # use this to automate the tasks that might be done manually out of the box, such as db:setup
    # ideally, this shortens the setup workflow to just: DL the codebase, install the DB, run bin/setup
    # this script runs before any of the libraries are loaded, so it must be Ruby-only
    # it won't be accessed/modified frequently, so it needs to be explicit and procedural in its approach

# bin/setup
#!/usr/bin/env ruby
def setup
    log "Installing gems"
    # Only do bundle install if the much-faster
    # bundle check indicates we need to
    system! "bundle check || bundle install"
    log "Installing Node modules"
    # Only do yarn install if the much-faster
    # yarn check indicates we need to. Note that
    # --check-files is needed to force Yarn to actually
    # examine what's in node_modules
    system! "bin/yarn check --check-files || bin/yarn install"
    log "Dropping & recreating the development database"
    # Note that the very first time this runs, db:reset
    # will fail, but this failure is fixed by
    # doing a db:migrate
    system! "bin/rails db:reset || bin/rails db:migrate"
    log "Dropping & recreating the test database"
    # Setting the RAILS_ENV explicitly to be sure
    # we actually reset the test database
    system!({ "RAILS_ENV" => "test" }, "bin/rails db:reset")
    log "All set up."
    log ""
    log "To see commonly-needed commands, run:"
    log ""
    log " bin/setup help"
    log ""
end

# the comments explain the WHY, not the WHAT

#* Route conventions
    # 1) always use canonical routes that conform to Rails defaults, like resource/resources :stuff
    # 2) never configure a route in routes.rb that isn't used 
        # use :only when defining resources
    # 3) user-friendly URLs should be used in addition to canonical routes
        # use redirect in routes.rb
    # 4) favor new resources over custom actions                           
    # 5) be wary of nested routes                                              

# for nested routes, use them only for sub-resources => where the sub-resources are never accessed other than from its parent resources
# the only other valid reason to use them would be for namespacing: a technique to disambiguate resources that have the same name but are used in different contexts

#* View guidelines
    # 1) mark-up all content with semantic HTML, use <div> and <span> to solve layout and styling problems
        # see https://developer.mozilla.org/en-US/docs/Web/HTML
    # 2) build templates around the controller's resource as a single instance variable
    # 3) extract shared components into partials
    # 4) erb is fine

# the exceptions to using a single instace variable matching the controller's resources are:
    # reference data (like enums)
    # authentication details (like current_user)

# guidelines for partials:
    # only use them for re-usable components
    # use locals for parameters, not instance variables
    # don't use layouts as re-usable components

# since there isn't an obvious way to declare locals, there are two means to counteract this:
    # use local_assigns method to test whether a local variable was declared
    # put comments at the top of the partial template containing param name, use, default value and whether it's optional

#* Helper guidelines
    # 1) reduce the number of helpers by properly modeling the domain
    # 2) concentrate helpers on what they do best: producing inline markup and rendering complex partials
    # 3) presenters/decorators can help but they have their own set of problems
    # 4) when generating markup (whether in helpers or not), use Rails APIs to avoid security issues
    # 5) helpers should be tested, but don't over-couple them with the markup that they generate

# a common convention for identifying concerns: any piece of data that doesn't come from the database - it can be aggregated or derived from it
    #! this convention is a bit too broad
# instead, think of what is *meaningful* for users; if a formatted ID or string is meaningful to the user, then it should be part of the model, not part of a view concern

# things that definitely belong in helpers: 
    # rendering complex partials => because render partial: [...] can become difficult to deal with in such cases
    # rendering simple, inline partials => because, on the other hand, render partial: [...] becomes cumbersome for a small component

# the presenter pattern: 
    # 1) controller locates a resource
    # 2) new class wraps around the resource, providing additional methods to render any view concerns based on the resource's data
    # 3) wrapper class is exposed to the view

    # use delegate_missing_to method to delegate methods from the presenter class to the underlying resource

#! to prevent injection attacks in methods that render HTML (like if it outputs user.name and user.name is user-supplied)
    # use content_tag methods, never interpolate or concantenate HTML output
    # if using html_safe, exlpain in comments WHY because it should not be the standard, also serves to warn that it should not be used by default

# helpers need to be tested, with a recommended strategy:
    # 1) render all possible versions of the helper
    # 2) ensure that the string returned is HTML-safe
    # 3) includes key content relevant to the behavior of the helper

#* CSS Gudelines 
# ideally, the growth of CSS should be lower than the growth of the code-base
# to achieve this, 3 things are needed:
    # 1) A desgin system, specifying font sizes, spacings and colors
    # 2) A CSS strategy that implements the design system, while also providing a single mechanism for styling components and re-using them when needed
    # 3) A style guide - living documentation of the design system and CSS strategy

# At its base, a design system is:
    # 1) A small set of font sizes, usually around 8
    # 2) A small set of spacings, usually around 8
    # 3) A finite palette of colors
# it can also contain reusable components such as buttons, form fields or other more complex layouts

# There are three main viable CSS strategies:
    # 1) CSS Framework like Bootstrap
    # 2) Object-Oriented CSS (OOCSS)
    # 3) Functional CSS
# Using semantic CSS is not a recommended system

# CSS Frameworks offer great out-of-the box value, with far less CSS to manage
# On the downside, they are harder to customize for custom layouts

# OOCSS is basically just component-oriented CSS, since CSS obviously has no objects to speak of 
    # common naming strategies involve using default components as a base, and adding modifiers as needed
    # examples are BEM (Block-Element-Modifier) and SMACSS
# It's a great system because it explicitly, presentationally names what everything is while keeping component-specific CSS isolated
    # On the downside, it does require everything to be named, so a lot of decisions are involved
    # An additional strategy is required for re-usable components that are identified as the project and CSS grow
    # To predict how the view will render, you can't just look at the CSS
# End result, a lot of CSS is written

# Funtctional CSS is also known as atomic CSS
    # it's just setting small classes that do a single, predictable thing
    # re-usable components are based on re-usable modules to avoid repeating a string of classes everywhere
# The downsides:
    # Increased volume of helpers
    # For highly-configurable UIs, OOCSS is usually more appropriate
    # For projects with separate front-end and back-end teams, an OOCSS approach is also more practical

# A style guide documents both the design system and CSS strategy
    # It can be just a .txt file but ideally, it should be a full fledged resource accessible in dev only

#* JavaScript Guidelines
# overall strategy:
    # 1) Understand why JavaScript is more of a liability than Ruby
    # 2) Embrace server-rendered views when client-side interactivity is not required
    # 3) Disable remote-forms-by-default and tweak Turbolinks

# JS is a liability because:
    # 1) No control over the runtime environment; it runs on different browsers, on different OS's, on different computers on different networks
        # whereas Ruby code runs on a singular server instance
        # this variability makes JS behavior more difficult to predict
    # 2) JS's behavior is difficult to observe
        # it can be observed locally on the developer's browser through console.log calls and debuggers
        # however, it cannot be observed in production; it only runs on the user's brwosers and we're left with only the API calls to work with
        # thus, bugs are harder to predict, detect and fix
    # 3) The ecosystem favors highly de-coupled modules that favor progress over stability
        # this implies a LOT of different, sometimes small libraries/modules, maintained by different people with different priorities
        # because of dependencies, that means stuff will break often
        # whereas Rails will go to great pains to make updates backwards-compatible, JavaScript doesn't have that mindset by default
# Thus, the best way to manage JS liabilities is by using it as little as possible, only where it is absolutely needed

# This can be done by embracing server-rendered views, ie .erb templates

# The alternative are JAM stacks - JavaScript, API and Markup (think vue.js stuff)
    # JAM apps require state management and offer 3 main benefits, at a heavy cost:
        # 1) Highly interactive UIs are easier to create because everything is in one place
        # 2) Full-fledged apps can be created using only front-end technologies
        # 3) If the entire app uses the JAM stack, there is only a single view technology in use
    # The numerous downsides include:
        # 1) Having to carefully map JSON responses to the input of each front-end component while carefully managing the app state
            # There is no one common standard approach, and tools like Redux can quickly get very complex
        # 2) Require either replicating Rails' form helpers to generate the right markup or abandon them altogether
        # 3) Must provide a custom user experience for fault tolerance because when a JAM application breaks, the default behavior is to do nothing
        # 4) JAM apps cannot be adequately tested without heavy use of browser-based tests
        # 5) Harder to write when doing server-side rendering
        # 6) JavaScript liability issues become much more preponderant 

# Ideally, .erb templates are used everywhere by default
    # JS comes in for features that simply cannot be achieved with server-side templates

# 3 techniques to manage the JS that cannot be avoided:
    # 1) Embrace plain JavaScript as much as possible, especially for basic interactions
    # 2) Use at most one framework and use it for sustainability reasons
    # 3) Unit test JavaScript

# Plain JS is encouraged to reduce the app's overall dependencies, especially given JS's approach to stability
    # When using JS, favor the use of data-* attributes over classes because the former are rarely if ever used for styling, whereas classes are almost always used for styling

#* Test guidelines
# Tests give confidence that the code is working as intended
    # They offer risk mitigation of production-level code failing with a carrying cost 
    # To make sure tests mitigate the right risks and maximize the value they provide, they should be user-focused
        # User-focused: tests the app the way a user would test it
        # Also known as system tests

# Don't assert every single piece of content that should appear
    # rather, find the minimum indicators that the feature providing the value it is supposed to provides

# Recommended strategy: system tests for every major user flow and unit tests for everything else that is important:
    # 1) Don't use a real brwoser for non-JS features; use :rack_test instead
    # 2) Test against markup and content by default
    # 3) Cultivate diagnostic tools to debug test failures
    # 4) Fake the back-end to succeed with front-end tests, then use that test to drive the back-end implementation
    # 5) If markup becomes unstable, use data-testid to locate the elements needed for the test
        # by convention, add data-testid to an element's HTML markup only when markup changes lead to a test failing, so as to not be consistently adding it to every single element
    # 6) Use a real browser for features that use JS

# Use FactoryBot to generate test models

#* Model guidelines
# While models don't necessarily match 1-to-1 with the DB tables, they do, taken altogether, represent the app's data model
    # Use ActiveModel for models that are not linked to a DB table, use ActiveRecord otherwise
# As a rule, there should not be any business logic inside the models
# Instead, there are 3 types of logic that should reside in the models:
    # 1) Additional model configuration such as associations and validations
    # 2) Class methods that query the database and reduce duplication by virtue of being used by multiple other classes
        # Do this if there is a need for this method's logic in more than one place and it is not coupled with business logic
    # 3) Instance methods that define core domain attributes whose values can be directly derived from the DB, without applying any business logic

#* Database guidelines

# Database design considerations:
    # 1) DBs provide much simpler types and validations than the code does
    # 2) Large and/or high-traffic DBs can be hard to change
    # 3) DBs are often consumed by more than 1 app

# Logical model of data: the one users talk about and understand
    # it is a tool of consensus between the devs and the business people
    # requirements are identified, NOT solutions
# Physical model of data: the one that is physically implemented by the database schema
    # identify solutions that satisfy the requirements by drafting a plan of the tables, their columns, indexes, etc.
    # once the plan is drafted, use it as a basis from which to write the migrations that will create the database schema

# Recommended to use an SQL schema format by setting in config/application.rb: #> config.active_record.schema_format = :sql

# Guidelines to plan the physical model:
    # 1) Create a table for each entity of the logical model
    # 2) Add columns to associate related models using foreign keys
    # 3) For each attribute, decide how the requirements will be enforced
    # 4) Create indexes enforcing uniqueness constraints
    # 5) Create indexes for any queries that might be run

# For 3):
    # Use check constraints whenever requirements must be satisfied, see #> add_check_constraint
    # Only rely on code validation when the tables get huge and check constraints become a performance issue
    # There should be test for database constraints that aren't null or unique, as those are trivial to implement

# When applying the physical model, recommended technique to deal with migrations is:
    # Write a small part, apply it, see if it did the right thing, roll it back with #> rails db:rollback
    # This means the final result will be a single migration file

#* Business Logic guidelines

# The code implementing business logic is the most critical and the least stable
    # It thus stands to reason that it must be easy to understand, in order to be easy to change
    # It must be behavior-revealing
# The recommended technique is to have that code act as a seam, implemented through a single class and method from which a given bit of business logic is initiated
    # New logic? New class/method
    # In the end, it's easier to tie together bits of related code than try to split one massive monolith of maybe not-so-tightly related features

# Such classes should be known as #~ services
    # Naming services can be something like a "ThingDoer" with a "do_thing()" method
    
# There are typically 3 types of objects that need to be accessed in order to implement business logic:
    # 1) Rails-managed classes like ActiveRecord classes, ActiveJob, ActiveMailer
    # 2) Data-holding objects like ActiveRecords, ActiveModels
    # 3) Other services
# A significant design decision involves how the code accesses these objects

# Creating a hard dependecy with Rails-managed classes is fine => we are writing a Rails app after all, so this is an acceptable cost
# The data-holding objects should be passed to the method directly
# As for other services, it depends:
    # If the service is always used the same way, refer to it directly
    # If the calling method must configure how/which other services are used, those need to be passed onto the constructor

# Favor returning rich object results over simple booleans or ActiveRecords
    # Rich object results provide better feedback and can be fed more easily to the following bits of logic
    # They can be declared as an internal class to the Service

#! Anti-patterns to avoid:
    # 1) Using class methods instead of instance methods => saves a few keystrokes, but prevents state encapsulation
        # Using a singleton as a middle-ground is maintenance heavy and a concern if multithreading is part of the equation
    # 2) Using a generic method name (because the class name already implies what the method does) => prevents other methods from being added if necessary
    # 3) Dependency injection: passing *all* needed arguments to the class itself, rather than to the method being called => obscures reality, whereas some bits of business logic sould be hard-wired to some data, rather than being left to the whims of the caller method

#* Model guidelines, pt2 (Validations, scopes, callbacks)

# Remember that validations do *not* provide reliable data integrity:
    # The DB could be accessed directly, or through other apps, bypassing the Rails validation process
    # Validations can be turned off when saving data in Rails itself
    # Some validations are inherently unreliable, like validates_uniqueness_of which is notoriously vulnerable to race conditions
# What validations do provide is constructive feedback to the user when they input invalid data
    # Since validations tend to include business logic, this breaks the "no business logic in ActiveRecords/Models"
    # However, since the alternative is building a new alternative to Rails Validations API from the ground up, it is a trade-off worth doing

# When using a service layer as a means to implement business logic, callbacks seldom are necessary
# There are two common scenarios where they can be useful:
    # 1) Normalizing data
    # 2) Managing cross-cutting operational concerns regarding database access, like tracking DB activity in production by logging stuff 

# Scopes are also business logic and, as such, should belong elsewhere than within the ActiveRecord classes
    # They can be defined in services, or as a standalone service in itself

# Testing on models can occur in different scenarios:
    # 1) Database cosntraint tests belong to the corresponding ActiveRecord class
    # 2) Complex validations

# There should be an ability to reliably and realistically produce test instances of any given model
    # Recommend using FactoryBot

#* Controller guidelines
# 4 sustainability issues arise with the use of Controllers:
    # 1) The structure is unlike anything else - it's not objet-oriented, functional or procedural
    # 2) Overuse of callbacks can spread code unnecessarily and makes it harder to understand and change
    # 3) Perfect place to insulate downstream business logic from the Rails-API-exposed HTML requests
    # 4) Unit tests of controllers are often duplicative of tests in other parts of the system

# Controllers should be thought of as configuration interfaces, which help in keeping business logic out of them
    # Callbacks have their purpose, but more often they should just be implemented as private methods instead, if only because they are easier to manage and understand
    # What callbacks are a great tool for is managing duplicate code that's both not specific to any given method *and* is needed in many controllers, such as authenthication, authorization and error handling (using the rescue_from callback)

# Controllers should convert parameters to richer types, as they are the ones receiving the HTML request params as a hash of strings
    # They are in the perfect position to convert these strings into the types that are expected by the business logic

# Ideally, in the name of not over-testing (or maximizing the value of tests), there should not be any controller tests, as they should be already covered by system tests
    # However, if operations like type conversions are happening and start to become complex, they could become a good candidate for testing

#* Jobs guidelines

# Jobs are code executions that fall outside of the typical web request/response cycle
# There can be a few reasons for this:
    # 1) A batch process needs to be run on a given schedule
    # 2) Moving non-critical code to outside the request/response cycle
    # 3) Encapsulate flaky code (usually due to physical factors, like long-distance network requests) that might need several retries in order to succeed

# Quick word about Puma, web workers, pools, etc.
# How it all works:
    # Puma (the web server) receives a request
    # Puma allocates a worker to handle the request
        # This worker can only work on that request until a response is sent
        # These workers are kept in a worker pool, whose size is limited due to CPU constraints
        # If no workers are available, the server either returns a 503 or waits for a worker to be free, causing a slow response

# Good targets for background jobs include 3rd party requests and external network calls, both of which can be notoriously slow

# Job Queuing isn't inherent to ActiveJob, so a gem must be used
    # It's important to understand how that gem works
    # Recommended is Sidekiq
# In fact, ActiveJob seems to have more of a purpose when building libraries, so it shouldn't be used unless there's a very good reason to
    # (!) confirm if this is still the case for Rails 7

# Jobs themselves shouldn't be tested, but whatever process is calling them should be

#* Mailer guidelines

    # 1) Understand the purpose of a mailer and avoid putting business logic in it: it's job is strictly to render an email given some data that is passed to it
    # 2) Mailers are usually jobs or rather, they should be jobs, using deliver_later instead of deliver_now
    # 3) Test mailers using built-in previews found in #> test/mailers/previews

# Use MailCatcher to test emails in development

#* Rake guidelines

# Rake allows for code to be run without being triggered by a web view
    # They can be run manually, unlike scheduled jobs 

# 2 issues arise from their use:
    # 1) Naming/organisation
    # 2) Code

# Organisation guidelines:
    # 1) Create a directory structure in lib/tasks that exactly matches the namespaces 
    # 2) Name the actual file with the name of the task, and keep it to 1 task per file
    # 3) Name the task explicitly
    # 4) Use `desc` to explain what the task does

# Rake tasks can trigger business logic but they should not contain any themselves

#* Authentication/Authorization guidelines

# Don't DIY, use Devise or OmniAuth
    # Devise: Website-specific auth
    # OmniAuth: Google-backed 3rd party login system

# For Authorization:
# Mapping roles can quickly become complex
    # Recommended strategy for a corporate setting is to set a role for each job title & department
    # Use Cancancan gem
        # for simple authorization `authorize!`
        # better method, using `authorize_resource` and `Ability` classes
        # use `can?` to check access
        # avoid advanced features and those that conflate database lookups with access checks
        # avoid using dynamic, implicit concepts in Ability class, use functional decomposition via private methods

# Typically, in ApplicationController, have:
    def current_user { @current_user ||= User.find_by_id(id: session[:user_id]) } end

# Test access controls with system tests
        # Test all authentication flows
        # Especially test access controls to actions that:
            # are heavily restricted
            # are untraceable
            # are important/impactful

# To make testing easier:
    # Have a variety of test users that can be created through a single line of code
        # Use Factories to be able to easily create any user of any role
    # Cultivate re-usable test code to setup for authorization-related tests
        # Extract patterns when they start to repeat themselves in test setups

#* JSON API guidelines

# 1) Be clear on what - and who - the API/JSON endpoint is for
# 2) Be resource-oriented and use canonical routes for the JSON API
# 3) Use the simplest mechanisms for authentication, content negotiating and versioning
# 4) Use Rails default serialization as much as possible
# 5) Test the API with an integration test

#* Sustainable processes and workflows

# 1) Use continuous integration, which usually refers to a system that runs all checks and tests of every branch pushed to a central repository
    # A CI flow typically goes:
        # 1. Create a branch with new changes
        # 2. Have `bin/ci` execute on the new branch
        # 3. Do code reviews
        # 4. Once both are OK, merge with main branch

# 2) Run frequent dependency updates
    # Run `bundle update` every month or so
    # Fix everything
    # Enjoy being up to date!

    # Suggested versioning policy:
        # Use only the latest two minor versions of Ruby, plan time in January for updates
        # Use only the latest two versions of Rails
            # In gemfile, specify a pessimistic version contraint for Rails so `bundle update` doesn't suddenly update Rails
        # Use only the latest two versions of node.js
        # For as many dependencies as possible, do not specify a version
        # For Node modules, do the same except for packages that require specific version of Rails, like Webpack or Turbolinks
        # For any gem that uses a particular version, write a comment in the Gemfile to explain why
        # For node modules that must use a particular version, put the comments in the app's README to get around json's lack of comments
    
    # Automate dependency updates!

# 3) Use generators, especially when documentation might be complicated
    # Drawbacks include:
        # Poor error-handling, must test generators for them to be reliable
        
