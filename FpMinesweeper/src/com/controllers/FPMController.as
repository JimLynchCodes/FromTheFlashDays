package com.controllers
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	public class FPMController
	{
		private var _model:Object;
		private var _config:Object;
		
		
		public function FPMController(model:Object)
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
		
		
		
	}
}