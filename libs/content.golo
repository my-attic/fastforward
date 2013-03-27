module content

import java.lang.String

#import java.lang.System
#import java.lang.Math
#import java.util.Date
#import java.util.UUID

#import java.lang.Thread
#import java.util.concurrent
#import gololang.concurrent.workers.WorkerEnvironment
#import java.lang.RuntimeException


import constants

function Flow = -> DynamicObject():
	contentType(""):
    content(""):
    bytesContent(0):
    responseCode(200):
    isRedirection(false):
    waitForSomething(false):
    define("init", |this, content, contentType| {
    	this: contentType(contentType)
        this: content(content)
        return this
    }):
    define("redirect", |this, location, httpExchange| {
        var responseHeaders = httpExchange: getResponseHeaders()
        responseHeaders: set("Content-Type", ContentType(): HTML()+";charset=utf-8")
        responseHeaders: set("Location", location)
        #OutputStream
        var responseBody = httpExchange: getResponseBody()
        httpExchange: sendResponseHeaders(302, 0)
        var content = String("")
        responseBody: write(content: getBytes()) 
        responseBody: close()
        this: isRedirection(true)
        return this
    })

#send content to client
function sendContent = |flow, httpExchange| {

	    var responseHeaders = httpExchange: getResponseHeaders()
        responseHeaders: set("Content-Type", flow: contentType()+";charset=utf-8")
        httpExchange: sendResponseHeaders(flow: responseCode(), 0)
        #OutputStream
        var responseBody = httpExchange: getResponseBody()

        if flow: bytesContent() is 0 { #dynamic content
            responseBody: write(flow: content(): getBytes())     
        } else { #static content
            responseBody: write(flow: bytesContent())     
        }
        
        responseBody: close()
}













