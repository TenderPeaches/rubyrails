# controllers

# naming conventions: pluralize the last word in the Controller's name like JobSitesController
    # this allows for using default route generators without needing to specify with :path and :controller options

class ClientController < ApplicationController
    def new                     # by default, accessed by routing through /clients/new
        @client = Client.new    # @client is accessible in the view
    end 
end

# two possible types of parameters possible for user actions:
    # QSA - query string parameters, defined after ? in an URL
    # POST data
# both are available in the `params` hash without distinction
    # QSA can event contain arrays: GET /clients?ids[]=1&ids[]=2&ids[]=3 => params[:ids] == ["1", "2", "3"]
    # Likewise, in POST data, can use name="client[address][civic_number]" to have nested arrays/hashes

# can also use JSON, loaded automatically if request type is "application/json"
    # if config.wrap_parameters has been turned on in the initializer or if wrap_parameters was called in controller, root elem of JSON object can be omitted

# params will always contain :controller and :action keys but these values should be accessed through controller_name and action_name respectively
get '/clients/:status', to: 'clients#index', some: 'value'  # when user goes to /clients/active, params[:status] == "active", params[:some] == "value"

# global default URL parameters can be set with default_url_option defined within Controller class:
def default_url_options
    { locale: I18n.locale }
end

# strong parameters
# action controller parameters cannot be used in active model mass assignments until they have been permitted, as a security measure
class PeopleController < ActiveController::Base
    def create 
        Person.create(params[:person])  # throws ForbiddenAttributesError because mass assignment is done without permission
    end
    
    def update
        person = current_account.people.find(params[:id]) # succeeds unless :id isn't a param, in which case throws ParameterMissing and returns 400
        person.update!(person_params)
        redirect_to person
    end

    private     # good pattern, can reuse between update & create, can customize per-user, etc.
        def person_params
            params.require(:person).permit(:name,:age) # permit allows to use scalar values (String, Symbol, etc.)
            params.permit(id: [])   # must be an array of permitted scalar values
            params.permit(settings: {})  # can be anything
            params.require(:log_entry).permit!  # permits an entire hash or params, be careful because it allows for mass assignemnt to models
            params.permit(:name, { emails: [] }) # can be used on nested parameters
        end
    end
end

# session
# user session is available through the controller to store temporary/local data
ActionDispatch::Session::CookieStore        # stores everything on the client
ActionDispatch::Session::CacheStore         # stores everything in the Rails cache
ActionDispatch::Session::ActiveRecordStore  # stores data in DB using ActiveRecord (requires activerecord-session_store gem)
ActionDispatch::Session::MemCacheStore      # stores data in memcached cluster (legacy, use CacheStore)
# all session stores use a cookie to store a unique ID for each session 
    # Rails enforces use of cookie for this, preventing session IDs as a QSA as a security measure
    # cookies are encrypted and also default method to store session ID
    # CookieStore can store around 4 kB of data
# favor CacheStore when user sessions don't store critical data or don't need to be around for too long

# to change storage mechanism, define it in the initializer
Rails.application.config.session_store :cookie_store, key: '_your_app_session', domain: ".example.com"
    # the generated key can be access with /bin/rails credentials:edit
# sessions are lazy-loaded and can be accessed by the controller through the `session` local hash
session[:current_user_id] = user.id
session.delete[:current_user_id]
reset_session           # to reset entire session

# flash is a special part of the session that is cleared with each request, so useful for immediate user feedback like errors, warnings, etc.
flash[:notice] = "login successful"
redirect_to root_url, notice: "logout successful"
redirect_to root_url, alert: "error"
redirect_to root_url, flash: { referral_code: 123 }
flash.keep              # to persist (once) beyond the next request 
flash.now[:error]       # use the flash immediately, before the next request is performed

# cookies
cookies[:name] = 'bob'
cookies.delete[:name]
# use a cookie jar for secure, encrypted cookies

# rendering JSON, XML
class UserController < ApplicationController
    def index 
        @users = User.all
        respond_to do |format|  
            format.html     # index.html.erb
            format.xml { render xml: @users }
            format.json { render json: @users }
        end
    end
end

# can do lifecycles hooks/filters  
class UserController < ApplicationController
    before_action :validate_stuff   # if a `before` filter redirects or renders, the action will not be performed
    skip_before_action :validate_stuff, only [:new, :create]    # skip filter for specific actions (new and create in this case)
    after_action :log_stuff         # run only if no exception is thrown in action
    around_action :wrap_stuff, only :show

    private
        def wrap_stuff
            ActiveRecord::Base.transaction do 
                begin 
                    yield
                ensure 
                    raise ActiveRecord::rollback
                end
            end
        end
    end

    def validate_stuff
        print "do stuff"
    end
end 

