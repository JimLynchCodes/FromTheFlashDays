package
{
	
	import com.configu.DCConfig;
	import com.controllers.DCController;
	import com.models.DCModel;
	import com.views.DcMainView;
	import com.trash.NewViewIos;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageAspectRatio;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	
	[SWF(frameRate="60", width="960", height="640", backgroundColor="0x333333")]
	
	
	public class DefendYourCastle extends Sprite
	{
		private var _stage:Stage;
		private var _config:DCConfig;
		private var _model:DCModel;
		private var _controller:DCController;
		private var _mainView:Starling;
		private var _version:String;
		private var _nativeStage:Stage;
		private var _realWidth:int;
		private var _realHeight:int;
		private var viewPort:Rectangle;
		
		
		
		public function DefendYourCastle()
		{
			init();
		}
		
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			assignVars();
		}
		
		
		private function assignVars():void
		{
			_nativeStage = stage;
			
			_realWidth = stage.fullScreenWidth;
			_realHeight= stage.fullScreenHeight;
			
			_version = Capabilities.version;
			
			if (_version.substr(0, 3) == "IOS")
			{
				
				 var viewPort:Rectangle = new Rectangle(0,0 , _realWidth, _realHeight) 

				
				Starling.handleLostContext = true;
				
				_mainView = new Starling(DcMainView, stage, viewPort, null, "auto");
				_mainView.stage.stageWidth = 960;
				_mainView.stage.stageHeight = 640;
				
				_mainView.antiAliasing = 1;
//				_mainView.addEventListener(starling.events.Event.ROOT_CREATED, onMainViewCreated);
				_mainView.start();
				
				
				trace(_mainView.contentScaleFactor)
				trace("starting ipad class");
				
			}
			if (_version.substr(0, 3) == "AND")
			{
				
				Starling.handleLostContext = true;
				this.stage.setAspectRatio( StageAspectRatio.LANDSCAPE );
				
				/**
				 *  I don't know if it is just my computer or something,
				 *  but the first way works in simulator and the second works
				 *  on device. 
				 */
				// viewPort = new Rectangle(0,0 , _realWidth, _realHeight) 
				viewPort = new Rectangle(0,0 , _realHeight, _realWidth) 
			
				
				_mainView = new Starling(DcMainView, stage, viewPort, null, "auto");
				_mainView.stage.stageWidth = 960;
				_mainView.stage.stageHeight = 640;
				
				_mainView.antiAliasing = 1;
//				_mainView.addEventListener(starling.events.Event.ROOT_CREATED, onMainViewCreated);
				_mainView.start();
//				addChild(_mainView);
				
				
				trace(_mainView.contentScaleFactor)
				trace("starting android class");
				
				
			}
			
			if (_version.substr(0, 3) != "AND" && 
				_version.substr(0, 3) != "IOS")
			{
				// start browser mode
//				var viewPort:Rectangle = new Rectangle(0,0 , _realWidth, _realHeight) 
				
				
				Starling.handleLostContext = true;
				
				_mainView = new Starling(DcMainView, stage, viewPort, null, "auto");
				_mainView.stage.stageWidth = 960;
				_mainView.stage.stageHeight = 640;
				
				_mainView.antiAliasing = 1;
				//				_mainView.addEventListener(starling.events.Event.ROOT_CREATED, onMainViewCreated);
				_mainView.start();
				
			}
			
			
			
		}
		
		
		
		
//		private function onMainViewCreated(e:starling.events.Event):void
//		{
////			var createdView:NewViewIos = Starling.current.root as NewViewIos;
////			
////			createdView.passVars(_model, _controller);
//			
////			_mainView.stage.addChild((createdView));
//			
//		}
		
		
		
	}
}