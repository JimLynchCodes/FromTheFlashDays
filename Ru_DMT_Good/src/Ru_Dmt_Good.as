package
{
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import feathers.controls.TextInput;
	
	import model.Model;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(frameRate="60", width="640", height="960", backgroundColor="0#E81227")]
	
	
	public class Ru_Dmt_Good extends flash.display.Sprite
	{
		private var m_starling:Starling;
		public static var widthy:uint;
		public static var height:uint;
		private var _realWidth:uint;
		private var _nativeStage:Stage;
		private var viewPort:Rectangle;
		private var _realHeight:uint;
		private var inputBox:TextInput;
		private var _loadingScreen:Sprite;
		public static var width:uint;
		private var _version:String;
		public static var dpi:Number;
		public static var pixelAspectRatio:Number;
		public static var rootStarling:Starling;
		
		
		public function Ru_Dmt_Good()
		{
			
			
			stage.color = 0xE81227;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = true;
			
			_nativeStage = stage;
			
			_loadingScreen = Sprite(new LoadingScreen);
			_nativeStage.addChild(_loadingScreen);
			
			_version = Capabilities.version;
			Starling.handleLostContext = true;
			
			if (_version.substr(0, 3) == "IOS" ||
				_version.substr(0, 3) == "AND" )
			{
				_realWidth = _nativeStage.fullScreenWidth;
				_realHeight = _nativeStage.fullScreenHeight;
				Model.isMobile = true;
				HelloDMT2.width = _realWidth;
				HelloDMT2.height = _realHeight;
			}
			else
			{
				_realWidth = 640;
				_realHeight = 960;
				Model.isMobile = false;
				HelloDMT2.width = 640;
				HelloDMT2.height = 960;
			}
			
			_loadingScreen.width = _realWidth;
			_loadingScreen.height = _realHeight;
			
			trace("width: " + _realWidth + " height: " + _realHeight);
			trace(Capabilities.screenDPI + " was dpi");
			dpi = Capabilities.screenDPI;
			
			trace(Capabilities.pixelAspectRatio + " was pixel aspect");
			pixelAspectRatio = Capabilities.pixelAspectRatio;
			
			viewPort = new Rectangle(0,0 ,_realWidth, _realHeight); 
			// initialize Starling
			m_starling = new Starling(Main, stage, viewPort);
			m_starling.simulateMultitouch  = false;
			//			m_starling.showStats = false;
			m_starling.addEventListener(Event.ROOT_CREATED, onMainViewCreated);
			m_starling.start();
			rootStarling = m_starling;
			
		}
		
		private function onMainViewCreated(e:starling.events.Event):void
		{
			_nativeStage.removeChild(_loadingScreen);
			
			//			nativestage = Starling.current.n;
			
		}
	}
}