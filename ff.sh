#!/bin/sh
# Copyright (c) 2013 Philippe Charrière aka @k33g_org
#
# All rights reserved. No warranty, explicit or implicit, provided.
#
if [ "$1" == "new" ]
	then
		#CREATE WEB APP FROM TEMPLATE
		echo "new $2 from $3"
		cp -r $3 $2
	else
		if [ "$1" != "" ]
			then
				#RUN WEB APPLICATION

				echo "1- loading global jars"
				#FIND GLOBAL JARS
				JARS=""
				FILES="$(find jars -name '*.jar')"
				for jar in $FILES
				do
					JARS="$JARS$PWD/$jar:"
					echo "--> $jar"
				done

				echo "2- loading application jars"
				#FIND APPLICATION JARS
				FILES="$(find $1/jars -name '*.jar')"
				for jar in $FILES
				do
					JARS="$JARS$PWD/$jar:"
					#echo "--> $jar"
				done

				export CLASSPATH_PREFIX=${CLASSPATH_PREFIX}:"$JARS"

				#echo "CLASSPATH_PREFIX : $CLASSPATH_PREFIX"
				#echo "starting : $0 with $1"

				echo "3- loading Fast!>>Forward Golo Libraries"
				#FIND FASTFORWARD GOLO LIBRARIES
				LIBS=""
				FILES="$(find libs -name '*.golo')"
				for gf in $FILES
				do
					LIBS="$LIBS $gf"
					#echo "--> $gf"
				done
				#echo "$LIBS"

				echo "4- loading application Golo Libraries and Scripts"
				#FIND GOLO APPLICATION SCRIPTS
				APPSCRIPTS=""
				FILES="$(find $1 -name '*.golo')"
				for gf in $FILES
				do
					APPSCRIPTS="$APPSCRIPTS $gf"
					#echo "--> $gf"
				done
				#echo "$APPSCRIPTS"

				gologolo $LIBS $APPSCRIPTS fastforwardnextgen.golo --args $1

			else
				echo "you probably forgot the name of the application"
		fi
	
fi



