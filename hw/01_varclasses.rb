# built-in number classes
# Integer => base class from which other number classes are derived
# Fixnum => integer values that can be represented in a native machine word
# Bignum => integet that fall outside of Fixnum
# Float => real, double-precision floating point representation
# Rational => number that can be expressed as a fraction p/q

# number conversions
print Integer (1.234)           # float to int
print Integer ("1234")          # string to int
print Integer (0xA4F5D3)        # hexa to int
print "e".getbyte(0)            # ascii to int

print Float (10)                # int to float
print Float ("10")              # string to float
# etc...

