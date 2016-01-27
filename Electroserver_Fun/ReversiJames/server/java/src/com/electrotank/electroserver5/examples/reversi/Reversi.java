package com.electrotank.electroserver5.examples.reversi;

import com.electrotank.electroserver5.extensions.BasePlugin;
import com.electrotank.electroserver5.extensions.ChainAction;
import com.electrotank.electroserver5.extensions.api.ScheduledCallback;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;
import com.electrotank.electroserver5.extensions.api.value.UserEnterContext;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

public class Reversi extends BasePlugin {

    // variables
    int minPlayers;
    int maxPlayers;
    int countDownSeconds;
    int turnTimeLimitSeconds;
    int restartGameInSeconds;
    GameState gameState;
    private ConcurrentHashMap<String, PlayerInfo> playerInfoMap;
    private TurnHolder turnHolder;
    private BoardState board;
    private int callbackId = -1;
    private int aiCallbackId = -1;
    private AI ai = null;  
    private boolean useAI = false;
    String winner = "";
    
    @Override
    public void init( EsObjectRO ignored ) {
        EsObject gameDetails = getApi().getGameDetails();
        minPlayers = gameDetails.getInteger(PluginConstants.MINIMUM_PLAYERS, PluginConstants.DEFAULT_MIN_PLAYERS);
        maxPlayers = gameDetails.getInteger(PluginConstants.MAXIMUM_PLAYERS, PluginConstants.DEFAULT_MAX_PLAYERS);
        countDownSeconds = gameDetails.getInteger(PluginConstants.COUNTDOWN, PluginConstants.DEFAULT_COUNTDOWN);
        turnTimeLimitSeconds = gameDetails.getInteger(PluginConstants.TURN_TIME_LIMIT, PluginConstants.DEFAULT_TURN_TIME_LIMIT);
        restartGameInSeconds = gameDetails.getInteger(PluginConstants.RESTART_GAME_SECONDS, PluginConstants.DEFAULT_RESTART_GAME_SECONDS);
        useAI = gameDetails.getBoolean(PluginConstants.AI_OPPONENT, useAI);
        playerInfoMap = new ConcurrentHashMap<String, PlayerInfo>();
        gameState = GameState.WaitingForPlayers;
        turnHolder = new TurnHolder();
    }

    @Override
    public void request(String playerName, EsObjectRO requestParameters) {
        if (gameState == GameState.GameOver) {
            // ignore the request
            return;
        }
        EsObject messageIn = new EsObject();
        messageIn.addAll(requestParameters);
        if (getApi().getLogger().isDebugEnabled()) {
           getApi().getLogger().debug("{} requests: {}", playerName, messageIn.toString());
        }
        
        String action = messageIn.getString(PluginConstants.ACTION);

        if (action.equals(PluginConstants.INIT_ME)) {
            handlePlayerInitRequest(playerName);
        } else if (action.equals(PluginConstants.MOVE_REQUEST)) {
            handleMoveRequest(playerName, messageIn);
        }
    }
    
    private synchronized void handlePlayerInitRequest(String playerName) {
        // add the new user to the user list
        playerInfoMap.put(playerName, new PlayerInfo(playerName));
        turnHolder.add(playerName);

        switch (gameState) {
            case WaitingForPlayers:
                if (useAI) {
                    // skip the countdown
                    stopCountdown();
                    return;
                } else {
                    startCountdown();
                }
                break;
            case CountingDown:
                if (playerInfoMap.size() >= maxPlayers) {
                    stopCountdown();    // this will start the game
                }
                break;
        }
    }
    
    /**
     *      GAMEFLOW METHODS
     */
    
    private void startCountdown() {
        if (gameState == GameState.CountingDown) {
            return;
        }
        gameState = GameState.CountingDown;
        setCountdownCallback(countDownSeconds);
    }

    private void setCountdownCallback(int seconds) {
        getApi().cancelScheduledExecution(callbackId);
        callbackId = getApi().scheduleExecution(seconds * 1000,
                1,
                new ScheduledCallback() {

                    public void scheduledCallback() {
                        stopCountdown();
                    }
                });
    }

