# router recognizes URLs and dispatches them to a controller's action or a Rack appication
# routes are stored in config/routes.db
    # for instances, checking request 
        # GET /patients/17 
    # matches with route
        # get '/patients/:id', to: 'patients#show'
    # redirects to `PatientsController, using snake_case for controller name
# routes match in the order in which they are declared

# can generate paths with :as option:
get '/patients/:id', to: 'patients#show', as: 'patient'
    # can be referred to as <% link_to 'Patient Record', patient_path(@patient) %>

# resource routing to quickly declare common routes for given resourceful controllers
    # a resourceful route provides a mapping between HTTP verbs and URLs controller actions
    # a single entry for a given resource creates 7 routes:
=begin
    HTTP Verb   || Path             || Controller#Action    || Used for
    GET         || /objs            || objs#index           || show list
    GET         || /objs/new        || objs#new             || show form
    POST        || /objs            || objs#create          || create/save object
    GET         || /objs/:id        || objs#show            || show object
    GET         || /objs/:id/edit   || objs#edit            || show form w/ obj's values
    PATCH/PUT   || /objs/:id        || objs#update          || update/save object
    DELETE      || /objs/:id        || objs#destroy         || delete object
=end

# path helpers offer shortcuts for these actions:
    # objects_path => /objects
    # new_object_path => /objects/new
    # edit_object_path(:id) => /objects/:id/edit
    # object_path(:id) => /objects/:id

    # each helper has a corresponding _url helper which returns the same path prefixed with current host, port and path prefix
        # like `objects_url`
    # if not using resources, use :as to declare route aliases
        # match '/static-events/new', :to => 'static_events#new', :as => :new_static_event

resources :clients, :products, :invoices            # resourceful routes can be batch declared

# singular resources might want to be accessed without requiring an ID 
    # passing a string to :to will expect a `controller#action` format
    # when using a Symbol, replace :to with :action
    # when using a String without a #, replace :to with :controller
        # get 'profile', action: :show, controller: 'users'
resource :singular                                  # difference is literally keyword and reosource name singular

# create namespace to regroup controllers together
namespace :admin do
    resources :articles, :comments
end
    # this will route through /admin/articles

# if don't want namespace in the name, use scope instead
scope module: 'admin' do
    resources :articles, :comments
end
    # this will route through /articles
resources :articles, module: 'admin'                # can also be done on an individual route basis

# if want to route through a prefix, but without a namespace
scope '/admin' do
    resources :articles, :comments
end

# use nested routes for resources that are children of others
resources :clients do 
    resources :projects, :transactions
end
    # will create routes like /clients/:client_id/projects
# although it's possible to nest resources more than one-level deep, a good rule of thumb is to not nest resources more than one-level deep
    
# do shallow nesting instead - build routes with minimal amount of data necessary to ID the resource
resources :articles do
    resources :comments, only: [:index, :new, :create]
end
resources :comments, only: [:show, :edit, :update, :destroy]
    # shorthands
resources :articles do
    resources :comments, shallow: true
end
resources :articles, shallow: true do
    resources :comments
end
shallow do 
    resources :articles do
        resources :comments
    end
end

# routing concerns declare common routes that can be used inside other resources and routes
concern :commentable do
    resources :comments
end
resources :messages, concerns: [:commentable, :loggable]
    # is equivalent to
resources :messages do
    resources :comments
end
# can be used anywhere with `concerns
namespace :article do
    concerns :commentable
end

# adding member routes
resources :photos do
    member do
        get 'preview'   # routes GET /photos/:id/preview to photos#preview (PhotoController action Preview)
    end
end

# adding route to collection
resources :photos do
    collection do
        get 'search'    # routes GET /photos/search to photos#search
    end
    get 'search', on: :collection   # alternative syntax
end

resources :comments do
    get 'preview', on: :new # routes GET /comments/new/preview to comments#preview
end

# specifying controller for resource
resources :photos, controller: 'images'
    #  for namespaced controllers
    resources :user_permissions, controller: 'admin/user_permissions'
# constraints
resources :photos, constraints: { id: /[A-Z][A-Z][0-9]+/ }
# overriding named route helpers
resources :photos, as: 'images'
    resources :photos, path_names: { new: 'make', edit: 'change' }

# restricting HTTP methods
resources :photos, only: [:index, :show]
resources :photos, except: :destroy

# translated paths
scope(path_names: { new: 'neu', edit: 'bearbeiten' }) do
    resources :categories, path: 'kategorien'
end  

# override nested path names
resources :magazines do
    resources :ads, as: 'periodical_ads'
end
    # override named route param
    resources :videos, param: :identifier


# non-resourceful routes
# bound parameters using dynamic segments
get 'photos/:id/:user_id', to: 'photos#show'
    # params[:id], params[:user_id] will be set accordingly in PhotosController action show
    # don't use `:` prefix for static segments, which must appear as-is in the URL
    # QSAs will also appear in params
    # use :default to assign default values to params
        # can use a block for multiple resources
        default format: :json do
            resources :photos, :comments
        end
# use :as to name routes
    # route is `{name}_path`
# use :via to accept multiple HTTP methods
    # via: :all for all HTTP methods
    # avoid routing GET and POST together 
# use :constraints to validate dynamic segments
get 'photos/:id', to: 'photos#show', constraints: { id: /[A-Z]\d{5}/ }
    # or use dynamic segment name directly
    get 'photos/:id', to: 'photos#show', id: /[A-Z]\d{5}/ 
# request-based constraints
get 'photos', to: 'photos#index', constraints: { subdomain: 'admin' }
# alternate block syntax
namespace :admin do
    constraints subdomain: 'admin' do
      resources :photos
    end
end
# advanced constraints can be made by using objects that define method `matches?`

# route globbing
get 'photos/*other', to: 'photos#unknown'
    # sets params[:other] to {whatever/is/in/the/URL} (wildcard segments)

# redirection
get '/stories', to: redirect('/articles')
    # redirection with dynamic segments
    get '/stories/:name', to: redirect('/articles/%{name}')
    # temporary redirection
    get '/stories/:name', to: redirect('/articles/%{name}', status: 302)

# routing to Rack application
match '/application.js', to: MyRackApp, via: :all

# root route - for '/'
root to: 'pages#main'
root 'pages#main' # shortcut for the above
    # put at top of the file, assumed to be most popular route and should be matched first
    # in namespaces
    namespace :admin do
        root to: "admin#index"
    end
      
    root to: "home#index"

# direct routes
direct :homepage do
    "https://rubyonrails.org"
end
    # >> homepage_url
    # => "https://rubyonrails.org"

# polymorphic mapping
resource :basket
resolve("Basket") { [:basket] }

=begin
<%= form_with model: @basket do |form| %>
    <!-- basket form -->
<% end %>
=end
  
# overriding singular form
ActiveSupport::Inflector.inflections do |inflect|
    inflect.irregular 'tooth', 'teeth'
 end

# to debug
include ActionDispatch::Routing
include Rails.application.routes.url_helpers
# then can ask for paths like user_path

# to print all helper routes
Rails.application.routes.named_routes.helper_names