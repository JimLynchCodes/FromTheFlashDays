package com.electrotank.electroserver5.examples.digging;

import com.electrotank.electroserver5.extensions.BasePlugin;
import com.electrotank.electroserver5.extensions.ChainAction;
import com.electrotank.electroserver5.extensions.api.ScheduledCallback;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;
import com.electrotank.electroserver5.extensions.api.value.UserEnterContext;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.AbstractMap;
import java.util.AbstractQueue;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.logging.Level;
import java.util.logging.Logger;
import nu.xom.Builder;
import nu.xom.Document;
import nu.xom.Element;
import nu.xom.Elements;
import nu.xom.Node;
import nu.xom.ParsingException;
import nu.xom.ValidityException;

public class DiggingGamePlugin extends BasePlugin
{
    // variables
    private AbstractMap<String, PlayerInfo> playerInfoMap;
    private AbstractQueue<PlayerInfo> delayQueue;
    private Grid grid;
    private GameState gameState;
    private int callbackId = -1;
    private int questionCallbackId = -1;
    private long startTime = 0;
    private Integer requestsReceived = 0;
    
    private String firstTimestamp;
    private String secondTimestamp;
    private int tempIntFirst;
    private int tempIntSecond;
     private int thinkingDurationInt;
      private String thinkingDurationString;
     private BigDecimal firstTimeNumber;
    private BigDecimal secondTimeNumber;
     private BigDecimal durationNumber;
      private int durationInt;
     private Integer answersReceived = 0;
     private Integer questionCount = 0;
   private String correctAnswer = "";
   private Integer scoreDelta;
   private Integer playersInitialized = 0;
   private String winnerName;
   private Integer winnerScore;
    private AI ai = null;
    private Boolean usingAi = false;
   
   XmlManager xmlManager;

    @Override
    public void init(EsObjectRO ignored) {
        grid = new Grid();
        playerInfoMap = new ConcurrentHashMap<String, PlayerInfo>();
        delayQueue = new ConcurrentLinkedQueue<PlayerInfo>();
        gameState = GameState.WaitingForPlayers;
    }

    @Override
    public ChainAction userEnter(UserEnterContext context) {
        String playerName = context.getUserName();
        boolean ok = okForPlayerToEnter();
        if (ok) {
            getApi().getLogger().debug("userEnter: " + playerName);
            return ChainAction.OkAndContinue;
        } else {
            getApi().getLogger().debug("Game refused to let " + playerName + " join.");
            return ChainAction.Fail;
        }
    }

    private int getCountdownLeft() {
        long now = System.currentTimeMillis();
        long elapsedMillis = now - startTime;
        long millisLeft = PluginConstants.COUNTDOWN_SECONDS * 1000 - elapsedMillis;
        return (int) (millisLeft / 1000);
    }

    private EsObject[] getScoreObjectList() {
        PlayerInfo[] playerScores = null;
        if (playerInfoMap.size() > 0) {
            playerScores = 
                    new PlayerInfo[playerInfoMap.size()];
            int index = 0;
            for (PlayerInfo pInfo : playerInfoMap.values()) {
                playerScores[index] = pInfo;
                index++;
            }
        } else {
            return null;
        }
        List<PlayerInfo> sortedScores = Arrays.asList( playerScores );
        Collections.sort( sortedScores );

        EsObject[] list = new EsObject[playerScores.length];

        int index = playerScores.length - 1;
        for ( PlayerInfo playerInfo : sortedScores ) {
            list[index] = playerInfo.toEsObject();
            index--;
        }
        
        return list;
    }

    private synchronized boolean okForPlayerToEnter() {
        if (gameState != GameState.WaitingForPlayers
                && gameState != GameState.CountingDown) {
            return false;
        }
        int numPlayers = getApi().getUsers().size();
        if (numPlayers > PluginConstants.MAXIMUM_PLAYERS) {
            getApi().setGameLockState(true);
            // numPlayers includes the player who is trying to enter
            return false;
        } else if (numPlayers == PluginConstants.MAXIMUM_PLAYERS) {
            getApi().setGameLockState(true);
            return true;
        } else {
            return true;
        }
    }

