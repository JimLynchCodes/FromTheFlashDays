package com.electrotank.electroserver5.examples.reversi;

public class PluginConstants {

    // Game Details Parameters
    public static final String MINIMUM_PLAYERS      = "np";
    public static final String MAXIMUM_PLAYERS      = "m";
    public static final String COUNTDOWN            = "cd";
    public static final String TURN_TIME_LIMIT      = "mt";
    public static final String RESTART_GAME_SECONDS = "pd";

    // Actions
    public static final String ACTION               = "a";
    public static final String INIT_ME              = "i";
    public static final String START_GAME           = "sg";
    public static final String GAME_OVER            = "go";
    public static final String MOVE_REQUEST         = "mr";
    public static final String MOVE_RESPONSE        = "ms";
    public static final String MOVE_EVENT           = "me";
    public static final String ANNOUNCE_TURN        = "t";

    // Parameters
    public static final String PLAYER_NAME          = "n";
    public static final String MOVE_VALUE           = "mv";
    public static final String WINNER               = "w";
    public static final String ERROR_MESSAGE        = "err";
    public static final String ID                   = "id";
    public static final String COLOR_IS_BLACK       = "ch";
    public static final String CHANGED_CHIPS        = "cc";
    public static final String SCORE                = "pts";
    public static final String LEGAL_MOVES          = "lm";
    
    // Game Flow constants
    public static final int DEFAULT_MIN_PLAYERS     = 2;
    public static final int DEFAULT_MAX_PLAYERS     = 2;
    public static final int DEFAULT_COUNTDOWN       = 10;
    public static final int DEFAULT_RESTART_GAME_SECONDS = 10;

    // Game initialization constant
    public static final String AI_NAME              = "Pixel";
    public static final int DEFAULT_TURN_TIME_LIMIT = 30;   // seconds
    public static final int BLACK                   = 0;
    public static final int WHITE                   = 1;
    public static final int BOARD_SIZE              = 8;
    
    public static final String GAME_TYPE            = "Reversi";
    public static final int MAX_LOBBY_USERS         = 20;
    public static final int FIND_GAMES_SECONDS      = 2;
    public static final String GAMES_FOUND          = "gf";
    public static final String NO_GAMES_FOUND       = "ngf";
    public static final String AI_OPPONENT          = "ai";
    
}
