module routes

#golo modules : controllers
import simple

#Choose you're way my friend
#=== ROUTES ===
function action = |route, httpConnection| -> match {
    when route: equals("GET:/")         then simple(): index(httpConnection)
    when route: equals("GET:/message")  then simple(): message(httpConnection)
    otherwise null
}