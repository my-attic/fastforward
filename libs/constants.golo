module constants

#Content type (mime)
function ContentType = -> DynamicObject():
    JSON("application/json"):
    HTML("text/html"):
    PLAIN("text/plain"):
    EVENTSTREAM("text/event-stream"):
    XML("text/xml"):
    APPXML("application/xml"):
    CSS("text/css"):
    JS("application/javascript"):
    ICO("image/ico"):
    MD("text/plain")

    #TO BE CONTINUED      

#Rest verbs
function REST = -> DynamicObject():
    POST("POST"):
    PUT("PUT"):
    GET("GET"):
    DELETE("DELETE")