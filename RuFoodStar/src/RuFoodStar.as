package
{
	import com.configu.RUSConfig;
	import com.controllers.RUSController;
	import com.models.RUSModel;
	import com.views.FPMView;
	import com.views.RUSView;
	import com.views.RUSViewIos;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	
	[SWF(frameRate="60", width="800", height="600", backgroundColor="0x333333")]
	
	
	public class RuFoodStar extends Sprite
	{
		private var _stage:Stage;
		private var _config:RUSConfig;
		private var _model:RUSModel;
		private var _controller:RUSController;
		private var _mainView:RUSViewIos;
		private var _version:String;
		private var _nativeStage:Stage;
		
		
		
		public function RuFoodStar()
		{
			init();
			
		}
		
		
		private function init():void
		{
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			assignVars();
			addListeners();
			
//			addChild(_mainView);
			
		
			
			trace("Document Class Initialized.");
		}
		
		
		private function assignVars():void
		{
			
			_nativeStage = stage;
			
			_config = new RUSConfig();
			_model = new RUSModel(_config);
			_controller = new RUSController(_model);
			
			_version = Capabilities.version;
			
			if (_version.substr(0, 3) == "IOS")
			{
				trace("starting ipad class");
				_mainView = new RUSViewIos(_model, _controller, _stage);
				_mainView.antiAliasing = 1;
				_mainView.addEventListener(Event.ROOT_CREATED, onMainViewCreated);
				_mainView.start();
			}
			
			
			private function onMainViewCreated(e:Event):void
			{
				var createdView:FPMView = Starling.current.root as FPMView;
				
				createdView.passVars(_model, _controller);
				
			}
			
			
		}
		
		
		private function addListeners():void
		{
			
			
			
		}		
		
		
		
	}
}