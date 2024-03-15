#!/bin/bash

# DEBUG
ls -la /opt/secure/
head -c 3 /opt/secure/keystore.pwd
# DEBUG

export SSL_KEY_FILE="/opt/secure/keystore.p12"
export SSL_KEY_PASSWORD="$(cat /opt/secure/keystore.pwd)"

java -javaagent:/dd-java-agent.jar \
     -Ddd.profiling.enabled=true \
     -Dgrails.env="development" \
     -DSSL_KEY_FILE="/opt/secure/keystore.p12" \
     -DSSL_KEY_PASSWORD="$(cat /opt/secure/keystore.pwd)" \
     -DGRAVIE_DB_HOST="172.17.0.1" \
     -jar /app/grails-docker.war
