package com.states
{
	import com.assets.Assets;
	import com.greensock.TweenLite;
	import com.leebrimelow.starling.StarlingPool1Param;
	import com.managers.EnemyManager;
	import com.models.GameModel;
	import com.models.RUXModel;
	import com.models.SaveModel;
	import com.objects.EnemyGuy;
	import com.objects.LevelDataObj;
	import com.trash.NewViewIos;
	import com.ui.panels.LosePopup;
	import com.ui.panels.PauseScreen;
	import com.ui.panels.WinPopup;
	import com.utils.GuyMover;
	import com.utils.RungeKuttaMover;
	import com.views.DcMainView;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import dragonBones.animation.WorldClock;
	
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class PlayState extends Sprite implements IDCState
	{
		private var _mainView:DcMainView;
		private var _model:Object;
		private var _bg:Image;
		private var _guyMc:MovieClip;
		private var _holdingGuy:Boolean;
		private var _fingerUpPosition:Point = new Point();
		private var _throwVelocity:Point = new Point();
		private var _guyPosAry:Array = [];
		private var _offsetY:Number;
		private var _offsetX:Number;
		private var _currentTime:int;
		private var _oldTime:int;
		private var _fingerDownPosition:Point = new Point();
		private var enemy:EnemyGuy;
		private var _enemyManager:EnemyManager;
		private var _rungeKuttaMover:RungeKuttaMover;
		private var _guyCount:int = 0;
		private var _guySpawnCount:int = 0;
		private var _rungePool:StarlingPool1Param;
		private var _guyMover:GuyMover;
		public static var _killsTF:TextField;
		public static var _healthTF:TextField;
		public static var _timeTF:TextField;
		private var _levelTimer :int;
		private var _secondsGone:int;
		private var _levelTimeLength:int = 100;
		private var _winPopupSprite:WinPopup;
		public static var _manaTF:TextField;
		private var _lostPopupSprite:LosePopup;
		private var powerUp1:Button;
		private var _pauseScreen:PauseScreen;
		
		public function PlayState(mainView:DcMainView, model:Object)
		{
			_mainView = mainView;
			_model = model
			
				trace("shop made");
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			trace("playing the play baby");
			
			
			buildScreen();
			
			buildPopups();
			resetGame();
			
			var level:int = GameModel.levelChosen;
			createLevel(level);
			
			_rungePool = new StarlingPool1Param(RungeKuttaMover, 10, this);
			_guyMover = GuyMover.getInstance();
			
			GameModel.gameOverSig.add(onGameLostEvent);
			GameModel.levelTimeUpSig.add(onLevelTimerUp);
			
			addEventListener(TouchEvent.TOUCH, onStageTouch);
			
			GameModel.levelBeginTime = getTimer();
			
			
		}
		
		private function buildPopups():void
		{
			
			_pauseScreen = new PauseScreen(_mainView);
			addChild(_pauseScreen);
			_pauseScreen.y = -600;
			
		}
		
		private function onStageTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			
			
			
			if (touch)
			{
				switch(touch.phase)
				{
					case "began":
						trace("stage touch began");
						break;
					
					case "ended":
//						trace("stage touch ended");
						var target:* = event.currentTarget;
						
						trace("event.currentTarget " + event.currentTarget);
						trace("event.target " + event.target);
						
						if (event.target == powerUp1)
						{
							trace("you clicked powerup 1!");
						}
						
//						trace("you clicked " + event.currentTarget.name);
						break;
					
					
				}
				
			}
			
			
		}
		
		private function onLevelTimerUp():void
		{
			
			// win or beat the level
			
			_winPopupSprite = new WinPopup(_mainView);
			addChild(_winPopupSprite);
			TweenLite.to(_winPopupSprite, 2, {y:stage.stageHeight * 0.5});
			
			_enemyManager.destroy();
			
			
		}		
		
		private function onGameLostEvent():void
		{
//			_mainView.changeState(DcMainView.GAME_OVER_STATE);
			
			_lostPopupSprite = new LosePopup(_mainView);
			addChild(_lostPopupSprite);
			TweenLite.to(_lostPopupSprite, 2, {y:stage.stageHeight * 0.5});
		
			trace("got the game over event");
			
			
		}
			
		
		
		
		private function createLevel(level:int):void
		{
			
//			var loader:URLLoader = new URLLoader();
//			var request:URLRequest = new URLRequest();
//			request.url = RUXModel.pathForCategorySpecificList;
//			loader.addEventListener(flash.events.Event.COMPLETE, onLoaderComplete);
//			
//			try{
//				loader.load(request);
//			} catch (error:Error) {
//				trace("Cannot load : " + error.message);
//			}
			
			
		}
		
		private function onLevelJsonLoaded():void
		{
			
			// loop through list of enemies in json and 
			// put in GameModel. 
			
			
			
		}
		
		
		
		private function resetGame():void
		{
			GameModel.castleHealth = 1000;
		}		
		
		private function buildScreen():void
		{
			var _velocity:Point = new Point(0,0);
			
//			trace("beginnig the add");
			_bg = new Image(Assets.gameBgT)
			this.addChild(_bg);
//				trace("adding the bg");
				
			var moneyBox:Image = new Image(Assets.moneyBox);
			addChild(moneyBox);
			
				_enemyManager = new EnemyManager(this);
				
				_killsTF = new TextField(250, 200, "SCORE: 0" , "KomikaAxis", 30, 0xFFFFFF);
				_killsTF.hAlign = "center";
				_killsTF.x = -40;
				_killsTF.y = 90;
				addChild(_killsTF);
				
				_healthTF = new TextField(250, 200, "HEALTH:" , "KomikaAxis", 30, 0xFFFFFF);
				_healthTF.hAlign = "center";
				_healthTF.x = 705;
				_healthTF.y = -75;
				_healthTF.text = "HEALTH: " + GameModel.castleHealth;
				addChild(_healthTF);

				_manaTF = new TextField(250, 200, "HEALTH:" , "KomikaAxis", 30, 0xFFFFFF);
				_manaTF.hAlign = "center";
				_manaTF.x = 705;
				_manaTF.y = -20;
				_manaTF.text = "MANA: " + GameModel.mana;
				addChild(_manaTF);
				
				_timeTF = new TextField(250, 200, "TIME:" , "KomikaAxis", 30, 0xFFFFFF);
				_timeTF.hAlign = "center";
				_timeTF.x = 360;
				_timeTF.y = -75;
				GameModel.secondsLeft = _levelTimeLength;
				_timeTF.text = "TIME: " + GameModel.secondsLeft;
				addChild(_timeTF);
				
				
				var pauseBtn:Button = new Button();
				pauseBtn.defaultSkin = new Image(Assets.greenBtnT);
				pauseBtn.label = "PAUSE";
				pauseBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
				pauseBtn.x = 780
				pauseBtn.y = 590
				pauseBtn.labelOffsetX = - 10; 
				//			creditsBtn.name = jsonArray.staff[i].RestId
				addChild(pauseBtn);
				pauseBtn.addEventListener(starling.events.Event.TRIGGERED, onPauseBtnClicked)
					
				powerUp1 = new Button();
				powerUp1.defaultSkin = new Image(Assets.gamePowUpBtn);
				powerUp1.label = "P1";
				powerUp1.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
				powerUp1.x = 650
				powerUp1.y = 110
				powerUp1.name = SaveModel.currentPowerUp1
				powerUp1.labelOffsetX = - 10; 
				//			creditsBtn.name = jsonArray.staff[i].RestId
				addChild(powerUp1);
				powerUp1.addEventListener(starling.events.Event.TRIGGERED, onPowerUpBtnClicked)
					
				var powerUp2:Button = new Button();
				powerUp2.defaultSkin = new Image(Assets.gamePowUpBtn);
				powerUp2.label = "P2";
				powerUp2.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
				powerUp2.x = 740
				powerUp2.y = 110
				powerUp2.labelOffsetX = - 10; 
				//			creditsBtn.name = jsonArray.staff[i].RestId
				addChild(powerUp2);
				powerUp2.addEventListener(starling.events.Event.TRIGGERED, onPowerUpBtnClicked)
//					
				var powerUp3:Button = new Button();
				powerUp3.defaultSkin = new Image(Assets.gamePowUpBtn);
				powerUp3.label = "P3";
				powerUp3.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
				powerUp3.x = 840
				powerUp3.y = 110
				powerUp3.labelOffsetX = - 10; 
				//			creditsBtn.name = jsonArray.staff[i].RestId
				addChild(powerUp3);
				powerUp3.addEventListener(starling.events.Event.TRIGGERED, onPowerUpBtnClicked)
					
				var cancelBtn:Button = new Button();
				cancelBtn.defaultSkin = new Image(Assets.gamePowUpBtn);
				cancelBtn.label = "Cancel";
				cancelBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
				cancelBtn.x = 840
				cancelBtn.y = 225
				cancelBtn.labelOffsetX = - 10; 
				//			creditsBtn.name = jsonArray.staff[i].RestId
				addChild(cancelBtn);
				cancelBtn.addEventListener(starling.events.Event.TRIGGERED, onPowerUpCancelBtnClicked)
					
				
				
		}
		
		private function onPowerUpCancelBtnClicked():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onPowerUpBtnClicked():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onPauseBtnClicked():void
		{
			trace("pause clicked");
			
			TweenLite.to(_pauseScreen, 2, {y:stage.stageHeight * 0.5});
			
			
		}
		
		public function update():void
		{
			
			WorldClock.clock.advanceTime(-1);
			_guyCount++;
			_guySpawnCount++;
			
			_levelTimer ++;
//			trace("_levelTimer" + _levelTimer);
			
				// recover mana / health
			if (_levelTimer % 80 == 0)
			{
				// if the game is not over
				if ( GameModel.secondsLeft > 0 && GameModel.castleHealth > 0)
				{
					// increase mana if the game is not over;
					if (GameModel.mana < 1000) 
					{
						GameModel.mana++;			
					}
					
					
				}
					
			}
			
			var currTime:int = getTimer();
			var timeDiff:int = currTime - GameModel.levelBeginTime;
			
			
			for (var i:int = GameModel.enemyDataAry.length - 1; i >= 0 ; i--)
			{
				
				if (GameModel.enemyDataAry[i].timeSent < (timeDiff))
				{
					trace("guy's time to be sent " + (GameModel.enemyDataAry[i].timeSent));
					trace("sending guy now " + (currTime - GameModel.levelBeginTime));
					
					var tempGuy:LevelDataObj = GameModel.enemyDataAry[i]
					
					_enemyManager.fire(tempGuy);
					GameModel.enemyDataAry.splice(i,1)
				}
				
				
				
				
			}
			
			
				// increase the timer every frame
			if (_levelTimer % 60 == 0)
			{
				
				if (GameModel.secondsLeft > 0)
				{
					GameModel.secondsLeft--;
					_timeTF.text = "TIME: " + GameModel.secondsLeft;
				}
				
			}
			

			if (_enemyManager != null)
			{
				_enemyManager.update();
				
			}
			_guyMover.update();
			
		}
		
		
		public function destroy():void
		{
			_bg.removeFromParent(true);
			_bg = null;
			
			removeChild(_killsTF);
			removeChild(_healthTF);
			
			_killsTF = null;
			_healthTF = null;
//			_rungePool = null;
//			_guyMover = null;
			
			_enemyManager.destroy();
//			_enemyManager = null;
//			_guyMover.destroy();
			
			_timeTF.removeFromParent(true);
			
			_manaTF.removeFromParent(true);
//			this.removeFromParent(true);
			
		}
	}
}