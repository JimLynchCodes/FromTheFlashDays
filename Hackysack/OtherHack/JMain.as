package com
{
	import com.configu.JConfig;
	import com.controllers.JController;
	import com.models.JModel;
	import com.views.JView;
	
	import flash.display.Sprite;
	
	public class JMain extends Sprite
	{
		
		private var _stage:Object;
		private var _mainView:JView;
		private var _controller:JController;
		private var _model:JModel;
		private var _config:JConfig;
		
		
		
		public function JMain():void
		{
			init();
		}
		
		
		private function init():void
		{
			
			assignVars();
			addListeners();
			
			addChild(_mainView);
			
			trace("Document Class Initialized.");
			
		}

		
		private function assignVars():void
		{
			
			_stage = stage;
			
			_config = new JConfig();
			_model = new JModel(_config);
			_controller = new JController(_model);
			_mainView = new JView(_model, _controller, _stage);
			
		}
		
		private function addListeners():void
		{
		
			
			
		}		
		
		
		
	}
}