# STAGE: SSL - Generate Self-signed cert for tomcat
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17 \
    AS ssl-gen

#    -keypass $(cat sskeystorepwd) \
WORKDIR /
RUN date +%s | base64 > sskeystorepwd && \
    keytool -genkey -noprompt \
    -alias tomcat \
    -dname "C=US, ST=Minnesota, L=Minneapolis, O=Gravie, OU=IT Department, CN=internal.self-signed.gravie.us" \
    -keystore keystore.p12 \
    -storetype PKCS12 \
    -storepass $(cat sskeystorepwd) \
    -keysize 2048 \
    -validity 365 \
    -keyalg RSA

# STAGE: MAIN - Package the main image
FROM amazoncorretto:8-al2023 \
    AS main

LABEL organization=Gravie

# Install the datadog java agent for exposing JVM metrics
RUN curl -sL 'https://dtdg.co/latest-java-tracer' -o "dd-java-agent.jar"

WORKDIR /app
COPY bootstrap.sh bootstrap.sh

# Install the service war/jar, generated ssl files
COPY build/libs/grails-docker-0.1.war grails-docker.war
COPY --from=ssl-gen keystore.p12 /opt/secure/keystore.p12
COPY --from=ssl-gen sskeystorepwd /opt/secure/keystore.pwd

EXPOSE 8005

CMD ["/app/bootstrap.sh"]
