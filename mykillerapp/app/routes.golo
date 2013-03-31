module routes

#golo modules : controllers
import application
import mycontroller

#=== ROUTES ===
function action = |route, httpConnection| -> match {
	when route: equals("GET:/display")      then mycontroller(): displaySomething(httpConnection)
	when route: equals("GET:/json")      	then mycontroller(): giveMeJsonObject(httpConnection)
    when route: equals("GET:/about")        then application(): about(httpConnection)
    when route: equals("GET:/aboutjson")    then application(): about_json(httpConnection)
    when route: equals("GET:/abouttxt")     then application(): about_txt(httpConnection)
    otherwise null
}

