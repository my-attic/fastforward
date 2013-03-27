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

    when route: startsWith("GET:/users/")   then users_byId(httpConnection)
    when route: equals("GET:/users")        then users_all(httpConnection)
    when route: equals("POST:/users")       then users_create(httpConnection)
    when route: startsWith("PUT:/users")    then users_update(httpConnection)
    when route: startsWith("DELETE:/users") then users_delete(httpConnection)

    when route: startsWith("GET:/w/") then work(httpConnection)
    when route: equals("GET:/w3") then work3(httpConnection)
    when route: equals("GET:/w4") then work4(httpConnection)

    when route: equals("GET:/serverevents") then callSSE(httpConnection)
    when route: equals("GET:/servereventswithworker") then callSSEWorker(httpConnection)

    when route: equals("GET:/pi")           then pi(): index(httpConnection)
    when route: equals("GET:/einstein")     then pi(): einstein(httpConnection)
    when route: equals("GET:/euler")        then pi(): euler(httpConnection)

    when route: equals("POST:/postdata")    then post_data(httpConnection)
    when route: startsWith("GET:/getdata/") then get_data(httpConnection)
    when route: equals("GET:/bob")          then bob(httpConnection)
    when route: equals("GET:/sam")          then sam(httpConnection)
    when route: equals("GET:/john")         then john(httpConnection)
    when route: equals("GET:/dsl")          then dsl(httpConnection)
    when route: equals("GET:/default")      then index(httpConnection)
    otherwise null
}