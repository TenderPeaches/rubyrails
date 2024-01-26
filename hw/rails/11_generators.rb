#> lib/generators/some_generator.rb

class InitGenerator < Rails::Generators::Base
    # generator description accessed with #> rails g init --help
    #! alternatively, use the auto-generated USAGE file
    desc "this generator does something"

    # when generator is invoked, each public method is executed sequentially 
    def create_init_file
        create_file "config/initializers/init.rb", <<~RUBY
            # init content goes here
        RUBY
    end
end

# run as #>rails g init

# alernateively, generators can be created using.. a generator:
#> rails g generator 

# creates the following generator file:
class InitGenerator < Rails::Generators::NamedBase
    # as it inherits from Generators::NamedBase, it expects at least one argument

    # CLI arguments #> rails g init stuff --example "something else"
    class_option :example, type: :string, default: "something"
    # then fetch using options:
    @example = options[:example]

    # points to the location of templates, if any
    source_root File.expand_path("templates", __dir__)
end
  
# to resolve a generator name like rails g initializer, rails tries to load each of the following until it is found:
#> rails/generators/initializer/initializer_generator.rb
#> generators/initializer/initializer_generator.rb
#> rails/generators/initializer_generator.rb
#> generators/initializer_generator.rb
# if none is found, error is raised
# since /lib is in $LOAD_PATH, the generators there are found by this process

# when resolving template files, Rails will look in many places including #> lib/templates

# when creating .erb templates, need to escape <% %> with double %%s:
<%% @<%= plural_table_name %>.count %> # which should result in #> <% @posts.cont %>

# built in generators can be configured and overridden via config.generators
# see https://stackoverflow.com/questions/32384713/override-rails-scaffold-generator

