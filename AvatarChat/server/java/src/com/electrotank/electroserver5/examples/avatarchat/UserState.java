package com.electrotank.electroserver5.examples.avatarchat;

import com.electrotank.electroserver5.extensions.api.value.EsObject;

public class UserState {

    private String name;
    private EsObject state;
    private EmotionState eState;
    
    public UserState (String name) {
        this.name = name;
        state = new EsObject();
        state.setString(PluginConstants.USER_NAME, name);
        eState = EmotionState.Default;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public EsObject getState() {
        return state;
    }

    public void setState(EsObject newState) {
        // this merges the current state with the new state, so that we 
        // don't need a separate method for position updates
        // It creates a new EsObject to avoid concurrent modification errors
        EsObject tempState = new EsObject();
        tempState.addAll(state);
        tempState.addAll(newState);
        state = tempState;
    }

    public EmotionState getEState() {
        return eState;
    }

    public void setEState(EmotionState eState) {
        this.eState = eState;
    }
}
