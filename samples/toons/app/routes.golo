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
    when route: startsWith("GET:/tinytoons/")   then tinyToons(): getById(httpConnection)
    when route: equals("GET:/tinytoons")        then tinyToons(): getAll()
    when route: equals("POST:/tinytoons")       then tinyToons(): create(httpConnection)
    when route: startsWith("PUT:/tinytoons")    then tinyToons(): update(httpConnection)
    when route: startsWith("DELETE:/tinytoons") then tinyToons(): delete(httpConnection)

    when route: startsWith("GET:/start/tinytoons/")   then tinyToons(): start(httpConnection)
    when route: equals("GET:/listen/tinytoons")       then tinyToons(): listen(httpConnection)
    otherwise null
}