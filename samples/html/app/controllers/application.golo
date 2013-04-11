module application

#golo modules
import content
import constants
import html

function application = -> DynamicObject():
    define("dsl", |this, httpConnection|{

        let onediv = div(): innerHTML("<h3>HELLO WORLD</h3>")
        let anotherdiv = div(): innerHTML("<h3>Salut à tous</h3>"): style("color:red")
        
        let page = 
            html(): 
                $(head(): 
                        $(title(): innerText("Hello")): 
                        $(link(): attrs("rel='stylesheet' type='text/css' href='css/bootstrap.min.css'")):
                        $(link(): 
                            rel("stylesheet"): 
                            type("text/css"): 
                            href("css/bootstrap-responsive.min.css")
                        ):
                        $(script():
                            src("js/vendors/jquery-1.9.1.min.js")
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
                        ):
                        $(script())
                    ):
                gen()

        #TODO tester un $(->{})


        println(page)

        return Flow(): init(page, ContentType(): HTML())

    })    



