module json

import java.util.Arrays
import java.util.HashMap
import java.util.Map
import java.util.LinkedList

import java.lang.StringBuilder
import java.lang.String
import java.lang.Double
import java.lang.Integer

#==============================================
# JSON library
# very simple : 
# - jsonString to HashMap
# - or HashMap to jsonString
# - LinkedList of HashMap to arrayJsonString
#==============================================

function JSON = -> DynamicObject():
	define("removeCurlyBraces", |this, str| {
		return aget(aget(str: split("\\{"),1): split("\\}"), 0)
	}):	
	define("extractFields", |this, str| {
		println(str)
		var arr = str: split(",")
		println(arr)
		return arr
		#return str: split("\",\"")
	}):
	define("toHashMap", |this, arrayOfFields| {
		var fields = HashMap()

		for (var i = 0, i < alength(arrayOfFields), i = i + 1) {
    		
    		#var tmp = aget(arrayOfFields, i): split("\":\"")
    		var tmp = aget(arrayOfFields, i): split("\":")
    		var key = aget(tmp,0)

    		#if key: startsWith("\"") {
    		#	key = key: substring(1, key: length())
    		#}
    		key = key: substring(1, key: length())

    		var value = aget(tmp,1)


    		if value: endsWith("\"") {
    			value = value: substring(0, value: length() - 1)
    		}

    		if value: startsWith("\"") {
    			value = value: substring(1, value: length())
    		} else {
    			#IT'S A NUMBER!!!
    			#value = "@NUM@"+value
    			value = Double.parseDouble(value)
    		}

    		#println(key + " : " + value)

    		fields: put(key, value)
  		}
  		return fields
	}):
	define("simpleParse", |this, str| { #return hashmap from json string
		var arr = this: extractFields(this: removeCurlyBraces(str))
		var hashMap = this: toHashMap(arr)
		return hashMap
	}):
	define("simpleStringify", |this, hsm| { #return json string from hashmap
		var sb = StringBuilder()
		sb: append("{")
	    foreach(element in hsm: entrySet()) {
	    	#println("ENTRYSET->"+element: getValue())
	    	if element: getValue() oftype Double.class or element: getValue() oftype Integer.class {
	    		sb: append(String.format("\"%s\":%s,", element: getKey(), element: getValue()))
	    	} else {
	    		sb: append(String.format("\"%s\":\"%s\",", element: getKey(), element: getValue()))
	    	}
	        
	    }
	    var ret = sb: toString()
	    ret = ret: substring(0, ret: length() - 1) + "}"
		return ret
	}):
	define("simpleListStringify", |this, lnkList| { #return json string from list of hashmap
		var sb = StringBuilder()
		sb: append("[")
		foreach (hashmap in lnkList) {
			sb: append(this: simpleStringify(hashmap)+",")
		}
		var ret = sb: toString()
	    ret = ret: substring(0, ret: length() - 1) + "]"
		return ret
	})	

function json = -> DynamicObject():
	start("{"): end("}")


#for test
function main = |args| {

}

