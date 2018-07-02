#!/bin/bash
# boy oh boy lets package yo
source ./env.sh

${LIBERTY_HOME}/bin/server stop

# remove prior server setup
echo Removing old server ${LIBERTY_SERVER_HOME}
rm -rf ${LIBERTY_SERVER_HOME}

${LIBERTY_HOME}/bin/server create ${LIBERTY_SERVER_NAME}
# we don't need this and it can confuse cf deployment
rm -rf ${LIBERTY_SERVER_HOME}/dropins

# copy new deployment
echo Deploying to ${LIBERTY_SERVER_HOME}/apps
cp ${BUILD_DIR}/howdy-app.ear ${LIBERTY_SERVER_HOME}/apps/

# copy server assets to LIBERTY_SERVER_HOME
rm ${LIBERTY_SERVER_HOME}/server.xml
cp ${PROJECT_HOME}/ear/src/main/server/server.xml ${LIBERTY_SERVER_HOME}/server.xml
cp ${PROJECT_HOME}/ear/src/main/server/runtime-vars.xml ${LIBERTY_SERVER_HOME}/runtime-vars.xml

# package server
${LIBERTY_HOME}/bin/server package ${LIBERTY_SERVER_NAME} --include=usr

# build deployment target
mkdir -p ${BUILD_DIR}/${LIBERTY_SERVER_NAME}

# copy packaged server to deployment target
mv ${LIBERTY_SERVER_HOME}/${LIBERTY_SERVER_NAME}.zip ${BUILD_DIR}/${LIBERTY_SERVER_NAME}/

# copy manifest from root project
cp ${PROJECT_HOME}/manifest.yml ${BUILD_DIR}/${LIBERTY_SERVER_NAME}/

# create vars.yml file with details for packaged server
echo "app:
  name: ${APP_NAME}
  artifact: ${LIBERTY_SERVER_NAME}.zip
  memory: 1G
  route: ${APP_NAME}.cfapps.io
  buildpack: https://github.com/cloudfoundry/ibm-websphere-liberty-buildpack
env-key-1: IBM_JVM_LICENSE
env-val-1: ${IBM_JVM_LICENSE}
env-key-2: IBM_LIBERTY_LICENSE
env-val-2: ${IBM_LIBERTY_LICENSE}" > ${BUILD_DIR}/${LIBERTY_SERVER_NAME}/vars.yml

# change into deployment target
cd ${BUILD_DIR}/${LIBERTY_SERVER_NAME}/
# show zip content
jar -tvf ${LIBERTY_SERVER_NAME}.zip
