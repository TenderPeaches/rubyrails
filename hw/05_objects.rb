# objects are self-contained pieces of logic that can be re-used as building blocks
# they consist of data and functions (object methods), collectively referred to as object members

# classes define what objects will look like when created
# like what methods do and member variables are
# classes can inherit from one another

class Fruit
    def type                # class variable accessor method
        @@type = "food"     # class variable
    end 

    def color               # accessor method to access instance variable
        @color = "red"      # instance variable 
    end

    def color(val)          # setter method
        @color = val
    end

    def initialize()        # standard ruby class constructor method
        
    end

    def eat()
        puts "yum " + color
    end
end

apple = Fruit.new()         # create object from class
print apple.eat

require 'Fruit'             # necessary only if the parent class is not in the same .rb file

class Apple < Fruit         # class inheritence
    def peel() 
        puts "slippery"
    end
end