# to avoid CSRF, make sure all create/udpate/destroy actions are accessed with non-GET requests
    # Rails secures this feature by adding a non-guessable token known only to the server to each request (added with form_with helper)

# HTTP request
request                 # of type ActionDispatch::Request
request.host            # hostname
request.domain(n=2)     # hostname first n segmensts,starting from the top-level-domain
request.format          # content type requested by client
request.method          # HTTP method used for the request
request.get?            # returns true if method matches
    .post? # etc
request.headers         # hash containing request headers
request.port            # port number used for the request
request.protocol        # protocol used + "://"
request.query_string    # query string part of the URL (everthing that follows `?`)
request.remote_ip       # target IP address
request.url             # full request URL
# the query string parameters are located in `params` but there are specific accessors available to request
request.query_parameters    # QSA
request.request_parameters  # $_POST
reuqest.path_parameters     # parameters recognized by routing as part of the path for this particular controller and action

# HTTP response
# often accessed in `after` hooks, built up during the execution of the action
response.body           # string of data sent back to the client: html, json, xml, etc.
response.status         # HTTP status code
response.location       # URL the client is being redirected to, if any
response.content_type   # content type of the response
response.charset        # character set used for the response, defaults to UTF-8
response.headers        # headers used for the response
    # ideal for customizing response headers
    response.headers["Content-type"] = "application/pdf"

# HTTP authentication
    # 3 built-in authentication mechanisms: basic, digest & token

class AdminController < ApplicationController
    # basic authentication is supported by majority of browser and other HTTP clients, safe over HTTPS 
    http_basic_authenticate_with name: "admin", password: "123"         # as long as a controller inherits AdminController, it will enforce this authentication method
    # digest authentiation is safer
    USERS = { "lifo" => "world "}
    before_action :authenticate
    private 
        def authenticate
            authenticate_or_request_with_http_digest do |username|
                USERS[username]
            end
        end
    end
    # token authentication is more complex but allows for more powerful possibilities
    TOKEN = "secret"
    before_action :authenticate
    private 
        def authenticate
            authenticate_or_request_with_http_token do |token, options|
                ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
            end
        end
    end
end

# streaming data
require "prawn"
class FileController < ApplicationController
    def download_pdf
        send_data generate_pdf(someData),               # send_data is available within Controllers
            filename: "#{someData.filename}.pdf",
            type: "application/pdf",
            disposition: "attachment"                   # default value, can be set to "inline"
    end

    private 
        def generate_pdf(data)
            Prawn::Document.new do
                text data.name, align: center,
            end.render
        end
    end
end

# sending files already on disk
class FileController < ApplicationController
    def download_pdf 
        send_file("#{Rails.root}/files/somefile.pdf",   # reads and stream the file through a buffer
            filename: "newfile.pdf",
            type: "application/pdf",
            :stream: true,                              # default is true
            :buffer_size: 8096)                         # default is 4kb
    end
end
# avoid using data coming from client (cookies, QSA, POST) to locate files, as that is a security risk
    # it's not recommended to stream files if they can instead be kept in a public-facing directory, as that is much more efficient

# RESTful download - files as representations of a resource
class ClientController < ApplicationController
    def show
        @client = Client.find(params[:id])

        respond_to do |format|
            format.html
            format.pdf { render pdf: generate_pdf(@client) }
        end
    end
end
# for this to work, must add PDF MIME type to Rails
Mime::Type.register "application/pdf", :pdf
# PDF would be accessible with request GET /clients/1.pdf

# streaming arbitrary data
class VideoController < ActionController::Base
    include ActionController::Live

    def stream
        response.headers['Content-Type'] = 'text/event-stream'  # must be done before the stream starts as headers cannot be changed after the response is committed
        100.times {
            response.stream.write "hello world\n"               # starts to commit the response with `write`
            sleep 1
        }
    ensure 
        response.stream.close           # need to make sure the stream is closed at the end
    end
end

# log filtering
# Rails keeps a log for each enviornment but it may not be useful to log every single bit of data and event
config.filter_parameters << :password           # in application configuration
    # default filters are set in initializers/filters_parameter_logging.rb
config.filter_redirect << 's3.amazonaws.com'    # reidrection filter
config.filter_redirect.concat ['s3.amazonaws.com', /private_path/]

# handling bugs by customizing 404/500 response views
    # remote rails error - 500
    # routing error - 404
class ApplicationController < ActionController::Base
    rescue_from ActiveRecord::RecordNotFound, with :record_not_found

    private 
        def record_not_found
            flash[:error] = "Record not found."
            redirect_back(fallback_location: root_path)
        end
    end
end
# avoid using rescue_from with Exception or StandardError
# certain exceptions are only rescuable from the ApplicationController

# force HTTPS
    # enable ActionDispatch::SSL via config.force_ssl in envionrment configuration
