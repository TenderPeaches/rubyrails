# math
add = 1 + 1                 # add
substract = 2 - 1           # substract
product = 3 * 4             # multiply
dividend = 10 / 3           # divide, rounded
dividend = 10.0 / 3         # divide, result is float
remainder = 10 % 3          # modulo
square = 5 ** 2             # exponent
# can also use a += b, a -= b, ... for a = a + b, a = a - b, etc.

# comparison
eq = a == b                 # true if values are equal
not_eq = a != b             # true if values are not equal
eq = a.eql?(b)              # true if values and types are equal
eq = a.equal?(b)            # true if two objects are the same in memo
lt = a < b                  # less than
gt = a > b                  # greater than
let = a <= b                # less than or equal to
get = a >= b                # greater than or equal to
comp = a <==> b             # -1 if a < b, 0 if a == b, 1 if b > a

# bitwise
not = ~a                    # NOT a
or = a | b                  # a OR b
and = a & b                 # a AND b
xor = a ^ b                 # a OR b but not a AND b
shift_left = a << b         # 
shift_right = a >> b        # 

# other
a ||= b                     # assign b to a unless a already has a value

# operator precedence: https://www.techotopia.com/index.php/Ruby_Operator_Precedence

