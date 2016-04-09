package com.controllers
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	public class DCController
	{
		private var _model:Object;
		private var _config:Object;
		
		
		public function DCController(model:Object)
		{
			_model = model;
			
			init();			
		}
		
		
		private function init():void
		{
			trace("Controller Initialized.");
			
			assignVars();
		}
		
		
		private function assignVars():void
		{
			_config = _model.configu;
				
		}		
		
		
		public function processKeyPress(event:KeyboardEvent):void
		{
			
			trace(String.fromCharCode(event.charCode));
			
			switch (event.keyCode)
			{
				
				case Keyboard.LEFT:
					_model.keyDirection = "Left";
					break;
				
				case Keyboard.RIGHT:
					_model.keyDirection = "Right";
					break;
				
				case Keyboard.UP:
					_model.keyDirection = "Up";
					break;
				
				case Keyboard.DOWN:
					_model.keyDirection = "Down";
					break;
				
			}
		}
		
		
		public function processMouseClick(m:MouseEvent):void
		{
			
			_model.clicks = _model.clicks + 1;
			
		}
		
		
		
		
	}
}