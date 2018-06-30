package io.corbs;

import javax.ejb.Stateless;
import java.util.logging.Logger;

@Stateless
public class HowdyEJB {
    private static final Logger LOG = Logger.getLogger(HowdyEJB.class.getName());

    public String sayHowdy(String name) {
        if(name == null || name.length() == 0) {
            name = "Sponge Bob";
        }

        LOG.info(getEnvVar("VCAP_APPLICATION"));
        LOG.info(getEnvVar("howdy.version"));

        return "Howdy " + name + " , I came from an EJB.  What a long strange trip its been.";
    }

    private static String getEnvVar(String varName){
        String value;
        value = System.getenv(varName);

        if(value != null){
            return value;
        }

        value = System.getProperty(varName);

        if(value != null){
            return value;
        }

        return value;
    }
}
