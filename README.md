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

Contains a maven-ear plugin build to package the EJB and Web modules into a plain ole ear :ear: file containing an application.xml and /libs folder.

## Dev Environment Setup

1. Clone ``https://github.com/corbtastik/howdy-ear.git``
1. Install [openliberty](https://openliberty.io/downloads/)
1. Create defaultServer ``${wlp.install.dir}/bin/server create``
1. Set vars in [env.sh](ear/src/main/bash/env.sh) for your environment
1. Run [build.sh](ear/src/main/bash/build.sh)



## Running on PAS  

Push from the top-level directory of this project  

```bash
> cf push --vars-file=./vars.yml
```

### References

1. [Liberty Directory Locations](https://www.ibm.com/support/knowledgecenter/en/SSEQTP_liberty/com.ibm.websphere.wlp.doc/ae/rwlp_dirs.html)  
2. [Liberty Downloads](https://openliberty.io/downloads/)  
3. [Adding libraries to EAR /lib](https://www.ibm.com/support/knowledgecenter/en/SSHR6W/com.ibm.websphere.wdt.doc/topics/add_libs_to_ear_lib_dir.html)  
4. [Liberty Buildpack - server.xml](https://github.com/cloudfoundry/ibm-websphere-liberty-buildpack/blob/master/docs/server-xml-options.md)  
5. [Options for pushing Liberty Apps](https://console.bluemix.net/docs/runtimes/liberty/optionsForPushing.html#options_for_pushing)  
