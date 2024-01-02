# https://www.mediawiki.org/wiki/API:Main_page
# https://en.wikipedia.org/wiki/Special:ApiSandbox

api_root = "https://en.wikipedia.org/w/api.php?"

class Param
    attr_accessor :name, :value

    def qsa
        :name + "=" + :value
    end
end

# main parameters
# API action to be performed
action = nil
action__query = "query" # https://www.mediawiki.org/wiki/API:Query fetch data from/about mediawiki
action = action__query
action_param = "action=" + action

# expected API output
output_format = "json"
format_param = "format=" + output_format

# query action parameters
# which properties to get for the queried pages
prop = ""
prop_param = "prop=" + prop

# which list to get
list = ""
list_param = "list=" + list

# metadata to get
metadata = "userinfo"
metadata_param = "meta=" + metadata