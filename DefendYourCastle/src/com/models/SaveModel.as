package com.models
{
	import flash.net.SharedObject;

	public class SaveModel
	{
		
		
		// do getters and setters for all these when you decide what they are
		
		private static var _sharedObj:SharedObject;
		
			// whether you have unlocked the power up or not
		private static var _aitemUnlocked:Boolean = false;
		private static var btemUnlocked:Boolean = false;
		private static var citemUnlocked:Boolean = false;
		private static var ditemUnlocked:Boolean = false;
		private static var eitemUnlocked:Boolean = false;
		private static var fitemUnlocked:Boolean = false;
		private static var gitemUnlocked:Boolean = false;
		
		
			// level of how the powerup
		private static var aitemLevel:int = 0;
		
		
			// current powerups selected
		private static var _currentPowerUp1:String = "";
		private static var _currentPowerUp2:String = "";
		private static var _currentPowerUp3:String = "";
		
			// acheivements unlocked
		private static var achievement1:Boolean = false;
		public static var currentVelocityNum:int = 4;
		public static var juggler:int = 4;
		
		
		
		public static function get currentPowerUp3():String
		{
			return _currentPowerUp3;
		}

		public static function set currentPowerUp3(value:String):void
		{
			_currentPowerUp3 = value;
		}

		public static function get currentPowerUp2():String
		{
			return _currentPowerUp2;
		}

		public static function set currentPowerUp2(value:String):void
		{
			_currentPowerUp2 = value;
		}

		public static function get currentPowerUp1():String
		{
			return _currentPowerUp1;
		}

		public static function set currentPowerUp1(value:String):void
		{
			_currentPowerUp1 = value;
		}

		public static function get sharedObj():SharedObject
		{
			return _sharedObj;
		}

		public static function set sharedObj(value:SharedObject):void
		{
			_sharedObj = value;
		}
		
		public function SaveModel()
		{
		}

		public static function get aitemUnlocked():Boolean
		{
			return _aitemUnlocked;
		}

		public static function set aitemUnlocked(value:Boolean):void
		{
			_aitemUnlocked = value;
			_sharedObj.data.aitemUnlocked = _aitemUnlocked;
			flush();
		}
		
		private static function flush():void
		{
			_sharedObj.flush();
		}

		public static function fillWithSavedData():void
		{
			// do this for every var in this class!
//			if (_sharedObj.data.aitemUnlocked != undefined)
//			{
				_aitemUnlocked = _sharedObj.data.aitemUnlocked
//			}ß
			// .
			// .
		    // .
		}
	}
}