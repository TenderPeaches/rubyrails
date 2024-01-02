rails new App               # create new project App
    # can use --skip-xxx options to lighten the load

rails --help                # list available commands

rails server                # start server
    rails s                 # alias
    rails s -e production   # development environment
    ralis s -p 4000         # set port

rails console               # launches irb console

rails generate              # list available generator methods
    rails g                 # alias
    rails g scaffold        # for generating model, migration, controller, views, resources, routes
    rails g model

    rails g migration

rails db:drop               # deletes the database
    # might need to use rails db:drop:_unsafe if permission denied
rails db:setup              # sets up the database according to schema.rb and seeds.rb  

rails routes                # lists current routes