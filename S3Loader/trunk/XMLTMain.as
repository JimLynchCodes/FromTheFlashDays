package com.fs.edu.xml_tut
{
	
	import com.fs.edu.xml_tut.configu.XMLTConfig;
	import com.fs.edu.xml_tut.controllers.XMLTController;
	import com.fs.edu.xml_tut.models.XMLTModel;
	import com.fs.edu.xml_tut.views.XMLTView;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	
	public class XMLTMain extends Sprite
	{
		
		private var _stage:Object;
		private var _mainView:XMLTView;
		private var _controller:XMLTController;
		private var _model:XMLTModel;
		private var _config:XMLTConfig;
		
		
		
		public function XMLTMain():void
		{
			init();
		}
		
		
		private function init():void
		{
			trace("Document Class Initialized.");
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			assignVars();
			addListeners();
			
			addChild(_mainView);
			
			
		}
		
		
		private function assignVars():void
		{
			
			_stage = stage;
			
			_config = new XMLTConfig();
			_model = new XMLTModel(_config);
			_controller = new XMLTController(_model);
			_mainView = new XMLTView(_model, _controller, _stage);
			
		}
		
		private function addListeners():void
		{
			
			
			
		}		
		
		
		
	}
}