module workers

import java.lang.Thread
import java.util.concurrent
import gololang.concurrent.workers.WorkerEnvironment

import java.lang.String
import java.util.Arrays
import java.util.HashMap
import java.util.LinkedList

import java.util.UUID

#Too much states for a worker !!!
function ffWorker = -> DynamicObject():
    isFree(true):
    message(""):
    name(""):
    isStarted(false):
    isEnded(false):
    isWorking(false):
    isBooked(false):
    define("task",|this| {
        
    }):
    define("isFreeAndNotBooked", |this| {

        return this: isFree() and not this: isBooked() 
    }):
    define("toString", |this| {
        return String.format("isFree %s isStarted %s isEnded %s isWorking %s", 
            this: isFree(), this: isStarted(), this: isEnded(), this: isWorking())
    }):
    define("init", |this, id, env|{
        this: id(id)
        this: env(env)

        let port =  this: env(): spawn(|message| { 
            this: isFree(false)
            this: message(message)

            this: isStarted(true)
            this: isEnded(false)
            this: isWorking(true)

            this: task()
            this: isFree(true)

            this: isStarted(false)
            this: isEnded(true)
            this: isWorking(false)
        })

        this: port(port)
        #this: env(): shutdown()
        return this
    }):
    define("start", |this, message|{
        this: port(): send(message)
    })


#ConcurrentQueue ?

function PoolWorkersManager = -> DynamicObject():
	pool(HashMap()):
    namesIdx(HashMap()):
	define("init", |this, env, size|{
        this: env(env)
        this: size(size)
        println("-> create pool of workers ...")
        for (var i = 0, i < this: size(), i = i + 1) {
            var uniqueID = UUID.randomUUID()
            this: pool(): put(uniqueID, ffWorker(): init(uniqueID, this: env()))                    
        }
        println("-> pool of " + this: size() +" workers has been created ...")
        return this      
	}):
    define("giveWorkerById", |this, idOfWorker| { #return a worker et set its isFree property
        return this: pool(): get(idOfWorker)
    }):
    define("giveFirstFreeWorker", |this| { #return first free worker (and not booked) and set it as not free (busy)
        
        var keys = this: pool(): keySet()
        var it = keys: iterator()
        var found = false
        var idOfWorker = null
        var worker = null

        while (it: hasNext() and not found ) {
            var current = it: next()
            if this: pool(): get(current): isFreeAndNotBooked() {
                found = true
                idOfWorker = current
                worker = this: giveWorkerById(idOfWorker)
                worker: isFree(false)
                println("-> id of first free worker is : "+idOfWorker)
            }
        }        
        return worker
    }):
    define("addWorker", |this| { # add an external worker tho the pool
        #TODO
    }):
    define("deleteWorkerById", |this, id| { # add an external worker tho the pool
        #TODO
        #only if free and not working
    }):   
    define("deleteWorkerByName", |this, id| { # add an external worker tho the pool
        #TODO
    }):       
    define("getWorkerByName", |this, name| {
        return this: pool(): get(this: namesIdx(): get(name))
    }):
    define("getNewWorker", |this, name, booked| { 
        # add new worker tho the pool & return this worker : it can be booked and free (by default)
        # so, if isBooked it cannot be used by giveFirstFreeWorker
        # be careful name is unique : so you overwrite existing worker with the same name
        var idOfWorker = UUID.randomUUID()
        this: size(this: size() + 1)
        
        var retWorker = ffWorker(): init(idOfWorker, this: env())

        retWorker: name(name): booked(booked)

        this: namesIdx(): put(name, idOfWorker)

        this: pool(): put(idOfWorker, retWorker)
        
        return this: giveWorkerById(idOfWorker)    

    })    
