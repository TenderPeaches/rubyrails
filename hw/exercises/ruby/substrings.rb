require "optparse"

def substrings(source = "", searches = Array.new)
    results = Hash.new                  # must list number of istances of each search in source

    searches.each do |searched|
        results[searched] = search_str(source, searched)    
    end

    puts results
end

def search_str(source, searched) 
    source.downcase.scan(searched.downcase).count   # case insensitive occurence count
end

OptionParser.new do |opts|
end

substrings(ARGV[0], ['1-2', 'gna', 'patate', 'a', ' ', 'at', 'zds'])