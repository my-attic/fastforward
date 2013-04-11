module routes

#golo modules : controllers
import pi

#Choose you're way my friend
#root : when route: equals("GET:/")           then pi(): index(httpConnection)
#or it takes parameters
#    PUBLIC("public/"):
#    DEFAULT_STATIC("/index.html"):
#=== ROUTES ===
function action = |route, httpConnection| -> match {
	when route: equals("GET:/")             then pi(): index(httpConnection)
    when route: equals("GET:/pi")           then pi(): index(httpConnection)
    when route: equals("GET:/einstein")     then pi(): einstein(httpConnection)
    when route: equals("GET:/euler")        then pi(): euler(httpConnection)
    otherwise null
}