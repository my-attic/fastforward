module routes

#golo modules : controllers
import controllers
import users
import pi
import tinytoons

#perhaps use the class loader here

#Choose you're way my friend
#root : when route: equals("GET:/")           then pi(): index(httpConnection)
#or it takes parameters
#    PUBLIC("public/"):
#    DEFAULT_STATIC("/index.html"):
#=== ROUTES ===
function action = |route, httpConnection| -> match {
    when route: startsWith("GET:/users/")   then users_byId(httpConnection)
    when route: equals("GET:/users")        then users_all(httpConnection)
    when route: equals("POST:/users")       then users_create(httpConnection)
    when route: startsWith("PUT:/users")    then users_update(httpConnection)
    when route: startsWith("DELETE:/users") then users_delete(httpConnection)
    otherwise null
}