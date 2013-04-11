module routes

#golo modules : controllers
import controllers

#perhaps use the class loader here

#Choose you're way my friend
#root : when route: equals("GET:/")           then pi(): index(httpConnection)
#or it takes parameters
#    PUBLIC("public/"):
#    DEFAULT_STATIC("/index.html"):
#=== ROUTES ===
function action = |route, httpConnection| -> match {
    when route: equals("GET:/serverevents") then callSSE(httpConnection)
    when route: equals("GET:/servereventswithworker") then callSSEWorker(httpConnection)
    otherwise null
}