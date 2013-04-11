module parameters

#Parameters
function Parameters = -> DynamicObject():
	HTTPPORT(8080):
	PUBLIC("public/"):
	DEFAULT_STATIC("/index.html"):
	ENCODING("UTF-8"): 		#"ISO-8859-1"
	COOKIE_NAME("MINIME_SESSION_ID"):
	REDIS("localhost")