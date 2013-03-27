module sse

#golo modules
import constants
import httpconnection


function ServerSourceEvent = -> DynamicObject():    
    define("run",|this| {
        
    }):
    define("init",|this, name, httpConnection| {
        this: name(name)
        this: httpExchange(httpConnection: httpExchange())
        this: env(httpConnection: env())
        this: httpConnection(httpConnection)
        #this: poolWorkers(httpConnection: poolWorkers())
        #this: environment(WorkerEnvironment.builder(): withCachedThreadPool())
        return this
    }): 
    define("writeSSEData", |this, data| {
        var SSEData = "data:"+ data +"\n\n"
        this: responseBody(): write(SSEData: getBytes())
        try {            
            this: responseBody(): flush()
        } catch(e) {
            throw RuntimeException("Ouch!!!") #ie when refresh page
        }   
        
    }):   
    define("sendSSE",|this| {
        var responseHeaders = this: httpExchange(): getResponseHeaders()
        responseHeaders: set("Content-Type", ContentType(): EVENTSTREAM())
        responseHeaders: set("Cache-Control", "no-cache")
        responseHeaders: set("Connection", "keep-alive")
        this: httpExchange(): sendResponseHeaders(200, 0)

        #OutputStream
        this: responseBody(this: httpExchange(): getResponseBody())
        
        this: run()    

        #println("END METHOD : sendSSE of " + this: name())
        return this   
    })
