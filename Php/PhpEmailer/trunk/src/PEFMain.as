package  
{
	import flash.display.Sprite;
	
	import configu.PEFConfig;
	
	import controllers.PEFController;
	
	import helpers.PEFPhpGuy;
	
	import models.PEFModel;
	
	import views.PEFView;
	
	public class PEFMain extends Sprite
	{
		
		private var _stage:Object;
		private var _mainView:PEFView;
		private var _controller:PEFController;
		private var _model:PEFModel;
		private var _config:PEFConfig;
		private var _phpguy:PEFPhpGuy;
		
		
		
		public function PEFMain():void
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
			
			_config = new PEFConfig();
			_model = new PEFModel(_config);
			_phpguy = new PEFPhpGuy(_model)
			_controller = new PEFController(_model);
			_mainView = new PEFView(_model, _controller, _stage);
			
		}
		
		private function addListeners():void
		{
		
			
			
		}		
		
		
		
	}
}