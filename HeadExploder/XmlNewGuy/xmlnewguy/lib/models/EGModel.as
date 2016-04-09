package models
{
	
		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.net.SharedObject;
		
		
		public class EGModel extends EventDispatcher
		{
			private var _configu:Object;
			private var _clicks:int = 0;
			private var _keyDirection:String;
			
			private var _blitSpriteAry:Array = [];
			private var _brains:uint = 0;
			
			private var _character:String = "guy";
			private var _girlOwned:Boolean = false;
			
			private var _headExplodeSharedObject:SharedObject = SharedObject.getLocal("headExplode");
			
			
			
			public function EGModel(config:Object)
			{
				_configu = config;
				
				init();
			}
			
			
			public function get girlOwned():Boolean
			{
				return _girlOwned;
			}

			public function set girlOwned(value:Boolean):void
			{
				_girlOwned = value;
			}

			public function get character():String
			{
				return _character;
			}

			public function set character(value:String):void
			{
				_character = value;
				dispatchEvent(new Event(_configu.CHARACTER_CHANGE));
			}

			public function get headExplodeSharedObject():SharedObject
			{
				return _headExplodeSharedObject;
			}

			public function set headExplodeSharedObject(value:SharedObject):void
			{
				_headExplodeSharedObject = value;
			}

			public function get brains():uint
			{
				return _brains;
				
			}

			public function set brains(value:uint):void
			{
				_brains = value;
				dispatchEvent(new Event(_configu.BRAINS_CHANGE));
				
				_headExplodeSharedObject.data.brains = value;
				_headExplodeSharedObject.flush();
				
			}

			public function get blitSpriteAry():Array
			{
				return _blitSpriteAry;
			}

			public function set blitSpriteAry(value:Array):void
			{
				_blitSpriteAry = value;
			}

			private function init():void
			{
				trace("Model Initialized");
				
			}
			
			
			
			public function get configu():Object
			{
				return _configu;
			}

			public function set configu(value:Object):void
			{
				_configu = value;
			}

			
			
			public function get keyDirection():String
			{
				return _keyDirection;
			}
			
			public function set keyDirection(value:String):void
			{
				_keyDirection = value;
				dispatchEvent(new Event(_configu.KEYBOARD_CHANGE));
				trace("dispatched keyaboard change");
			}
			
			public function get clicks():int
			{
				return _clicks;
			}
			
			public function set clicks(value:int):void
			{
				_clicks = value;
				dispatchEvent(new Event(_configu.MOUSE_CLICK_CHANGE));
				trace("dispatched mouse click change");
				
			}
			
			
			
		}
}