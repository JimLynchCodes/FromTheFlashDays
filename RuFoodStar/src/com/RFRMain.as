package com
{
	
	import flash.display.Sprite;
	
	import configu.RFRConfig;
	
	import controllers.RFRController;
	
	import models.RFRModel;
	
	import views.RFRView;
	
	public class RFRMain extends Sprite
	{
		
		private var _stage:Object;
		private var _mainView:RFRView;
		private var _controller:RFRController;
		private var _model:RFRModel;
		private var _config:RFRConfig;
		trace("cheese");
		
		
		public function RFRMain():void
		{
			init();
			trace("poopy train");
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
			
			_config = new RFRConfig();
			_model = new RFRModel(_config);
			_controller = new RFRController(_model);
			_mainView = new RFRView(_model, _controller, _stage);
			
		}
		
		private function addListeners():void
		{
		
			
			
		}		
		
		
		
	}
}