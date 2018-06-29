package io.corbs;

import java.io.Serializable;

class Todo implements Serializable {

    private Integer id;
    private String title;
    private Boolean completed = Boolean.FALSE;

    public Todo() {

    }

    public Todo(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Boolean getCompleted() {
        return completed;
    }

    public void setCompleted(Boolean completed) {
        this.completed = completed;
    }
}
