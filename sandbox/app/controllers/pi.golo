module pi

import java.lang.Thread
import java.util.concurrent
import gololang.concurrent.workers.WorkerEnvironment

import java.lang.System
import java.lang.Math

#golo modules
import content
import html
import constants
import httpconnection
import json
#import workers


local function term = |k| {
    return (Math.pow(-1.0, k))/(2*k+1)
}

local function piCalculusBy = |fromWho, howManyIterations, httpExchange| {
	    println("===== START : "+fromWho+" =====")

	    var startTime = System.currentTimeMillis()
	    var unQuartDePi = 0.0
	    var pi = 0.0
	    var k = 0.0

	    for (var i = 0, i < howManyIterations, i = i + 1) {

	        unQuartDePi = unQuartDePi + term(k)
	        pi = 4 * unQuartDePi
	        k=k+1.0
	    }

	    println("Après "+k+" itérations, "+fromWho+" pense que PI = "+ pi)
	    var endTime   = System.currentTimeMillis()
	    var totalTime = endTime - startTime
	    println("Et tout ça en "+totalTime+" ms")

		var flow = Flow(): init(pi + " après "+k+" itérations Et tout ça en "+totalTime+" ms" , ContentType(): PLAIN())

		sendContent(flow, httpExchange)

		println("===== END : "+fromWho+" =====")
}

#	env(WorkerEnvironment.builder(): withFixedThreadPool()):



function pi = -> DynamicObject():
	define("einstein", |this, httpConnection|{

		let einsteinPort = httpConnection: env(): spawn(|fromWho| {
			piCalculusBy(fromWho, 1050000, httpConnection: httpExchange())
			
			#httpConnection: env(): shutdown()
		})
		
		einsteinPort: send("ALBERT EINSTEIN")

		#httpConnection: env(): shutdown()

		#explain to the handler to not flush header
		return Flow(): waitForSomething(true)

	}):
	define("euler", |this, httpConnection|{


		let eulerPort = httpConnection: env(): spawn(|fromWho| {
			piCalculusBy(fromWho, 3050000, httpConnection: httpExchange())
			
			#httpConnection: env(): shutdown()
		})

		eulerPort: send("EULER")

		#httpConnection: env(): shutdown()

		return Flow(): waitForSomething(true)
		
	}):
	define("index", |this, httpConnection|{
    var html = Array("<!DOCTYPE html>",
        "<html>",
        "   <head>",
        "       <title>Albert et Euler</title>",
        "       <link rel='stylesheet' type='text/css' href='css/bootstrap.min.css'>",
        "   </head>",
        "   <body>",
        "   <h1>Euler et Albert Einstein calculent π</h1>",
        "   <h2>powered by golo and fast!>>forward NextGen.</h2>",
        "   <h3>Regardez votre console serveur ...</h3>",
        "   <h4>Euler : <euler></euler></h4>",
        "   <h4>Einstein : <einstein></einstein></h4>",
        "   <style>",
        "       body {",
        "           margin: 20px;",
        "       }",
        "   </style>",
        "   <script src='js/vendors/jquery.js'></script>",
        "   <script>",
        "        $.get('/euler',function(data){",
        "       	$('euler').html(data);",
        "        });",
        "        $.get('/einstein',function(data){",
        "       	$('einstein').html(data);",
        "        });",
        "   </script>",
        "   </body>",
        "</html>")
        var result = ""
        foreach (line in atoList(html)) {
            result = result + line
        }

        return Flow(): init(
    		result, 
    		ContentType(): HTML()
    	)

})
