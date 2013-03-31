#Fast!>>Forward NextGen.

![FF](https://raw.github.com/k33g/fastforward/master/logo.png)

Fast!>>Forward is a tiny Web application server with Redis database for Single Page Applications ... or more (ie: workers, server events, ...)

##How to install ?

- install Golo : [http://golo-lang.org/](http://golo-lang.org/) and set your path
- `git clone https://github.com/k33g/fastforward.git`

##How to launch an application

- OSX & TUX : `./ff.sh <name_of_application>` 
- Windows : `./ff.sh <name_of_application>` with Cygwin, *yes i know ...*

##Create a new application

Type : `./ff.sh new <name_of_application> <name_of_template>`, ie : `./ff.sk mykillerapp jquery.tpl`

You obtain a new Fast!>>Forward application :

	-- mykillerapp\
	              |- parameters.golo
	              |- routes.golo
	              |- app\
	              |     |- contollers\
	              |     |            |- application.golo
	              |     |- models
	              |
	              |- public\
	                        |- index.html
	                        |- favicon.ico
	                        |- css (stylesheets directory, comes with twitter bootstrap and font awesome)
	                        |- font
	                        |- js\
	                              |- vendors (comes at least with jQuery)

To run it : `./ff.sh mykillerapp`

###Create a controller

####Serve HTML Content

In `mykillerapp/app/controllers` create a new file `mycontroller.golo` :

```coffeescript
	module mycontroller

	#golo modules
	import content
	import constants

	function mycontroller = -> DynamicObject():
	    define("displaySomething", |this, httpConnection|{

	        return Flow(): init(
	            "<h1>This is a message from mycontroller</h1>", 
	            ContentType(): HTML()
	        )
	    })
```

- Definition of `Flow()` is in `libs/content.golo`
- Definition of `ContentType()()` is in `libs/constants.golo`


You have to had a route : edit `mykillerapp/app/routes.golo` and 

- add `import mycontroller`
- add new route `when route: equals("GET:/display") then mycontroller(): displaySomething(httpConnection)`

```coffeescript
	module routes

	#golo modules : controllers
	import application
	import mycontroller

	#=== ROUTES ===
	function action = |route, httpConnection| -> match {
		when route: equals("GET:/display")      then mycontroller(): displaySomething(httpConnection)
	    when route: equals("GET:/about")        then application(): about(httpConnection)
	    when route: equals("GET:/aboutjson")    then application(): about_json(httpConnection)
	    when route: equals("GET:/abouttxt")     then application(): about_txt(httpConnection)
	    otherwise null
	}
```

You can now run the application : `./ff.sh mykillerapp` and call [http://localhost:9090/display](http://localhost:9090/display)

####Serve JSON Content

Add a new method `giveMeJsonObject` to `mycontroller` :

```coffeescript
	module mycontroller

	#golo modules
	import content
	import constants

	function mycontroller = -> DynamicObject():
	    define("displaySomething", |this, httpConnection|{

	        return Flow(): init(
	            "<h1>This is a message from mycontroller</h1>", 
	            ContentType(): HTML()
	        )
	    }):
	    define("giveMeJsonObject", |this, httpConnection|{

	        return Flow(): init(
	            "{\"firstName\":\"Bob\",\"lastName\":\"Morane\"}", 
	            ContentType(): JSON()
	        )
	    })    
```

Add a new route to `routes.golo` : `when route: equals("GET:/json") then mycontroller(): giveMeJsonObject(httpConnection)`

```coffeescript
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
```

You can now run the application : `./ff.sh mykillerapp` and call [http://localhost:9090/json](http://localhost:9090/json). 

You can call it too with ajax request (thanks to jQuery), like that :

	$.getJSON("json", function(data) { console.log(data.firstName, data.lastName)})

###REST API : query parameters

####GET (or DELETE) parameter

Add a 2 new methods `sayHello` and `sayGoodBye` to `mycontroller`, and import `httpconnection` :

```coffeescript
	module mycontroller

	#golo modules
	import content
	import constants
	import httpconnection

	function mycontroller = -> DynamicObject():
	    define("displaySomething", |this, httpConnection|{

	        return Flow(): init(
	            "<h1>This is a message from mycontroller</h1>", 
	            ContentType(): HTML()
	        )
	    }):
	    define("giveMeJsonObject", |this, httpConnection|{

	        return Flow(): init(
	            "{\"firstName\":\"Bob\",\"lastName\":\"Morane\"}", 
	            ContentType(): JSON()
	        )
	    }):
	    define("sayHello", |this, httpConnection|{
	        var param = httpConnection: getParameters("/hello/")
	        return Flow(): init(
	            "<h1>Hello " + param + "</h1>", 
	            ContentType(): HTML()
	        )
	    }):        
	    define("sayGoodBye", |this, httpConnection|{
	        var param = httpConnection: getParameters("/goodbye/")
	        return Flow(): init(
	            "<h1>Good Bye " + param + "</h1>",  
	            ContentType(): HTML()
	        )
	    })


	}
```

Add a new routes to `routes.golo` : 

```coffeescript
	when route: startsWith("GET:/hello/")      then mycontroller(): sayHello(httpConnection)
	when route: startsWith("DELETE:/goodbye/") then mycontroller(): sayGoodBye(httpConnection)
```

You can now run the application : `./ff.sh mykillerapp` and test routes in console browser with ajax request (thanks to jQuery) :

	$.ajax({type:"GET", url:"hello/bob", success:function(data){console.log(data);}})

	$.ajax({type:"DELETE", url:"goodbye/sam", success:function(data){console.log(data);}})


####POST (or PUT) data





Add a new method `` to `mycontroller` :

```coffeescript
```

Add a new route to `routes.golo` : ``

```coffeescript
```

You can now run the application : `./ff.sh mykillerapp` and call [http://localhost:9090/](http://localhost:9090/). 

You can call it too with ajax request (thanks to jQuery), like that :


##HTML DSL

*to be continued ...*

##Workers

*to be continued ...*

##Server Sent Events

*to be continued ...*

##Fast!>>forward java extensions

###JSON

*to be continued ...*

###Redis

*to be continued ...*

###...

*to be continued ...*

##How to parametrize the application

See `<name_of_application>/app/parameters.golo` :

	module parameters

	#Parameters
	function Parameters = -> DynamicObject():
		HTTPPORT(8080):
		PUBLIC("public/"):
		DEFAULT_STATIC("/index.html"):
		ENCODING("UTF-8"): 		#"ISO-8859-1"
		COOKIE_NAME("MINIME_SESSION_ID"):
		REDIS("localhost")


##experimental samples :

**Don't forget to launch Redis !!!**

- `./ff.sh sansbox`
- try [http://localhost:8080/](http://localhost:8080/)
- try [http://localhost:8080/toons.html](http://localhost:8080/toons.html)
- try [http://localhost:8080/pi](http://localhost:8080/pi)
- try [http://localhost:8080/serverevents](http://localhost:8080/serverevents)
- try [http://localhost:8080/servereventswithworker](http://localhost:8080/servereventswithworker)
