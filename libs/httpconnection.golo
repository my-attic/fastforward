module httpconnection

import java.io
import java.io.File
import java.io.IOException
import java.io.OutputStream
import java.io.InputStream
import java.io.ByteArrayOutputStream

import java.lang.String

import java.util.HashMap
import java.util.UUID

#golo modules
import parameters
import constants
import httpconnection

function Session = -> DynamicObject():
    id(null):
    new(false)

function HttpConnection = -> DynamicObject():
    URI(""):
    RESTMethod(""):
    httpExchange(0):
    session(Session()):
    data(HashMap()):
    define("init", |this, URI, RESTMethod| {
        this: URI(URI)
        this: RESTMethod(RESTMethod)
        return this
    }):
    define("postValues", |this| { #very simple 
        var stringRead = ""
        #if this: RESTMethod(): equals(REST(): POST()) { and PUT ???
            var inputStream = this: httpExchange(): getRequestBody()
            var inputStreamReader = InputStreamReader(inputStream)
            var bufferedReader = BufferedReader(inputStreamReader)
            stringRead = bufferedReader: readLine()         
        #} 
        return stringRead
        #while(stringRead isnt null) {
        #    println(stringRead)
        #    stringBuilder: append(stringRead)
        #    stringRead = bufferedReader: readLine()
        #}
        #println(stringBuilder: toString())
    }):
    define("getParameters", |this, partUri| { #partAfterURI
        return  java.net.URLDecoder.decode(aget(this: URI(): split(partUri),1))
    }):
    define("getCurrentSession", |this| {
        #this: session(0) #ko or not ?
        if this: httpExchange(): getRequestHeaders(): get("Cookie") isnt null {

            if alength(this: httpExchange(): 
                        getRequestHeaders(): 
                        get("Cookie"): 
                        toString(): 
                        split(Parameters(): COOKIE_NAME()+"=")) > 0 {

                var cookieStr = this: httpExchange(): 
                                    getRequestHeaders(): 
                                    get("Cookie"): 
                                    toString() 

                println("cookieStr : "+cookieStr + " length : " + cookieStr: length())

                if cookieStr: length() > 0 {

                    var miniMeCookie = cookieStr: split(Parameters(): COOKIE_NAME()+"=")

                    if alength(miniMeCookie) > 1 {

                        var miniMeCookieStr = aget(miniMeCookie,1)
                        println("miniMeCookieStr : "+miniMeCookieStr) 

                        if miniMeCookieStr: length() > 0 { 
                            #test alength too
                            var id = aget(aget(miniMeCookieStr: split(";"),0): split("]"),0)                
                            println("SessionID : "+id)
                            this: session(Session())
                            this: session(): id(id)
                        }                            
                    }
                }
            }
        }

        return this: session()
    }):
    define("getNewSession", |this|{
        this: session(Session())
        this: session(): id(UUID.randomUUID(): toString())

        var session_id = Parameters(): COOKIE_NAME()+"="+ this: session(): id() +";"

        this: httpExchange(): 
            getResponseHeaders(): 
            add("Set-Cookie",session_id)

        return this: session()
    }):
    define("deleteCurrentSession", |this|{

        if this: getCurrentSession(): get("id") isnt null {
            var session_id = Parameters(): COOKIE_NAME()+"="+ this: session(): id()

            this: httpExchange(): 
                getResponseHeaders(): 
                add("Set-Cookie", String.format("%s=; Expires=Thu, 01 Jan 1970 00:00:00 GMT", session_id))
                println("session deleted")
        } else {
            #nothing
            println("no current session to delete")
        }
    })
