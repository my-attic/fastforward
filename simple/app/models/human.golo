module human #kind of model


function Human = -> DynamicObject():
	define("initialize", |this, firstName, lastName|{
		this:firstName(firstName)
		this:lastName(lastName)
		return this
	})