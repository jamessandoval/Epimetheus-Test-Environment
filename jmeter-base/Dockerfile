
FROM openjdk:8u181-jdk-alpine3.8

# Setup Environmental Variables (for JMETER)
ENV JMETER_PLUGINS_MANAGER_VERSION 1.3
ENV CMDRUNNER_VERSION 2.2
ENV NUMBER_OF_FILES_UNDER_LIB_EXT 73
ENV JMETER_HOME /jmeter/apache-jmeter-5.0
ENV JMETER_BIN /jmeter/apache-jmeter-5.0/bin

COPY entrypoint.sh /usr/local/bin/

# Add base utilities
RUN chmod +x /usr/local/bin/entrypoint.sh \
    && apk add --no-cache \
    curl \
    net-tools \
    shadow \
    su-exec \
    tcpdump

# Install Jmeter
RUN mkdir /jmeter \
&& wget -P /jmeter https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.0.tgz \
&& tar -xvzf /jmeter/apache-jmeter-5.0.tgz -C /jmeter \
&& rm /jmeter/apache-jmeter-5.0.tgz

#Install Package manager
RUN curl --location --silent --show-error --output ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/${JMETER_PLUGINS_MANAGER_VERSION}/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar \
&& curl --location --silent --show-error --output ${JMETER_HOME}/lib/cmdrunner-${CMDRUNNER_VERSION}.jar http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/${CMDRUNNER_VERSION}/cmdrunner-${CMDRUNNER_VERSION}.jar \
&& java -cp ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar org.jmeterplugins.repository.PluginManagerCMDInstaller

# Install Additional packages
RUN ${JMETER_HOME}/bin/PluginsManagerCMD.sh install \
jpgc-graphs-additional=2.0,\
jpgc-graphs-basic=2.0,\
jpgc-graphs-composite=2.0,\
jpgc-graphs-dist=2.0,\
jpgc-graphs-vs=2.0,\
jpgc-perfmon=2.1,\
jpgc-plugins-manager=${JMETER_PLUGINS_MANAGER_VERSION},\
jpgc-rotating-listener=0.2,\
jpgc-webdriver=3.0\
&& ${JMETER_HOME}/bin/jmeter --version \
&& ${JMETER_HOME}/bin/PluginsManagerCMD.sh status \
&& chmod +x ${JMETER_HOME}/bin/*.sh
## update number of pckgs if uncomment && if [ `ls -l ${JMETER_HOME}/lib/ext/ | wc -l` != ${NUMBER_OF_FILES_UNDER_LIB_EXT} ]; then exit -1; fi

# Copy 4logj2.xml to get correct output for debugging
ADD log4j2.xml ${JMETER_BIN}

# Add Jmeter to the Path
ENV PATH $JMETER_HOME/bin:$PATH

WORKDIR /jmeter
#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#CMD ["jmeter", "--?"]
