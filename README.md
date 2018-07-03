## Howdy Ear :ear:

This repo contains a sample project that packages an [ejb](https://en.wikipedia.org/wiki/Enterprise_JavaBeans) and [war](https://en.wikipedia.org/wiki/WAR_(file_format)) module as an [ear](https://en.wikipedia.org/wiki/EAR_(file_format)).  It's what we'd typically call the first step into the dEEp end if you know what I mean :smile:.

For reals its meant to be a simple starter to exploring cloud based EAR deployments using the [WebSphere Liberty Buildpack](https://github.com/cloudfoundry/ibm-websphere-liberty-buildpack).  Microservices are everywhere but its not uncommon for Dev Shops to have major investments in Monoliths, many of which started with a "simple" ejb/war ear.

Having said that I see tremendous value providing simple patterns to "lift" the Monolith to the cloud by wrapping in Cloud Native principles.  Can we develop simple opinions on how a cloud based EAR deployment should look?  You bet...the value is this...your code isn't throw away, its leveled-up, packaging remains an ``ear`` but what we package for the cloud is different.  Then obviously the workload runs different in the sense it goes from JEE cluster to Cloud based on a runtime such as Pivotal Application Service.

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

## Dev Environment Setup

1. Clone ``https://github.com/corbtastik/howdy-ear.git``
1. Install [openliberty](https://openliberty.io/downloads/)
1. Create defaultServer ``${wlp.install.dir}/bin/server create``
1. Set vars in [env.sh](ear/src/main/bash/env.sh) for your environment
1. Run [build.sh](ear/src/main/bash/build.sh)

## Packaging App w/ Liberty Server

Packaging for Liberty buildpack

```bash
cd ear/src/main/bash
# edit env.sh with your deets
./build.sh
./package.sh
```

## Running on PAS  

Push from the top-level directory of this project  

```bash
> cf push --vars-file=./vars.yml
```

## Typical start command

```bash
.liberty/create_vars.rb wlp/usr/servers/defaultServer/runtime-vars.xml \
    && .liberty/calculate_memory.rb \
    && WLP_SKIP_MAXPERMSIZE=true \
    JAVA_HOME="$PWD/.java" \
    WLP_USER_DIR="$PWD/wlp/usr" \
    exec .liberty/bin/server run defaultServer
```

```bash
vcap@6318cc70-7f57-4fa5-7434-3154:~/app/wlp/usr/servers/defaultServer$ ls -al
total 12
drwxr-xr-x 7 vcap vcap  133 Jul  2 13:20 .
drwxr-xr-x 3 vcap vcap   27 Jul  2 13:18 ..
drwxr-xr-x 3 vcap vcap   23 Jul  2 13:18 apps
-rw-r--r-- 1 vcap vcap  554 Jul  2 13:19 jvm.options
drwxr-xr-x 2 vcap vcap    6 Jul  2 13:18 lib
drwxr-x--- 3 vcap vcap   39 Jul  2 13:19 logs
-rw-r--r-- 1 vcap vcap  473 Jul  2 13:19 runtime-vars.xml
-rw-r--r-- 1 vcap vcap 1142 Jul  2 13:18 server.xml
drwxr-x--- 4 vcap vcap   39 Jul  2 13:20 tranlog
drwxr-x--- 5 vcap vcap  115 Jul  2 13:19 workarea
```

```bash
vcap@b02773e4-9bdb-4496-5a23-719f:~/app/wlp/usr/servers/defaultServer$ ls -al
total 28
drwxr-xr-x 10 vcap vcap  284 Jul  2 13:47 .
drwxr-xr-x  3 vcap vcap   27 Jul  2 13:46 ..
drwxr-xr-x  2 vcap vcap   66 Jul  2 07:57 ${application.log.dir}
drwxr-xr-x  3 vcap vcap   27 Jul  2 13:46 apps
drwxr-xr-x  2 vcap vcap    6 Jul  2 07:46 dropins
-rwxr--r--  1 vcap vcap   81 Jul  2 08:45 howdy-vars.xml
-rw-r--r--  1 vcap vcap  554 Jul  2 13:47 jvm.options
drwxr-xr-x  2 vcap vcap    6 Jul  2 13:46 lib
drwxr-x---  3 vcap vcap   39 Jul  2 13:47 logs
drwxr-xr-x  3 vcap vcap   26 Jul  2 13:46 messaging
drwxr-xr-x  3 vcap vcap   22 Jun 29 23:06 resources
-rw-r--r--  1 vcap vcap  485 Jul  2 13:47 runtime-vars.xml
-rwxr--r--  1 vcap vcap   67 Jun 29 23:06 server.env
-rwxr--r--  1 vcap vcap 1264 Jul  2 13:46 server.xml
-rwxr--r--  1 vcap vcap 1222 Jul  2 08:45 server.xml.backup
-rwxr--r--  1 vcap vcap 1222 Jul  2 13:46 server.xml.org
drwxr-xr-x  5 vcap vcap  115 Jul  2 13:47 workarea
```



### References

1. [Liberty Directory Locations](https://www.ibm.com/support/knowledgecenter/en/SSEQTP_liberty/com.ibm.websphere.wlp.doc/ae/rwlp_dirs.html)  
2. [Liberty Downloads](https://openliberty.io/downloads/)  
3. [Adding libraries to EAR /lib](https://www.ibm.com/support/knowledgecenter/en/SSHR6W/com.ibm.websphere.wdt.doc/topics/add_libs_to_ear_lib_dir.html)  
4. [Liberty Buildpack - server.xml](https://github.com/cloudfoundry/ibm-websphere-liberty-buildpack/blob/master/docs/server-xml-options.md)  
5. [Options for pushing Liberty Apps](https://console.bluemix.net/docs/runtimes/liberty/optionsForPushing.html#options_for_pushing)  
6. [Customizing Liberty Env](https://www.ibm.com/support/knowledgecenter/en/SSEQTP_liberty/com.ibm.websphere.wlp.doc/ae/twlp_admin_customvars.html)
