module simple #controller

#golo modules
import content
import little #views
import constants
import human #models

function simple = -> DynamicObject():
    define("index", |this, httpConnection|{

        return Flow(): init(
            "Hello, this is the <b>simple</b> application", 
            ContentType(): HTML()
        )
    }):
    define("message", |this, httpConnection|{

        var bob = Human():initialize("Bob", "Morane")

        return Flow(): init(
            little():render(
                "Hello World !!! from "+
                    bob:firstName()+" "+
                    bob:lastName(), 
                    "Have fun with Fast!>>forward ;)"
            ), 
            ContentType(): HTML()
        )
    })