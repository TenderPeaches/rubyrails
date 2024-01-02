# 4 standard locations to initialize code:
    # config/application.rb
    # environment-specific config files
    # initializers
    # after-initializers

# if application needs to run code before loading Rails itself
    # put above the `require "rails/all"` in `config/application.rb`

# when using config, use public configuration methods
    # e.g. Rails.application.config.action_mailer.options instead of ActionMailer::Base.options

config.after_initialize do
    print "useful to config values set by other initializers"
end

config.asset_host                       # set asset host, useful when CDNs are hosting assets
config.autoload_once_paths              # accepts array of paths from which Rails will load constants
config.cache_classes                    # whether application classes and modules should be reloaded if they change; when true, does not occur
config.cache_store                      # sets which cache store to use
config.beginning_of_week                # sets default beginning of the week, accepts :monday, :sunday, etc.
config.console                          # sets console class used in bin/rails console
config.encoding                         # sets application-wide encoding, defaults to UTF-8
config.file_watcher                     # class used to detect file updates in the filesystem, must conform to ActiveSupport::FileUpdateChecker API
config.filter_parameters                # filter out parameters that shouldn't be shown in the logs like CCs 
config.javascript_path                  # sets path for JS files relative to /app directory
config.log_formatter                    # defines ActiveSupport::Logger::SimpleFormatter used to format the logs
config.log_level                        # sets logger verbosity; defaults to :debug for all envs except production, :info in prod, other options are :warn, :error, :fatal and :unknown
config.logger                           # sets ActiveSupport::TaggedLogging used, defaults to one that outputs in /log
config.middleware                       # sets app middleware
config.rake_eager_load                  # eager load the application when running Rake tasks
config.time_zone                        # sets default timezone

config.credentials.content_path         # lookup path for encrypted credentials
config.credentials.key_path             # lookup path for encryption key

config.force_ssl                        # force all requests to be HTTPS, sets https:// as default protocol
config.ssl_options                      # config options for ActionDispatch::SSL middleware

config.session_store                    # what class used to store session, :cookie_store, :mem_cache_store, custom store or :disabled
    # configured via a method call:
    config.session_store :cookie_store, key: "_your_app_session"


config.assets.css_compressor            # set to 'sass-rails' by default, options are :yui, :sass
config.assets.js_compressor             # can be set to :terser, :closure, :uglifier, :yui
config.assets.gzip                      # true by default, creates gzip'ped versions of compiled assets
config.assets.path                      # paths used to look for the assets, append path to include
config.assets.precompile                # specify additional assets (other than application.css and application.js) to precompile with rake assets:precompile
config.assets.prefix                    # location of precompiled assets, defaults to /assets
config.assets.debug                     # disables concatenation and compression of assets, true in development.rb
config.assets.compile                   # bool to turn on live Sprockets compilation in production

# configuring generators
config.generator do |g|
    g.orm :active_record                # defines which ORM to use
    g.test_framework :test_unit         # which test framework to use
    g.force_plural                      # allows pluralized model names, default to false
    g.helper                            # whether to generate helpers
    g.system_tests                      # defines which integration tool to use to generate integration tests, defaults to :test_unit
    g.resource_controller               # defines which generator to use for generating a controller, defaults to :controller
    g.resource_route                    # whether a resource route definition should be generated or not
    g.scaffold_controller               # which generator to use for generating a scaffold, defaults to :scaffold_controller
    g.template_engine                   # which template engine to use, such as ERB or Haml; defaults to :erb


end