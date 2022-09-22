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

LABEL maintainer=larbotech@gmail.com
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

COPY target/$ARTIFACT $FINALARTIFACTNAME
COPY ./entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh
RUN chown -R $PUID:$PGID .

#1066.15.   « DockerFile » USER
USER $PUID

ENV JAVA_OPTS="-Djdk.tls.client.protocols=TLSv1.2 -Dhttps.protocols=TLSv1.2"
ENV JAR_FILE=$FINALARTIFACTNAME

#1066.17.   “Dockerfile” EXPOSE
EXPOSE 8080

ENTRYPOINT ["/applis/entrypoint.sh"]
