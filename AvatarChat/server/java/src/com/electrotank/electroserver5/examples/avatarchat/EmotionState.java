package com.electrotank.electroserver5.examples.avatarchat;

public enum EmotionState {

    Default (0),
    Happy (1),
    Sad (2),
    Surprised (3),
    Confused (4);
    
    private final int index;
    
    private EmotionState(int index) {
        this.index = index;
    }
    
    public int getIndex() {
        return index;
    }
}
