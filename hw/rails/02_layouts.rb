# layouts = view => how controllers transmits data to user
=begin 
From the Controller' POV, there are 3 ways to create an HTTP resposne
    `render` to create a full response to send back to the browser
    `redirect_to` to send an HTTP redirect status code to the browser
    `head` to send a response consisting only of headers

By default, controllers render views with names that correspond to valid routes
    If something isn't explicitely rendered at the end of a controller action,
        Rails will look for action_name.html.erb template in the controller's view path and render that instead

`render` can be used with text, XML, JSON
=end

# many ways to render a given template called template.html.erb
render "template"
render :template
render action: :template
render action "template"
render "controller/template"       
render template: "controller/template"
# choice is style and convention, use whichever is simpler/most consistent

render inline: "<% stuff.each do |s| %>"        # bad idea but possible
render plain: "text"                            # return plain text, no HTML markup, useful for ajax requests, etc.
    # add :layout option to use current layout and use .text.erb extension for the layout file
render html: helpers.tag.strong('Not Found')    # return HTML, useful for small snippets
render json: @object                            # return JSON by using to_json
render xml: @object                             # return XML by using to_xml
render js: "console.log('hello')"               # return vanilla JS with MIME type text/javascript
render body: "raw"                              # return raw content, should only be used if don't care about response content type
render file: "#{Rails.root}/public/404.html", layout: false # render raw file, does not support ERB or other handlers
    # don't use with user input because the usual rails security measures don't apply to raw files
    # send_file is often a better option    
render MyRenderable.new                         # render object that defines :render_in

# render options:
render :feed, content_type: "application/rss"   # defaults to `text/html` unless :js or :xml
render layout: "some_layout"                    # specify a layout to use for current action
render layout: false                            # don't use layout
render xml: photo, location: photo_url(photo)   # set HTTP location header
render status: 404                              # set response HTTP status code
render formats: :xml                            # 
render variants: [:mobile, :desktop]            # looks for action.html+mobile.erb, etc.

# looks for a file in app/view/layouts with same name as controller, if not found use application.html.erb
    # can also use .builder
class ThingController < ApplicationController
    layout "main"       # all views rendered by this controller will use app/views/layouts/main.html.erb as their layout
        # to assign to whole application, define it in ApplicationController instead
        # can assign at runtime through a proc
        # accept :only and :except to filter out methods for which layout is used
        # layouts use inheritence, so if layout is not found at expected path for current object, it will look for its parent layout and so on
        # same with templates and partials
        # use app/views/appication/ to store shared partials
        # can only render or redirect once per action: render doesn't stop execution; make sure all branches lead to it only being called once
            # or use `and return`
    #...
end

# using redirect_to
redirect_to some_url                            # instead of returning a response, it tells the browser to send a new request
redirect_back(fallback_location: root_path)     # redirect to previous page
    # use :status for response status code

# using head
head :bad_request
head 403

# within the context of a layout (so erb file) yield identifies a section where content from the view should be inserted, for instance:
=begin
<html>
    <head>
    <%= yield :head %>
    </head>
    <body>
    <%= yield %>
    </body>
</html>
=end
# use content_for to populate named yields:
=begin
<% content_for :head do %>
    <title>Page</title>
<% end %>

# partials are just chunks of code moved to their own files, called with `render` within a view like <%= render "menu" %>
    # renders file with a leading underscore like `_menu.html.erb`