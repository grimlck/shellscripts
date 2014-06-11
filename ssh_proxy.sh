#!/bin/bash
#.name		homeproxy.sh
#.version	0.2
#.coder		grim
#.date		20110803
#
#.usage		ssh_proxy.sh [user@host] [start|stop]
LOCALPORT=1080
REMOTEPORT=22
KEYFILE=""

checkPortInUse () { #check if the given port is already in use
	if [ $(netstat -anop 2>&1|grep -ic \:$1) -ne 0 ]
	then
		return 1 #port is in use
	else
		return 0 #port is not in use
	fi
}

start_tunnel () {

	checkPortInUse $LOCALPORT
	if [ $? -eq 0 ]
	then
		if [ -e ./ssh_proxy_pid.tmp ]
		then
			echo "Tunnel pid found. Check if there is already a tunnel established"
		elif [ "$KEYFILE" != "" ]
		then
			ssh -f -N -D -i $KEYFILE $LOCALPORT $1 -p $REMOTEPORT 2>&1 > /dev/null
			echo $? > ssh_proxy_pid.tmp
		else
			ssh -f -N -D $LOCALPORT $1 -p $REMOTEPORT
			echo $? > ssh_proxy_pid.tmp 2>&1 > /dev/null
		fi
	else
		echo "Port $LOCALPORT already in use. Choose another one."
	fi
}

stop_tunnel () {
	if [ -e ./ssh_proxy_pid.tmp ]
	then
		read TUNNELPID < ./ssh_proxy_pid.tmp
        echo $TUNNELPID
		kill $TUNNELPID
		rm "./ssh_proxy_pid.tmp"
	else
		echo "No tunnel established"
		exit 1
	fi
}


if [ "$1" == "start" ] || [ "$1" == "Start" ]
then
	echo "Usage: $0 [user@host] [start|stop]"
	exit 1
elif [ "$1" == "stop" ] || [ "$1" == "Stop" ]
then
	stop_tunnel
else
	case $2 in
	"start"|"Start")
		start_tunnel $1
		exit 0
		;;
	*)
		echo "No such option. Usage: $0 [user@host] [start|stop]"
		exit 1
		;;
	esac
fi

exit 0
