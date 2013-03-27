#Fast!>>Forward NextGen.

![FF](https://raw.github.com/k33g/fastforward/master/logo.png)

##More docs to come ...

##How to install ?

- install Golo : [http://golo-lang.org/](http://golo-lang.org/) and set your path
- `git clone https://github.com/k33g/fastforward.git`

##How to parameter the application

See `app/parameters.golo` :

	module parameters

	#Parameters
	function Parameters = -> DynamicObject():
		HTTPPORT(8080):
		PUBLIC("public/"):
		DEFAULT_STATIC("/index.html"):
		ENCODING("UTF-8"): 		#"ISO-8859-1"
		COOKIE_NAME("MINIME_SESSION_ID"):
		REDIS("localhost")

**Don't forget to launch Redis !!!**

##How to launch the application

- OSX & TUX : `./ff.sh name_of_application` 
- Windows : `./ff.sh` with Cygwin, *yes i know ...*

**Don't forget to set classpath for jedis jar driver.**

##Demos

###First :

- `./ff.sh simple`
- try [http://localhost:9090](http://localhost:9090)
- try [http://localhost:9090/message](http://localhost:9090/message)

###Second :

- `./ff.sh demo`
- try [http://localhost:8080/](http://localhost:8080/)
- try [http://localhost:8080/toons.html](http://localhost:8080/toons.html)
- try [http://localhost:8080/pi](http://localhost:8080/pi)
- try [http://localhost:8080/serverevents](http://localhost:8080/serverevents)
- try [http://localhost:8080/servereventswithworker](http://localhost:8080/servereventswithworker)