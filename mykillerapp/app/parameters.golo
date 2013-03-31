module parameters

#Parameters
function Parameters = -> DynamicObject():
	HTTPPORT(9090):
	PUBLIC("public/"):
	DEFAULT_STATIC("/index.html"):
	ENCODING("UTF-8")