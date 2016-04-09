package com.trash
{
	import com.assets.Assets;
	import com.controllers.DCController;
	import com.controllers.FPMController;
	import com.controllers.RUSController;
	import com.greensock.easing.Quad;
	import com.helpers.RungeKuttaMover;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	
	public class GameState extends Sprite
	{
		private var _stage:Object;
		private var _model:Object;
		private var _controller:Object;
		private var _configu:Object;
		private var _fpMinesweeperTextureAtlas:TextureAtlas;
		private var _fpMinesweeperTextureAtlas2:TextureAtlas;
		private var _yellowFireworkMc:MovieClip;
		private var _redFireworkMc:MovieClip;
		private var _tempFirework:MovieClip;
		private var _scaleFactor:Number;
		private var _guyMc:MovieClip;
		private var _holdingGuy:Boolean;
		private var _offsetX:Number;
		private var _offsetY:Number;
		private var _rungeKuttaMover:RungeKuttaMover;
		private var _fingerDownPosition:Point = new Point(0,0);
		private var _throwVelocity:Point = new Point(0,0);
		private var _fingerUpPosition:Point = new Point (0,0);
		private var _currentTime:int;
		private var _oldTime:int;
		private var _timeAry:Array;
		private var _fingerPosAry:Array;
		private var _guyPosAry:Array;
		
		
		public function GameState()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			_stage = stage;
		}		
		
		private function init():void
		{
			
			assignVars();
			addListeners();
			
			trace("Main View Initialized.");
			
			startFireworks();
		}
		
		private function startFireworks():void
		{
			trace("doing the fireworks mang");
			_stage.addEventListener(Event.RESIZE, resizeDisplay); 
			
			var quady:starling.display.Quad = new starling.display.Quad(960, 640, 0x33333, true);
			_stage.addChild(quady);
			
			_scaleFactor = Starling.contentScaleFactor
			
			
//			 get the textures frames
			var yellowFireworkFrames:Vector.<Texture> = _fpMinesweeperTextureAtlas.getTextures("yellow_firework");
			var redFireworkFrames:Vector.<Texture> = _fpMinesweeperTextureAtlas.getTextures("red_firework");
			
			
			_yellowFireworkMc = new MovieClip(yellowFireworkFrames, 20);
			_redFireworkMc = new MovieClip(redFireworkFrames, 20);

			_stage.addChild(_redFireworkMc);
			_stage.addChild(_yellowFireworkMc);
			
			_redFireworkMc.x = 440;
			_redFireworkMc.y = 500;
			
			_yellowFireworkMc.x = 0;
			_yellowFireworkMc.y = 300;
			
			Starling.juggler.add(_redFireworkMc);
			Starling.juggler.add(_yellowFireworkMc);
			
			_redFireworkMc.play();
			_yellowFireworkMc.play();
//			
//			for (var i:uint = 0; i < 200; i++)
//			{
//					_tempFirework = new MovieClip(redFireworkFrames, 20);	
//				
//					_stage.addChild(_tempFirework);
//					
//					_tempFirework.x = Math.random()* 640;
//					_tempFirework.y = Math.random()* 960;
//					
//					Starling.juggler.add(_tempFirework);
//					
//					_tempFirework.play();
//					trace("adding temp firework " +i);
//			}
//			
			
			// make walking guy
			var guyFrames:Vector.<Texture> = _fpMinesweeperTextureAtlas2.getTextures("guy_walking_brime/GuyWalking");
			//			
			//			
			_guyMc = new MovieClip(guyFrames, 4);
			
			_stage.addChild(_guyMc);
						
			_guyMc.x = 0;
//			_guyMc.y = 800;
			_guyMc.y = 400;
			
			Starling.juggler.add(_guyMc);
							
			_guyMc.play();
			
			_guyMc.pivotX = 0;
			_guyMc.pivotY = _guyMc.height;
			
			_guyMc.addEventListener(TouchEvent.TOUCH, onTouchEvent);
			
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}		
		
		private function onTouchEvent(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.target as DisplayObject);
			
			if (touch)
			{
				
//				var _guyPos:Point = touch.getLocation(_guyMc as DisplayObject);
				
				//			var globalPos = _holdingGuy.parent.localToGlobal
				var _fingerPos:Point = touch.getLocation(_stage as DisplayObject) as Point;
				
//				trace(_fingerPos.x, 
				
				switch(touch.phase){
					case "ended":
						trace("end position" + _guyMc);
						
						_holdingGuy = false;
						
						_fingerUpPosition.x = _fingerPos.x 
						_fingerUpPosition.y = _fingerPos.y
						
						
						_throwVelocity.x = Math.abs(_guyPosAry[(_guyPosAry.length -2)].x - _guyMc.x)*2;
						_throwVelocity.y = (_guyPosAry[(_guyPosAry.length - 2)].y - _guyMc.y)*2;
										
						if (_guyMc.x < _guyPosAry[(_guyPosAry.length - 2)].x)
						{
							_throwVelocity.x = -1 * _throwVelocity.x
						}
						
						if (_guyMc.y < _guyPosAry[(_guyPosAry.length - 2)].y)
						{
							_throwVelocity.y = -1 * _throwVelocity.y
						}
						
						
						trace("_fingerDownPosition.x " + _guyPosAry[(_guyPosAry.length -1)].x + " _fingerUpPosition.x " + _guyMc.x )
						trace("_fingerDownPosition.y " + _guyPosAry[(_guyPosAry.length - 1)].y + " _fingerUpPosition.y " + _guyMc.y )
						trace("_throwVelocity: " + _throwVelocity.x + " " + _throwVelocity.y)
						_stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
						_rungeKuttaMover.moveGuy(_guyMc, _throwVelocity);
						
						for (var j:uint = 0; j < _guyPosAry.length; j++)
						{
							trace("ary element x: " + j + " is " + _guyPosAry[(j)].x)
							
						}
						break;
					case "began":
						_offsetX = (_fingerPos.x - _guyMc.x);
						_offsetY = (_fingerPos.y - _guyMc.y);
						
						_currentTime = getTimer();
						
						_oldTime = _currentTime;
						
						_guyPosAry = [];
					
						
						_holdingGuy = true;
						break;
					case "moved":
						trace("down position x: " + _fingerPos.x)
						
						_fingerDownPosition.x = _fingerPos.x;
						_fingerDownPosition.y = _fingerPos.y;
						
						trace("touch beganX: finger x: " + _fingerPos.x + " _guy: " + _guyMc.x + " offset: " + _offsetX);
						trace("touch beganX: finger y: " + _fingerPos.y + " _guy: " + _guyMc.y + " offset: " + _offsetY);
						trace("guyrealx " + _guyMc.x + "y: " + _guyMc.y);
//											_guyMc.x = _fingerPos.x;
//											_guyMc.y = _fingerPos.y;
						_guyMc.x = _fingerPos.x - _offsetX;
						_guyMc.y = _fingerPos.y - _offsetY;
						trace("moved guy x pos to: " + _guyMc.x + "and finger.x:" + _fingerPos.x);
						trace("moved guy y pos to: " + _guyMc.y + "and finger.y:" + _fingerPos.y);

						_currentTime = getTimer();

						if (_currentTime - _oldTime > 20)
						{
							var _guyPos:Point = new Point(_guyMc.x, _guyMc.y);
							_guyPosAry.push(_guyPos)
								_oldTime = _currentTime;
						}
					break;
					
					default:
						break;		
				}
			}
			
		}		
		
		private function onEnterFrame():void
		{
//			trace("_guyMC.x: " + _guyMc.x);
			if (_holdingGuy == false)
			{
				_guyMc.x += 1;
				
			}
			
			if (_guyMc.x > 960)
			{
				_guyMc.x = 0;
			}
			
		}		
		
		private function resizeDisplay(event:Event):void 
		{ 
			
			
			trace("resizing display");
			var swfWidth:int = _stage.stageWidth; 
			var swfHeight:int = _stage.stageHeight; 
			
			var quad2:starling.display.Quad = new starling.display.Quad(_stage.stageWidth, _stage.stageHeight);
			_stage.addChild(quad2);
			
			//			// Resize the main content area 
			//			var newContentHeight:Number = swfHeight - controlBar.height; 
			//			mainContent.height = newContentHeight; 
			//			mainContent.scaleX = mainContent.scaleY; 
			//			
			//			// Reposition the control bar. 
			//			controlBar.y = newContentHeight; 
			//		}
			//			assignVars();
			//			
			//			_startSound = new Chime;
			//			_startSound.play();
			//
			//			trace("Main View Initialized.");
		}
		
		
		
		private function assignVars():void
		{
			_configu = _model.configu;
			
			
			// create the texture atlas(es) and save into a model variable			
			var fpAtlas1Bitmap:Bitmap = new Assets.FpMineSweeperAtlas_1SS;
			var fpAtlasTexture:starling.textures.Texture = Texture.fromBitmap(fpAtlas1Bitmap);
			var fpAtlas1Xml:XML = XML(new Assets.FpMineSweeperAtlas_1Xml);
			
			_fpMinesweeperTextureAtlas = new TextureAtlas(fpAtlasTexture, fpAtlas1Xml);
//			_model.fpMinesweeperTextureAtlas = _fpMinesweeperTextureAtlas;
			
			var fpAtlas2Bitmap:Bitmap = new Assets.FpMineSweeperAtlas_2SS;
			var fpAtlas2Texture:starling.textures.Texture = Texture.fromBitmap(fpAtlas2Bitmap);
			var fpAtlas2Xml:XML = XML(new Assets.FpMineSweeperAtlas_2Xml);
			
			_fpMinesweeperTextureAtlas2 = new TextureAtlas(fpAtlas2Texture, fpAtlas2Xml);
//			_model.fpMinesweeperTextureAtlas2 = _fpMinesweeperTextureAtlas2;
			
			_rungeKuttaMover = new RungeKuttaMover(_stage, this)
			
		}
		
		
		private function addListeners():void
		{
			
		}
		
		
		private function addedToStageHandler(event:Event):void
		{
			trace("Main view added to stage.");
		}
		
		
		// how I am passing variables from Main class to a new Starling
		public function passVars(model:Object, controller:DCController):void
		{
			_model = model;
			_controller = controller;
			_configu = _model.configu;
			
			init();
		}
		
		
		
		public function putInListener():void
		{
			_guyMc.addEventListener(TouchEvent.TOUCH, onTouchEvent);
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		
		
	}
}