package com.electrotank.electroserver5.examples.reversi;

import com.electrotank.electroserver5.extensions.api.value.EsObject;

public class LobbyGameInfo  {
    private int gameId;
    private String userName;
    
    public LobbyGameInfo( int gameId, String userName) {
        this.gameId = gameId;
        this.userName = userName;
    }

    public int getGameId() {
        return gameId;
    }

    public String getUserName() {
        return userName;
    }
    
    public EsObject toEsObject() {
        EsObject obj = new EsObject();
        obj.setString(PluginConstants.PLAYER_NAME, userName);
        obj.setInteger(PluginConstants.ID, gameId);
        return obj;
    }
}
