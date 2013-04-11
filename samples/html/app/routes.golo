module routes

#golo modules : controllers
import application

#perhaps use the class loader here

#Choose you're way my friend
#root : when route: equals("GET:/")
#or it takes parameters
#    PUBLIC("public/"):
#    DEFAULT_STATIC("/index.html"):
#=== ROUTES ===
function action = |route, httpConnection| -> match {
	when route: equals("GET:/")          then application(): dsl(httpConnection)
    otherwise null
}