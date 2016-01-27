package com.gamebook.model
{
	import com.electrotank.electroserver5.zone.Room;
	
	import flash.system.ApplicationDomain;
	import playerio.Client;

	public class StorageModel
	{
		
		public static var myWins:int;
		public static var myLevel:int;
		public static var myExp:int;
		
		public static var p2Wins:int;
		public static var p2Level:int;
		public static var p2Exp:int;
		public static var myCoins:int;
		private static var _currentCursorClassName:String;
		public static var p2CursorClassName:String;
		
		public static var loadedCursors:ApplicationDomain;
		public static var lobbyRoom:Room;
		public static var gameRoom:Room;
		
		public static var GreenTrowel:Class;
		public static var BlackTrowel:Class;
		public static var Trowel:Class;
		public static var BlueTrowel:Class;
		public static var iAmGuest:Boolean;
		
		public static var myCurrentOffsetX:Number;
		public static var myCurrentOffsetY:Number;
		public static var expToNextLevel:int;
		public static var playerIOClient:Client;
		public static var myUsername:String;
		
		
		public function StorageModel()
		{
		}

		public static function get currentCursorClassName():String
		{
			return _currentCursorClassName;
		}

		public static function set currentCursorClassName(value:String):void
		{
			_currentCursorClassName = value;
			trace("WHAT SETTING MY CURSOR NAME: " + value);
		}

	}
}