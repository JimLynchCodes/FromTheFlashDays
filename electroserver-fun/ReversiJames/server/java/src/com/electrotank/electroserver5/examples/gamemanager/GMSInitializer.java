package com.electrotank.electroserver5.examples.gamemanager;

import com.electrotank.electroserver5.examples.reversi.PluginConstants;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;
import com.electrotank.electroserver5.extensions.api.value.ExtensionComponentConfiguration;
import com.electrotank.electroserver5.extensions.api.value.GameConfiguration;
import com.electrotank.electroserver5.extensions.api.value.RoomConfiguration;
import com.electrotank.electroserver5.extensions.BaseExtensionLifecycleEventHandler;

public class GMSInitializer extends BaseExtensionLifecycleEventHandler {

    /**
     * Initializes each minigame's plugin, initial game details, and registers it with
     * the GameManager.
     * 
     * @param ignored could contain the XML parameters from the web admin interface, 
     * but in this case is just ignored
     */
    @Override
    public void init(EsObjectRO ignored) {
        // use the name of the extension that will contain all the game plugins
        String extensionName = getApi().getExtensionName();

        // invoke the initialization method for each of your games
        initReversi(extensionName);
        initLobby(extensionName);
    }

    /**
     * Registers a game with GameManager, using the standard options.  
     * If a game needs custom gameDetails, it is best to just make a new method for that game.
     * 
     * @param extensionName  Name of the extension that this game is in.  Does not have to be the same as the extension GMSInitializer is in.
     * @param pluginName    Name (handle) of the plugin for the game.  It's best to have the handle and name the same.
     * @param gameType      Game type as registered with GameManager.  Does not need to match pluginName.
     * @param maxPlayers    Maximum number of players.
     */
    private void initReversi(String extensionName) {
        ExtensionComponentConfiguration gamePlugin = new ExtensionComponentConfiguration();
        gamePlugin.setExtensionName(extensionName);

        gamePlugin.setHandle(PluginConstants.GAME_TYPE);
        gamePlugin.setName(PluginConstants.GAME_TYPE);

        // Create the room configuration
        RoomConfiguration roomConfig = new RoomConfiguration();
        roomConfig.setCapacity(2);
        roomConfig.setDescription("Reversi Multiplayer game");

        //add the game plugin(s)
        roomConfig.addPlugin(gamePlugin);

        // Create the game configuration

        // When a user joins a room there are many events that user can potentially receive. 
        // The default subscriptions for a user joining the game are defined here.
        GameConfiguration gameRoomConfig = new GameConfiguration();
        gameRoomConfig.setReceivingRoomListUpdates(false);
        gameRoomConfig.setReceivingRoomVariableUpdates(false);
        gameRoomConfig.setReceivingUserListUpdates(true);
        gameRoomConfig.setReceivingUserVariableUpdates(true);
        gameRoomConfig.setReceivingVideoEvents(false);
        gameRoomConfig.setRoomConfiguration(roomConfig);

        //Create the default GameDetails object

        // When a game is created it has a game details EsObject associated with it. 
        // This object is publicly seen in the game list, and can be accessed and modified 
        // by the game itself.

        EsObject esob = new EsObject();
        esob.setInteger(PluginConstants.MINIMUM_PLAYERS, PluginConstants.DEFAULT_MIN_PLAYERS);
        esob.setInteger(PluginConstants.MAXIMUM_PLAYERS, PluginConstants.DEFAULT_MAX_PLAYERS);
        esob.setInteger(PluginConstants.COUNTDOWN, PluginConstants.DEFAULT_COUNTDOWN);
        esob.setInteger(PluginConstants.TURN_TIME_LIMIT, PluginConstants.DEFAULT_TURN_TIME_LIMIT);
        esob.setInteger(PluginConstants.RESTART_GAME_SECONDS, PluginConstants.DEFAULT_RESTART_GAME_SECONDS);
        gameRoomConfig.setInitialGameDetails(esob);

        // Register the game
        // Once the game has been registered, users can create a new instance of this game 
        // using the integrated game manager.
        // Plugins can also create a new game and put users into it.

        getApi().registerGameConfiguration(PluginConstants.GAME_TYPE, gameRoomConfig);

        getApi().getLogger().warn("{} game registered with GameManager.", PluginConstants.GAME_TYPE);
    }

    private void initLobby(String extensionName) {
        ExtensionComponentConfiguration gamePlugin = new ExtensionComponentConfiguration();
        gamePlugin.setExtensionName(extensionName);

        gamePlugin.setHandle("ReversiLobby");
        gamePlugin.setName("ReversiLobby");

        // Create the room configuration
        RoomConfiguration roomConfig = new RoomConfiguration();
        roomConfig.setCapacity(PluginConstants.MAX_LOBBY_USERS);
        roomConfig.setDescription("ReversiLobby");

        //add the game plugin(s)
        roomConfig.addPlugin(gamePlugin);

        // Create the game configuration

        // When a user joins a room there are many events that user can potentially receive. 
        // The default subscriptions for a user joining the game are defined here.
        GameConfiguration gameRoomConfig = new GameConfiguration();
        gameRoomConfig.setReceivingRoomListUpdates(false);
        gameRoomConfig.setReceivingRoomVariableUpdates(false);
        gameRoomConfig.setReceivingUserListUpdates(true);
        gameRoomConfig.setReceivingUserVariableUpdates(false);
        gameRoomConfig.setReceivingVideoEvents(false);
        gameRoomConfig.setRoomConfiguration(roomConfig);

        //Create the default GameDetails object

        EsObject esob = new EsObject();
        gameRoomConfig.setInitialGameDetails(esob);

        // Register the game
        getApi().registerGameConfiguration("ReversiLobby", gameRoomConfig);

        getApi().getLogger().warn("ReversiLobby game registered with GameManager.");
    }
}
