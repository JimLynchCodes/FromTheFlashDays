package com.electrotank.electroserver5.examples.avatarchat;

import com.electrotank.electroserver5.extensions.BasePlugin;
import com.electrotank.electroserver5.extensions.ChainAction;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;
import com.electrotank.electroserver5.extensions.api.value.UserEnterContext;
import com.electrotank.electroserver5.extensions.api.value.UserPublicMessageContext;
import com.electrotank.electroserver5.messages.Message.Reliability;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

/**
 *  This room plugin will work for any Avatar chat client or other room
 *  that just needs to be able to broadcast messages to the room, either 
 *  immediately or queued or UDP.
 * 
 */
public class AvatarChatPlugin extends BasePlugin  {
    
    private ConcurrentHashMap<String, UserState> userStateMap;
    private EmoChatFilter filter = null;
    private int queueFrequency;
    private boolean sendUserEnterExitEvents;
    private boolean checkChatForTriggerEvents;
    
    @Override
    public void init( EsObjectRO parameters ) {
        queueFrequency = parameters.getInteger(PluginConstants.TAG_QUEUE_FREQUENCY, PluginConstants.QUEUE_FREQUENCY);
        sendUserEnterExitEvents = parameters.getBoolean(PluginConstants.TAG_SEND_USER_ENTER_EXIT_EVENTS, PluginConstants.SEND_USER_ENTER_EXIT_EVENTS);
        checkChatForTriggerEvents = parameters.getBoolean(PluginConstants.TAG_CHECK_CHAT_FOR_TRIGGER_WORDS, PluginConstants.CHECK_CHAT_FOR_TRIGGER_WORDS);
        getApi().startQueue(queueFrequency);
        userStateMap = new ConcurrentHashMap<String, UserState>();
        ClassLoader loader = this.getClass().getClassLoader();
        if (checkChatForTriggerEvents) {
            filter = new EmoChatFilter(loader, getApi().getLogger());
        }
        
        getApi().getLogger().debug("AvatarChatPlugin queue started");
    }

    @Override
    public void destroy() {
        getApi().stopQueue();
        getApi().getLogger().debug("AvatarChatPlugin destroyed");
    }

    @Override
    public ChainAction userEnter(UserEnterContext context) {
        String playerName = context.getUserName();
        getApi().getLogger().debug("userEnter: " + playerName);
        userStateMap.put(playerName, new UserState(playerName));
        if (sendUserEnterExitEvents) {
            EsObject obj = new EsObject();
            obj.setString(PluginConstants.ACTION, PluginConstants.USER_ENTER_EVENT);
            obj.setString(PluginConstants.USER_NAME, playerName);
            sendAndLogQueued("userEnter", obj, "");
        }
        return ChainAction.OkAndContinue;
    }

    @Override
    public void userExit(String playerName) {
        getApi().getLogger().debug("userExit: " + playerName);
        userStateMap.remove(playerName);
        if (sendUserEnterExitEvents) {
            EsObject obj = new EsObject();
            obj.setString(PluginConstants.ACTION, PluginConstants.USER_EXIT_EVENT);
            obj.setString(PluginConstants.USER_NAME, playerName);
            sendAndLogQueued("userExit", obj, "");
        }
    }
    
    @Override
    public ChainAction userSendPublicMessage(UserPublicMessageContext message) {
        if (checkChatForTriggerEvents) {
            String username = message.getUserName();
            String chatline = message.getMessage();
            checkChatForTriggers(username, chatline);
        }
        return ChainAction.OkAndContinue;
    }

