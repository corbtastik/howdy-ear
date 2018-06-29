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
# remove prior deployment
echo Removing old deplyment to $LIBERTY_SERVER_HOME/dropins/howdy-app.ear
rm -rf $LIBERTY_SERVER_HOME/dropins/howdy-app.ear
# copy new deployment
echo Deploying to $LIBERTY_SERVER_HOME/dropins
cp $BUILD_DIR/howdy-app.ear $LIBERTY_SERVER_HOME/dropins/

