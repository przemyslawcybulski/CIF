#!/bin/bash
#################################################
## Autor: Przemyslaw Cybulski			#
## e-mail: przemyslaw.cybulski@comp.com.pl	#
## last update: 23.12.2019			#
#################################################

db=/var/lib/cif/cif.db

while [ -n "$1" ]
do
case "$1" in
--help|-h) 	
	echo 'Quick-CIF 0.1'
	echo ''
	echo 'Usage: agrument'
	echo ''
	echo 'Arguments:'
	echo '  -s,	--status	Checking the status of services'
	echo '  -r,	--restart	Restart the services'
	echo '   	--stop		Stop the services'	
	echo '  	--start		Run the services'
	echo '  -c,	--crontab	Add commands restart services to crontab'
	echo '  -d	--cleardb	Delete all records from database'
	echo '  '
	exit 0;;

--status|-s) 	
	echo '====================' 
	echo ' Services status '
	echo '===================='
	systemctl status csirtg-smrt.service 
	systemctl status cif-httpd.service 
	systemctl status cif-router.service
	
	exit 0 ;;

--restart|-r)	
	echo '================================'
	echo '	 Run of the restart services '
	echo '================================'
	echo 'Restart now csirtg-smrt.service...'
	systemctl restart csirtg-smrt.service
	echo 'Restart now cif-httpd.service...' 
	systemctl restart cif-httpd.service
	echo 'Restart now cif-router.service...'
	systemctl restart cif-router.service
	echo 'Services status'
        systemctl status csirtg-smrt.service
        systemctl status cif-httpd.service
        systemctl status cif-router.service
	exit 0 ;;

--stop)
        echo '================='
        echo ' Stop services '
        echo '================='
        echo 'Stop csirtg-smrt.service...'
        systemctl stop csirtg-smrt.service
        echo 'Stop cif-httpd.service...'
        systemctl stop cif-httpd.service
        echo 'Stop cif-router.service...'
        systemctl stop cif-router.service
        echo 'Services status'
        systemctl status csirtg-smrt.service
        systemctl status cif-httpd.service
        systemctl status cif-router.service
        exit 0 ;;

--start)
        echo '================'
        echo '  Run services '
        echo '================'
        echo 'Run csirtg-smrt.service...'
        systemctl start csirtg-smrt.service
        echo 'Run cif-httpd.service...'
        systemctl start cif-httpd.service
        echo 'Run cif-router.service...'
        systemctl start cif-router.service
        echo 'Services status'
        systemctl status csirtg-smrt.service
        systemctl status cif-httpd.service
        systemctl status cif-router.service
        exit 0 ;;


--crontab|-c)	
	echo '==========================='
        echo '  Adds entries to crontab '
        echo '==========================='
	rm -rf /etc/cron.weekly/cif
	echo 'systemctl restart cif-router' >> /etc/cron.weekly/cif
	echo 'systemctl restart cif-httpd' >> /etc/cron.weekly/cif
	exit 0 ;;

--cleardb|-db)
	echo '===================================================='
	echo ' I will start the process of cleaning the database '	
	echo '===================================================='
	if [ -e $db ] ; then
    	echo "1. I find database in this path: $db"
	echo "2. I create script for clear of database"
	touch cleardatabase
	echo 'delete from indicators;' >> cleardatabase
	echo 'delete from indicators_fqdn;' >> cleardatabase
	echo 'delete from indicators_hash;' >> cleardatabase
	echo 'delete from indicators_ipv4;' >> cleardatabase
        echo 'delete from indicators_ipv6;' >> cleardatabase
        echo 'delete from indicators_url;' >> cleardatabase
	echo 'delete from messages;' >> cleardatabase
	echo 'delete from tags;' >> cleardatabase
	echo 'vacuum;' >> cleardatabase
	echo "3. Created scipt"
	echo "4. Stop services"
	systemctl stop csirtg-smrt.service
	systemctl stop cif-httpd.service
	systemctl stop cif-router.service
	echo "5. I run script for clear of database"
	sqlite3 $db < cleardatabase
	echo "6. Finished cleared of database"
	echo "7. Remove script"
	rm -rf cleardatabase;
	else
    	read -p "I can't find the database. Enter the path: " path_db
	echo "1. I create script for clear of database"
        touch cleardatabase
        echo 'delete from indicators;' >> cleardatabase
        echo 'delete from indicators_fqdn;' >> cleardatabase
        echo 'delete from indicators_hash;' >> cleardatabase
        echo 'delete from indicators_ipv4;' >> cleardatabase
        echo 'delete from indicators_ipv6;' >> cleardatabase
        echo 'delete from indicators_url;' >> cleardatabase
        echo 'delete from messages;' >> cleardatabase
        echo 'delete from tags;' >> cleardatabase
        echo 'vacuum;' >> cleardatabase
        echo "2. Created scipt"
        echo "3. Stop services"
        systemctl stop csirtg-smrt.service
        systemctl stop cif-httpd.service
        systemctl stop cif-router.service
        echo "4. I run script for clear of database"
        sqlite3 $path_db < cleardatabase
        echo "5. Finished cleared of database"
        echo "6. Removing script"
        rm -rf cleardatabase;
	fi
	exit 0 ;;

*) echo "Invalid agrument" ;;

esac
shift
done
