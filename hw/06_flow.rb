# standard if
if boolean then       
    print "do stuff"
end
    # only falsely values are nil and false
        # everything else is true, including empty strings, 0, "false"

# can omit then keyword
if boolean 
end


print "do stuff" if boolean                 # can put if at the end, omit end keyword
if bool: print "do stuff" end               # can use :

# if-else
if bool
    print "do thing"
else
    print "do other thing"
end

# if-else if-else
if bool 
    print "do thing"
elsif other_bool
    print "do other thing"
elsif another_bool : print "do stuff"       # with : shorthand for single-line
else 
    print "do nothing"

print bool ? 'true' : 'false'               # ternary operator

# select case
result = case fruit
    when 'banana' then Banana.new
    when 'apple' then Apple.new
    when 0..40 then Orange.new              # using ranges
    else Frut.new
end

# unconditional loop
loop do
    print "do stuff"
    break # exit loop
end

# while 
while bool do
    print "stuff"
    if done : break                         # break to exit loop
end

# until - loops until condition is true
until bool do
    print "bool is not true yet"
end

# unless - if not
unless bool 
    print "bool is false"
else
    print "bool is true"
end

# for
for i in 1..8 do            # do is optional unless written on the same line
    print i
    break                   # exit loop with break
end

5.times { |i| print i }     # Integer.times() method allows for a task to be performed x times
1.upto(n) { |i| print i }   # Integer.upto(n) to set initial i, ++i
i.downto(n) { |i| print i } # Integer.downto(n) set initial i, --i

# enumerable methods implement common case loop functionalities
array.each { |item| print 'do stuff' }              # do something with each item
    hash.each { |key, value| puts "#{key} is #{value}" } # also works with hashes
    hash.each { |pair| puts "can also print #{pair} like [key, value]" }
array.each_with_index { |item, index| puts "#{item} is }"}
array.select { |item| item == 'something' }         # select items where item == 'something'
array.reject { |item| item == 'something' }         # reject items where item == 'something', so select all those for which condition is false  
array.map { |item| item.upcase }                    # returns a new array with transformation applied to each element
array.reduce { |accumulator, item| accumulator + item }                      # returns a single value set from the array's values
    # accumulator stores result of each iteration and is returned at the end
    # can pass parameter to reduce() to set accumulator's initial value

# for multiline blocks, use enumerable methods with do keyword
array.each do |item| 
    item *= 2
    puts item
end