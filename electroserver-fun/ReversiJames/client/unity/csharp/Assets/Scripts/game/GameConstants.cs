/*
 * These are all the required game constants
 * for managing various actions and properties
 * passed between ES and all clients connected
 */

using UnityEngine;
using System.Collections;

static class GameConstants {

    public static string PLUGIN_NAME = "Reversi";
    public static string EXTENSION_NAME = "Reversi";
    public static string ZONE_NAME = "Reversi";

    public const string ACTION              = "a";

    public const int LEGAL = 3;
    public const int EMPTY = 2;
    public const int BLACK = 0;
    public const int WHITE                   = 1;
    public const int BOARD_SIZE             = 8;
    public const int TILE_SIZE              = 32;
    public const string AI_NAME = "Pixel";

    public const int PIXEL_GAME = -1;
    public const int QUICK_JOIN = -2;
    public const int CREATE_NEW = -3;
	
    public const string INIT_ME              = "i";
    public const string START_GAME           = "sg";
    public const string GAME_OVER            = "go";
    public const string MOVE_REQUEST         = "mr";
    public const string MOVE_RESPONSE        = "ms";
    public const string MOVE_EVENT           = "me";
    public const string ANNOUNCE_TURN        = "t";
    public const string TURN_TIME_LIMIT      = "mt";
    public const string LEGAL_MOVES          = "lm";

    // Parameters
    public const string PLAYER_NAME          = "n";
    public const string MOVE_VALUE           = "mv";
    public const string WINNER               = "w";
    public const string ERROR_MESSAGE        = "err";
    public const string ROW                  = "r";
    public const string COLUMN               = "c";
    public const string ID                   = "id";
    public const string COLOR_IS_BLACK       = "ch";
    public const string CHANGED_CHIPS        = "cc";
    public const string COUNTDOWN            = "cd";
    public const string SCORE = "pts";
    public const string AI_OPPONENT = "ai";

    // When user clicks "create new" he wants a human opponent
    // We want to give him more than just 10 seconds before
    // Pixel joins the game.  This specifies the number of seconds to wait.
    public const int COUNTDOWN_SECONDS_FOR_CREATE_NEW_GAME = 60;

}
