package com.models
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	public class HackModel extends EventDispatcher
	{
		private var _config:Object;
		private var _clicks:int = 0;
		private var _keyDirection:String;
		
		private var _kickHeight:Number = 60;
		private var _xDirection:Number = 0;
		private var _kicks:Number = 0;
		
		private var _leftFoot:Sprite;
		private var _rightFoot:Sprite;
		
		private var _guy:Sprite;
		
		
		
		
		public function HackModel(config:Object)
		{
			_config = config;
			
			init();
		}
		
		
		public function get guy():Sprite
		{
			return _guy;
		}

		public function set guy(value:Sprite):void
		{
			_guy = value;
		}

		public function get config():Object
		{
			return _config;
		}

		public function set config(value:Object):void
		{
			_config = value;
		}

		public function get kicks():Number
		{
			return _kicks;
			
		}

		public function set kicks(value:Number):void
		{
			_kicks = value;
			dispatchEvent(new Event(config.KICKS_CHANGE));
		}

		public function get xDirection():Number
		{
			return _xDirection;
		}

		public function set xDirection(value:Number):void
		{
			_xDirection = value;
		}

		public function get rightFoot():Sprite
		{
			return _rightFoot;
		}

		public function set rightFoot(value:Sprite):void
		{
			_rightFoot = value;
		}

		public function get leftFoot():Sprite
		{
			return _leftFoot;
		}

		public function set leftFoot(value:Sprite):void
		{
			_leftFoot = value;
		}

		public function get kickHeight():Number
		{
			return _kickHeight;
		}

		public function set kickHeight(value:Number):void
		{
			_kickHeight = value;
		}

		private function init():void
		{
			trace("Model Initialized");
			
		}
		
		
		public function get keyDirection():String
		{
			return _keyDirection;
		}
		
		
		public function set keyDirection(value:String):void
		{
			_keyDirection = value;
			dispatchEvent(new Event(_config.KEYBOARD_CHANGE));
			trace("dispatched keyaboard change");
		}
		
		
		public function get clicks():int
		{
			return _clicks;
		}
		
		
		public function set clicks(value:int):void
		{
			_clicks = value;
			dispatchEvent(new Event(_config.MOUSE_CLICK_CHANGE));
			trace("dispatched mouse click change");
			
		}
		
		
		
	}
}