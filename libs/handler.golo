module handler

import com.sun.net.httpserver.Headers
import com.sun.net.httpserver.HttpExchange
import com.sun.net.httpserver.HttpHandler

#golo modules
#import parameters
import html
import constants
import httpconnection
import content
import static
import rainbow

import routes

#=== Handler and handle ===
function Handler = |handle| -> asInterfaceInstance(HttpHandler.class, handle)

function handle = |httpExchange, env, poolWorkers, memory| {

    var requestMethod = httpExchange: getRequestMethod()
    var requestUri = httpExchange: getRequestURI() :toString(): trim()
    #httpConnection is a DynamicObject HttpConnection()        
    var httpConnection = HttpConnection(): init(requestUri, requestMethod)
    httpConnection: httpExchange(httpExchange)

    httpConnection: env(env)
    httpConnection: poolWorkers(poolWorkers)
    httpConnection: memory(memory)

    #flow is a DynamicObject Flow()
    var flow = null     

    try {
	        
        flow = action(requestMethod + ":" +requestUri, httpConnection)

    } catch(e) {
            
        console():brightRed():println("============ ERROR : Handler / handle ============")            
    	e: printStackTrace()
        let errorMessage = e: getCause(): toString()

        console():println(errorMessage)
        if errorMessage: startsWith("java.net.ConnectException: Connection refused") {
            console():purple():println("did you think to turn on the redis server ?!?")     
        }

        console():brightRed():println("==================================================") 
        console():reset()  
    
    } finally {

        if flow is null {
            #static assets
            sendContent(serveStaticFiles(httpExchange, memory: get("applicationName")), httpExchange)   

            #env = "STATIC ENV" 
            
        } else { #dynamic or redirection or waitForSomething
            if flow: isRedirection() isnt true {
                if flow: waitForSomething() isnt true {
                    #dynamic content
                    sendContent(flow, httpExchange)                    
                }

            }
        }    

    }	
}
