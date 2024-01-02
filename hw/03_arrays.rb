print 1..10                             # inclusive range (1 to 10)
print 1...10                            # exclusive range (1 to 9)
print 'a'..'z'                          # character range
print (1..10).to_a                      # range to array

range = 1..10
print range.min                         # lowest value in range
print range.max                         # highest value in range
print range.include?(1)                 # whether item is value
print range.any? { |item| item > 1 }    # whether any item matches boolean
print range.all? { |item| item > 1 }    # whether all items match boolean
print range.none? { |item| item > 1 }   # whether not a single item matches boolean
print range.reject {|val| val < 10}     # filter values based on condition
print range.each {|val| puts "stuff" }  # foreach
print range === 5                       # does value fit in range

# ranges can be used in case statements
result = case somevalue 
    when 0..40: "something"
    when 41..60: "something else"
end

# arrays are classes
some_array = Array.new
some_array = Array.new(10)              # initialize with 10 empty items
some_array = Array.new(10, 'default')   # initialize with 10 items with value "default"
    # default value should be an immutable type: number, boolean, symbol
        # otherwise, each value in the array would be a reference to the same default value
        # if that value is changed once, it will be changed everywhere
        some_array = Array.new(5) { Array.new(5) }  # declaring with brackets will default each item to an individual reference
some_array = Array[1,2,3,4,5]           # initialize with explicit values

# array access
some_array.empty?                       # array is empty
some_array.size                         # array size/length
some_array[0]                           # accessing first item with 0-indexed int
some_array.at(0)                        # accessing first item with 0-index int through Array class method
some_array[-1]                          # accessing last item 
some_array.first                        # accessing first item
some_array.last                         # accessing last item
some_array.index(1)                     # find index of item
some_array.rindex(1)                    # find index of last matching item 
some_array[1..3]                        # array subset
some_array[1, 3]                        # array subset
some_array.slice(1..3)                  # array subset

# array operations
concat_arrays = array_1 + array_2       # array concat
concat_arrays = array_1.concat(array_2) # array concat
diff = arary_1 - array_2                # array difference - rets array of items in array_1 that aren't in array_2
intersect = array_1 & array_2           # array intersection - rets array of items both in array_1 and array_2, no duplicates
union = array_1 | array_2               # array union - concatenates both arrays, removes duplicates
unique = some_array.uniq                # removes duplicates
some_array.uniq!                        # removes duplicates in-place

# array comparison
array_1 == array_2                      # true if arrays contain same number of elements and same contents for each corresponding elemnet
array_1.eql? array_2 (?)                # same as == but value classes/types must match
array_1 <==> array_2                    # 0 if arrays are equal, -1 if array_1 is "lesser", 1 if array_2 is "higher"

# list functions
some_array.push("stuff")                # push item at the end of array
some_array.pop                          # pop item out from the end of the array

# modifying array values
some_array[1] = "stuff"                 # assign value to array item based on int index
some_array[1..3] = 1, 1, 2              # assign value to array item based on int range index
some_array.delete_at(1)                 # delete value from array based on index
some_array.delete("stuff")              # delete value(s) from array where value is param

# array sort
sorted = some_array.sort                # sorts array
some_array.sort!                        # sorts array in-place
reversed = some_array.reverse           # reverse-sorts array, can use ! for in-place

# hashes are key-value pairs 
hash = {
    'key' => 'value',
    'other_kay' => 'other_value',
    'an_array' => [],
    'an_hash' => {}
}
hash = Hash.new     # also an obj
value = hash['key'] # access value
value = hash[:key]  # access value

vehicles.filter_map { |name, data| name if data[:year] >= 2020 }    # => [:caleb, :dave]

# nested array (multidimensional arrays)
stats = [[0, 1, 2],[3, 4, 5],[6, 7, 8]]
    stats[0][1]     # => 1
    stats[0][-2]    # => 0
    stats[4][0]     # => NoMethodError 
    stats[0][4]     # => nil
    stats.dig(4,0)  # => nil