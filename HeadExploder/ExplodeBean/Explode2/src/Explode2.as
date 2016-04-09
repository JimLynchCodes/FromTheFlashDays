package
{
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	
	import configu.E2Config;
	
	import controllers.E2Controller;
	
	import models.E2Model;
	
	import views.E2View;
	
	public class Explode2 extends Sprite
	{
		
		private var _stage:Object;
		private var _mainView:E2View;
		private var _controller:E2Controller;
		private var _model:E2Model;
		private var _config:E2Config;
		
		
		
		public function Explode2():void
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
			
			_config = new E2Config();
			_model = new E2Model(_config);
			_controller = new E2Controller(_model);
			_mainView = new E2View(_model, _controller, _stage);
			
		}
		
		private function addListeners():void
		{
			
			
			
		}		
		
		
		
	}
}
import com.fs.edu.blit_test_5;

