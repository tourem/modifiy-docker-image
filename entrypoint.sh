#!/bin/bash

java ${JAVA_OPTS} -cp /applis/cp org.springframework.boot.loader.JarLauncher ${0} ${@}
#java ${JAVA_OPTS} -Djava.io.tmpdir=/applis/tmp -jar ${JAR_FILE}
