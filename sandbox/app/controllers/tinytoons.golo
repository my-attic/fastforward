module tinytoons

import java.util.Map
import java.util.HashMap
import java.util.LinkedList
import java.util.UUID
import java.lang.StringBuilder
import java.lang.String

import java.lang.Thread
import java.lang.Math
import java.util.Random

#golo modules
import content
import html
import constants
import httpconnection
import json
import tinytoon #models
import sse

# TODO : 
#	- to explain model structure
#	- query by firstName


#tinyToons controller
function tinyToons = -> DynamicObject():
	define("listen", |this, httpConnection| { # Server Events

		var sse = -> DynamicObject():
	        mixin(ServerSourceEvent()):
	        stop(false):
	        httpConnection(httpConnection): #context propagation
	        define("run",|this| {
	        	try {
		        	while (this: stop() is false) {
				        var data = ""

				        var infosList = LinkedList()
					    
					    foreach(worker in this: httpConnection(): memory(): entrySet()) {
					    	#println(worker: getKey()+" "+worker: getValue())
					    	if worker: getKey(): startsWith("worker:") {

					    		var info = HashMap()
					    		info: put("name", worker: getValue(): name())
					    		info: put("x", worker: getValue(): x())
					    		info: put("y", worker: getValue(): y())
					    		info: put("id", worker: getValue(): toonID())

					    		infosList: add(info)

					    		data = data + 
					    			worker: getValue(): name() + " " + 
					    			worker: getValue(): x() + " " + 
					    			worker: getValue(): y()
					    	}
					    }

					    println(data)

					    #this: writeSSEData(Date(): toString())
					    this: writeSSEData(JSON(): simpleListStringify(infosList))
				        Thread.sleep(1000_L)	        		
		        	}
		        } catch(e) {
		        	println("ouchhh, probably, page has been refreshed ...")
	        	} finally {

	        	}

	        })

	    sse(): init("positions of toons", httpConnection): sendSSE()  

	    #explain to the handler to not flush header
	    return Flow(): waitForSomething(true)  

	}):
	define("start", |this, httpConnection| { #GET:/start/tinytoons/
		var id = httpConnection: getParameters("/start/tinytoons/")
	    
		println("STARTING TOON ... " + id)
		#get the toon in redis
		var toon = TinyToon(): queryById(id): getFirst()

		println(toon: toJSONString())

		#create a toon worker with firstName of the toon

		if httpConnection: poolWorkers(): getWorkerByName(toon:getField("firstName")) is null {

		    var toonWorker = httpConnection: poolWorkers(): getNewWorker(toon:getField("firstName"), true)
		    
		    toonWorker: x(toon: getField("x"))
		    toonWorker: y(toon: getField("y"))
		    toonWorker: stop(false)

		    toonWorker: maxWidth(500)
		    toonWorker: maxHeight(500)

		    toonWorker: toonID(toon: getField("id"))

		    #add pointer to the worker
		    httpConnection: memory(): put("worker:"+ toon: getField("firstName"), toonWorker)

		    toonWorker: define("rnd", |this|{ 
		    	var min = 1
		    	var max = 500
		    	return Random(): nextInt((max + 1) - min) + min
		    })

		    toonWorker: define("task", |this| {

		    	while (this: stop() is false) {

		    		#var dx = this: rnd()
		    		#var dy = this: rnd()

		    		#this: x(this: x() + dx)
		    		#this: y(this: y() + dy)

		    		this: x(this: rnd())
		    		this: y(this: rnd())		    		

		    		println(String.format("%s -> x : %s y : %s", this: name(), this: x(), this: y()))

		    		#save the toon ?

		    		Thread.sleep(1000_L)
		    	}

		    })
		    
		    toonWorker: start("...")			
		} else {
			println("################################################################")
			println(" "+toon:getField("firstName")+" is already running")
			println("################################################################")
		}



	    return Flow(): 
	        init(
	            "{\"ID\":\""+id+"\"}",
	            ContentType(): JSON()
	        )			
	}):
	define("getAll", |this| { #GET : http://localhost:8080/tinytoons

		var toons = TinyToon(): getAll()
   		var modelsList = LinkedList()
   		#TODO: TinyToon(): getAllAsJSON()
	    foreach (toon in toons) {
	        modelsList: add(toon: fields())
	    }

	    return Flow(): 
	        init(
	            JSON(): simpleListStringify(modelsList), 
	            ContentType(): JSON()
	        )		
	}):	
	define("getById", |this, httpConnection| { #GET : http://localhost:8080/tinytoons/db9b76bb-a43d-4736-b796-df89505e5481
		
		var id = httpConnection: getParameters("/tinytoons/")
	    try {
	        var toonFieldsHashMap = TinyToon(): queryById(id): getFirst(): fields()
	        return Flow(): 
	                init(
	                    JSON(): simpleStringify(toonFieldsHashMap), 
	                    ContentType(): JSON()
	                )
	    } catch(e) {
	        return Flow(): 
	                init(
	                    "{\"message\":\"ouch\"}", 
	                    ContentType(): JSON()
	                )
	    }
	}):
	define("delete", |this, httpConnection| { 
		#DELETE : 
		# babs.destroy({
		#	success:function(data){console.log("data",data);},
		#	error:function(err){console.log("error",err)}
		# })
		var id = httpConnection: getParameters("/tinytoons/")
	    var toon = TinyToon(): init(HashMap(): add("id",id))
	    toon: delete()

	    return Flow(): 
	            init(
	                JSON(): simpleStringify(toon: fields()), 
	                ContentType(): JSON()
	            )		
	}):
	define("create", |this, httpConnection| {
		#POST REQUEST : CREATE TOON
		# babs = new TinyToon({firstName:"Babs", lastName:"Bunny"})
		# babs.save({},{
		#	success:function(data){console.log("data",data);},
		#	error:function(err){console.log("error",err)}
		# })
	    var values = httpConnection: postValues()
	    var modelFieldsHashMap = JSON(): simpleParse(values) #return hashmap from json string

	    var toon = TinyToon(): init(modelFieldsHashMap)
	    
	    toon: save()

	    return Flow(): 
	            init(
	                JSON(): simpleStringify(toon: fields()), 
	                ContentType(): JSON()
	            )

	}):
	define("update", |this, httpConnection| {
		#PUT REQUEST : UPDATE TOON
		# babs.set("email","babs.bunny@gmail.com")
		# babs.save({},{
		#	success:function(data){console.log("data",data);},
		#	error:function(err){console.log("error",err)}
		# })
	    var values = httpConnection: postValues()
	    var id = httpConnection: getParameters("/tinytoons/") 
	    
	    var modelFieldsHashMap = JSON(): simpleParse(values) #return hashmap from json string
	    var toon = TinyToon(): init(modelFieldsHashMap)

	    toon: save()

	    return Flow(): 
	            init(
	                JSON(): simpleStringify(toon: fields()), 
	                ContentType(): JSON()
	            )

	})
