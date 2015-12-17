#! /bin/bash -x
# chkconfig: 2345 99 10
# description: auto start joinple
#
# Starts/stops neo4j and rails on this specific server, depending on the server name.
#
# Authors:
# 	Paolo Di Pietro <pdipietro@joinple.com>

shopt -s nocasematch
# 99set -ex

cd $HOME/joinple

# test for autologin definition

if [ ! -f /etc/lightdm/lightdm.conf.d/50-myconfig.conf ]; then
		cp ~/joinple/50-myconfig.conf /etc/lightdm/lightdm.conf.d
fi

# test command line parms
 
case $1 in 
	start) 		: ;;
	restart) 	: ;;
	rails) 	  : ;;
	stop) 		: ;;
	stopNeo4j): ;;
	status) 	: ;;
	*) echo "usage: bash ./autorun.sh [start|rails|restart|stop|stopNeo4j|status)"; exit 9;;
esac

# RE to check server name

re="JPL[-_](dev|development|depl|deploy|deployment|prod|production|test|demo)[0-9]*[-_]?(depl|deploy|deployment|prod|production|demo)?";
name=$(hostname);

if [[ $name =~ $re ]]; then 
	x=0
else
	exit 2
fi

stage=""

case ${BASH_REMATCH[1]} in	
		dev)  				stage="development";;
		development)  stage="development";;

		depl) 				stage="production";; 
		deploy) 			stage="production";; 
		deployment) 	stage="production";; 
		prod) 				stage="production";; 
		production) 	stage="production";; 
		demo) 				stage="development";; 

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
	esac
fi

# ############################## Settinh cloudinary keys

case "$stage" in
	"development")
		CLOUDINARY=cloudinary://366838292492816:UeYoN5X7ErMed26Jo3YHkw7U84E@dev-joinple-com
	;;
  "demo")
  	CLOUDINARY=cloudinary://217559122767512:_IsSa14mTzfbAk4ZXgU9WYUbpcA@demo-joimple-com
	;;
  "test")
  	CLOUDINARY=cloudinary://122778178523376:dCiaL9DbB5WlsppOSkOFfsqDxek@test-joinple-com
  ;;
  "production")
		CLOUDINARY=cloudinary://318235473349975:-ansQxvlvQ0AzwctsjGwdSeMQkA@www-joinple-com
	;;
	"*")
  	CLOUDINARY=none
  ;;
esac

# positioning on joinple directory
cd /home/joinple/joinple

neo4jVersion=$(cat /home/joinple/joinple/db/neo4j-version)

if [[ ! -d ./db/neo4j ]]; then 
	mkdir ./db/neo4j 
fi

if [[ -h ./db/neo4j/$stage ]] && [[ ! ./db/neo4j/$stage -ef ../$neo4jVersion ]]; then 
	unlink ./db/neo4j/$stage
fi
if [[ ! -h ./db/neo4j/$stage ]]; then 
	ln -s ../$neo4jVersion ./db/neo4j/$stage
	# echo "created "./db/neo4j/$stage" => "../$neo4jVersion
fi

railsPidDir="/home/joinple/joinple/tmp/pids"

neo4jData="./db/neo4j/$stage/data/graph.db"
neo4jLog="./db/neo4j/$stage/data/log"
neo4jBin="./db/neo4j/$stage/bin"

# neo4jPid="/home/joinple/joinple/db/$neo4jVersion/pids"


if [[ ! -d $neo4jData/schema  ||  ! -d $neo4jData ]]; then
	# echo "Create a new DB and initialize it."
	if [[ ! -d $neo4jData ]]; then	mkdir -p $neo4jData $neo4jLog; fi
	chown -R $USER:$USER $neo4jLog $neo4jData 
	cat ./db/joinple_load_initial.txt | $neo4jBin/neo4j-shell neo4j.properties -path $neo4jData > $neo4jLog/db_load.log   2>$neo4jLog/db_load_stderr.log
	chown -R $USER:$USER $neo4jLog $neo4jData $neo4jLog/db_load.log $neo4jLog/db_load_stderr.log
	chmod -R 777 $neo4jLog $neo4jData $neo4jLog/db_load.log $neo4jLog/db_load_stderr.log
fi


getRailsPid() {
	GRP=`ps -ef | grep '/home/joinple/.rvm/rubies'  | grep -v 'ps -ef' | grep -v 'grep' | awk '{print $2}'`
	echo "GRP=${GRP}"
}

getNeo4jPid() {
	GNP=`ps -ef | grep '/java -cp /home/joinple/joinple/db/neo4j/' | grep -v 'ps -ef' | grep -v 'grep' | awk '{print $2}'`
	echo "GNP=${GNP}"
}


outStatus() {
	getNeo4jPid

	if [ "${GNP}" ]; then
		echo "Neo4j is running with PID=[$GNP]"
	else
		echo "Neo4j is not running"
	fi
	
	getRailsPid
	if [ "${GRP}" ]; then
		echo "Rails is running with PID=[$GRP]"
	else
		echo "Rails is not running"
	fi
}

startNeo() {
	getNeo4jPid

	# start the db neo4j if not yet running
	if [ ! "${GNP}" ]; then
		echo Starting Neo4j...
		$neo4jBin/neo4j start || { exit 1; }
	fi
}

startRails() {
	getRailsPid
	if [ ! "${GRP}" ]; then
		{ rails s -b0.0.0.0 -e$stage; } || { exit 1; }
	fi
	return 0;
}

stopNeo() {
	getNeo4jPid
	if [ "${GNP}" ]; then
		$neo4jBin/neo4j stop || { return 0; }
	fi
}

stopRails() {
	getRailsPid
	if [ "${GRP}" ]; then
		kill -9 $GRP 
		if [[ -f $railsPidDir/server.pid ]]; then
			rm -f $railsPidDir/server.pid
		fi
	fi
	return 0;
}

case $1 in
	start)
		startNeo 
		startRails
		# exit 0
		;;

	rails)
		startRails
		exit 0
		;;

	stop)
		stopRails
		stopNeo
		exit 0
		;;

	stopNeo4j)
		stopNeo
		exit 0
		;;

	restart)
		stopRails
		stopNeo

		startNeo
		startRails
		# exit 0
		;;

	status)
		outStatus
		exit 0
		;;
	*)
		#echo "usage: bash ./autorun.sh [start|rails|restart|stop)"
		exit 1
		;;
esac





