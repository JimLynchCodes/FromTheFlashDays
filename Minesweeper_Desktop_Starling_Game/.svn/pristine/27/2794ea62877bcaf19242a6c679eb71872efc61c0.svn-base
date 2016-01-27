package com.views.screens
{
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import feathers.controls.Button;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class YouWinPopup extends Sprite
	{
		private var _model:Object;
		private var _gameScreen:GameScreen;
		private var _startScreen:StartScreen;
		private var _popupBgTexture:Texture;
		private var _stage:Object;
		private var _popupBgImage:Image;
		private var _playAgainBtnUpTexture:Texture;
		private var _playAgainBtnDownTexture:Texture;
		private var _backToMainBtnUpTexture:Texture;
		private var _backToMainBtnDownTexture:Texture;
		private var _backToMainBtn:Button;
		private var _playAgainBtn:Button;
		private var _beginPos:Point;
		private var _gameWonSound:WinSound;
		private var _redFireWorkMc:MovieClip;
		private var _yellowFireWorkMc:MovieClip;
		private var _horrayFireworksSound:HorrayFireworks;
		
		
		public function YouWinPopup(model:Object, stage:Object, startScreen:StartScreen, gameScreen:GameScreen)
		{
			_gameScreen = gameScreen;
			_stage = stage;
			_startScreen = startScreen;
			_model = model;
			
			init();	
		}
		
		
		private function init():void
		{
			assignVars();
			addListeners();
			buildScreen();
			
			_stage.addChild(this);
			
			_beginPos = new Point(200,3000);
			this.y = _beginPos.y;
			this.x = _beginPos.x;
		}
		
		
		private function buildScreen():void
		{
			this.addChild(_popupBgImage);
			
			this.addChild(_backToMainBtn);
			_backToMainBtn.x = 25;
			_backToMainBtn.y = 300;
			this.addChild(_playAgainBtn);
			_playAgainBtn.x = 230;
			_playAgainBtn.y = 300;
		}
		
		
		private function addListeners():void
		{
			_playAgainBtn.addEventListener(Event.TRIGGERED, onPlayAgainBtnTriggered);
			_backToMainBtn.addEventListener(Event.TRIGGERED, onBackToMainBtnTriggered);
			
			_model.addEventListener(_model.configu.GAME_WON, onGameWonEvent);
		}
		
		
		private function onBackToMainBtnTriggered():void
		{
			_model.goingBackToStart = true;
			this.visible = false;
			
			_model.resetGame = true;
			_model.goingBackToStart = true;
			_model.lightOverlay.visible = false;
			
			TweenMax.to(this, 2, {y:-500, onComplete:onPopupFinishedTweeningOut});
		}
		
		
		private function onGameWonEvent(e:Event):void
		{
			this.visible = true;
			TweenMax.to(this, 2, {y:200});
			
			_gameWonSound.play();
			_model.lightOverlay.visible = true;
			
			Starling.juggler.add(_redFireWorkMc);
			Starling.juggler.add(_yellowFireWorkMc);
			
			_redFireWorkMc.play();
			_yellowFireWorkMc.play();
			_yellowFireWorkMc.visible = true;
			_redFireWorkMc.visible = true;
			
			_horrayFireworksSound.play();
		}

		
		private function onPlayAgainBtnTriggered():void
		{
			TweenMax.to(this, 2, {y:-500, onComplete:onPopupFinishedTweeningOut});
			
			_model.lightOverlay.visible = false;
			_model.resetGame = true;
		}
		
		
		private function onPopupFinishedTweeningOut():void
		{
			this.y = _beginPos.y;
			_redFireWorkMc.stop();
			_yellowFireWorkMc.stop();
			
			Starling.juggler.remove(_redFireWorkMc);
			Starling.juggler.remove(_yellowFireWorkMc);
			_redFireWorkMc.visible = false;
			_yellowFireWorkMc.visible = false;
			
		}
		

		private function assignVars():void
		{
			_popupBgTexture = _model.fpMinesweeperTextureAtlas2.getTexture("YouWinPanel");
			_popupBgImage = new Image(_popupBgTexture);
			
			_playAgainBtnUpTexture = _model.fpMinesweeperTextureAtlas.getTexture("PlayAgainBtnUp");
			_playAgainBtnDownTexture = _model.fpMinesweeperTextureAtlas.getTexture("PlayAgainBtnDown");
			
			_backToMainBtnUpTexture = _model.fpMinesweeperTextureAtlas.getTexture("BackToMenuBtnUp");
			_backToMainBtnDownTexture = _model.fpMinesweeperTextureAtlas.getTexture("BackToMenuBtnDown");
			
			_backToMainBtn = new Button;
			_backToMainBtn.defaultSkin = new Image(_backToMainBtnUpTexture);
			_backToMainBtn.downSkin = new Image(_backToMainBtnDownTexture);
			_backToMainBtn.useHandCursor = true;
			
			_playAgainBtn = new Button;
			_playAgainBtn.defaultSkin = new Image(_playAgainBtnUpTexture);
			_playAgainBtn.downSkin = new Image(_playAgainBtnDownTexture);
			_playAgainBtn.useHandCursor = true;
			
			var yellowFireworkFrames:Vector.<Texture> = _model.fpMinesweeperTextureAtlas.getTextures("yellow_firework");
			var redFireworkFrames:Vector.<Texture> = _model.fpMinesweeperTextureAtlas.getTextures("red_firework");
			
			// create a starling movieclip
			_redFireWorkMc = new MovieClip(redFireworkFrames, 15);
			_yellowFireWorkMc = new MovieClip(yellowFireworkFrames, 15);
			
			_stage.addChild(_redFireWorkMc);
			_stage.addChild(_yellowFireWorkMc);

			_redFireWorkMc.visible = false;
			_yellowFireWorkMc.visible = false;
			_redFireWorkMc.x = 440;
			_redFireWorkMc.y = 20;
			_redFireWorkMc.pause();
			
			_yellowFireWorkMc.x = 0;
			_yellowFireWorkMc.y = 300;
			_yellowFireWorkMc.pause();
			
			_horrayFireworksSound = new HorrayFireworks;
			_gameWonSound = new WinSound;
			
		}		
		
		
		
	}
}