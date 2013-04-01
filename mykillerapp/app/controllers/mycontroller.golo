module mycontroller

import fastforward.java.extensions.Json
import java.util.HashMap

#golo modules
import content
import constants
import httpconnection

function mycontroller = -> DynamicObject():
    define("displaySomething", |this, httpConnection|{

        return Flow(): init(
            "<h1>This is a message from mycontroller</h1>", 
            ContentType(): HTML()
        )
    }):
    define("giveMeJsonObject", |this, httpConnection|{

        return Flow(): init(
            "{\"firstName\":\"Bob\",\"lastName\":\"Morane\"}", 
            ContentType(): JSON()
        )
    }):
    define("sayHello", |this, httpConnection|{
        var param = httpConnection: getParameters("/hello/")
        return Flow(): init(
            "<h1>Hello " + param + "</h1>", 
            ContentType(): HTML()
        )
    }):        
    define("sayGoodBye", |this, httpConnection|{
        var param = httpConnection: getParameters("/goodbye/")
        return Flow(): init(
            "<h1>Good Bye " + param + "</h1>",  
            ContentType(): HTML()
        )
    }):
    define("postInfos", |this, httpConnection| {
        var values = httpConnection: postValues()
        println(values)
        return Flow(): init(
            values, 
            ContentType(): JSON()
        )
    }):
    define("giveMeBigJsonObject", |this, httpConnection| {
        var human = HashMap()
        var address = HashMap()

        address: put("street", "Champs-Elysées")
        address: put("town", "Paris")

        human: put("firstName","Bob")
        human: put("lastName","Morane")
        human: put("address", address)

        println(human)
        return Flow(): init(
            Json.stringify(Json.toJson(human)), 
            ContentType(): JSON()
        )
    })

