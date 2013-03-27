module static

import java.io.File
import java.nio.file.Files
import java.nio.file.FileSystems
import java.net.URLConnection
import java.lang.String

#golo modules
import parameters
import content
import constants
import rainbow

local function getMimeType = |file| {
    var mime = URLConnection.getFileNameMap(): getContentTypeFor(file: getName())

    if mime is null {
        if file: getName(): contains(".css") {
            mime = ContentType(): CSS()
        }
        if file: getName(): contains(".js") {
            mime = ContentType(): JS()
        }
        if file: getName(): contains(".json") {
            mime = ContentType(): JSON()
        }
        if file: getName(): contains(".ico") {
            mime = ContentType(): ICO()
        }
        if file: getName(): contains(".md") {
            mime = ContentType(): PLAIN()
        }
    #TO BE CONTINUED                
    }
    return mime
}

#Static assets
function serveStaticFiles = |httpExchange, applicationName| {
	var flow = Flow()
	#flow: responseCode(200)
    try {
	    var requestUri = httpExchange: getRequestURI() :toString(): trim()

        #println("requestUri : " +requestUri)
        if requestUri: equals("/") {
            requestUri = Parameters(): DEFAULT_STATIC()
        }

	    var pub = File(applicationName+"/"+Parameters(): PUBLIC())		#final File pub = new File(Params.PUBLIC);
	    var absolutePath = pub: getAbsolutePath()	#String absolutePath = pub.getAbsolutePath();
	    var file = File(absolutePath + requestUri)	#final File file = new File(absolutePath + requestUri);        
        
        if file: exists() isnt true { #Ouch ... 404
        	console():yellow():println("404!? : " + absolutePath + requestUri):reset()
        	#httpExchange: sendResponseHeaders(404, 0)
            flow: content("<h1><span style='color:red;'>404!?</span> : " + requestUri + " not found :(</h1>")
        	flow: contentType(ContentType(): HTML())
        	flow: responseCode(404)
            #sendContent(flow, httpExchange)
        } else { #so ... file exists
            var mime = getMimeType(file)

            try {             
                #var path = Paths.get(absolutePath + requestUri)
                var fs =  FileSystems.getDefault()
                var path = fs: getPath(absolutePath + requestUri)

                var out = Files.readAllBytes(path)          

                flow: contentType(mime)
                flow: bytesContent(out) #dynamic assignement (no more)

            } catch(e) {
                e: printStackTrace()
                #Ouch, i did it again
                var errorFlow = Flow(): init(
                    e: getCause(): getMessage(), 
                    ContentType(): HTML()
                )
                errorFlow: responseCode(500)
                sendContent(errorFlow, httpExchange) #or return flow in finally block ?
            } finally {
                #... ???
            }
        } #end if

    } catch(e) {
    	e: printStackTrace()
    	#Ouch, i did it again
    	var errorFlow = Flow(): init(
    		e: getCause(): getMessage(), 
    		ContentType(): HTML()
    	)
    	errorFlow: responseCode(500)
    	sendContent(errorFlow, httpExchange) #or return flow in finally block ?
    } finally {
    	#... ???
    }
    return flow	
}