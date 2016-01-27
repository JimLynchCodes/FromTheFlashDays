package com.electrotank.electroserver5.examples.digging;

public class PluginConstants {

    // actions 
    public static final String ACTION          = "a";
    public static final String ADD_PLAYER      = "au";
    public static final String DIG_HERE        = "d";
    public static final String DONE_DIGGING    = "dd";
    public static final String ERROR           = "err";
    public static final String GAME_OVER       = "go";
    public static final String INIT_ME         = "i";
    public static final String POSITION_UPDATE = "pu";
    public static final String REMOVE_PLAYER   = "ru";
    public static final String START_COUNTDOWN = "s";
    public static final String STOP_COUNTDOWN  = "sc";
    public static final String START_GAME      = "sg";
    public static final String PLAYER_LIST     = "ul";
    public static final String QUESTION_REQUEST     = "qr";
    public static final String ANSWER_HAS_BEEN_CHOSEN     = "ahc";
    public static final String ROUND_TIME     = "rt";
    
    public static final String QUESTION_TEXT     = "qt";
    public static final String A_TEXT     = "at";
    public static final String B_TEXT     = "bt";
    public static final String C_TEXT     = "ct";
    public static final String D_TEXT     = "dt";
    public static final String ANSWER_VALUE     = "av";
   public static final String ANSWER_CHOSEN     = "anc";
    public static final String TIME_TO_ANSWER     = "tta";
    public static final String WINNER_CHOSEN     = "wc";
    public static final String WINNER_NAME     = "wn";
    public static final String CHAMPION_NAME     = "cham";
    public static final String QUESTION_COUNT     = "qc";
    public static final Integer QUESTIONS_PER_ROUND     = 5;
    public static final Integer ROUND_TIME_LENGTH     = 15;
    public static final String CURSOR_BROADCAST     = "cub";
    
    public static final String ROUND_OVER     = "ro";
    public static final int MS_OF_ROUND     = 8000;
    
    // parameters
    public static final String COUNTDOWN_LEFT  = "cs";
    public static final String ITEM_FOUND      = "f";
    public static final String GAME_STATE      = "gs";
    public static final String ITEM_ID         = "id";
    public static final String NAME            = "n";
    public static final String SCORE           = "s";
    public static final String SUCCESS         = "suc";
    public static final String TIME_STAMP      = "tm";
    public static final String X               = "x";
    public static final String Y               = "y";   
    public static final String CURSOR_NAME               = "cur"; 
  
    // error messages
    public static final String ALREADY_DIGGING  = "AlreadyDigging";
    public static final String SPOT_ALREADY_DUG = "SpotAlreadyDug";
    public static final String GAME_IS_OVER     = "GameIsOver";
    
    // game flow constants
    public static final int MAXIMUM_PLAYERS     = 4;
    public static final int MINIMUM_PLAYERS     = 2;    
    public static final int COUNTDOWN_SECONDS   = 10;    
    
    // other constants
    public static final int DURATION_MS        = 2000;   // 2 seconds
    public static final int BOARD_WIDTH        = 800;
    public static final int BOARD_HEIGHT       = 600;
    public static final int NUM_ROWS           = 12;
    public static final int NUM_COLS           = 16;
    public static final int POINTS_TO_WIN      = 4000;  
    public static final String AI_NAME              = "Pixel";
}
