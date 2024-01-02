# can use a User model, as long as:
    # there is a password_digest field, as it is used by has_secure_password

class User < ActiveRecord::Base
    has_secure_password     # need to uncomment bcrypt-ruby line in gemfile, validates password/confirmation
    attr_accessible :email, :password, :password_confirmation # can be set by mass assignemnt through the form
    vaildates_uniqueness_of :email
end

# creating the signup form

class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new(params[:user])
        if @user.save
            redirect_to root_url, notice: "Sign-up completed"
        else
            render "new"
        end
    end
end

# _form.html.erb    
<h1>Sign Up</h1>

<%= form_for @user do |f| %>
  <% if @user.errors.any? %>
    <div class="error_messages">
      <h2>Form is invalid</h2>
      <ul>
        <% @user.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= f.label :email %><br />
    <%= f.text_field :email %>
  </div>
  <div class="field">
    <%= f.label :password %><br />
    <%= f.password_field :password %>
  </div>
  <div class="field">
    <%= f.label :password_confirmation %><br />
    <%= f.password_field :password_confirmation %>
  </div>
  <div class="actions"><%= f.submit "Sign Up" %></div>
<% end %>

# then generate controller for sessions
rails g controller sessions