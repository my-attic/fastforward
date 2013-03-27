module controllers

import java.util.Map
import java.util.HashMap
import java.util.UUID
import java.lang.StringBuilder
import java.lang.String
import java.lang.Integer

import java.util.Date
import java.lang.Thread
import java.util.concurrent
import gololang.concurrent.workers.WorkerEnvironment

#golo modules
import content
import html
import constants
import httpconnection
import json
import sse
#import workers


function work  = |httpConnection| {

    #var id = Integer.parseInt(httpConnection: getParameters("/w/"))
    
    var name = httpConnection: getParameters("/w/")
    var w = httpConnection: poolWorkers(): getWorkerByName(name)

    w: start("FROM WORK")

    return Flow(): init(
        String.format("Worker '%s' is launched", name), 
        ContentType(): HTML()
    )

}


function callSSE  = |httpConnection| {

    var MySSE = -> DynamicObject():
        mixin(ServerSourceEvent()):
        define("run",|this| {

            for (var i = 0, i < 10, i = i + 1) {
                print(i+" ... ")
                this: writeSSEData(Date(): toString())
                Thread.sleep(1000_L)
            }
            println("the end")   
            
        })

    MySSE(): init("my first SSE", httpConnection): sendSSE()  

    #explain to the handler to not flush header
    return Flow(): waitForSomething(true)
}

#TODO : env pool
function callSSEWorker = |httpConnection| {
    
    let port = httpConnection: env(): spawn(|fromWho| {
        
        var MySSE = -> DynamicObject():
            mixin(ServerSourceEvent()):
            define("run",|this| {
                    for (var i = 0, i < 35, i = i + 1) {
                        print(i+" ... ")
                        this: writeSSEData(this: name()+" : "+Date(): toString())
                        Thread.sleep(1000_L)
                    }
                    println("the end") 
            })

        MySSE(): init("SSE ONE", httpConnection): sendSSE()  
        
    })

    port: send("GOGOGO")

    #httpConnection: env():shutdown() 
    #explain to the handler to not flush header
    return Flow(): waitForSomething(true)
    
}


function index = |httpConnection| {
    return Flow(): 
        redirect(
            "/index.html", 
            httpConnection: httpExchange()
        )
}

#Actions : Controllers, tests about Session
function bob  = |httpConnection| {
    var session_id = httpConnection: getCurrentSession(): get("id")
    println(session_id)
    return Flow(): init(
        String.format("Hello i am <b>Bob Morane</b><br>id = %s", session_id), 
        ContentType(): HTML()
    )
} 

function sam = |httpConnection| {
    var session_id = httpConnection: getNewSession(): id()
    println(session_id)
    return Flow(): init(
        String.format("Hello i am <b>Sam LePirate</b><br>id = %s", session_id), 
        ContentType(): HTML()
    )
}

function john = |httpConnection| {
    httpConnection: deleteCurrentSession()
    return Flow(): init(
        "Hello i am <b>John Doe</b><br><i>Session has been deleted</i>", 
        ContentType(): HTML())
}


#Test POST REQUEST
function post_data = |httpConnection| {
    #ex: $.post("/postdata","SALUT",function(data) {console.log("DATA",data);})    
    println(httpConnection: postValues()) # = SALUT
    #Send plain text
    return Flow(): init("HELLO WORLD !!!", ContentType(): PLAIN())
}

#Test GET REST REQUEST
function get_data = |httpConnection| {
    #ex: $.get("/getdata/bob:morane",function(data) {console.log("DATA",data);})    
    println(httpConnection: getParameters("getdata/")) # = bob:morane
    #Send plain text
    return Flow(): init("HELLO WORLD AGAIN !!!", ContentType(): PLAIN())
}

#to be continued
function dsl = |httpConnection| {

    var onediv = div(): innerHTML("<h3>HELLO WORLD</h3>")
    var anotherdiv = div(): innerHTML("<h3>Salut à tous</h3>"): style("color:red")
    
    var page = 
        html(): 
            $(head(): 
                    $(title(): innerText("Hello")): 
                    $(link(): attrs("rel='stylesheet' type='text/css' href='css/bootstrap.min.css'")):
                    $(link(): 
                        rel("stylesheet"): 
                        type("text/css"): 
                        href("css/bootstrap-responsive.min.css")
                    )
            ):
            $(body(): cssclass("pretty"): style("border:0"): 
                    $(div(): style("border:solid; border-color:red"):
                        $(div(): innerHTML("Salut")):
                        $(a(): innerText("I am a link"): attrs("href='http://www.google.com'"))
                    ): 
                    $(#add to body
                        div(): attrs("data-msg='hello'"):
                        $(#add to div
                            input(): attrs("type='text' value='Hello you'")
                        ):
                        $(
                            onediv #this is a part of html code   
                        ):
                        $(
                            anotherdiv
                        )
                    ):
                    $(div(): 
                        innerHTML("..."): 
                        data("x","y"):
                        data("message","Bonjour de la part de Philippe")
                    ):
                    $(ul():
                        $(li(): innerHTML("Salut")): 
                        $(li(): innerHTML("Hello")):
                        $(li(): innerHTML("Morgen"))
                    )
                ):
            gen()

#TODO tester un $(->{})


    println(page)

    return Flow(): init(page, ContentType(): HTML())
}