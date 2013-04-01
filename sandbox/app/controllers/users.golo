module users

import java.util.Map
import java.util.HashMap
import java.util.LinkedList
import java.util.UUID
import java.lang.StringBuilder
import java.lang.String
import fastforward.java.extensions.Json

#golo modules
import content
import html
import constants
import httpconnection
import user

#http://localhost:8080/users
function users_all = |arg| {

    var users = user(): getAll()
    var modelsList = LinkedList()

    println("Users list :")
    foreach (user in users) {
        var userFields = user: fields()
        println("---> "+user: getField("id"))
        userFields: remove("password")
        modelsList: add(userFields)
    }
    
    return Flow(): 
        init(
            Json.stringify(Json.toJson(modelsList)), 
            ContentType(): JSON()
        )
}

#GET
#Get one user (by id)
#http://localhost:9090/users/db9b76bb-a43d-4736-b796-df89505e5481
function users_byId = |httpConnection| {
    var id = httpConnection: getParameters("/users/")
    println("GET USER: " + id)    
    try {
        var userFieldsHashMap = user(): queryById(id): getFirst(): fields()
        userFieldsHashMap: remove("password")
        return Flow(): 
                init(
                    Json.stringify(Json.toJson(userFieldsHashMap)), 
                    ContentType(): JSON()
                )
    } catch(e) {
        return Flow(): 
                init(
                    "{\"message\":\"ouch\"}", 
                    ContentType(): JSON()
                )
    }
}

#DELETE
#phil.destroy({success:function(data){console.log("data",data);},error:function(err){console.log("error",err)}})
function users_delete = |httpConnection| {
    var id = httpConnection: getParameters("/users/")
    println("DELETE : "+id)

    var myUser = user(): init(HashMap(): add("id",id))
    myUser: delete()

    return Flow(): 
            init(
                Json.stringify(Json.toJson(myUser: fields())), 
                ContentType(): JSON()
            )
}


#POST REQUEST : CREATE USER
#phil = new User({firstName:"Philippe", lastName:"CHARRIERE", login:"k33g"})
#phil.save({},{success:function(data){console.log("data",data);},error:function(err){console.log("error",err)}})
function users_create = |httpConnection| {
     
    var values = httpConnection: postValues()
    var modelFieldsJsonNode = Json.parse(values) 
    var modelFieldsHashMap = Json.fromJson(modelFieldsJsonNode, HashMap.class)

    var myUser = user(): init(modelFieldsHashMap)
    myUser: save()

    return Flow(): 
            init(
                Json.stringify(Json.toJson(myUser: fields())), 
                ContentType(): JSON()
            )
}

#PUT REQUEST : UPDATE USER
#phil.set("email","ph.charriere@gmail.com")
#phil.save({},{success:function(data){console.log("data",data);},error:function(err){console.log("error",err)}})
function users_update = |httpConnection| {
    var values = httpConnection: postValues()
    var id = httpConnection: getParameters("/users/") 
    
    var modelFieldsJsonNode = Json.parse(values) 
    var modelFieldsHashMap = Json.fromJson(modelFieldsJsonNode, HashMap.class)

    var myUser = user(): init(modelFieldsHashMap)

    myUser: save()

    return Flow(): 
            init(
                Json.stringify(Json.toJson(myUser: fields())), 
                ContentType(): JSON()
            )
}
