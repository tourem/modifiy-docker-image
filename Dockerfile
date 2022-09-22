FROM crm-nexus.itg.echonet/bp2i-images/openjdk11:0.6-1
ENV SPRING_CONFIG_ADDITIONAL_LOCATION /applis/config/

# ARTIFACT, GITBRANCH et GITCOMMIT seront surchargés au moment du build
# Laisser ces valeurs par défaut

ARG ARTIFACT=rdb-ap27085-event-replicator-*-spring-boot.jar
ARG FINALARTIFACTNAME=rdb-ap27085-event-replicator.jar
ARG GITBRANCH=master
ARG GITCOMMIT=0000000

ARG PUID=1024
ARG PGID=1024

#1083.47.   Labels for Docker image (mandatory)
LABEL maintainer=mlist_paris_itg_rdb_dna_all@bnpparibas.com
LABEL description="AP27085 EVENT REPLICATOR"

#1083.48.   Labels for Docker image (Best practice)
LABEL codetype=java
LABEL gitbranch=$GITBRANCH
LABEL gitcommit=$GITCOMMIT
LABEL component=HUBBLE_MIDDLE

#1066.16.   “Dockerfile” WORKDIR
WORKDIR /applis

USER 0

#1066.15.   « DockerFile » USER
RUN groupadd -g $PGID app-group
RUN useradd -u $PUID -g $PGID -c "add app user" -M app

RUN mkdir -p ./config ./tmp ./security


# Il faut pas monter les volumes Docker. Les volumes Docker ne fonctionne pas dans paas V4. Les volumes seront monter dans Kubernetes.
# VOLUME ./config ./tmp ./security : a ne pas mettre.

COPY target/$ARTIFACT $FINALARTIFACTNAME
COPY ./entrypoint.sh entrypoint.sh
COPY ./target/classes/bnpp-truststore.jks bnpp-truststore.jks
COPY ./target/classes/ap12583-itr-v360-client-dev.jks ap12583-itr-v360-client-dev.jks
COPY ./target/classes/certificat.crt certificat.crt
RUN chmod +x entrypoint.sh
RUN chown -R $PUID:$PGID .
RUN $JAVA_HOME/bin/keytool -cacerts -import -alias kafkacertificat -file /applis/certificat.crt -storepass changeit -noprompt

#1066.15.   « DockerFile » USER
USER $PUID

ENV JAVA_OPTS="-Djdk.tls.client.protocols=TLSv1.2 -Dhttps.protocols=TLSv1.2"
ENV JAR_FILE=$FINALARTIFACTNAME

#1066.17.   “Dockerfile” EXPOSE
EXPOSE 8080

ENTRYPOINT ["/applis/entrypoint.sh"]
