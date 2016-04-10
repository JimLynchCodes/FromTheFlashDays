package com.electrotank.electroserver5.examples.avatarchat;

public class PluginConstants {

    // Strings used for variable/parameter names in plugin requests and messages

    // actions 
    public static final String ACTION               = "a";
    public static final String BROADCAST_REQUEST    = "b";
    public static final String BROADCAST_EVENT      = "be";
    public static final String BROADCAST_UDP_REQUEST    = "bu";
    public static final String BROADCAST_UDP_EVENT      = "bue";
    public static final String ERROR                = "err";
    public static final String USER_LIST_REQUEST    = "ul";
    public static final String USER_LIST_RESPONSE   = "ulr";
    public static final String USER_ENTER_EVENT     = "j";
    public static final String USER_EXIT_EVENT      = "x";
    public static final String POSITION_UPDATE_REQUEST = "p";
    public static final String POSITION_UPDATE_EVENT = "pe";
    public static final String AVATAR_STATE_REQUEST = "av";
    public static final String AVATAR_STATE_EVENT   = "ave";
    
    // parameters
    public static final String IMMEDIATELY          = "i";
    public static final String USER_NAME            = "n";
    public static final String USER_STATE            = "s";
    public static final String QUEUE_LABEL          = "ql";
    public static final String USE_UDP              = "udp";
    public static final String EMOTION_STATE        = "em";
    
    // error messages
    public static final String MISSING_ACTION       = "MissingAction";
    public static final String INVALID_ACTION       = "InvalidAction";
    
    // other constants

    // How often should the "Rapid Message Accumulator" send queued messages, in ms?
    // 200 sends 5 times a second.  We need to keep total plugin messages below 20/sec
    // for ActionScript clients
    public static final int QUEUE_FREQUENCY = 200;
    public static final String TAG_QUEUE_FREQUENCY = "queueFrequency";
    
    // A low traffic room can set this to false and just use the normal
    // ElectroServer client events for userlist updates, enter, exit.
    // High traffic rooms need to suppress these events and get the information from 
    // the plugin
    public static final boolean SEND_USER_ENTER_EXIT_EVENTS = true;
    public static final String TAG_SEND_USER_ENTER_EXIT_EVENTS = "sendUserEnterExitEvents";
    
    // if avatars will change state based on trigger words in the text of the user's chat
    // set this to true
    public static final boolean CHECK_CHAT_FOR_TRIGGER_WORDS = true;
    public static final String TAG_CHECK_CHAT_FOR_TRIGGER_WORDS = "checkChatForTriggerEvents";
}