    private void stopCountdown() {
        getApi().cancelScheduledExecution(callbackId);
        if (playerInfoMap.size() == 0) {
            // only users in the room that haven't sent init me request, so kill the game
            endGame();
        }
        getApi().setGameLockState(true);
        int numberUsersInRoom = getApi().getUsers().size();
        if (numberUsersInRoom < playerInfoMap.size()) {
            // somebody hasn't sent init me yet, so add him anyway
            for (String user : getApi().getUsers()) {
                if (!playerInfoMap.containsKey(user)) {
                    playerInfoMap.putIfAbsent(user, new PlayerInfo(user));
                    turnHolder.add(user);
                }
            }
        }

        if (playerInfoMap.size() > 0 && playerInfoMap.size() < minPlayers) {
            // add one AI opponent
            ai = new AI(PluginConstants.AI_NAME);
            playerInfoMap.put(PluginConstants.AI_NAME, ai.getPInfo());
            turnHolder.add(ai.getName());
            getApi().getLogger().debug("Adding AI player: {}", ai.getName());
        } else {
            getApi().getLogger().debug("No AI added.  minPlayers = {}", minPlayers);
        }
        
        startGame();
    }

    private void startGame() {
        getApi().setGameLockState(true);
        
        // initialize colors
        turnHolder.pickRandomPlayer();
        Collection<String> players = turnHolder.getPlayers();
        int size = players.size();
        for (int ii = 0; ii < size; ii++) {
            PlayerInfo pInfo = playerInfoMap.get(turnHolder.getTurnHolder());
            pInfo.setColor(ii);
            turnHolder.nextPlayer();
        }
        
        // initialize the board
        board = new BoardState(PluginConstants.BOARD_SIZE);
        
        gameState = GameState.InPlay;
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.START_GAME);
        message.setEsObjectArray(PluginConstants.CHANGED_CHIPS, board.toEsObjectArray());
        sendAndLog("Reversi.startGame", message);
        
