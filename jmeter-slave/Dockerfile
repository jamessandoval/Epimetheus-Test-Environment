FROM jmeter-base

# Ports to be exposed from the container for JMeter Slaves/Server
EXPOSE 1099 50000

RUN echo "Starting up slaves"

# Application to run on starting the container
ENTRYPOINT $JMETER_HOME/bin/jmeter-server -Jserver.rmi.ssl.disable=true \
-Dserver.rmi.localport=50000 \
-Dserver_port=1099
