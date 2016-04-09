package views 
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import blitter.BlitSprite;
	import blitter.PerformanceProfiler;
	import blitter.XmlParserBlit;
	
	
	public class E2View extends Sprite
	{
		private var _stage:Object;
		private var _model:Object;
		private var _controller:Object;
		private var _configu:Object;
		private var _stageBitmapData:BitmapData;
		private var _bitmapStage:Bitmap;
		private var _spritesheet:BitmapData;
		private var _blitDataAry:Array;
		private var _xmlDataAry:Array;
		private var _xmlPath:String;
		private var _testXml:XML;
		private var _testXmlRequest:URLRequest;
		private var _testXmlLoader:URLLoader;
		private var _blitSprite:BlitSprite;
		private var _blitTimer:Timer;
		private var _panel:Sprite;
		private var _memTF:TextField;
		private var _fpsTF:TextField;
		private var _stopAndShutDownBtn:SimpleButton;
		private var _stopBtn:SimpleButton;
		private var _startBtn:SimpleButton;
		private var _time:int;
		private var _fps:int;
		private var _previousTime:int = 0;
		private var _maxTF:TextField;
		private var _minTF:TextField;
		private var _minFps:int = 100;
		private var _maxFps:int;
		private var _mem:Number;
		private var _count:int;
		private var _loopOffBtn:SimpleButton;
		private var _loopOnBtn:SimpleButton;
		private var _stageHeight:uint;
		private var _stageWidth:uint;
		
		
		public function E2View(model:Object, controller:Object, stage:Object)
		{

			_model = model;			
			_controller = controller;
			_stage = stage;
			
			init();
			
		}
		
		
		private function init():void
		{
			
			assignVars();
			addListeners();
			
			trace("HeadExploder View Initialized.");
			
				// add performance panel to the stage;
			_stage.addChild(_panel);
			_panel.x = 0;
			_panel.y = 100;
			
				// load the xml
			_xmlDataAry = []
			
			_xmlPath = "blit_test_5_100g.xml"
			
			_testXml = new XML();
			_testXmlRequest = new URLRequest(_xmlPath);
			_testXmlLoader = new URLLoader();
			
			_testXmlLoader.addEventListener(Event.COMPLETE, onXmlLoaded);
			_testXmlLoader.load(_testXmlRequest);
			
		}
		
		
		private function assignVars():void
		{
			_configu = _model.configu;
			
			_stageWidth = _stage.stageWidth;
			_stageHeight = _stage.stageHeight;
			
				// set up the transparent "bitmap stage"
			_stageBitmapData = new BitmapData(_stageWidth, _stageHeight, true, 0x0000CC);
			_bitmapStage = new Bitmap(_stageBitmapData);
			_stage.addChild(_bitmapStage);
			_bitmapStage.x = 0;
			_bitmapStage.y = 0;
			
			
				// load in the spritesheet
			var _spritesheetClass:Class = getDefinitionByName("SpriteSheet") as Class;
			_spritesheet = new _spritesheetClass() as BitmapData;
			
			var _panelClass:Class = getDefinitionByName("Panel") as Class;
			_panel = new _panelClass() as Sprite;
			
			_fpsTF = _panel["fpsTxt"];
			_memTF = _panel["memTxt"];
			_minTF = _panel["minFpsTxt"];
			_maxTF = _panel["maxFpsTxt"];
			
			_startBtn = _panel["startBtn"];
			_stopBtn = _panel["stopBtn"];
			_stopAndShutDownBtn = _panel["stopAndShutdownBtn"];
			
			_loopOnBtn = _panel["loopOnBtn"];
			_loopOffBtn = _panel["loopOffBtn"];
			
			_loopOffBtn.visible = false;
			
		}
		
		
		private function addListeners():void
		{
			
			_model.addEventListener(_configu.KEYBOARD_CHANGE, keyboardChangeHandler);
			_model.addEventListener(_configu.MOUSE_CLICK_CHANGE, mouseChangeHandler);
			_stage.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_startBtn.addEventListener(MouseEvent.CLICK, onStartBtnClick);
			_stopBtn.addEventListener(MouseEvent.CLICK, onStopBtnClick);
			_stopAndShutDownBtn.addEventListener(MouseEvent.CLICK, onShutdownBtnClick);
			_loopOnBtn.addEventListener(MouseEvent.CLICK, onLoopBtnClick);
			_loopOffBtn.addEventListener(MouseEvent.CLICK, onLoopBtnClick);
		
			
		}
		
		protected function onLoopBtnClick(event:MouseEvent):void
		{
			
			if (_blitSprite.loop == false)
			{
				for (var g:int = 0; g < _model.blitSpriteAry.length; g++)
				{
					_model.blitSpriteAry[g].loop = true;
				}
				
				_loopOffBtn.visible = true;
				_loopOnBtn.visible = false;
			}
			
			
			else
			{
				for (var m:int = 0; m < _model.blitSpriteAry.length; m++)
				{
					_model.blitSpriteAry[m].loop = false;
				}

				_loopOffBtn.visible = false;
				_loopOnBtn.visible = true;
			}
		}		
		
		private function BlitLoop(e:Event):void
		{
			
				// blitting
			_stageBitmapData.lock();
			_stageBitmapData.fillRect(new Rectangle(0,0,_stageWidth,_stageHeight), 0x0000CC);
			
			for (var f:int = 0; f < _model.blitSpriteAry.length; f++)
			{
				_model.blitSpriteAry[f].render();
			}
			
			_stageBitmapData.unlock();
			
			
				// performance monitoring
			_fps = PerformanceProfiler.i.fps
			_mem = Math.round(PerformanceProfiler.i.memory)
			_fpsTF.text = "FPS: " + _fps;
			_memTF.text = "MEM: " + _mem + " MB";
			
			
		}
			
		
		private function addedToStageHandler(event:Event):void
		{
			trace("HeadExploder view added to stage.");
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			_stage.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		
		protected function onXmlLoaded(event:Event):void
		{
				// parse the xml into an array
			var _loadedXML:XML = new XML(event.target.data);
			
			var _xmlParser:XmlParserBlit = new XmlParserBlit();
			_blitDataAry = _xmlParser.getArrayFromLoadedXml(_loadedXML);
			
			trace(_blitDataAry);
			
			createBlitSprite();
		
			_stage.addEventListener(Event.ENTER_FRAME, BlitLoop);
		}		
		
		
		protected function onShutdownBtnClick(event:MouseEvent):void
		{
			trace("Shutdown button clicked.");
			for (var g:int = 0; g < _model.blitSpriteAry.length; g++)
			{
				_model.blitSpriteAry[g].stopAndShutdown();
			}			
		}
		
		protected function onStopBtnClick(event:MouseEvent):void
		{
			trace("Stop button clicked.");
			for (var g:int = 0; g < _model.blitSpriteAry.length; g++)
			{
				_model.blitSpriteAry[g].stop();
			}	
			
		}
		
		protected function onStartBtnClick(event:MouseEvent):void
		{
			trace("Start button clicked.");
//			_blitSprite.start();
			for (var g:int = 0; g < _model.blitSpriteAry.length; g++)
			{
				_model.blitSpriteAry[g].start();
			}	
			
		}	
		
		
		private function createBlitSprite():void
		{
			for (var j:int = 0; j < _model.configu.SPRITES; j++)
			{
				_blitSprite = new BlitSprite(_spritesheet, _blitDataAry , _stageBitmapData, _stageWidth, _stageHeight);
				_blitSprite.x = 20 + (Math.random()* (_stageWidth - 20) );
				_blitSprite.y = 20 + (Math.random()* (_stageHeight - 20) );
//				_blitSprite.y = _stageHeight - 200;
				
				trace("_blitSprite.x " + _blitSprite.x);
				
				_model.blitSpriteAry.push(_blitSprite);
			}
			
			
			_model.blitSpriteAry[0].givenName = "johnny";
			
			_model.blitSpriteAry[1].x = 100;
			_model.blitSpriteAry[2].x = 200;
			
			
			
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{

			_controller.processKeyPress(event);
			
		}
		
		
		private function onMouseClick(m:MouseEvent):void
		{

			_controller.processMouseClick(m);
		
		}
		
		
		private function keyboardChangeHandler(event:Event):void
		{

			trace("the " + _model.keyDirection + "key")
			
			
		}
		
		
		private function mouseChangeHandler(e:Event):void
		{

			trace(_model.clicks + " clicks");
			
			
		}
		
		
		
	}
}