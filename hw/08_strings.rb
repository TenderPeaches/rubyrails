# strings
print String.new("a string")
string = "\n"       # displays a newline
string = '\n'       # displays \n
string = %$bob$     # prefix any character with % to use as delimiter, also works with parentheses, square brackets, braces
string.length
string.empty?
string = %Q(
    Another way to do heredoc
)

# regexp testing https://rubular.com/
"%a + %b" % { a: val_a, b: val_b }          # string templating

string = part1 + part2                      # string concat
string = part1 part2                        # string concat, without + shorthand
string = part1 << part2                     # string concat alt
string = part.concat(part2)                 # string concat alt

string.freeze                               # can't modify frozen strings

string["seq"]                               # returns the sequence if fonud, nil otherwise
string[0]                                   # returns ASCII code of char at that location
string[0].chr                               # returns character at that location
string[0..5]                                # substring
string[0, 5]                                # substring

string1 == string2                          # compare
string1.eql? string2                        # compare
string1.casecmp string2                     # compare (case-insentitive)

string['replace this'] = 'with this'        # string replace
string[0..5] = ' replace with'              # string replace range
string[0] = 'insert at'                     # string insert at position
string.insert 0, 'this'                     # string insert at position
string.gsub('replace this', 'with this')    # string replace, use ! to replace in place
string.replace('new string')                # string replace entire string
string * 3                                  # string repeat
string.chop                                 # removes trailing character
string.chomp                                # removes record separators, defined by $/ (\n by default)
string.reverse                              # string reverse

string.each { |word| print word }           # string loop based on $/
string.split                                # convert string to array as [string]
string.split(//)                            # convert string to array using param regexp as record separator
string.downcase                             # string to lower case
string.upcase                               # string to upper case
string.swapcase                             # string swap case
string.each_byte                            # loop on string using each byte's ASCII value (base-10 hex)

string.to_i                                 # string to integer
string.to_f                                 # string to float
string.to_sym                               # string to symbol

stirng.scan(/regex/)                        # find occurences

string = <<-DOC
Do stuff and blabla
    With fancy tabs
        And keep all this stuff
            later etc.  
DOC               # heredoc (does it work?)