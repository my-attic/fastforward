module application

#golo modules
import content
import constants

function application = -> DynamicObject():
    define("about", |this, httpConnection|{

        return Flow(): init(
            "<h1>Hello World !!!</h1>", 
            ContentType(): HTML()
        )
    }):
    define("about_txt", |this, httpConnection|{

        return Flow(): init(
            "Hello World in plaintext", 
            ContentType(): PLAIN()
        )
    }):
    define("about_json", |this, httpConnection|{

        return Flow(): init(
            "{\"message\":\"hello world !!!\"}", 
            ContentType(): JSON()
        )
    })

