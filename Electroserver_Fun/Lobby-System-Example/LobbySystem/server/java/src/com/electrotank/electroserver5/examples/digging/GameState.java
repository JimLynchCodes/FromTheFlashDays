package com.electrotank.electroserver5.examples.digging;

public enum GameState {

    WaitingForPlayers ("wp"),
    CountingDown ("cd"),
    InPlay ("ip"),
    GameOver ("go");

    private final String state;

    private GameState( String state ) {
        this.state = state;
    }
    
    public String getState() {
        return state;
    }
}
