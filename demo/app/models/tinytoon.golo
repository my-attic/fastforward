module tinytoon

import java.util.HashMap
import java.util.LinkedList

#golo modules
import redismodel

#composition with r_model
function TinyToon = -> DynamicObject():
	mixin(r_model()):
    kind("TinyToon"):
    keyFields(Array(
        "firstName", 
        "lastName"
    )):
    define("init", |this, fields| {
        this: fields(fields)
        return this
    }):    
    define("queryById", |this, id|{
        return this: query("*:id:"+id+"*")
    }):
    define("queryByFirstName", |this, firstName|{
        return this: query("*:firstName:"+firstName+"*")
    })