        announcePlayerTurn();
    }
    
    private EsObject[] getPlayerScores() {
        if (playerInfoMap.size() < 1) {
            return null;
        }
        int highScore = -1;
        String highScoreName = "";
        int lowScore = -1;
        EsObject[] list = new EsObject[playerInfoMap.size()];
        int ptr = 0;
            for (PlayerInfo pInfo : playerInfoMap.values()) {
                int color = pInfo.getColor();
                int score = board.determineScore(color);
                pInfo.setScore(score);
                list[ptr] = pInfo.toEsObject();
                if (score > highScore) {
                    highScore = score;
                    highScoreName = pInfo.getPlayerName();
                }
                if (lowScore == -1) {
                    lowScore = highScore;
                } else if (score < lowScore) {
                    lowScore = score;
                }
                ptr++;
            }
            
            // determine winner
            if (highScore == lowScore && playerInfoMap.size() > 1) {
                winner = "TIED";
            } else {
                winner = highScoreName;
            }
            //getApi().getLogger().debug("getPlayerScores determines winner: " + winner);
            //getApi().getLogger().debug("getPlayerScores size of array: " + list.length);
         return list;
    }
    
    

    private void endGame() {
        getApi().cancelScheduledExecution(callbackId);
        getApi().cancelScheduledExecution(aiCallbackId);
        gameState = GameState.GameOver;
        int numberUsers = getApi().getUsers().size();
        if (numberUsers < 1 || playerInfoMap.isEmpty()) {
            return;
        }
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.GAME_OVER);
        message.setEsObjectArray(PluginConstants.SCORE, getPlayerScores());
        
        message.setString(PluginConstants.WINNER, winner);
        sendAndLog("Reversi.endGame", message);
        
        if (restartGameInSeconds > 0) {
            restartGameAfterPause();
        }
    }
    
    @Override
    public ChainAction userEnter(UserEnterContext context) {
        String playerName = context.getUserName();
        boolean ok = okForPlayerToEnter();
        if (ok) {
            getApi().getLogger().debug("userEnter: {}", playerName);
            return ChainAction.OkAndContinue;
        } else {
            getApi().getLogger().debug("Game refused to let {} join.", playerName);
            return ChainAction.Fail;
        }
    }

    private synchronized boolean okForPlayerToEnter() {
        if (gameState != GameState.WaitingForPlayers
                && gameState != GameState.CountingDown) {
            return false;
        }
        int numPlayers = getApi().getUsers().size();
        if (numPlayers > maxPlayers) {
            getApi().setGameLockState(true);
            // numPlayers includes the player who is trying to enter
            return false;
        } else if (numPlayers == maxPlayers) {
            getApi().setGameLockState(true);
            return true;
        } else {
            return true;
        }
    }

    @Override
    public void userExit(String playerName) {
        if (playerInfoMap.containsKey(playerName)) {
                playerInfoMap.remove(playerName);
        }
        int numUsersInRoom = getApi().getUsers().size();
        if (numUsersInRoom < 1) {
                getApi().getLogger().debug("endGame called");
                endGame();
                return;
        }

        if (gameState == GameState.InPlay) {
            //If a player exits while playing, the other player wins since this is a 2 player game
            //Another option would be to replace an exiting human player with an AI opponent
            endGame();
        }
    }
    
    @Override
    public void destroy() {
        getApi().cancelScheduledExecution(callbackId);
        getApi().cancelScheduledExecution(aiCallbackId);
        getApi().getLogger().debug("room destroyed");
    }
    
    private void restartGameAfterPause() {
        callbackId = getApi().scheduleExecution(restartGameInSeconds * 1000, 1,
                new ScheduledCallback() {

                    public void scheduledCallback() {
                        restartGame();
                    }
                });
    }
    
    public void restartGame() {
        // clear all data structures, set game state, tell clients to send INIT_ME
        board = null;
        playerInfoMap.clear();
        turnHolder.clear();
        ai = null;
        gameState = GameState.WaitingForPlayers;
        getApi().setGameLockState(false);
        EsObject obj = new EsObject();
        obj.setString(PluginConstants.ACTION, PluginConstants.INIT_ME);
        sendAndLog("restartGame", obj);
    }
    
    /**
     * GAME LOGIC methods
     */

    private void handleMoveRequest(String playerName, EsObject messageIn) {
        if (!playerName.equals(turnHolder.getTurnHolder())) {
            //sendMoveResponseError(playerName, "NotYourTurn");
            // just ignore the request
            return;
        } else {
            getApi().cancelScheduledExecution(callbackId);
        }

        if (gameState != GameState.InPlay) {
            sendMoveResponseError(playerName, "GameNotInPlay");
            return;
        }
        
        PlayerInfo pInfo = playerInfoMap.get(playerName);
        if (pInfo == null) {
            sendMoveResponseError(playerName, "InvalidPlayer");
            announcePlayerTurn();
            return;
        }
        
        int id = messageIn.getInteger(PluginConstants.ID, -1);
        int color = pInfo.getColor();
        EsObject[] arr = null;
        
        if (id >= 0 ) {
            // check for legal move
            Chip chip = new Chip(id, color);
            
            boolean isMoveLegal = board.isLegalMove(chip);
            if (!isMoveLegal) {
                sendMoveResponseError(playerName, "IllegalMove");
                announcePlayerTurn();
                return;
            }
            
            // update the board
            List<EsObject> changedChips = board.checkAndAddIfLegal(chip);
            if (!changedChips.isEmpty()) {
                changedChips.add(chip.toEsObject());
                arr = new EsObject[changedChips.size()];
                arr = changedChips.toArray(arr);
                messageIn.setEsObjectArray(PluginConstants.CHANGED_CHIPS, arr);
                messageIn.setString(PluginConstants.ACTION, PluginConstants.MOVE_EVENT);
                messageIn.setString(PluginConstants.PLAYER_NAME, playerName);

                sendAndLog("handleMoveRequest", messageIn);
            }
        }  // else player skips turn
        
        //getApi().getLogger().debug("Board: " + board.toString());
        
        if (isTerminal()) {
            endGame();
        } else {
            announcePlayerTurn();
        }
    }
    
    private void announcePlayerTurn() {
        int[] allLegalMoves = null;
        int count = 0;
        String playerName = "";
        PlayerInfo pInfo = null;
        
        // two player game
        while ((allLegalMoves == null) && count < 2) {
            playerName = turnHolder.nextPlayer();
            if (playerName == null) {
                continue;
            }
            pInfo = playerInfoMap.get(playerName);
            if (pInfo == null) {
                // this automatically skips users who have left the room
                continue;
            }
            allLegalMoves = board.getAllLegalMoves(pInfo.getColor());
            
            // this prevents an endless loop if neither player has a legal move
            count++;
        }
        
        if (allLegalMoves == null) {
            // nobody has any moves
            endGame();
            return;
        }
        
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.TURN_TIME_LIMIT);
        message.setString(PluginConstants.PLAYER_NAME, playerName);
        message.setBoolean(PluginConstants.COLOR_IS_BLACK, pInfo.isColorBlack());
        message.setInteger(PluginConstants.TURN_TIME_LIMIT, turnTimeLimitSeconds);
        message.setIntegerArray(PluginConstants.LEGAL_MOVES, allLegalMoves);
        sendAndLog("announcePlayerTurn", message);
        
        if (ai != null && playerName.equals(ai.getName())) {
            setAiCallback(5, allLegalMoves);
        }
        
        //getApi().getLogger().debug("Legal moves: " + allLegalMoves);
        
        getApi().cancelScheduledExecution(callbackId);
        callbackId = getApi().scheduleExecution(turnTimeLimitSeconds * 1000,
                1,
                new ScheduledCallback() {

                    public void scheduledCallback() {
                        announcePlayerTurn();
                    }
                });
    }

    private boolean isTerminal() {
        for (PlayerInfo pInfo : playerInfoMap.values()) {
            // if a player has a legal move, return false;
            if (board.hasLegalMoves(pInfo.getColor())) {
                return false;
            }
        }
        return true;
    }

    private void sendAndLog(String fromMethod, EsObject message) {
        getApi().sendPluginMessageToRoom(getApi().getZoneId(), getApi().getRoomId(), message);
        if (getApi().getLogger().isDebugEnabled()) {
            getApi().getLogger().debug("{}: {}", fromMethod, message.toString());
        }
    }

    private void sendMoveResponseError(String playerName, String error) {
        EsObject obj = new EsObject();
        obj.setString(PluginConstants.ACTION, PluginConstants.MOVE_RESPONSE);
        obj.setString(PluginConstants.ERROR_MESSAGE, error);
        if (getApi().getLogger().isDebugEnabled()) {
            getApi().getLogger().debug("MoveResponseError to {}: {}", playerName, obj.toString());
        }
        getApi().sendPluginMessageToUser(playerName, obj);
    }
    
    private void setAiCallback(int seconds, final int[] legalMoves) {
        getApi().cancelScheduledExecution(aiCallbackId);
        aiCallbackId = getApi().scheduleExecution(seconds * 1000,
                1,
                new ScheduledCallback() {

                    public void scheduledCallback() {
                        tellAiToMakeMove(legalMoves);
                    }
                });
    }

    private void tellAiToMakeMove(int[] legalMoves) {
        if (gameState != GameState.InPlay) {
            return;
        }
        Chip move = ai.makeMove(board, legalMoves);
        EsObject moveObj = move.toEsObject();
        if (getApi().getLogger().isDebugEnabled()) {
            getApi().getLogger().debug("AI attempts move: {}", moveObj.toString());
        }
        handleMoveRequest(ai.getPInfo().getPlayerName(), moveObj);
    }
}
