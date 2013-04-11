module parameters

#Parameters
function Parameters = -> DynamicObject():
	HTTPPORT(8080):
	PUBLIC("public/"):
	DEFAULT_STATIC("/index.html"):
	ENCODING("UTF-8")