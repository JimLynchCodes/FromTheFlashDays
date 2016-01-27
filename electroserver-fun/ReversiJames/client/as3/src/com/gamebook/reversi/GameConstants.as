package com.gamebook.reversi 
{
	
	public class GameConstants 
	{
		public static const PLUGIN_NAME:String = "Reversi";
		public static const EXTENSION_NAME:String = "Reversi";
		public static const ZONE_NAME:String = "Reversi";
		
		public static const ACTION:String = "a";
		public static const INIT_ME:String = "i";
		public static const START_GAME:String = "sg";
		public static const GAME_OVER:String = "go";
		public static const MOVE_REQUEST:String = "mr";
		public static const MOVE_RESPONSE:String = "ms";
		public static const MOVE_EVENT:String = "me";
		public static const ANNOUNCE_TURN:String = "t";
		public static const TURN_TIME_LIMIT:String = "mt";
		public static const LEGAL_MOVES:String = "lm";
		public static const PLAYER_NAME:String = "n";
		public static const MOVE_VALUE:String = "mv";
		public static const WINNER:String = "w";
		public static const ERROR_MESSAGE:String = "err";
		public static const ROW:String = "r";
		public static const COLUMN:String = "c";
		public static const ID:String = "id";
		public static const COLOR_IS_BLACK:String = "ch";
		public static const CHANGED_CHIPS:String = "cc";
		public static const COUNTDOWN:String = "cd";
		public static const SCORE:String = "pts";
		public static const AI_OPPONENT:String = "ai";

		public static const LEGAL:int = 3;
		public static const EMPTY:int = 2;
		public static const BLACK:int = 0;
		public static const WHITE:int = 1;
		public static const BOARD_SIZE:int = 8;
		public static const TILE_SIZE:int = 32;
		public static const PIXEL_GAME:int = -1;
		public static const QUICK_JOIN:int = -2;
		public static const CREATE_NEW:int = -3;
		
		public static const AI_NAME:String = "Pixel";

		// When user clicks "create new" he wants a human opponent
		// We want to give him more than just 10 seconds before
		// Pixel joins the game.  This specifies the number of seconds to wait.
		public static const COUNTDOWN_SECONDS_FOR_CREATE_NEW_GAME:int = 60;
	}
	
}