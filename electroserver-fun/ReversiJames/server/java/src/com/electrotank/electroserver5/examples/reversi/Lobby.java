package com.electrotank.electroserver5.examples.reversi;

import com.electrotank.electroserver5.entities.GameRO;
import com.electrotank.electroserver5.extensions.BasePlugin;
import com.electrotank.electroserver5.extensions.api.ScheduledCallback;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;

public class Lobby extends BasePlugin {

    private int callbackId = -1;
    EsObject message = null;

    @Override
    public void init( EsObjectRO ignored ) {
        startTicker(PluginConstants.FIND_GAMES_SECONDS);
    }

    @Override
    public void destroy() {
        getApi().cancelScheduledExecution(callbackId);
        getApi().getLogger().debug("room destroyed");
    }

    @Override 
    public void userDidEnter(String playerName) {
        if (null == message) {
            tick(false);
        }
        getApi().sendPluginMessageToUser(playerName, message);
    }

    
    private void startTicker(int seconds) {
        callbackId = getApi().scheduleExecution(seconds * 1000,
                -1,
                new ScheduledCallback() {

                    public void scheduledCallback() {
                        tick(true);
                    }
                });
    }
    
    private void tick(boolean sendToRoom) {
        GameRO[] gamesFound = getApi().findGames(PluginConstants.GAME_TYPE, false, new EsObject());
        if (gamesFound.length > 0) {
            EsObject[] listOfGames = new EsObject[gamesFound.length];
            int ptr = 0;
            for (GameRO game : gamesFound) {
                EsObject gameDetails = game.getGameDetails();
                String userName = gameDetails.getString(PluginConstants.PLAYER_NAME, "");
                LobbyGameInfo obj = new LobbyGameInfo(game.getId(), userName);
                listOfGames[ptr] = obj.toEsObject();
                ptr++;
            }
            
            EsObject esob = new EsObject();
            esob.setString(PluginConstants.ACTION, PluginConstants.GAMES_FOUND);
            esob.setEsObjectArray(PluginConstants.GAMES_FOUND, listOfGames);
            
            message = esob;
            
            if (sendToRoom) {
                getApi().sendPluginMessageToRoom(getApi().getZoneId(), 
                    getApi().getRoomId(), esob);
            }
            
        } else {
            // no games found
            EsObject esob = new EsObject();
            esob.setString(PluginConstants.ACTION, PluginConstants.NO_GAMES_FOUND);
            message = esob;
            
            if (sendToRoom) {
                getApi().sendPluginMessageToRoom(getApi().getZoneId(), 
                    getApi().getRoomId(), esob);
            }
        }
    }
}