    @Override
    public void request(String playerName, EsObjectRO requestParameters) {
        EsObject messageIn = new EsObject();
        messageIn.addAll(requestParameters);
        getApi().getLogger().debug(playerName + " requests: " + messageIn.toString());

        if (gameState == GameState.GameOver) {     
            sendErrorMessage(playerName, PluginConstants.GAME_IS_OVER);
            return;
        }

        String action = messageIn.getString(PluginConstants.ACTION);

        if (action.equals(PluginConstants.INIT_ME)) {
            handlePlayerInitRequest(playerName);
        } else if (action.equals(PluginConstants.DIG_HERE)) {
            handleDigHereRequest(playerName, messageIn);
        } else if (action.equals(PluginConstants.CURSOR_BROADCAST)) {
            handleCursorBroadcast(playerName, messageIn);
        } else if (action.equals(PluginConstants.POSITION_UPDATE)) {
            relayMessage(playerName, messageIn);
        }
        else if(action.equals(PluginConstants.QUESTION_REQUEST)) {
            handleQuestionRequest(playerName, messageIn);
        } 
         else if(action.equals(PluginConstants.ANSWER_HAS_BEEN_CHOSEN)) {
            handleAnswerHasBeenChosenRequest(playerName, messageIn);
        } 
        
    }

    @Override
    public void userExit(String playerName) {
        if (playerInfoMap.containsKey(playerName)) {
            if (gameState == GameState.InPlay || gameState == GameState.GameOver) {
                PlayerInfo pInfo = playerInfoMap.get(playerName);
                pInfo.userExit(getApi());
            } else {
                playerInfoMap.remove(playerName);
            }
        }
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.REMOVE_PLAYER);
        message.setString(PluginConstants.NAME, playerName);
        sendAndLog("userExit", message);

