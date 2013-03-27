module files

import java.io.FileReader
import java.io.BufferedReader
import java.lang.StringBuilder


function file = -> DynamicObject():
	define("read", |this, strFilePath| {
		var br = BufferedReader(FileReader(strFilePath))
		var ret = null
		try {
			
			var sb = StringBuilder()
	        var line = br: readLine()

	        while (line != null) {
	        	#println(line)
	            sb: append(line)
	            sb: append("\n")
	            line = br: readLine()
	        }

	        ret = sb: toString()			
	    } catch(e) {
	    	println(e: getMessage())
	    } finally {
        	br: close()	
        }
        return ret

	})