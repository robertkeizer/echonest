log	= require( "logging" ).from __filename
util	= require "util"
url	= require "url"
http	= require "http"

class Echonest
	constructor: ( @api_url, @api_version ) ->
		
	req: ( path, args, method, cb ) ->
		# Build up options
		_options		= url.parse @api_url + "/#{@api_version}/" + path, true
		_options["method"]	= method

		# Remove the search, since we've got the querystring obj now.
		delete _options["search"]
	
		# Force JSON.
		_options["query"]["format"] = "json"
	
		for key, val of args
			_options["query"][key] = val
	
		log url.format _options
		process.exit 1

		# Do an simple http request. Parse the response, return the obj.
		req = http.request url.format _options, ( res ) ->
			res.setEncoding "utf8"
			_data = ""

			res.on "data", ( chunk ) ->
				_data += chunk

			res.on "end", ( ) ->
				try
					_o = JSON.parse _data
					cb null, _o
				catch err
					cb err
			
			res.on "error", cb

		req.on "error", cb
		
	song_info: ( artist, title ) ->
		
	
ent = new Echonest "http://developer.echonest.com/api", "v4"

ent.req "song/search", { "bar": "foo" }, "GET"
log "Got here"
