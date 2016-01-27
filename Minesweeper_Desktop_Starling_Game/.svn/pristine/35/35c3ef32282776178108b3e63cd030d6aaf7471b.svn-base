package com.views.screens
{
	
	import feathers.controls.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	
	public class StartScreen extends Sprite
	{
		private var _model:Object;
		private var _startBtnUpTexture:Texture;
		private var _startBtnUp:Image;
		private var _startBtnDownTexture:Texture;
		private var _startBtnDown:Image;
		private var _howToPlayBtnUpTexture:Texture;
		private var _howToPlayBtnDownTexture:Texture;
		private var _startBtn:Button;
		private var _stage:Object;
		private var _startScreenTexture:Texture;
		private var _startScreen:Image;
		private var _helpBtnUp:Texture;
		private var _helpBtnDown:Texture;
		private var _helpBtn:Button;
		private var _howToPlayPopup:HowToPlayPopup;
		private var _difficultyPopup:DifficultyPopup;
		private var _startBtnSpeed:Number = 0.25;
		private var _startDirection:int = 1;
		private var _btnSpeed:Number = 0.25;
		private var _helpBtnDirection:int = -1;
		private var _helpBtnSpeed:Number = 0.25;
		private var _startSound:Chime;
		private var helpSound:Help;
		
		
		public function StartScreen(model:Object, stage:Object, howToPlayPopup:HowToPlayPopup, difficultyPopup:DifficultyPopup)
		{
			_model = model;
			_stage = stage;
			_howToPlayPopup = howToPlayPopup;
			_difficultyPopup = difficultyPopup;

			init();
		}
		
		
		private function init():void
		{
			assignVas();
			addListeners();
			buildScreen();
		}		

		
		public function setUpStartScreen():void
		{
			_startScreen.visible = true;
			_startBtn.visible = true;
			_helpBtn.visible = true;
		}
		
		
		private function buildScreen():void
		{
			_stage.addChild(_startScreen);
			
			_stage.addChild(_startBtn);
			_startBtn.x = 500;
			_startBtn.y = 350;
			
			_stage.addChild(_helpBtn);
			_helpBtn.x = 200;
			_helpBtn.y = 420;
			
		}
		
		
		private function assignVas():void
		{
			_startBtnUpTexture = _model.fpMinesweeperTextureAtlas.getTexture("StartBtnUp");
			_startBtnDownTexture = _model.fpMinesweeperTextureAtlas.getTexture("StartBtnDown");
			
			_howToPlayBtnUpTexture = _model.fpMinesweeperTextureAtlas.getTexture("HelpBtnUp");
			_howToPlayBtnDownTexture = _model.fpMinesweeperTextureAtlas.getTexture("HelpBtnDown");
			
			_model.addEventListener(_model.configu.START_SCREEN_CLOSE, onStartScreenCloseEvent);
				
			_startBtn = new Button;
			_startBtn.defaultSkin = new Image(_startBtnUpTexture);
			_startBtn.downSkin = new Image(_startBtnDownTexture);
			_startBtn.useHandCursor = true;
			
			_helpBtn = new Button;
			_helpBtn.defaultSkin = new Image(_howToPlayBtnUpTexture);
			_helpBtn.downSkin = new Image(_howToPlayBtnDownTexture);
			_helpBtn.useHandCursor = true;

			_startScreenTexture = _model.fpMinesweeperTextureAtlas.getTexture("StartScreen");
			_startScreen = new Image(_startScreenTexture);
			
			helpSound = new Help; 
			
		}
		
		
		private function onStartScreenCloseEvent(e:Event):void
		{
			hideStartScreen();
		}
		
		
		private function addListeners():void
		{
			_helpBtn.addEventListener(Event.TRIGGERED, onHelpBtnTriggered);
			_startBtn.addEventListener(Event.TRIGGERED, onStartBtnTriggered);
			
			_model.addEventListener(_model.configu.BACK_TO_START, onBackToStartEvent);
		}		
		
		
		private function onBackToStartEvent(e:Event):void
		{
			showStartScreen();
		}
		
		
		private function onStartBtnTriggered(e:Event):void
		{
			_difficultyPopup.setUpSelf();
		}
		
		
		private function hideStartScreen():void
		{
			_startScreen.visible = false;
			_startBtn.visible = false;
			_helpBtn.visible = false;
		}
		
		
		private function showStartScreen():void
		{
			_startScreen.visible = true;
			_startBtn.visible = true;
			_helpBtn.visible = true;
		}
		
		
		private function onHelpBtnTriggered(e:Event):void
		{
			_howToPlayPopup.setUpSelf();
			
			helpSound.play();
		}
		
		
		
		
	}
}