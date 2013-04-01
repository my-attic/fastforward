#Jars

You can put jars here, they will be "visibles" by all webapps

#Fast!>forward java extensions

Build it : 

	cd java.extensions
	 mvn compile assembly:single

Then a new jar `fastforward.java.extensions-1.0-jar-with-dependencies.jar` is generated to `/java.extensions/target/`.
You can move it (or not) if you want (ie in production) to the root of `jars` directory.

You can add your own java extenssions : see `src` directory or add jar dependencies to the `pom.xml` file