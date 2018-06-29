package io.corbs;

import javax.ejb.Stateless;

@Stateless
public class HowdyEJB {
    public String sayHowdy(String name) {
        if(name == null || name.length() == 0) {
            name = "Sponge Bob";
        }
        return "Howdy " + name + " , I came from an EJB.  What a long strange trip its been.";
    }
}
