package com.electrotank.electroserver5.examples.dblogin;

import java.util.concurrent.atomic.AtomicInteger;



public class UserObject {

    private String name;
    private String password;
    private AtomicInteger rank = new AtomicInteger(0);
    
    public boolean doesPasswordMatch(String pwd) {
        return password.equals(pwd);
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the password
     */
    public String getPassword() {
        return password;
    }

    /**
     * @param password the password to set
     */
    public void setPassword(String password) {
        this.password = password;
    }

    public int getRank() {
        return rank.intValue();
    }

    public void setRank(int value) {
        rank.set(value);
    }
    
    public void addToRank(int delta) {
        rank.addAndGet(delta);
    }
}
