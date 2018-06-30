#!/bin/bash
# required variables
source env.sh
cd $PROJECT_HOME
# build
./mvnw clean package
# check ear exists
if [ ! -f ${BUILD_DIR}/howdy-app.ear ]; then
    echo "howdy-app.ear not found yo!"
fi


