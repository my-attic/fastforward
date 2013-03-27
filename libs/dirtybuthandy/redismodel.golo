module redismodel

import java.util.Arrays
import java.util.HashMap
import java.util.LinkedList

import java.util.UUID

import redis.clients.jedis.Jedis

#golo modules
import parameters
import json

function db = -> DynamicObject():
    helper(Jedis(Parameters(): REDIS()))

#http://www.c2.com/cgi/wiki?DoubleBraceInitialization
pimp java.util.HashMap {
  function add = |this, key, value| {
  	this: put(key, value)
  	return this
  }
}

#JSON(): simpleStringify(jsonObject) -> return string from a hashmap
#JSON(): simpleParse(values) -> return hashMap from a string

function r_model = -> DynamicObject():
	kind("something"):
    fields(HashMap()):
    define("init", |this, kind, fields| {
    	this: kind(kind)
        this: fields(fields)
        return this
    }):
    define("toJSONString", |this| -> JSON(): simpleStringify(this: fields())):
    define("fromJSONString", |this, jsonString| {
        this: fields(JSON(): simpleParse(jsonString))
        return this
    }):
    define("getField", |this, fieldName| -> this: fields(): get(fieldName)):
    define("setField", |this, fieldName, value| -> this: fields(): put(fieldName, value)):
    define("getKeyById", |this| {
        var keyToDelete = null
        try {
            #Search by id to get the exact key
            var allKeys = db(): helper(): keys(this: kind()+"*id:"+this: fields(): get("id")+"*")
            if allKeys: size() > 0 {
                keyToDelete = allKeys: iterator(): next()
            }
        } catch(e) {
            println("Huston we've got a problem when getting exact key by id")
        } finally {
            return keyToDelete
        }
    }):
    define("delete", |this| {
        try {
            #Search by id to get the exact key

            var exactKeyToDelete = this: getKeyById()
            if exactKeyToDelete isnt null {
                db(): helper(): del(exactKeyToDelete)
            } else {
                println("nothing to delete")
            }

        } catch(e) {
            println("Huston we've got a problem when deleting model")
        }
    }):
    define("save", |this| {
        #keyfields : Array, fields to construct the key

        var result = ""
        foreach (line in atoList(this: keyFields())) {
            result = result + line+ ":"+ this: getField(line) + ":"
        }

        #verifiy if id exists
        var id = this: fields(): get("id")

        if id is null { #creation
            id = UUID.randomUUID()
            this: fields(): put("id", id)
        } else { #update
            try {
                db(): helper(): del(this: getKeyById())
            } catch(e) {
                e: printStackTrace()
            }
        }

        var key = this: kind()+":"+result+"id:"+id

        #this: key(key) #useful ? ... We'll see

        try {
            #db(): helper(): set(key, this: stringify())
            var stringToSave = JSON(): simpleStringify(this: fields()) 
            db(): helper(): set(key, stringToSave)
            println("Saving Key : "+ key)
            println("Saving model fields : "+ stringToSave)
        } catch(e) {
            println(e: getCause(): getMessage())
            println("Huston we've got a problem when saving model")
        }

    }):
    define("getAll",|this| {
        var modelsList = LinkedList()

        #println("### GETALL ### "+ this: kind())

        var allKeys = db(): helper(): keys(this: kind()+":*")

        #println("### allKeys ### "+ allKeys)

        foreach (key in allKeys) {
            var modelHashMap = JSON(): simpleParse(db(): helper(): get(key))

            #println("### modelHashMap ### "+ modelHashMap)

            var model = r_model(): init(this: kind(), modelHashMap)
            
            #modelsList: add(modelHashMap)
            modelsList: add(model)
        }
        return modelsList
    }):
    define("query",|this,queryString|{
        var modelsList = LinkedList()
        var allKeys = db(): helper(): keys(this: kind()+queryString)
        foreach (key in allKeys) {
            var modelHashMap = JSON(): simpleParse(db(): helper(): get(key))
            var model = r_model(): init(this: kind(), modelHashMap)
            #modelsList: add(modelHashMap)
            modelsList: add(model)
        }
        return modelsList
    })





