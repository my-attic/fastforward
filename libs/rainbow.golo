module rainbow


function console = -> DynamicObject():
	define("reset", |this|{
		print("\u001B[0m")
		return this
	}):		
	define("black", |this|{
		print("\u001B[30m")
		return this
	}):	
	define("gray", |this|{
		print("\u001B[30;1m")
		return this
	}):		
	define("red", |this|{
		print("\u001B[31m")
		return this
	}):
	define("brightRed", |this|{
		print("\u001B[31;1m")
		return this
	}):	
	define("green", |this|{
		print("\u001B[32m")
		return this
	}):
	define("brightGreen", |this|{
		print("\u001B[32;1m")
		return this
	}):			
	define("yellow", |this|{
		print("\u001B[33m")
		return this
	}):	
	define("brightYellow", |this|{
		print("\u001B[33;1m")
		return this
	}):		
	define("blue", |this|{
		print("\u001B[34m")
		return this
	}):
	define("brightBlue", |this|{
		print("\u001B[34;1m")
		return this
	}):	
	define("purple", |this|{
		print("\u001B[35m")
		return this
	}):	
	define("brightPurple", |this|{
		print("\u001B[35;1m")
		return this
	}):		
	define("cyan", |this|{
		print("\u001B[36m")
		return this
	}):	
	define("brightCyan", |this|{
		print("\u001B[36;1m")
		return this
	}):		
	define("white", |this|{
		print("\u001B[37m")
		return this
	}):
	define("brightWhite", |this|{
		print("\u001B[37;1m")
		return this
	}):													
	define("println", |this, content|{
		println(content)
		return this
	}):
	define("print", |this, content|{
		print(content)
		return this
	})	


function main = |args| {
	console():
		green():print("Hello "): 
		red():println("World !!!"):
		yellow():print("Salut "):blue():println("à tous ..."):
		purple():print("Morgen "):cyan():println(" ..."):brightBlue():println("Hi !!! "):
		white():print("tadaaaaaaa"):red():print("tadaaaaaaa"):brightRed():
		print("that's all folks"):gray():println(" !!!")
}


