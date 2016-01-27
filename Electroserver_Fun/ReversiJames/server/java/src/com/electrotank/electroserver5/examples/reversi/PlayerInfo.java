package com.electrotank.electroserver5.examples.reversi;

import com.electrotank.electroserver5.extensions.api.value.EsObject;

public class PlayerInfo {

    private String playerName;
    private boolean isHuman = true;
    private int color;
    private int score;

    public PlayerInfo(String playerName) {
        this.playerName = playerName;
    }
    
    public EsObject toEsObject() {
        EsObject obj = new EsObject();
        obj.setString(PluginConstants.PLAYER_NAME, playerName);
        obj.setInteger(PluginConstants.SCORE, score);
        return obj;
    }
    
    public String getPlayerName() {
        return playerName;
    }

    public boolean isIsHuman() {
        return isHuman;
    }

    public void setIsHuman(boolean isHuman) {
        this.isHuman = isHuman;
    }
    
    public int getColor() {
        return color;
    }

    public void setColor(int color) {
        this.color = color;
    }

    public boolean isColorBlack() {
        return color == PluginConstants.BLACK;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }
}
