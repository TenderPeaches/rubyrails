require 'date'                          # Date & DateClass are in date library, must be included with require

date = Date.new(2020, 04, 01)           # date obj contains D/M/Y
day = date.day
month = date.month 
year = date.year 

dt = DateTime.new(2020, 04, 01, 16, 20) # datetime for timestamps
now = DateTime.now                      # current datetime

datediff = date1 - date2                # difference between dates
datediff.to_i                           # difference as days
Date.day_fraction_to_time(datediff)     # precise difference as [hours, minutes, seconds, frac]

date.strftime("%D %T")                       # https://apidock.com/ruby/DateTime/strftime