    @Override
    public void request(String playerName, EsObjectRO requestParameters) {
        EsObject messageIn = new EsObject();
        messageIn.addAll(requestParameters);
        getApi().getLogger().debug(playerName + " requests: " + messageIn.toString());
        String action = messageIn.getString(PluginConstants.ACTION, "");

        if (action.equals(PluginConstants.USER_LIST_REQUEST)) {
            handleUserListRequest(playerName);
        } else if (action.equals(PluginConstants.BROADCAST_REQUEST)) {
            handleBroadcastRequest(playerName, messageIn);
        } else if (action.equals(PluginConstants.BROADCAST_UDP_REQUEST)) {
            handleBroadcastUDPRequest(playerName, messageIn);
        } else if (action.equals(PluginConstants.POSITION_UPDATE_REQUEST)) {
            handlePositionUpdateRequest(playerName, messageIn);
        } else if (action.equals(PluginConstants.AVATAR_STATE_REQUEST)) {
            handleAvatarStateRequestRequest(playerName, messageIn);
        } else if (action.isEmpty()) {
            sendErrorMessage(playerName, PluginConstants.MISSING_ACTION);
        } else {
            sendErrorMessage(playerName, PluginConstants.INVALID_ACTION);
        }
    }

    private void checkChatForTriggers(String username, String chatline) {
        UserState userState = userStateMap.get(username);
        if (userState == null) {
            // user isn't in the room?
            return;
        }
        EmotionState emo = filter.getStateForChat(chatline);
        if (emo == userState.getEState()) {
            // no change in emotion state
            return;
        }
        // force the change in avatar state
        userState.setEState(emo);
        EsObject obj = new EsObject();
        obj.setInteger(PluginConstants.EMOTION_STATE, emo.getIndex());
        handleAvatarStateRequestRequest(username, obj);
    }

    private void handleAvatarStateRequestRequest(String playerName, EsObject messageIn) {
        boolean immediate = messageIn.getBoolean(PluginConstants.IMMEDIATELY, false);
        boolean useUDP = messageIn.getBoolean(PluginConstants.USE_UDP, false);
        UserState state = userStateMap.get(playerName);
        if (state == null) {
            // user is not in the room, ignore it
            return;
        } else {
            EsObject messageOut = new EsObject();
            messageIn.setString(PluginConstants.USER_NAME, playerName);
            state.setState(messageIn);
            messageOut.addAll(messageIn);
            messageOut.setString(PluginConstants.ACTION, PluginConstants.AVATAR_STATE_EVENT);
            if (useUDP) {
                sendAndLogUDP("handleAvatarStateRequestRequest", messageOut);
            } else if (immediate) {
                sendAndLogImmediately("handleAvatarStateRequestRequest", messageOut);
            } else {
                String queueLabel = messageIn.getString(PluginConstants.QUEUE_LABEL, "");
                sendAndLogQueued("handleAvatarStateRequestRequest", messageOut, queueLabel);
            }
        }
    }

    private void handleBroadcastUDPRequest(String playerName, EsObject messageIn) {
        EsObject messageOut = new EsObject();
        messageOut.addAll(messageIn);
        messageOut.setString(PluginConstants.ACTION, PluginConstants.BROADCAST_UDP_EVENT);
        
        // Add the username so that everybody knows who sent the message
        messageOut.setString(PluginConstants.USER_NAME, playerName);
        sendAndLogUDP("handleBroadcastUDPRequest", messageOut);
    }

    private void handleBroadcastRequest(String playerName, EsObject messageIn) {
        EsObject messageOut = new EsObject();
        messageOut.addAll(messageIn);
        messageOut.setString(PluginConstants.ACTION, PluginConstants.BROADCAST_EVENT);
        
        // Add the username so that everybody knows who sent the message
        messageOut.setString(PluginConstants.USER_NAME, playerName);
        
        if (messageOut.variableExists(PluginConstants.IMMEDIATELY)) {
            sendAndLogImmediately("handleBroadcastRequest", messageOut);
        } else {
            // If there is a queue label on the message, use it.  
            String queueLabel = messageIn.getString(PluginConstants.QUEUE_LABEL, "");
            sendAndLogQueued("handleBroadcastRequest", messageOut, queueLabel);
        }
    }

    private EsObject[] getFullPlayerList() {
        List<EsObject> userStateList = new ArrayList<EsObject>();
        for (UserState state : userStateMap.values()) {
            userStateList.add(state.getState());
        }
        EsObject[] list = new EsObject[userStateList.size()];
        list = userStateList.toArray(list);
        return list;
    }

