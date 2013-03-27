module html

#============================
# My little html dsl
#============================

import java.util.HashMap
import java.util.Map
import java.util.LinkedList

import java.lang.StringBuilder
import java.lang.String

#TO BE CONTINUED ...

function tag = -> DynamicObject():
	name(""):
	tags(LinkedList()):
	datas(LinkedList()):
	define("set", |this| {
		var style = ""
		var attrs = ""
		var cssclass = ""
		
		var rel = ""
		var type = ""
		var href = ""

		var datas = ""

		if this: get("style") isnt null {
			style = " style='"+this: style()+"'"
		}

		if this: get("attrs") isnt null {
			attrs = " "+this: attrs()
		}

		#rel='stylesheet' type='text/css' href='css/bootstrap.min.css'
		if this: get("rel") isnt null {
			rel = " rel='"+this: rel()+"'"
		}
		if this: get("type") isnt null {
			type = " type='"+this: type()+"'"
		}
		if this: get("href") isnt null {
			href = " href='"+this: href()+"'"
		}				

		if this: get("cssclass") isnt null {
			cssclass = " class='"+this: cssclass()+"'"
		}

		foreach (m in this: datas()) {
            datas = " "+ datas + m
        }

		this: start(String.format("<%s%s%s%s%s%s%s%s>", this: name(), attrs, datas, style, rel, type, href, cssclass))
		this: end(String.format("</%s>", this: name()))
		return this
	}):	
	define("add", |this, tag| {
		this: tags(): add(tag)
		return this
	}):
	define("$", |this, tag| {
		this: tags(): add(tag)
		return this
	}):	
	define("$$", |this, tag| {
		#this: tags(): add(tag)
		#ajouts multiples 
		return this
	}):
	define("data", |this, data, value|{
		#println(data,value)
		this: datas(): add("data-"+data+"=\""+value+"\"")
		return this
	}):	
	define("gen", |this| {
		
		this: set()
		var sb = StringBuilder()

		sb: append(this: start())

		if this: get("innerText") isnt null {
			sb: append(this: innerText())
		}

		if this: get("innerHTML") isnt null {
			sb: append(this: innerHTML())
		}

        foreach (m in this: tags()) {
            sb: append(m: gen())
        }

		sb: append(this: end())
		return sb: toString()
	})



function text = -> DynamicObject():
	content(""):
	define("set", |this, text|{
		this: content(text)
		return this
	}):
	define("gen", |this| {
		return this: content()
	})


function body = -> DynamicObject():
	mixin(tag()):
	name("body")

function head = -> DynamicObject():
	mixin(tag()):
	name("head")


function div = -> DynamicObject():
	mixin(tag()):
	name("div")

function h1 = -> DynamicObject():
	mixin(tag()):
	name("h1")

function h2 = -> DynamicObject():
	mixin(tag()):
	name("h2")

function h3 = -> DynamicObject():
	mixin(tag()):
	name("h3")

function h4 = -> DynamicObject():
	mixin(tag()):
	name("h4")

function h5 = -> DynamicObject():
	mixin(tag()):
	name("h5")					

function p = -> DynamicObject():
	mixin(tag()):
	name("p")	

function title = -> DynamicObject():
	mixin(tag()):
	name("title")

function link = -> DynamicObject():
	mixin(tag()):
	name("link")

function a  = -> DynamicObject():
	mixin(tag()):
	name("a")

function input  = -> DynamicObject():
	mixin(tag()):
	name("input")

function script  = -> DynamicObject():
	mixin(tag()):
	name("script")	

function ul  = -> DynamicObject():
	mixin(tag()):
	name("ul")

function li  = -> DynamicObject():
	mixin(tag()):
	name("li")



function html = -> DynamicObject():
	lang("en"): #todo
	mixin(tag()):
	name("html")


# ul li
# span
# textarea
# table ....
# generic tag



#for test
function main = |args| {

    var page = 
        html(): 
            $(head(): 
                    $(title(): innerText("Hello")): 
                    $(link())
            ):
            $(body(): cssclass("pretty"): style("border:0"): 
                    $(div(): style("border:solid; border-color:red"):
                        $(div(): innerHTML("Salut"))
                    ): 
                    $(div(): attrs("data-msg='hello'"))
                ):
            gen()

	println(page)

}





