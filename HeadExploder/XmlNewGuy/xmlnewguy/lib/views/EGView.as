package views 
{

	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import blit_utils.BlitSprite;
	import blit_utils.PerformanceProfiler;
	import blit_utils.XmlParserBlit;
	
	import externaltween.FGtween;
	import externaltween.easing.Back;
	
	
	public class EGView extends Sprite
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
//		private var _stopAndShutDownBtn:SimpleButton;
//		private var _stopBtn:SimpleButton;
//		private var _startBtn:SimpleButton;
		private var _fps:int;
		private var _previousTime:int = 0;
		private var _maxTF:TextField;
		private var _minTF:TextField;
		private var _minFps:int = 100;
		private var _maxFps:int;
		private var _mem:Number;
		private var _count:int;
//		private var _loopOffBtn:SimpleButton;
		private var _loopOnBtn:SimpleButton;
		private var _stageHeight:uint;
		private var _stageWidth:uint;
		private var _guy:Sprite;
		private var _guyHead:Sprite;
		private var _explosionAreaRect:Sprite;
		private var _explodeBtn:SimpleButton;
		private var _head:MovieClip;
		private var _fakeExplodeBtn:Sprite;
		private var _timeTF:TextField;
		private var _time:uint;
		private var _growTimer:Timer;
		private var _brainsTF:TextField;
		private var _thisBrainAmount:uint;
		private var _mainMenu:Sprite;
		private var _beginMenuTimer:Object;
		private var _shopBtn:SimpleButton;
		private var _missionsBtn:SimpleButton;
		private var _settingsBtn:SimpleButton;
		private var _helpBtn:SimpleButton;
		private var _coinsTF:TextField;
		private var _menuBtn:SimpleButton;
		private var _xBtn:SimpleButton;
		private var _okPopup:Sprite;
		private var _howToPlayPopup:MovieClip;
		private var _missionsPopup:MovieClip;
		private var _shopPopup:MovieClip;
		private var _settingsPopup:MovieClip;
		private var _body:MovieClip;
		private var _buyBtn:SimpleButton;
		private var _buyGirlBtn:SimpleButton;
		private var _boughtGirlPopup:Sprite;
		private var _notEnoughBrainsPopup:MovieClip;
		private var _startBtn:SimpleButton;
		private var _changeCharPopup:Sprite;
		private var _girlSettingsBtn:SimpleButton;
		private var _guySettingsBtn:SimpleButton;
		private var _dontOwnGirlPopup:*;
		
		
		public function EGView(model:Object, controller:Object, stage:Object, guy:Sprite)
		{

			_model = model;			
			_controller = controller;
			_stage = stage;
			_guy = guy;
			
			trace("go ahead");
			init();
			
		}
		
		
		private function init():void
		{
			
			assignVars();
			addListeners();
			
			trace("HeadExploder View Initialized.");
			
				// add performance panel to the stage;
			_stage.addChild(_panel);
//	/**
			_panel["profiler"].visible = false;	
//	 **/		
			_panel.x = 250.5;
			_panel.y = 138.3;
			
				// load the xml
			_xmlDataAry = []
			
			_xmlPath = "https://s3.amazonaws.com/xmlFiles/first/explosion_guy.xml";
			
			_testXml = new XML();
			_testXmlRequest = new URLRequest(_xmlPath);
			_testXmlLoader = new URLLoader();
			
			_testXmlLoader.addEventListener(Event.COMPLETE, onXmlLoaded);
			_testXmlLoader.load(_testXmlRequest);
			
			_explosionAreaRect.visible = false;
			
			
//			/**
			 // hide the panel buttons
//			_startBtn.visible = false;
//			_stopBtn.visible = false;
//			_stopAndShutDownBtn.visible = false;
			
//			**/
			
			
				// if you want a timer to begin on startup here it is
//			beginMenuTimer();
//			_beginMenuTimer = new Timer(1000, 3);   // every second, forever
//			
//			_beginMenuTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onbeginMenuTimerComplete);
//			
//			
//			_beginMenuTimer.start();
			
			if (_model.headExplodeSharedObject.data.brains > 0)
			{
				_brainsTF.text = _model.headExplodeSharedObject.data.brains;
				_model.brains = _model.headExplodeSharedObject.data.brains	
			}
			
		}
		
		
		private function onbeginMenuTimerComplete(e:TimerEvent):void
		{
			trace("timer up");
			FGtween.to(_mainMenu, 2, {y:259.7, ease:Back.easeOut, onComplete:onbeginMenuTweenInFinished});
			
		}
		
		private function onbeginMenuTweenInFinished():void
		{
			
			
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
			
			var panelClass:Class = getDefinitionByName("Panel") as Class;
			_panel = new panelClass() as Sprite;
			
			var explodeBtnClass:Class = getDefinitionByName("ExplodeBtn") as Class;
			_explodeBtn = new explodeBtnClass() as SimpleButton;
			
			var fakeExplodeBtnClass:Class = getDefinitionByName("FakeExplodeBtn") as Class;
			_fakeExplodeBtn = new fakeExplodeBtnClass() as Sprite;
			
			var mainMenuClass:Class = getDefinitionByName("MainMenu") as Class;
			_mainMenu = new mainMenuClass() as Sprite;
			
			var yesNoPopupClass:Class = getDefinitionByName("helpers.YesNoPopup") as Class;
			_boughtGirlPopup = new yesNoPopupClass(_model, _stage) as Sprite;
			_changeCharPopup = new yesNoPopupClass(_model, _stage) as Sprite;
			
			var okPopupClass:Class = getDefinitionByName("helpers.OkPopup") as Class;
			_okPopup = new okPopupClass(_model, _stage) as Sprite;
			_notEnoughBrainsPopup = new okPopupClass(_model, _stage) as MovieClip;
			_dontOwnGirlPopup = new okPopupClass(_model, _stage) as MovieClip;
			
			_howToPlayPopup = new okPopupClass(_model, _stage) as MovieClip;
			_missionsPopup = new okPopupClass(_model, _stage) as MovieClip;
			_shopPopup = new okPopupClass(_model, _stage) as MovieClip;
			_settingsPopup = new okPopupClass(_model, _stage) as MovieClip;
			
			 
				// main menu
			_stage.addChild(_mainMenu)
			_mainMenu.x = 169.6
			_mainMenu.y = _stage.stageHeight + 50;
			
			_startBtn = _mainMenu["startBtn"];
			_shopBtn = _mainMenu["shopBtn"];
			_missionsBtn = _mainMenu["missionsBtn"];
			_settingsBtn = _mainMenu["settingsBtn"];
			_helpBtn = _mainMenu["helpBtn"];
			
			_xBtn = _mainMenu["xBtn"];
			
			
				// how to play popup
			_stage.addChild(_howToPlayPopup);
			_howToPlayPopup.x = 64;
			_howToPlayPopup.y = -1 * (_howToPlayPopup.height + 50);
			_howToPlayPopup.gotoAndPlay("howToPlay");
			
				// missions popup
			_stage.addChild(_missionsPopup);
			_missionsPopup.x = 64;
			_missionsPopup.y = -1 * (_missionsPopup.height + 50);
			_missionsPopup.gotoAndPlay("missions");
			
				// shop popup
			_stage.addChild(_shopPopup);
			_shopPopup.x = 64;
			_shopPopup.y = -1 * (_shopPopup.height + 50);
			_shopPopup.gotoAndPlay("shop");
			_buyGirlBtn = _shopPopup["buyGirlBtn"];
		
				// settings popup
			_stage.addChild(_settingsPopup);
			_settingsPopup.x = 64;
			_settingsPopup.y = -1 * (_settingsPopup.height + 50);
			_settingsPopup.gotoAndPlay("settings");
			_guySettingsBtn = _settingsPopup["guyBtn"];
			_girlSettingsBtn = _settingsPopup["girlBtn"];
			
				// not enough brains popup
			_stage.addChild(_notEnoughBrainsPopup);
			_notEnoughBrainsPopup.x = 64;
			_notEnoughBrainsPopup.y = -1 * (_notEnoughBrainsPopup.height + 50);
			_notEnoughBrainsPopup.gotoAndPlay("notEnoughBrains");
			
				// after girl purchased popup
			_stage.addChild(_boughtGirlPopup);
			_boughtGirlPopup.x = 64;
			_boughtGirlPopup.y = -1 * (_boughtGirlPopup.height + 50);
			_boughtGirlPopup["txt"].text = "Congratulations. You bought the girl character! Would you like to begin exploding her head now?";			
			
				// change character popup
			_stage.addChild(_changeCharPopup);
			_changeCharPopup.x = 64;
			_changeCharPopup.y = -1 * (_changeCharPopup.height + 50);
			
				// dont own girl popup
			_stage.addChild(_dontOwnGirlPopup);
			_dontOwnGirlPopup.x = 64;
			_dontOwnGirlPopup.y = -1 * (_dontOwnGirlPopup.height + 50);
			_dontOwnGirlPopup["titleTxt"].text = "Whoops";
			_dontOwnGirlPopup["bodyTxt"].text = "Sorry. You don't own the girl yet. Buy her with brains in the shop!";
			
			
			_stage.addChild(_explodeBtn);
			_explodeBtn.x = 200;
			_explodeBtn.y = _stageHeight - 200;
			
			_stage.addChild(_fakeExplodeBtn);
			_fakeExplodeBtn.x = _explodeBtn.x;
			_fakeExplodeBtn.y = _explodeBtn.y;
			_fakeExplodeBtn.visible = false;
			
			
			_explosionAreaRect = _guy["exAreaRect"];
			
			_body = _guy["body"];
			_head = _guy["head"];
			_timeTF = _guy["time"];
			_timeTF.visible = false;
			_brainsTF = _panel["brainsTxt"];
			
			
			_fpsTF = _panel["fpsTxt"];
			_memTF = _panel["memTxt"];
			_minTF = _panel["minFpsTxt"];
			_maxTF = _panel["maxFpsTxt"];
			_coinsTF = _panel["coinsTxt"];
			
			_menuBtn = _panel["menuBtn"];
			
//			_startBtn = _panel["startBtn"];
//			_stopBtn = _panel["stopBtn"];
//			_stopAndShutDownBtn = _panel["stopAndShutdownBtn"];
			
			_loopOnBtn = _panel["loopOnBtn"];
//			_loopOffBtn = _panel["loopOffBtn"];
			
//			_loopOffBtn.visible = false;
			
			
			_growTimer = new Timer(1000, 0);   // every second, forever
			
		}
		
		
		private function addListeners():void
		{
			
			_model.addEventListener(_configu.KEYBOARD_CHANGE, keyboardChangeHandler);
			_model.addEventListener(_configu.MOUSE_CLICK_CHANGE, mouseChangeHandler);
			_stage.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			
			_explodeBtn.addEventListener(MouseEvent.CLICK, onExplodeBtnClick);
//			_startBtn.addEventListener(MouseEvent.CLICK, onStartBtnClick);
//			_stopBtn.addEventListener(MouseEvent.CLICK, onStopBtnClick);
//			_stopAndShutDownBtn.addEventListener(MouseEvent.CLICK, onShutdownBtnClick);
//			_loopOnBtn.addEventListener(MouseEvent.CLICK, onLoopBtnClick);
//			_loopOffBtn.addEventListener(MouseEvent.CLICK, onLoopBtnClick);
			
			_menuBtn.addEventListener(MouseEvent.CLICK, onMenuBtnClick);
			
			
				// add listeners for main menu buttons
			_shopBtn.addEventListener(MouseEvent.CLICK, onShopBtnClick);
			_missionsBtn.addEventListener(MouseEvent.CLICK, onMissionsBtnClick);
			_settingsBtn.addEventListener(MouseEvent.CLICK, onSettingsBtnClick);
			_helpBtn.addEventListener(MouseEvent.CLICK, onHelpBtnClick);
			
			_xBtn.addEventListener(MouseEvent.CLICK, onXBtnClick);
			_startBtn.addEventListener(MouseEvent.CLICK, onStartBtnClick);

			_buyGirlBtn.addEventListener(MouseEvent.CLICK, onBuyGirlBtnClick);
			
			_guySettingsBtn.addEventListener(MouseEvent.CLICK, onGuyBtnClick);
			_girlSettingsBtn.addEventListener(MouseEvent.CLICK, onGirlBtnClick);
			
			_model.addEventListener(_model.configu.CHARACTER_CHANGE, onCharacterChange);
			_model.addEventListener(_model.configu.BRAINS_CHANGE, onBrainsChange);
			_boughtGirlPopup["yesBtn"].addEventListener(MouseEvent.CLICK, onBoughtGirlYesBtnClicked);
				
		}
		
		protected function onGirlBtnClick(event:MouseEvent):void
		{
			trace("girl button clicked");
			
			if (_model.girlOwned == true)
			{
//				_head.gotoAndPlay(_model.character);
//				_body.gotoAndPlay(_model.character);
				trace("girl owned is true");
				_model.character = "girl";
			}
			
			else
			{
				trace("foing else");
				FGtween.to(_dontOwnGirlPopup, 0.8, {y:243, ease:Back.easeOut, onComplete:onbeginMenuTweenInFinished});
			}
//			_head.gotoAndPlay("girl");
//			_body.gotoAndPlay("girl");
		}
		
		protected function onGuyBtnClick(event:MouseEvent):void
		{
//			trace("guy button clicked");
//			_head.gotoAndPlay("guy");
//			_body.gotoAndPlay("guy");
			_model.character = "guy";
			
		}		
		
		protected function onBoughtGirlYesBtnClicked(event:MouseEvent):void
		{
			trace("true");
			_model.character = "girl";
			
			FGtween.to(_boughtGirlPopup, 0.8, {y:(-1 * (_boughtGirlPopup.height + 50)), ease:Back.easeIn});
			
		}		
		
		private function onCharacterChange(e:Event):void
		{
			
			var person:String = _model.character;
//			_head.gotoAndPlay("girl");
//			_body.gotoAndPlay(_model.character);
//			trace("_model.character on char change " + _model.character);
			trace("changing character to " + person);
			_head.gotoAndPlay(person);
			_body.gotoAndPlay(person);			
		}
		
		private function onBrainsChange(e:Event):void
		{
			_brainsTF.text = _model.brains;
			trace("updating brains tf");
		}
		
		
		protected function onBuyGirlBtnClick(event:MouseEvent):void
		{
			trace("model.brains " + _model.brains);
			
			if (_model.brains >= _model.configu.GIRL_COST)
			{
				_model.brains = _model.brains - _model.configu.GIRL_COST;
				_model.girlOwned = true;
				FGtween.to(_boughtGirlPopup, 0.8, {y:243, ease:Back.easeOut, onComplete:onbeginMenuTweenInFinished});
			}
			
			else
			{
				FGtween.to(_notEnoughBrainsPopup, 0.8, {y:243, ease:Back.easeOut, onComplete:onbeginMenuTweenInFinished});
			}
			
		}		
		
		protected function onShopBtnClick(event:MouseEvent):void
		{
			FGtween.to(_shopPopup, 0.8, {y:243, ease:Back.easeOut, onComplete:onbeginMenuTweenInFinished});
		}
		
		
		protected function onHelpBtnClick(event:MouseEvent):void
		{
			FGtween.to(_howToPlayPopup, 0.8, {y:243, ease:Back.easeOut, onComplete:onbeginMenuTweenInFinished});
		}
		
		
		protected function onSettingsBtnClick(event:MouseEvent):void
		{
			FGtween.to(_settingsPopup, 0.8, {y:243, ease:Back.easeOut, onComplete:onbeginMenuTweenInFinished});
		}
		
		
		protected function onMissionsBtnClick(event:MouseEvent):void
		{
			FGtween.to(_missionsPopup, 0.8, {y:243, ease:Back.easeOut, onComplete:onbeginMenuTweenInFinished});
		}
		
		
		protected function onXBtnClick(event:MouseEvent):void
		{
			FGtween.to(_mainMenu, 0.8, {y:(_stage.stageHeight + 50), ease:Back.easeIn, onComplete:onbeginMenuTweenInFinished});
			
		}
		
		protected function onStartBtnClick(event:MouseEvent):void
		{
			FGtween.to(_mainMenu, 0.8, {y:(_stage.stageHeight + 50), ease:Back.easeIn, onComplete:onbeginMenuTweenInFinished});
			
		}
		
		protected function onMenuBtnClick(event:MouseEvent):void
		{
			FGtween.to(_mainMenu, 0.8, {y:259.7, ease:Back.easeOut, onComplete:onbeginMenuTweenInFinished});
		}
		
		private function onGrowTimer (e:TimerEvent):void
		{
			if (_time > 0)
			{
				_time --;
				_timeTF.text = "" + _time;
			}
			
			else
			{
				trace("done");
			}
		}
		
		
		protected function onLoopBtnClick(event:MouseEvent):void
		{
			
			if (_blitSprite.loop == false)
			{
				for (var g:int = 0; g < _model.blitSpriteAry.length; g++)
				{
					_model.blitSpriteAry[g].loop = true;
				}
				
//				_loopOffBtn.visible = true;
				_loopOnBtn.visible = false;
			}
			
			
			else
			{
				for (var m:int = 0; m < _model.blitSpriteAry.length; m++)
				{
					_model.blitSpriteAry[m].loop = false;
				}

//				_loopOffBtn.visible = false;
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
	/**		_fps = PerformanceProfiler.i.fps
			_mem = Math.round(PerformanceProfiler.i.memory)
			_fpsTF.text = "FPS: " + _fps;
			_memTF.text = "MEM: " + _mem + " MB";
	**/		
			
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
		
//		protected function onStartBtnClick(event:MouseEvent):void
//		{
//			trace("Start button clicked.");
////			_blitSprite.start();
//			for (var g:int = 0; g < _model.blitSpriteAry.length; g++)
//			{
//				_model.blitSpriteAry[g].start();
//			}	
//			
//		}	
		
		
		protected function onExplodeBtnClick(event:MouseEvent):void
		{
			trace("Start button clicked.");
//			_blitSprite.start();
			for (var g:int = 0; g < _model.blitSpriteAry.length; g++)
			{
				_model.blitSpriteAry[g].start();
			}	
			
			_thisBrainAmount = 100 + Math.random() * 200;
			
			_model.brains = _model.brains + _thisBrainAmount;
			_brainsTF.text = "" + _model.brains;
			
			_explodeBtn.visible = false;
			_fakeExplodeBtn.visible = true;
			
			FGtween.to(_head, 1, {scaleX:0.02, scaleY:0.02, onComplete:onHeadDoneShrinking});
			_timeTF.visible = true;
			
			_time = (_model.configu.GROW_TIME + 1)
			
			_timeTF.text = "" + _time;
			_growTimer.start();
			
		}	
		
		
		private function onHeadDoneShrinking():void
		{
			_head.x = 132;
			_head.y = 195;
			FGtween.to(_head, _model.configu.GROW_TIME, {y: -10, x:70, scaleX:1, scaleY:1, onComplete:onHeadDoneGrowing});
			_growTimer.addEventListener(TimerEvent.TIMER, onGrowTimer);
			_growTimer.start();
		
		}
		
		private function onHeadDoneGrowing():void
		{
			_explodeBtn.addEventListener(MouseEvent.CLICK, onExplodeBtnClick);
			_explodeBtn.visible = true;
			_fakeExplodeBtn.visible = false;
			
			_growTimer.removeEventListener(TimerEvent.TIMER, onGrowTimer);
			_growTimer.stop();
			_timeTF.visible = false;
			
		}
		
		
		private function createBlitSprite():void
		{
			for (var j:int = 0; j < _model.configu.SPRITES; j++)
			{
				_blitSprite = new BlitSprite(_spritesheet, _blitDataAry , _stageBitmapData, _stageWidth, _stageHeight);
				_blitSprite.x = _explosionAreaRect.x + (Math.random() * _explosionAreaRect.width );
				_blitSprite.y = _explosionAreaRect.y + (Math.random() * _explosionAreaRect.height );
//				_blitSprite.y = _stageHeight - 200;
				
				trace("_blitSprite.x " + _blitSprite.x);
				
				_model.blitSpriteAry.push(_blitSprite);
			}
			
			
			_model.blitSpriteAry[0].givenName = "johnny";
			
//			_model.blitSpriteAry[0].x = 320;
//			_model.blitSpriteAry[0].y = 300;
			
//			_model.blitSpriteAry[1].x = 100;
//			_model.blitSpriteAry[2].x = 200;
			
			
			
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