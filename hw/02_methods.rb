# DRY: don't repeat yourself
    # functions => no associated objects
    # methods => invoked on a receiver object
    # because everything in Ruby is an object, all "functions" are actually methods

    # by convention, # denotes Ruby instance methods for instance Integer#upto, or #upto

# method syntax
def method_name(arg1 = 'default_value', arg2, arg3, ...)          # def built-in keyword to declare method definition
    # method name can use alphanum, _, ?, ! and =
        # special characters can only be used at the end of the name
        # cannot begin a method name with a number
    # use snake_case, lower-case 
    # cannot replace keywords, see list http://www.java2s.com/Code/Ruby/Language-Basics/Rubysreservedwords.htm

    # parameters act as placeholder variables in the method template
    # arguments are the actual variables that get passed to the method when it is called

    # do things
    "a value"                                   # the `return` is implicit - last computed value is returned
end
    # implicitly returns the last expression evaluated in the method
    # calling method arguments doesn't need parentheses:
    puts("something", "else")
    puts "something", "else"

# class methods use self keyword
class MyClass
    def self.class_method
    end
end
    # => MyClass.class_method

# method w/ variable number of arguments
def method_w_many_arguments(*args) 
    args.each { |arg| puts arg }
end

# method alias
alias alias_for_method method_name

# methods can be chained
object.do_stuff.do_more_stuff

object.has_things?      # predicate methods return a boolean by convention
object.downcase!        # bang methods assign the returned value to the object, equivalent to object = object.downcase