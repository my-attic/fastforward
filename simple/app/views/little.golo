module little #view

import html

function little = -> DynamicObject():
	define("render", |this, message, otherMessage|{

	    return 
	        html(): 
	            $(head(): 
	                    $(title(): innerText("Hello"))
	            ):
	            $(body(): 
	                    $(div(): style("border:solid; border-color:red"):
	                        $(h1(): style("color:green;"): innerHTML(message)):
	                        $(h2(): style("color:blue;"): innerHTML(otherMessage))
	                    ):
	                    $(p():innerHTML("yes, i know, it's creepy"))
	                ):
	            gen()
	})