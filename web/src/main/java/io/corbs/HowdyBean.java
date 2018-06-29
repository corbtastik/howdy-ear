package io.corbs;

import javax.ejb.EJB;
import javax.enterprise.context.RequestScoped;
import javax.inject.Named;
import java.io.Serializable;

@Named("howdy")
@RequestScoped
public class HowdyBean implements Serializable {
    private static final long serialVersionUID = 1L;

    @EJB
    private HowdyEJB howdyEJB;

    private String message;

    public void setName(String name) {
        message = howdyEJB.sayHowdy(name);
    }

    public String getMessage() {
        return message;
    }
}
