# Assuming use of RSpec, Capybara

#* Sample test file
require 'rails_helper' # loads the test config from spec/rails_helper.rb

# declare spec name & block, test type
# type :system implies Capybara will be load to simulate browser use
RSpec.describe "Spec name", type: :system do 
    # Declare a particular text
    it "Does a particular thing right" do
        visit some_path     # tell capybara to use the browser to visit a given path
        expect(page).to have_content('some content')    # assert what the page must have for the test to succeed
    end
end

# Capybara DSL
# Action functions

# direct navigation, always using GET
visit(some_path) 

# clicking links, elements
click_link('link_id')
click_link('link text')
click_button('button text')
click_on('button or link text')
click_on('button value')

# form interactions, locators being name, ID, test_id attribute or label text
fill_in('label', with: 'value')
choose('radio button')
check('checkbox')
uncheck('checkbox')
attach_file('image', 'path/to/img.jpg')
select('city name', from: 'city-list')

# querying the page for existence of elements https://rubydoc.info/github/jnicklas/capybara/Capybara/Node/Matchers
page.has_selector?('#some_element_id')

# finding elements to manipulate them https://rubydoc.info/github/jnicklas/capybara/Capybara/Node/Finders
find_field('#field_id').value
find_link('hello', :visible => :all).visible?
find_button('Send').click
find_button(value: '123').click
all('a').each { |a| 'do stuff with each link/anchor' }

# scoping
within('table') do
    fill_in 'Name', with: 'bob'
end

# debugging
save_and_open_page  # take snapshot of page and look at it, stored to Capybara.save_path
print page.html     # print page DOM

# RSpec matchers
have_current_path(some_path)