    private void handlePositionUpdateRequest(String playerName, EsObject messageIn) {
        boolean immediate = messageIn.getBoolean(PluginConstants.IMMEDIATELY, false);
        boolean useUDP = messageIn.getBoolean(PluginConstants.USE_UDP, false);
        UserState state = userStateMap.get(playerName);
        if (state == null) {
            // user is not in the room, ignore it
            return;
        } else {
            EsObject messageOut = new EsObject();
            messageIn.setString(PluginConstants.USER_NAME, playerName);
            state.setState(messageIn);
            messageOut.addAll(messageIn);
            messageOut.setString(PluginConstants.ACTION, PluginConstants.POSITION_UPDATE_EVENT);
            if (useUDP) {
                sendAndLogUDP("handlePositionUpdateRequest", messageOut);
            } else if (immediate) {
                sendAndLogImmediately("handlePositionUpdateRequest", messageOut);
            } else {
                String queueLabel = messageIn.getString(PluginConstants.QUEUE_LABEL, "");
                sendAndLogQueued("handlePositionUpdateRequest", messageOut, queueLabel);
            }
        }
    }

    private void handleUserListRequest(String playerName) {
        EsObject messageOut = new EsObject();
        messageOut.setString(PluginConstants.ACTION, PluginConstants.USER_LIST_RESPONSE);
        messageOut.setEsObjectArray(PluginConstants.USER_STATE, getFullPlayerList());
        getApi().sendPluginMessageToUser(playerName, messageOut);
        getApi().getLogger().debug("UserListResponse sent to " + playerName + ": " + messageOut.toString());
    }

    /**
     * Sends an error message to a user.  
     * 
     * @param playerName
     * @param error: description of the error
     */
    private void sendErrorMessage(String playerName, String error) {
        EsObject message = new EsObject();
        message.setString(PluginConstants.ACTION, PluginConstants.ERROR);
        message.setString(PluginConstants.ERROR, error);
        getApi().sendPluginMessageToUser(playerName, message);
        getApi().getLogger().debug("sendErrorMessage to " + playerName + ": " + message.toString());
    }

    /**
     * Broadcast a message immediately, bypassing the queue.  Use when message
     * is urgent.
     * 
     * @param fromMethod: Label for the log message
     * @param message: EsObject message to be broadcast
     */
    private void sendAndLogImmediately(String fromMethod, EsObject message) {
        getApi().sendPluginMessageToRoom(getApi().getZoneId(), getApi().getRoomId(), message);
        getApi().getLogger().debug("sendAndLogImmediately from " + 
                fromMethod + ": " + message.toString());
    }
    
    /**
     * Broadcast a message immediately using UDP.  Use when message
     * isn't important, so it doesn't matter if it never gets delivered.
     * Note: currently only works with Unity and AIR clients, so if there are other
     * types of clients in the room, don't use this.
     * 
     * @param fromMethod: Label for the log message
     * @param message: EsObject message to be broadcast
     */
    private void sendAndLogUDP(String fromMethod, EsObject message) {
        getApi().sendPluginMessageToRoom(getApi().getZoneId(), getApi().getRoomId(),
                Reliability.Unreliable, message);
        getApi().getLogger().debug("sendAndLogUDP from " + 
                fromMethod + ": " + message.toString());
    }

    /**
     * Broadcast a message using the Rapid MessageAccumulator (queue).
     * If there is a non-null, non-empty queueLabel, then any previous message 
     * in the queue with the same queueLabel is replaced by this one - a good
     * idea for position updates.
     * 
     * @param fromMethod: Label for the log message
     * @param message: EsObject message to be broadcast 
     * @param queueLabel: optional label for the message
     */
    private void sendAndLogQueued(String fromMethod, EsObject message, String queueLabel) {
        if (queueLabel != null && !queueLabel.isEmpty()) {
            getApi().sendQueuedPluginMessageToRoom(queueLabel, message);
        } else {
            getApi().sendQueuedPluginMessageToRoom(message);
        }
        getApi().getLogger().debug("sendAndLogQueued from " + 
                fromMethod + ": " + message.toString());
    }
}
