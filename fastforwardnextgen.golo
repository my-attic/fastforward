module fastforwardnextgen

import com.sun.net.httpserver.HttpServer
import java.net.InetSocketAddress
import java.util.concurrent.Executors

import java.lang.Thread
import java.util.concurrent
import gololang.concurrent.workers.WorkerEnvironment

import java.util.HashMap

import java.util.Date

#golo modules
import parameters
import handler
import workers
import files
import rainbow


#My little server
function main = |args| {
    #http://stackoverflow.com/questions/5762491/how-to-print-color-in-console-using-system-out-println
    #println("--- "+aget(args, 0)+" ---")
    #let applicationName = aget(args, 0)

    console():cyan():println(file(): read("logo.rsrc"))

    console():blue() #change color for next print statement

    var env = WorkerEnvironment.builder(): withCachedThreadPool()
    #=== POOL OF WORKERS ===
    
    var poolWorkers = PoolWorkersManager():init(env, 50)

    var memory = HashMap()
    memory: put("applicationName", aget(args, 0))


	let httpPort = Parameters(): HTTPPORT()
	var inetSocketAddress = InetSocketAddress(httpPort)
	var server = HttpServer.create(inetSocketAddress, 0)

    try {

		server: createContext("/", Handler(|httpExchange|-> handle(
            httpExchange, 
            env, 
            poolWorkers,
            memory)
        ))	
	    server: setExecutor(Executors.newCachedThreadPool())
        console():brightRed():println("starting server ...")
	    server: start()

    } catch(e) {
    	println("============ ERROR fastforwardnextgen ============")    	
    	e: printStackTrace()
    	println("==================================================")
    }
    console():brightPurple():println("Fast!>>Forward NextGen° \""+memory: get("applicationName")+"\" Server is listening on port "+httpPort)
    console():reset()

}
