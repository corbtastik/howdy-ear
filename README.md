## Howdy Ear :ear:

This repo contains a sample project that packages an [ejb](https://en.wikipedia.org/wiki/Enterprise_JavaBeans) and [war](https://en.wikipedia.org/wiki/WAR_(file_format)) module as an [ear](https://en.wikipedia.org/wiki/EAR_(file_format)).  It's what we'd typically call the first step into the dEEp end if you know what I mean :smile:.

For reals its meant to be a simple starter to exploring cloud based EAR deployments using the [WebSphere Liberty Buildpack](https://github.com/cloudfoundry/ibm-websphere-liberty-buildpack).  Microservices are everywhere but its not uncommon for Dev Shops to have major investments in Monoliths, many of which started with a "simple" ejb/war ear.

Having said that I see tremendous value providing simple patterns to "lift" the Monolith to the cloud by sprinkling in Cloud Native principles.  

## The Code

### Howdy EJB project

Has a Stateless Bean that takes a name and returns a Howdy message.

### Howdy Web project

Contains a Named RequestScoped Bean "howdy", that has the client interface for HowdyEJB in the ejb project.  The Bean is exposed to jsf under the name "howdy" and can be dereferenced as a Java Object in jsf/xhtml templates.

### Howdy EAR project

Contains a maven-ear plugin build to package the EJB and Web modules into a plain ole ear :ear: file containing an application.xml and ``/lib`` folder.

### Clone, Build and Push

#### Clone and Build  

```bash
> git clone git@github.com:corbtastik/howdy-ear.git
> cd howdy-ear
> ./mvnw clean package
# what a standard EAR package looks like
> jar -tvf ear/target/howdy-app.ear  
    lib/
    lib/README.md
    META-INF/
    META-INF/application.xml  
    META-INF/MANIFEST.MF
    META-INF/maven/
    META-INF/maven/io.corbs/
    META-INF/maven/io.corbs/howdy-ear/
    META-INF/maven/io.corbs/howdy-ear/pom.properties  
    META-INF/maven/io.corbs/howdy-ear/pom.xml
    io.corbs-howdy-web-1.0.0.SNAP.war
    io.corbs-howdy-ejb-1.0.0.SNAP.jar
```

#### Push to Cloud Foundry

First you need to login to your Cloud Foundry environment or get an account on [Pivotal Web Services](https://run.pivotal.io/).

##### Login to Cloud Foundry

Login to Cloud Foundry with your information (replace ``CF_*`` values).

```bash
# using pivotal web services
> cf login -a api.run.pivotal.io -u ${CF_USER} -o ${CF_ORG} -s ${CF_SPACE}
```

##### vars.yml

Manually edit ``vars.yml`` and add values for ``IBM_JVM_LICENSE`` and ``IBM_LIBERTY_LICENSE``.  Information on how to get those values can be found [here](https://github.com/cloudfoundry/ibm-websphere-liberty-buildpack#usage).

```yml
app:
  name: howdy-ear-green
  artifact: ear/target/howdy-app.ear
  memory: 1G
  buildpack: https://github.com/cloudfoundry/ibm-websphere-liberty-buildpack
env-key-1: IBM_JVM_LICENSE
env-val-1: ???
env-key-2: IBM_LIBERTY_LICENSE
env-val-2: ???
```

Once ``cf login`` and licensing is taken care of we can ``cf push`` (awe yeah).

```bash
# using pivotal web services
> cf push --vars-file=./vars.yml

> cf app howdy-ear-green
Showing health and status for app howdy-ear-green in org NY / space corbs ...

name:              howdy-ear-green
requested state:   started
instances:         1/1
usage:             1G x 1 instances
routes:            howdy-ear-green-restless-gecko.cfapps.io
buildpack:         https://github.com/cloudfoundry/ibm-websphere-liberty-buildpack

     state     since                  cpu    memory       disk         details
#0   running   2018-07-03T16:10:58Z   0.5%   167M of 1G   284M of 1G 
```

Access the ``web`` module under the context ``/howdy-web``.

<p align="center">
  <img src="https://github.com/corbtastik/todos-images/blob/master/todos-ear/howdy-ear.png" width="400">
</p>

"Say Howdy" to send a message to a named ``@RequestScoped`` bean (``"howdy"``) which in-turn makes an EJB call to actually handle the request.

<p align="center">
  <img src="https://github.com/corbtastik/todos-images/blob/master/todos-ear/howdy-ear-message.png" width="400">
</p>

## WebSphere Liberty Specifics

In the [Push to Cloud Foundry](#push-to-cloud-foundry) section we pushed a simple EAR with one war and ejb module with little to no effort.  EAR to Cloud fast track so to speak...that came with accepting how the default Liberty container gets crafted, namely we accept the ``server.xml`` [defaults](https://github.com/cloudfoundry/ibm-websphere-liberty-buildpack/blob/master/docs/server-xml-options.md).  There's a lot of value in developing around the default fast track but if you want more control over how Liberty is crafted there's essentially 2 options.

1. Push a supported Liberty Server **Zip**
1. Push a supported Liberty Server **Directory**

The instructions and bash scripts included talk about and support option 1, pushing a zipped Liberty Server.  This is a little more ops friendly in the sense we control what gets zipped whereas pushing the Server Directory lends itself to picking up cruft.  [Cruft](https://en.wikipedia.org/wiki/Cruft) is bad.  

### Install [openliberty](https://openliberty.io/downloads/)

On my local machine I've installed liberty in ``~/dev/openlibery/wlp`` but you can install anywhere or you can unzip a fresh openliberty distro each time you want to run this package process.

The package process below will remove prior installs of ``howdy-server`` by design.

### Set vars in [env.sh](ear/src/main/bash/env.sh) for your environment

To package a Liberty Server Zip perform the following steps, again note the need to provide values for ``IBM_JVM_LICENSE`` and ``IBM_LIBERTY_LICENSE``.

```bash
#!/bin/bash
APP_NAME=howdy-ear-green
PROJECT_HOME=${HOME}/dev/github/howdy-ear
BUILD_DIR=${PROJECT_HOME}/ear/target
LIBERTY_HOME=${HOME}/dev/openliberty/wlp
LIBERTY_SERVER_NAME=howdy-server
LIBERTY_SERVER_HOME=${LIBERTY_HOME}/usr/servers/${LIBERTY_SERVER_NAME}
IBM_JVM_LICENSE=???
IBM_LIBERTY_LICENSE=???
```

### [Build](ear/src/main/bash/build.sh) Howdy EAR

Just for sanity let's do a fresh build.

```bash
> cd ear/src/main/bash
> ./build.sh
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] 
[INFO] howdy-app .......................................... SUCCESS [  0.103 s]
[INFO] howdy-ejb .......................................... SUCCESS [  0.772 s]
[INFO] howdy-web .......................................... SUCCESS [  0.229 s]
[INFO] howdy-ear .......................................... SUCCESS [  0.280 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 1.463 s
[INFO] Finished at: 2018-07-03T12:53:29-05:00
[INFO] Final Memory: 25M/484M
[INFO] ------------------------------------------------------------------------
```

This places the EAR file in ``ear/target``.

### [Package](ear/src/main/bash/package.sh) Liberty Server

```bash
> cd ear/src/main/bash
> ./package.sh
Stopping server howdy-server.
Server howdy-server is not running.
Removing old server /Users/corbs/dev/openliberty/wlp/usr/servers/howdy-server
Server howdy-server created.
Deploying to /Users/corbs/dev/openliberty/wlp/usr/servers/howdy-server/apps
cp: /Users/corbs/dev/github/howdy-ear/ear/src/main/server/runtime-vars.xml: No such file or directory
Packaging server howdy-server.
Server howdy-server package complete in /Users/corbs/dev/openliberty/wlp/usr/servers/howdy-server/howdy-server.zip.
howdy-server.zip contents:  
wlp/usr/servers/howdy-server/
wlp/usr/servers/howdy-server/server.xml
wlp/usr/servers/howdy-server/server.env
wlp/usr/servers/howdy-server/apps/
wlp/usr/servers/howdy-server/apps/howdy-app.ear
```

#### Packed Liberty Server

This places our custom Liberty Server ``howdy-server`` in ``ear/target/howdy-server/``.  Here's that directory after running ``package.sh``.

```bash
> ls -al ear/target/howdy-server/
howdy-server.zip
manifest.yml
vars.yml
```

### cf push (awe yeah)

Now we just need to cf push the zip file, everything is setup in ``manifest.yml`` and ``vars.yml`` files.

```bash
> cd ear/target/howdy-server/
> cf push --vars-file=./vars.yml
```

### Typical Liberty Server start command

Minus Cruft :wink:

```bash
java -jar /home/vcap/app/.liberty/bin/tools/ws-server.jar howdy-server
```

Here's what the deployment looks like in Liberty running on Cloud Foundry  

```bash
vcap@howdy-ear-container~$ ls -al app/wlp/usr/servers/howdy-server/
total 20
drwxr-xr-x 7 vcap vcap  173 Jul  3 19:47 .
drwxr-xr-x 3 vcap vcap   26 Jul  3 19:45 ..
drwxr-xr-x 3 vcap vcap   27 Jul  3 19:45 apps
-rw-r--r-- 1 vcap vcap  554 Jul  3 19:47 jvm.options
drwxr-xr-x 2 vcap vcap    6 Jul  3 19:46 lib
drwxr-x--- 3 vcap vcap   39 Jul  3 19:47 logs
-rw-r--r-- 1 vcap vcap  500 Jul  3 19:47 runtime-vars.xml
-rwxr--r-- 1 vcap vcap   67 Jul  3 14:32 server.env
-rwxr--r-- 1 vcap vcap 1169 Jul  3 19:46 server.xml
drwxr-x--- 4 vcap vcap   39 Jul  3 19:47 tranlog
drwxr-xr-x 5 vcap vcap  115 Jul  3 19:47 workarea
```

### References

1. [Liberty Directory Locations](https://www.ibm.com/support/knowledgecenter/en/SSEQTP_liberty/com.ibm.websphere.wlp.doc/ae/rwlp_dirs.html)  
2. [Liberty Downloads](https://openliberty.io/downloads/)  
3. [Adding libraries to EAR /lib](https://www.ibm.com/support/knowledgecenter/en/SSHR6W/com.ibm.websphere.wdt.doc/topics/add_libs_to_ear_lib_dir.html)  
4. [Liberty Buildpack - server.xml](https://github.com/cloudfoundry/ibm-websphere-liberty-buildpack/blob/master/docs/server-xml-options.md)  
5. [Options for pushing Liberty Apps](https://console.bluemix.net/docs/runtimes/liberty/optionsForPushing.html#options_for_pushing)  
6. [Customizing Liberty Env](https://www.ibm.com/support/knowledgecenter/en/SSEQTP_liberty/com.ibm.websphere.wlp.doc/ae/twlp_admin_customvars.html)
