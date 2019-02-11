

### Epimetheus Test Environment
This Repository contains a system to be able to run load tests using jmeter along with selenium tests across many headless browsers on one machine.

#### To run it:

1.) Execute Tests by running the shell command with the required number of slave nodes for Jmeter (Slaves simply run an exact duplicate of the test specified and combine the results with master)

(This will start Selenium hub, browsers, and jmeter master/slave images -> Then it will run all tests with files labeled *.jmx stored in scripts directory)

$ ./exec-jmeter-docker.sh <# of jmeter slaves to run>

If that test completed successfully, results will be stored in the results folder with name of test and timedate stamp

#### References:

# Adding Plugins and using different jmeter versions
https://hub.docker.com/r/egaillardon/jmeter-plugins

Set up Selenium Grid with multiple Chrome nodes
https://robotninja.com/blog/introduction-using-selenium-docker-containers-end-end-testing/


#### TODO : This may be worth checking out at some point:
#### Selenium on kubernetes

https://github.com/kubernetes/examples/tree/master/staging/selenium

docker run -d -p 4444:4444 --name selenium-hub selenium/hub:3.141.59-gold

docker run -d --link selenium-hub:hub selenium/node-chrome:3.141.59-gold
