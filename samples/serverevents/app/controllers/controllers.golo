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

#import gololang.concurrent.workers.WorkerEnvironment

#golo modules
import content
import html
import constants
import httpconnection
import json
import sse
#import workers


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

