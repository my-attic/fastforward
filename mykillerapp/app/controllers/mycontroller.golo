module mycontroller

#golo modules
import content
import constants

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
    })    