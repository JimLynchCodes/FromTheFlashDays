package com
{
	import com.configu.RUSConfig;
	import com.controllers.RUSController;
	import com.models.RUSModel;
	import com.views.RUSView;
	
	import flash.display.Sprite;
	
	public class JMain extends Sprite
	{
		
		private var _stage:Object;
		private var _mainView:RUSView;
		private var _controller:RUSController;
		private var _model:RUSModel;
		private var _config:RUSConfig;
		
		
		
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
			
			_config = new RUSConfig();
			_model = new RUSModel(_config);
			_controller = new RUSController(_model);
			_mainView = new RUSView(_model, _controller, _stage);
			
		}
		
		private function addListeners():void
		{
		
			
			
		}		
		
		
		
	}
}