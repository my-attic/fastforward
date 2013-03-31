


	var babs = new TinyToon({firstName:"Babs", lastName:"Bunny"})
	var buster = new TinyToon({firstName:"Buster", lastName:"Bunny"})
	var elmyra = new TinyToon({firstName:"Elmyra", lastName:"Duff"})

	elmyra.save()

	elmyra.save({description:"a kid, redheaded, female human"})

	buster.save({description:"a blue male rabbit"})
	babs.save({description:"a pink female rabbit"})

	
	toons = new TinyToons()
	toons.fetch()

	//ajouter une méthode
	toons.at(0).start()


