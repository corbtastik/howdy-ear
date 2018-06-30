#!/bin/bash
# boy oh boy lets deploy
source ./env.sh

# remove prior deployment
echo Removing old deplyment to ${LIBERTY_SERVER_HOME}/dropins/howdy-app.ear
rm -rf ${LIBERTY_SERVER_HOME}/dropins/howdy-app.ear

# copy new deployment
echo Deploying to ${LIBERTY_SERVER_HOME}/dropins
cp ${BUILD_DIR}/howdy-app.ear ${LIBERTY_SERVER_HOME}/dropins/

# package op requires server to be offline
${LIBERTY_HOME}/bin/server stop
${LIBERTY_HOME}/bin/server package ${SERVER_NAME} --include=usr

# build deployment target
mkdir -p ${BUILD_DIR}/${SERVER_NAME}

# copy packaged server to deployment target
mv ${LIBERTY_SERVER_HOME}/${SERVER_NAME}.zip ${BUILD_DIR}/${SERVER_NAME}/

# start the server backup, package server complete
${LIBERTY_HOME}/bin/server start

# copy manifest from root project
cp ${PROJECT_HOME}/manifest.yml ${BUILD_DIR}/${SERVER_NAME}/

# create vars.yml file with details for packaged server
echo "app:
  name: howdy-ear
  artifact: ${SERVER_NAME}.zip
  memory: 1G
  route: howdy-ear.cfapps.io
  buildpack: https://github.com/cloudfoundry/ibm-websphere-liberty-buildpack
env-key-1: IBM_JVM_LICENSE
env-val-1: ${IBM_JVM_LICENSE}
env-key-2: IBM_LIBERTY_LICENSE
env-val-2: ${IBM_LIBERTY_LICENSE}" > ${BUILD_DIR}/${SERVER_NAME}/vars.yml

# change into deployment target
cd ${BUILD_DIR}/${SERVER_NAME}/

# cf push awe yeah...
# cf push --vars-file=./vars.yml
