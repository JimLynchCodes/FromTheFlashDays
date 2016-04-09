package com.models
{
	
		import flash.events.Event;
		import flash.events.EventDispatcher;
		
		
		public class DCModel extends EventDispatcher
		{
			private var _configu:Object;
			private var _clicks:int = 0;
			private var _keyDirection:String;
			
			
			public function DCModel(config:Object)
			{
				_configu = config;
				
				init();
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