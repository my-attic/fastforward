module user

import java.util.HashMap
import java.util.LinkedList

#golo modules
import redismodel

#composition with r_model
function user = -> DynamicObject():
	mixin(r_model()):
    kind("USER"):
    keyFields(Array(
        "firstName", 
        "lastName", 
        "login", 
        "email"
    )):
	authenticated(false):
	sessionID(""):
    define("init", |this, fields| {
        this: fields(fields)
        return this
    }):    
    define("queryById", |this, id|{
        return this: query("*:id:"+id+"*")
    })


