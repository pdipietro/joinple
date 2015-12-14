#! /bin/bash -x
#
# joinple autostart
#
# Starts/stops neo4j and rails on a specific server.
#
# Rules: The start script is not run when the service was already
# configured to run in the previous runlevel.  A stop script is not run
# when the the service was already configured not to run in the previous
# runlevel.
#
# Authors:
# 	Paolo Di Pietro <pdipietro@joinple.com>

shopt -s nocasematch
set -ex



# test for autologin definition

if [ ! -f /etc/lightdm/lightdm.conf.d/50-myconfig.conf ]; then
		cp --parents ~/joinple/50-myconfig.conf /etc/lightdm/lightdm.conf.d
fi

# test command line parms
 
case $1 in 
	start) 		: ;;
	restart) 	: ;;
	rails) 	  : ;;
	stop) 		: ;;
	status) 	: ;;
	*) echo "usage: bash ./autorun.sh [start|rails|restart|stop|status)"; exit 9;;
esac

# RE to check server name

re="JPL[-_](dev|development|depl|deploy|deployment|prod|production|test|demo)[0-9]*[-_]?(depl|deploy|deployment|prod|production|demo)?";
name=$(hostname);

#echo $name;

if [[ $name =~ $re ]]; then 
	x=0
else
	exit 2
fi

stage=""
substage=""

case ${BASH_REMATCH[1]} in	
		dev)  				stage="development";;
		development)  stage="development";;

		depl) 				stage="production";; 
		deploy) 			stage="production";; 
		deployment) 	stage="production";; 
		prod) 				stage="production";; 
		production) 	stage="production";; 
		demo) 				stage="production";; 

		test) 				stage="test";; 

		*)						stage="" 
esac

if [[ $stage == "test" ]]; then
	case ${BASH_REMATCH[2]} in
		depl) 				stage="production";; 
		deploy) 			stage="production";; 
		deployment) 	stage="production";; 
		prod) 				stage="production";; 
		production) 	stage="production";; 
		demo) 				stage="demo";;

		*) 						substage=""
	esac
fi

#echo -n "This is the stage named" $stage;
#if [ $substage ]; then
#	echo -n " ["$substage"]";
#fi
#echo " ";

# positioning on joinple directory
cd /home/joinple/joinple


railsPidDir="/home/joinple/joinple/tmp/pids"

neo4jVersion=$(cat /home/joinple/joinple/db/neo4j-version)

neo4jData="./db/$neo4jVersion/data/graph.db"
neo4jLog="./db/$neo4jVersion/data/log"
neo4jBin="./db/$neo4jVersion/bin"

# neo4jPid="/home/joinple/joinple/db/$neo4jVersion/pids"


if [[ ! -d $neo4jData/schema  ||  ! -d $neo4jData ]]; then
	echo "Create a new DB and initialize it."
	if [[ ! -d $neo4jData ]]; then	mkdir $neo4jData; fi
	chown -R $USER:$USER $neo4jLog $neo4jData $neo4jLog/db_load.log $neo4jLog/db_load_stderr.log
	cat ./db/joinple_load_initial.txt | $neo4jBin/neo4j-shell neo4j.properties -path $neo4jData > $neo4jLog/db_load.log   2>$neo4jLog/db_load_stderr.log
	chown -R $USER:$USER $neo4jLog $neo4jData $neo4jLog/db_load.log $neo4jLog/db_load_stderr.log
	chmod -R 777 $neo4jLog $neo4jData $neo4jLog/db_load.log $neo4jLog/db_load_stderr.log
fi

neo4jPid="/home/joinple/joinple/db/$neo4jVersion/data/neo4j-service.pid"
echo 	"echo 1)" $railsPidDir

getRailsPid() {
	if [[ -f $railsPidDir/server.pid ]]; then
		railsPid=$(cat $railsPidDir/server.pid)
		echo "2)" $railsPid
	else
		railsPid=eval "ps -C rails -o pid="
		echo "1)" $railsPid
	fi
}

echo "evaluate request" $1

startNeo4j() {
	# start the db neo4j if not yet running
	if [ -f $neo4jPid ]; then
		pid=$(cat $neo4jPid)
		echo "Neo4j already running with PID=" $pid". Run bash ./autorun.sh stop"
	else
		echo Starting Neo4j...
		$neo4jBin/neo4j start || { echo "Err starting Neo4j"; exit 1; }
	fi
}

startRails() {
	{ rails s -b0.0.0.0 -e$stage; } || { echo "Err starting Rails"; exit 2; }
}

stopRails() {
	getRailsPid
	if [ ! -z "${railsPid}" ]; then
		kill -9 $railsPid || { echo "Err stopping Rails: continue"; return 3; }
		rm -f $railsPidDir/server.pid
	fi
}

stopNeo4j() {
	$neo4jBin/neo4j stop || { echo "Err stopping Neo4j"; return 4; }
}

case $1 in

	start)
		startNeo4j 
		startRails
		# exit 0
		;;

	rails)
		startRails
		exit 0
		;;

	stop)
		stopRails
		stopNeo4j
		exit 0
		;;

	restart)
		stopRails
		stopNeo4j

		startNeo4j
		startRails
		# exit 0
		;;

	status)
		echo "not yet implemented"
		exit 1
		;;
	*)
		echo "usage: bash ./autorun.sh [start|rails|restart|stop)"
		exit 1
		;;
esac





