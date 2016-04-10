package com.electrotank.electroserver5.examples.databasewithjdbi;

public class PersistObject {
    private String userName;
    private PersistType type;
    
    public PersistObject(String userName, PersistType type) {
        this.userName = userName;
        this.type = type;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public PersistType getType() {
        return type;
    }

    public void setType(PersistType type) {
        this.type = type;
    }
    
}
