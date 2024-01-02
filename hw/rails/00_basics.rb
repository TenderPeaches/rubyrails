# https://guides.rubyonrails.org/getting_started.html

# DL Ruby @ https://rubyinstaller.org/

gem install rails           # specify version
rails new $projectName

require('nothing')          # no need to use require in rails apps, unless: loading files under /lib or gem dependencies that have required: false in gem file

# assume ./bin
ruby rails                  # windows
rails                       # non-windows

rails server                # run server

rails generate controller ControllerName index
rails generate model ModelName field1:field1type field2:field2type ...
rails db:migrate                                                                # to migrate/create db
rails console 
rails routes                # routes overview
rails generate scaffold Shark name:string facts:text    # to generate model & controller

# when routing use article_path in erb files to enforce relative routes
# or better, use link_to (text, url) 

model.save                  # insert model
Model.find(pk)              # select model where id = pk
Model.all                   # select all models, returns ActiveRecord::Relation object

# when a model has all of CRUD operations implemented, it's referred to as a "Resource"

# concerns are modules that can be extended by other modules

# shortcut blocks - rails special
some_array.collect(|obj| obj.name)
some_array.collect(&:name)             # same effect