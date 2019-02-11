#!/bin/bash

logfile="logfile.log"
COUNT=${1-1}

docker build -t jmeter-base jmeter-base
docker-compose build

#Selenium Services
#docker-compose up -d selenium_hub
#docker-compose up -d --scale node_chrome=2

# Only run if not running
if [ ! "$(docker ps -q -f name='selenium-hub' )" ]; then
    docker run -d -p 4444:4444 --name selenium-hub selenium/hub:3.141.59-gold
fi

# Run a chrome instance for each run
for (( i=1; i<=$COUNT; i++ ))
do
   docker run -d --link selenium-hub:hub selenium/node-chrome:3.141.59-gold
done

# Jmeter Services
docker-compose up -d master
docker-compose up -d --scale slave=$COUNT

# Start Selenium Hub Containers :

SLAVE_IP=$(docker inspect -f '{{.Name}} {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq) | grep slave | awk -F' ' '{print $2}' | tr '\n' ',' | sed 's/.$//')
WDIR=`docker exec -it master /bin/pwd | tr -d '\r'`

#rm -rf results
mkdir -p results
#mkdir -p logs

#echo "Beginning jmeter execution"
for filename in scripts/*.jmx; do
    NAME=$(basename $filename)
    NAME="${NAME%.*}"
    CURRENTDATETIME=$(sed -e "s/:/-/g" <<< `date +"%Y-%m-%d_%T"`)

    eval "docker cp $filename master:$WDIR/scripts"
    eval "docker exec master ls $WDIR/scripts"
    eval "docker exec master mkdir -p /jmeter/reports"
    eval "docker exec master rm -rf /jmeter/apache-jmeter-5.0/bin/report-output"
    eval "docker exec master /jmeter/apache-jmeter-5.0/bin/jmeter -e -n -f -l /jmeter/reports/$NAME/logfile.log -t $WDIR/$filename -j /jmeter/jmeter-log-$CURRENTDATETIME.log -Jserver.rmi.ssl.disable=true -R$SLAVE_IP"
    eval "docker exec master ls /jmeter/reports/$NAME"
    eval "docker cp master:/jmeter/apache-jmeter-5.0/bin/report-output results/$NAME-$CURRENTDATETIME"
    eval "docker cp master:/jmeter/jmeter-log-$CURRENTDATETIME.log results/$NAME-$CURRENTDATETIME/jmeter-log-$CURRENTDATETIME.log"
    # Compress and email results
    zip -r results/$NAME-$CURRENTDATETIME.zip results/$NAME-$CURRENTDATETIME
    echo "Test Results: $NAME-$CURRENTDATETIME " | mutt -s 'Test Results: $NAME-$CURRENTDATETIME' jasandov@starbucks.com -a results/$NAME-$CURRENTDATETIME.zip 
	
    rm results/$NAME-$CURRENTDATETIME.zip

done

# Connect to an IMAGE via ssh (Useful for debugging)
#docker run --rm -ti docker-jmeter-cluster_master sh

##
## JMETER OPTIONS  ---------------------------------------------------------->
##
