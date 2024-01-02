# stack trace 
    # first line - specifies line that caused the error

puts debugged_object                # output value of variables, objects for debugging
    # prints a blank line for nil, empty arrays/collections
p debugged_object                   

# pry debug is recommended gem to debug
gem install pry-byebug              # install
require 'pry-byebug'                # make it available in modules
binding.pry                         # call in ruby program to debug

# try .. catch
begin
    # do stuff that could raise exception
rescue => exception
    print "exception occurred"
end