        int numUsersInRoom = getApi().getUsers().size();
        getApi().getLogger().debug("numUsersInRoom: " + numUsersInRoom);
        if (numUsersInRoom <= PluginConstants.MINIMUM_PLAYERS) {
            if (gameState == GameState.CountingDown) {
                getApi().getLogger().debug("resetCountdown called");
                resetCountdown();
            } else if (gameState == GameState.InPlay) {
                getApi().getLogger().debug("endGame called");
                endGame();
            }
        }
    }

    @Override
    public void destroy() {
        while (!delayQueue.isEmpty()) {
            PlayerInfo pInfo = delayQueue.poll();
            if (pInfo != null) {
                pInfo.cancelCallback(getApi());
            }
        }
        getApi().getLogger().debug("room destroyed");
    }

    private synchronized EsObject[] getFullPlayerList() {
        EsObject[] list = new EsObject[playerInfoMap.size()];
        int ptr = 0;
        for (PlayerInfo pInfo : playerInfoMap.values()) {
            list[ptr] = pInfo.toEsObject();
            ptr++;
        }
        return list;
    }

    
    private void handleCursorBroadcast(String playerName, EsObject messageIn)
    {
         messageIn.setString(PluginConstants.NAME, playerName);
         
         sendAndLog("Doing cursor Broadcast", messageIn);
    }
    
    private void handleAnswerHasBeenChosenRequest(String playerName, EsObject messageIn)
    {
        
        long now = System.currentTimeMillis();
        long elapsedMillis = now - startTime;
//       thinkingDurationInt = elapsedMillis;
        
        String answer = messageIn.getString(PluginConstants.ANSWER_CHOSEN);
//        
//          secondTimestamp = new String();    
//          secondTimestamp = String.valueOf(System.currentTimeMillis());
//        
           secondTimeNumber = new BigDecimal(System.currentTimeMillis()); 
           durationNumber = secondTimeNumber.subtract(firstTimeNumber);
           durationInt = durationNumber.intValueExact();
            
//          tempIntFirst = Integer.parseInt(firstTimestamp);
//          tempIntSecond = Integer.parseInt(secondTimestamp);
//          thinkingDurationInt =  tempIntSecond - tempIntFirst;   
//          thinkingDurationString = String.valueOf(thinkingDurationInt);
//          
//          getApi().getLogger().debug("thinking duration: " + thinkingDurationInt );
//          thinkingDurationString = String.valueOf(thinkingDurationInt);
          
           if (answer.equals(correctAnswer))
           {
                PlayerInfo pInfo = playerInfoMap.get(playerName);
                scoreDelta = (100000 /durationInt);
                
                pInfo.addToScore(scoreDelta);
               
           }
           else
           {
                   
               scoreDelta = 0;
           }
          
           
//            messageIn.setString(PluginConstants.TIME_TO_ANSWER, secondTimestamp);
        messageIn.setInteger(PluginConstants.TIME_TO_ANSWER, durationInt);
        messageIn.setString(PluginConstants.NAME, playerName);
        messageIn.setInteger(PluginConstants.SCORE, scoreDelta);
//        
//        getApi().getLogger().debug("player: " + playerName + "chose " + answer + " time waS: " + secondTimestamp + " so time taken was: " + thinkingDurationString);
        
        
        answersReceived++;   
        
        messageIn.setString(PluginConstants.WINNER_CHOSEN, "false");
        if (answersReceived.equals(1))
        {
            messageIn.setString(PluginConstants.WINNER_CHOSEN, "true");
            messageIn.setString(PluginConstants.WINNER_NAME, playerName);
        }    
        if (answersReceived.equals(2))
         {
             answersReceived = 0;       
         }
            
        
        sendAndLog("something", messageIn);
        
    }
    
    private void handleQuestionRequest(String playerName, EsObject messageIn)
    {
        requestsReceived++;
       
       questionCount = messageIn.getInteger(PluginConstants.QUESTION_COUNT);
       
        getApi().getLogger().debug("!Question count: " + questionCount);
        
        if (questionCount == PluginConstants.QUESTIONS_PER_ROUND)
        {
             getApi().getLogger().debug("!sending game over message: " + questionCount);
            messageIn.setString(PluginConstants.ACTION, PluginConstants.GAME_OVER);
            
            messageIn.setEsObjectArray(PluginConstants.PLAYER_LIST, getScoreObjectList());
                   
//            messageIn.setBoolean(PluginConstants.SUCCESS, false);
            
            
            sendAndLog("handly", messageIn);
        
        }
       
        if (requestsReceived.equals(1))
        {
            if (ai != null)
            {
                requestsReceived++;
            }
            setQuestionOverCallback();
        }
            // if you have received one from all of the players
        if (requestsReceived.equals(2))
        {
           firstTimestamp = new String();
                   
           firstTimeNumber = new BigDecimal(System.currentTimeMillis());
           
           firstTimestamp = String.valueOf(System.currentTimeMillis());
           
           QuestionObj thisQuestionObj = xmlManager.pullRandomNewQuestion();
            
            messageIn.setString(PluginConstants.QUESTION_TEXT, thisQuestionObj.questionText);
            messageIn.setString(PluginConstants.A_TEXT, thisQuestionObj.aAns);
            messageIn.setString(PluginConstants.B_TEXT, thisQuestionObj.bAns);
            messageIn.setString(PluginConstants.C_TEXT, thisQuestionObj.cAns);
            messageIn.setString(PluginConstants.D_TEXT, thisQuestionObj.dAns);
            messageIn.setString(PluginConstants.ANSWER_VALUE, thisQuestionObj.correctAns);
            correctAnswer = thisQuestionObj.correctAns;
            messageIn.setString(PluginConstants.TIME_STAMP, firstTimestamp);
            messageIn.setInteger(PluginConstants.ROUND_TIME, PluginConstants.ROUND_TIME_LENGTH);
           
            
        getApi().getLogger().debug("!!!!!!! sent questioin, time stamp: " + firstTimestamp + "Object: " + messageIn);
             sendAndLog("handly", messageIn);
             requestsReceived = 0;
        }
       
    }
    
    private void setQuestionOverCallback() {
        getApi().cancelScheduledExecution(questionCallbackId);
        questionCallbackId = getApi().scheduleExecution(PluginConstants.MS_OF_ROUND,
                1,
                new ScheduledCallback() {

                    public void scheduledCallback() {
                        sendRoundOver();
                    }
                });
    }
    
 
    
    private void sendRoundOver()
    {
             EsObject obj = new EsObject();
        obj.setString(PluginConstants.ACTION, PluginConstants.ROUND_OVER);
       
        sendAndLog("question Callback id: " + questionCallbackId, obj);
    }
    
        private void handleDigHereRequest(String playerName, EsObject messageIn) {
        PlayerInfo pInfo = playerInfoMap.get(playerName);
        if (pInfo == null) {
            getApi().getLogger().debug("No user info found for " + playerName);
            return;
        } else if (pInfo.isDigging()) {
            sendErrorMessage(playerName, PluginConstants.ALREADY_DIGGING);
            return;
        } else {
            int x = messageIn.getInteger(PluginConstants.X);
            int y = messageIn.getInteger(PluginConstants.Y);
            getApi().getLogger().debug("row, col: " + grid.getRow(x, y) + ", " +
                    grid.getCol(x, y));
            boolean okayToDigHere = grid.tryToTakeCell(x, y);
            if (okayToDigHere) {
                pInfo.startDigging(x, y);
                queueCallbackToFinishDigging(pInfo);
                messageIn.setString(PluginConstants.NAME, playerName);
                sendAndLog("handleDigHereRequest", messageIn);
            } else {
                sendErrorMessage(playerName, PluginConstants.SPOT_ALREADY_DUG);
            }
        }
    }

    private void handleDiggingFinished(PlayerInfo pInfo) {
        String playerName = pInfo.getPlayerName();
        getApi().getLogger().debug("handleDiggingFinished: " + playerName);
        if (!playerInfoMap.containsKey(playerName)) {
            getApi().getLogger().debug(playerName + " already left the room");
            return;
        }

        EsObject obj = new EsObject();
        obj.setString(PluginConstants.ACTION, PluginConstants.DONE_DIGGING);
        obj.setString(PluginConstants.NAME, playerName);

        ItemType itemFound = ItemType.getRandomItemType();

        int score = pInfo.addToScore(itemFound.getPoints());
        boolean itemWasFound = itemFound.getPoints() != 0;

        obj.setInteger(PluginConstants.SCORE, score);
        obj.setBoolean(PluginConstants.ITEM_FOUND, itemWasFound);
        obj.setInteger(PluginConstants.ITEM_ID, itemFound.getItemTypeId());

        pInfo.stopDigging();
        sendAndLog("handleDiggingFinished", obj);

        if (isTerminal()) {
            endGame();
        }
    }

    private synchronized void handlePlayerInitRequest(String playerName) {
        EsObject message2 = new EsObject();
        message2.setString(PluginConstants.ACTION, PluginConstants.ADD_PLAYER);
        message2.setString(PluginConstants.NAME, playerName);
        
        sendAndLog("addUser", message2);
        
        playersInitialized++;
        

        // add AI user
        playerInfoMap.put(playerName, new PlayerInfo(playerName));
        
//          if (playerInfoMap.size() > 0 && playerInfoMap.size() < 2) {
//            // add one AI opponent
//            ai = new AI(PluginConstants.AI_NAME);
//            playerInfoMap.put(PluginConstants.AI_NAME, ai.getPInfo());
//            
//            usingAi = true;
////            turnHolder.add(ai.getName());
//            playersInitialized++;
//            getApi().getLogger().debug("Adding AI player: {}", ai.getName());
//        } else {
//            getApi().getLogger().debug("No AI added.  minPlayers = {}", 2);
//        }
          
           if (playersInitialized.equals(2))
        {
            getApi().getLogger().debug("beginning Questions document read!  !!.");
            
            xmlManager = new XmlManager(getApi().getLogger());
            xmlManager.createQuestions("https://s3.amazonaws.com/LobbySystem/xml/Questions.xml");
            
        } 

        // send the user the full user list
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.PLAYER_LIST);
        EsObject[] list = getFullPlayerList();
        message.setEsObjectArray(PluginConstants.PLAYER_LIST, list);
        message.setString(PluginConstants.GAME_STATE, gameState.getState());
        if (gameState == GameState.CountingDown) {
            message.setInteger(PluginConstants.COUNTDOWN_LEFT, getCountdownLeft());
        }
        getApi().sendPluginMessageToUser(playerName, message);
        getApi().getLogger().debug("Message sent to " + playerName + ": " + message.toString());

        switch (gameState) {
            case WaitingForPlayers:
                if (playerInfoMap.size() >= PluginConstants.MINIMUM_PLAYERS) {
                    startCountdown();
                }
                break;
            case CountingDown:
                startLateJoinerCountdown(playerName);
                if (playerInfoMap.size() >= PluginConstants.MAXIMUM_PLAYERS) {
                    stopCountdown();    // this will start the game
                }
                break;
        }

    }

    private void queueCallbackToFinishDigging(PlayerInfo pInfo) {
        String playerName = pInfo.getPlayerName();
        getApi().getLogger().debug("Delayed message for " + playerName + " queued.");
        if (delayQueue.add(pInfo)) {
            int callback = getApi().scheduleExecution(PluginConstants.DURATION_MS,
                    1,
                    new ScheduledCallback() {

                        public void scheduledCallback() {
                            tickQueue();
                        }
                    });
            pInfo.setCallBackId(callback);
        }
    }

    private void sendErrorMessage(String playerName, String error) {
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.ERROR);
        message.setString(PluginConstants.ERROR, error);
        getApi().sendPluginMessageToUser(playerName, message);
        getApi().getLogger().debug("Message sent to " + playerName + ": " + message.toString());
    }

    private synchronized void tickQueue() {
        if (delayQueue.isEmpty()) {
            return;
        }
        try {
            PlayerInfo pInfo = delayQueue.poll();
            if (pInfo != null) {
                handleDiggingFinished(pInfo);
            }
        } catch (Exception exception) {
            getApi().getLogger().error("Exception while running tickQueue", exception);
        }
    }

    private void relayMessage(String playerName, EsObject messageIn) {
        messageIn.setString(PluginConstants.NAME, playerName);
        messageIn.setString(PluginConstants.TIME_STAMP, String.valueOf(System.currentTimeMillis()));
        sendAndLog("relayMessage", messageIn);
    }
    
    private void sendToOneAndLog(String fromMethod, String playerName, EsObject message) {
        getApi().sendPluginMessageToUser(playerName, message);
        getApi().getLogger().debug(fromMethod + " to " + playerName + ": " + message.toString());
    }

    private void sendAndLog(String fromMethod, EsObject message) {
        List<String> initializedPlayers = new ArrayList<String>();
        for (PlayerInfo pInfo : playerInfoMap.values()) {
            initializedPlayers.add(pInfo.getPlayerName());
        }

        if (initializedPlayers.size() < 1) {
            return;     // nobody to send the message to
        }

        getApi().sendPluginMessageToUsers(initializedPlayers, message);
        getApi().getLogger().debug(fromMethod + ": " + message.toString());
    }
    
    private void startLateJoinerCountdown(String playerName) {
        if (gameState != GameState.CountingDown) {
            return;
        }
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.START_COUNTDOWN);
        message.setInteger(PluginConstants.COUNTDOWN_LEFT, getCountdownLeft());
        sendToOneAndLog("DiggingPlugin2.startLateJoinerCountdown", playerName, message);
    }

    private void startCountdown() {
        if (gameState == GameState.CountingDown) {
            return;
        }
        gameState = GameState.CountingDown;
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.START_COUNTDOWN);
        message.setInteger(PluginConstants.COUNTDOWN_LEFT, PluginConstants.COUNTDOWN_SECONDS);
        sendAndLog("DiggingPlugin2.startCountdown", message);
        setCountdownCallback(PluginConstants.COUNTDOWN_SECONDS);
    }

    private void resetCountdown() {
        getApi().cancelScheduledExecution(callbackId);
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.STOP_COUNTDOWN);
        message.setString(PluginConstants.GAME_STATE, GameState.WaitingForPlayers.getState());
        sendAndLog("DiggingPlugin2.resetCountdown", message);
        gameState = GameState.WaitingForPlayers;
        getApi().setGameLockState(false);
    }

    private void stopCountdown() {
        getApi().cancelScheduledExecution(callbackId);
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.STOP_COUNTDOWN);
        sendAndLog("DiggingPlugin2.stopCountdown", message);

        if (playerInfoMap.size() >= PluginConstants.MINIMUM_PLAYERS) {
            getApi().setGameLockState(true);
            startGame();
        } else {
            gameState = GameState.WaitingForPlayers;
            getApi().setGameLockState(false);
        }
    }

    private void startGame() {
        gameState = GameState.InPlay;
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.START_GAME);
        sendAndLog("DiggingPlugin2.startGame", message);
    }

    private void endGame() {
         getApi().getLogger().debug("ENDING THE ASDF GAME");
        gameState = GameState.GameOver;
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.GAME_OVER);
        message.setBoolean(PluginConstants.SUCCESS, isTerminal());
        
