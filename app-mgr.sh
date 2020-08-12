#!/bin/bash

# coffee='node_modules/.bin/coffee'
node='node'
forever='forever'

# app=$(pwd)/app/nobone.coffee
app=$(pwd)/server/server.js

case $1 in
	'setup' )
		# Dependencies install
        cd server && npm install;

		# Configuration
		# config_example='kit/config.example.coffee'
		# if [ ! -f var/config.coffee ]; then
		# 	echo '>> Auto created an example config file.'
		# 	cp $config_example var/config.coffee
		# fi
		;;

    'build' )
		cd app && npm run build;
		;;

	'test' )
		# $node --debug $app
		;;

	'start' )
        NODE_ENV=production
		uptime_conf='--minUptime 5000 --spinSleepTime 5000'
		log_conf='-a -o log/std.log -e log/err.log'
		$forever start $uptime_conf $log_conf $app
		;;

	'stop' )
		$forever stop $app
		;;
esac
