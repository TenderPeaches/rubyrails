print "do\n"
print "stuff\n"

# comment stuff
=begin
from cmd line:
	execute with -e flag:
		ruby -e ‘print “stuff”’ -e ‘print “more stuff”’
		
interactive ruby code:
	irb
=end

print "Variables store values and assign a name to the reference"
# they are dynamically typed
somevar = "hello"
# chain assignment
a, b, c = 1, 2, 3   
# constants are declared by starting the variable name with a capital letter
SOMECONSTANT = "hello"
# constants can be changed but throw warning
# to get a variable type
print somevar.kind_of?
# to get a variable class
print somevar.class
	# print puts all the output in one line
	puts somevar.name 		# puts puts all the content in a single line

print 'a'; puts 'b'			# semicolon's only use is to run multiple instructions in a single line of code

# to convert variables, each type has its fct:
float = somevar.to_f        # float
string = somevar.to_s       # takes base as param

# scope defines where variables are accessible:
# local, global, instance, class + constant
# scopes are declared by starting variable with a special character
local_variable = 0        # start with lowercase or underscore, cannot be accessed outside of closure it was declared in (loop/method)
$global_variable = 1      # accessible anywhere in the program; use is strongly discouraged
@@class_variable = 2      # "static" variable, shared between all instances of a class
@instance_variable = 3    # variable local to specific instances of an object
# constants declared in a class/module are available anywhere within that class/module, otherwise they are global


{ |var| var = 'stuff'}	  # block variable, when iterating over arrays, collections, etc.; named arbitrarily

:a_symbol		# symbols are stored in memory once

# getting variable scope
scopoe = defined? somevar

# Ruby-defined global variables:
print $@        # location of latest error
print $_        # string last read by get
print $.        # last line number read by interpreter
print $&        # last string matched by regexp
print $~        # last regexp match as an array of subexpressions
print $n        # where n = int, nth subexpression in last regexp match
print $=        # case insensitivity flag
print $/        # input record separator
print $\        # output record separator
print $0        # name of the ruby file currently executing
print $*        # command line arg used to invoke the script
print $$        # ruby interpreter process ID
print $?        # exit status of last executed child process

# naming conventions 
# https://namingconvention.org/ruby/

# import librare for use
require 'libraryname'