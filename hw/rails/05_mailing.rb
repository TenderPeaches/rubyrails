# mailers are like controllers and are stored in `app/mailers`
  # they have methods also called `actions` and use views to structure their content

# generate a mailer
rails generate mailer User

# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout 'mailer'
end
# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer  
  default from: 'notifications@example.com'     # sets default values for all emails sent fromt his mailer

  def sample_email                              # sample send email action
    @user = params[:user]
    @url = 'http://example.ca/login'
    mail(to: @user.email, subject: 'Sample Subject')  # creates and sends the actual email
  end
end
  # to custom-build one, just make sure it inherits from ActionMailer::Base

# use mailer views to format the email being sent
  # sample_email.html.erb in app/views/user_mailer
=begin
<!DOCTYPE html>
<html>
  <head>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
  </head>
  <body>
    <h1>Welcome to example.com, <%= @user.name %></h1>
    <p>
      You have successfully signed up to example.com,
      your username is: <%= @user.login %>.<br>
    </p>
    <p>
      To login to the site, just follow this link: <%= @url %>.
    </p>
    <p>Thanks for joining and have a great day!</p>
  </body>
</html>
=end
# good practice to also include a non-html text version
  # sample_email.text.erb
=begin
  Welcome to example.com, <%= @user.name %>
  ===============================================
  
  You have successfully signed up to example.com,
  your username is: <%= @user.login %>.
  
  To login to the site, just follow this link: <%= @url %>.
  
  Thanks for joining and have a great day!
=end

# execute mailing methods with deliver methods
UserMailer.with(user: @user).sample_email.deliver_later   # Active Job
UserMailer.with(user: @user).sample_email.deliver_now     # cron job
  # any key-value pair passed to with is used as params in the mailer action

# other mailer action methods include
  headers[:field_name] = 'value'                          # to change email headers
  attachments['filename.jpg'] = File.read('filename.jpg') # add attachments to email

  # can specify attachment settings
  encoded_content = SpecialEncode(File.read('/path/to/filename.jpg'))
  attachments['filename.jpg'] = {
    mime_type: 'application/gzip',
    encoding: 'SpecialEncoding',
    content: encoded_content
  }

  # inline attachments
  def welcome
    attachments.inline['image.jpg'] = File.read('/path/to/image.jpg')
  end
    # ref in the html
    # <%= image_tag attachments['image.jpg'].url, alt: 'My Photo', class: 'photos' %>

# sending email to multiple recipients
class AdminMailer < ApplicationMailer
  default to: -> { Admin.pluck(:email) },
          from: 'notification@example.com'
    # can also set cc: and bcc:

  def new_registration(user)
    @user = user
    mail(subject: "New User Signup: #{@user.email}")
  end
end

# using names instead of emails
class UserMailer < ApplicationMailer
  default from: email_address_with_name('notification@example.com', 'Example Company Notifications')
    
  def welcome_email
    @user = params[:user]
    mail(
      to: email_address_with_name(@user.email, @user.name),
      subject: 'Welcome to My Awesome Site'
    )
  end
end

# change default mailer views
class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: @user.email,
         subject: 'Welcome to My Awesome Site',
         template_path: 'notifications',    # looks in app/views/notifications
         template_name: 'another')
  end
end

# preview emails
  # given this sample
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.with(user: User.first).welcome_email
  end
end
  # a preview will be available at http://localhost:3000/rails/mailers/user_mailer/welcome_email

# mailers don't have any context for incoming requests
  # the host parameter is set globally in config/application.rb
  config.action_mailer.default_url_options = { host: 'example.com' }
  # within emails, need to use *_url instead of *_path

# inserting images in image body
  # configure asset host globally in config/application.rb
  config.asset_host = 'http://example.com'
  # in email template
  # <%= image_tag 'image.jpg' %>

# email lifecycle hooks
class InvitationsMailer < ApplicationMailer
  before_action :set_inviter_and_invitee
  before_action { @account = params[:inviter].account }

  default to:       -> { @invitee.email_address },
          from:     -> { common_address(@inviter) },
          reply_to: -> { @inviter.email_address_with_name }

  def account_invitation
    mail subject: "#{@inviter.name} invited you to their Basecamp (#{@account.name})"
  end

  def project_invitation
    @project    = params[:project]
    @summarizer = ProjectInvitationSummarizer.new(@project.bucket)

    mail subject: "#{@inviter.name.familiar} added you to a project in Basecamp (#{@account.name})"
  end

  private

  def set_inviter_and_invitee
    @inviter = params[:inviter]
    @invitee = params[:invitee]
  end
end
