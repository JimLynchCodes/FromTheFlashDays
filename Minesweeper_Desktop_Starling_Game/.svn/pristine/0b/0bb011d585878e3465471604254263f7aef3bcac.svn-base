package com.views.screens
{
	import flash.geom.Point;
	
	import feathers.controls.Button;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	
	public class GameOverPopup extends Sprite
	{
		private var _model:Object;
		private var _gameScreen:GameScreen;
		private var _startScreen:StartScreen;
		private var _stage:Object;
		private var _beginPos:Point;
		private var _popupBgTexture:Texture;
		private var _popupBgImage:Image;
		private var _retryBtnBtnUpTexture:Texture;
		private var _retryBtnnBtnDownTexture:Texture;
		private var _backToMainBtnUpTexture:Texture;
		private var _backToMainBtnDownTexture:Texture;
		private var _backToMainBtn:Button;
		private var _retryBtn:Button;
		
		
		public function GameOverPopup(model:Object, stage:Object, startScreenC:StartScreen, gameScreen:GameScreen)
		{
			_gameScreen = gameScreen;
			_stage = stage;
			_startScreen = startScreenC;
			_model = model;
			
			init();
		}
		
		private function init():void
		{
			assignVars();
			addListeners();
			buildScreen();
			
		}
		
		private function buildScreen():void
		{
			
			_stage.addChild(this);
			this.visible = false;
			this.addChild(_popupBgImage);
			
			this.addChild(_backToMainBtn);
			_backToMainBtn.x = 40;
			_backToMainBtn.y = 280;
			this.addChild(_retryBtn);
			_retryBtn.x = 260;
			_retryBtn.y = 280;
			
			_beginPos = new Point(200,700);
			this.y = _beginPos.y;
			this.x = _beginPos.x;
			
		}
		
		
		private function onRetryBtnTriggered(e:Event):void
		{
			this.visible = false;
			_model.resetGame = true;
			_model.lightOverlay.visible = false;
		}
		
		
		private function onBackToMainBtnTriggered(e:Event):void
		{
			this.visible = false;
			_model.resetGame = true;
			_model.goingBackToStart = true;
			_model.lightOverlay.visible = false;
		}
		
		
		private function onGameLostEvent(e:Event):void
		{
			this.visible = true;
			_model.lightOverlay.visible = true;
			
			this.y = 100;
			
		}
		
		
		private function addListeners():void
		{
			_retryBtn.addEventListener(Event.TRIGGERED, onRetryBtnTriggered);
			_backToMainBtn.addEventListener(Event.TRIGGERED, onBackToMainBtnTriggered);
			
			_model.addEventListener(_model.configu.GAME_LOST, onGameLostEvent);
			
		}
		
		
		private function assignVars():void
		{
			_popupBgTexture = _model.fpMinesweeperTextureAtlas2.getTexture("YouLosePanel");
			_popupBgImage = new Image(_popupBgTexture);
			
			_retryBtnBtnUpTexture = _model.fpMinesweeperTextureAtlas.getTexture("RetryBtnUp");
			_retryBtnnBtnDownTexture = _model.fpMinesweeperTextureAtlas.getTexture("RetryBtnDown");
			
			_backToMainBtnUpTexture = _model.fpMinesweeperTextureAtlas.getTexture("BackToMenuBtnUp");
			_backToMainBtnDownTexture = _model.fpMinesweeperTextureAtlas.getTexture("BackToMenuBtnDown");
			
			_backToMainBtn = new Button;
			_backToMainBtn.defaultSkin = new Image(_backToMainBtnUpTexture);
			_backToMainBtn.downSkin = new Image(_backToMainBtnDownTexture);
			_backToMainBtn.useHandCursor = true;
			
			_retryBtn = new Button;
			_retryBtn.defaultSkin = new Image(_retryBtnBtnUpTexture);
			_retryBtn.downSkin = new Image(_retryBtnnBtnDownTexture);
			_retryBtn.useHandCursor = true;
			
		}		
		
		
		
	}
}