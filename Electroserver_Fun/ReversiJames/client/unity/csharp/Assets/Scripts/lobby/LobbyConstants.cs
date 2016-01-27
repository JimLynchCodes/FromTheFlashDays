/*
 * These are all the required game constants
 * for managing various actions and properties
 * passed between ES and all clients connected
 */

using UnityEngine;
using System.Collections;

static class LobbyConstants {

    public static string PLUGIN_NAME = "ReversiLobby";
    public static string EXTENSION_NAME = "Reversi";
    public static string ZONE_NAME = "Reversi";

    public const string ACTION = "a";
    public const string GAMES_FOUND = "gf";
    public const string NO_GAMES_FOUND = "ngf";
    public const string PLAYER_NAME = "n";
    public const string ID = "id";

    public const int NUM_ROWS = 4;
    public const int NUM_FIXED_ROWS = 3;
    public const string AI_NAME = "Pixel";
    public const string QUICK_JOIN_NAME = "Quick Join";
    public const string CREATE_NEW_NAME = "Create New Game";

    public const int PIXEL_GAME = -1;
    public const int QUICK_JOIN = -2;
    public const int CREATE_NEW = -3;
	
}
