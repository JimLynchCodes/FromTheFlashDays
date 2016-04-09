package 
{

	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	
	import configu.EGConfig;
	import controllers.EGController;
	import models.EGModel;
	import views.EGView;

	
	public class EGMain extends Sprite
	{
		
		private var _stage:Object;
		private var _mainView:EGView;
		private var _controller:EGController;
		private var _model:EGModel;
		private var _config:EGConfig;
		private var _guy:Sprite;
		
		
		
		public function EGMain():void
		{
			init();
		}
		
		
		private function init():void
		{
			
			assignVars();
			addListeners();
			
			addChild(_mainView);
			
			trace("Document Class Initialized.");
			
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			
		}

		
		private function assignVars():void
		{
			
			_stage = stage;
			
			_guy = this["guy"];
			
			
			_config = new EGConfig();
			_model = new EGModel(_config);
			_controller = new EGController(_model);
			_mainView = new EGView(_model, _controller, _stage, _guy);
			
		}
		
		private function addListeners():void
		{
		
			
			
		}		
		
		
		
	}
}