//        String winner = "fred";
//        message.setString(PluginConstants.WINNER_NAME, winner);
        
        EsObject[] scoreObjectList = getScoreObjectList();
        if (scoreObjectList != null) {
            message.setEsObjectArray(PluginConstants.PLAYER_LIST, getScoreObjectList());
        } else {
            message.setBoolean(PluginConstants.SUCCESS, false);
        }
        sendAndLog("GAME IS OVER ", message);
    }

    private void setCountdownCallback(int seconds) {
        getApi().cancelScheduledExecution(callbackId);
        startTime = System.currentTimeMillis();
        callbackId = getApi().scheduleExecution(seconds * 1000,
                1,
                new ScheduledCallback() {

                    public void scheduledCallback() {
                        stopCountdown();
                    }
                });
    }

   private String getWinner()
   {
       for (PlayerInfo pInfo : playerInfoMap.values()) {
//            if (pInfo.getScore() >= PluginConstants.POINTS_TO_WIN) {
//                return true;
//            }
            
            if (winnerName == null || winnerName.isEmpty())
            {
                winnerName =  pInfo.getPlayerName();
                winnerScore = pInfo.getScore();
            }
            else
            {
                   if (pInfo.getScore() > winnerScore)
                   {
                    winnerName =  pInfo.getPlayerName();
                    winnerScore = pInfo.getScore();
                   }
            }
            
       }
            return winnerName;
   }
    
    
    private boolean isTerminal() {
        for (PlayerInfo pInfo : playerInfoMap.values()) {
//            if (pInfo.getScore() >= PluginConstants.POINTS_TO_WIN) {
//                return true;
//            }
            
            if (winnerName == null || winnerName.isEmpty())
            {
                winnerName =  pInfo.getPlayerName();
                winnerScore = pInfo.getScore();
            }
            else
            {
                   if (pInfo.getScore() > winnerScore)
                   {
                    winnerName =  pInfo.getPlayerName();
                    winnerScore = pInfo.getScore();
                   }
            }
            
            
        }

//        if (!grid.isAnySpotLeft()) {
//            return true;
//        }

        return false;
    }
}
