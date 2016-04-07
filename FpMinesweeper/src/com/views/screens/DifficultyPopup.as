package com.views.screens
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	
	import flash.geom.Point;
	
	import feathers.controls.Button;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class DifficultyPopup extends Sprite
	{
		private var _model:Object;
		private var _stage:Object;
		private var _difficultyPopupBgTexture:Texture;
		private var _difficultyPopupImage:Image;
		private var _difficultyPopup:Sprite;
		private var _easyBtnUpTexture:Texture;
		private var _easyBtnDownTexture:Texture;
		private var _easyBtn:Button;
		private var _mediumBtnUpTexture:Texture;
		private var _mediumBtnDownTexture:Texture;
		private var _mediumBtn:Button;
		private var _hardBtnUpTexture:Texture;
		private var _hardBtn:Button;
		private var _overlay:Quad;
		private var _hardBtnDownTexture:Texture;
		private var _addedAlready:Boolean;
		private var _gameScreen:GameScreen;
		private var _xBtnUpTexture:Texture;
		private var _xBtnDownTexture:Texture;
		private var _xBtn:Button;
		private var _popupStartPos:Point = new Point(-150, -500);
		private var _flyInSound:DifficultyFlyIn;
		private var _difficultyChoiceSound:DifficultyChoice;
		
		
		public function DifficultyPopup(model:Object, stage:Object, gameScreen:GameScreen)
		{
			_model = model;
			_stage = stage;
			_gameScreen = gameScreen;
		
			init();
		}
		
		
		private function init():void
		{
			assignVars();
			addListeners();
			buildScreen();
		}	
		
		
		private function assignVars():void
		{
			_difficultyPopupBgTexture = _model.fpMinesweeperTextureAtlas.getTexture("DifficultyPanel");
			_difficultyPopupImage = new Image(_difficultyPopupBgTexture);
			_difficultyPopup = new Sprite();
			_difficultyPopup.addChild(_difficultyPopupImage);
			_easyBtnUpTexture = _model.fpMinesweeperTextureAtlas.getTexture("EasyBtnUp");
			_easyBtnDownTexture = _model.fpMinesweeperTextureAtlas.getTexture("EasyBtnUp");
			
			_easyBtn = new Button;
			
			_easyBtn.defaultSkin = new Image(_easyBtnUpTexture);
			_easyBtn.downSkin = new Image(_easyBtnDownTexture);
			_easyBtn.useHandCursor = true;
			
			_mediumBtnUpTexture = _model.fpMinesweeperTextureAtlas.getTexture("MediumBtnUp");
			_mediumBtnDownTexture = _model.fpMinesweeperTextureAtlas.getTexture("MediumBtnUp");
			
			_mediumBtn = new Button;
			
			_mediumBtn.defaultSkin = new Image(_mediumBtnUpTexture);
			_mediumBtn.downSkin = new Image(_mediumBtnDownTexture);
			_mediumBtn.useHandCursor = true;
			
			_hardBtnUpTexture = _model.fpMinesweeperTextureAtlas.getTexture("HardBtnUp");
			_hardBtnDownTexture = _model.fpMinesweeperTextureAtlas.getTexture("HardBtnUp");
			
			_hardBtn = new Button;
			
			_hardBtn.defaultSkin = new Image(_hardBtnUpTexture);
			_hardBtn.downSkin = new Image(_hardBtnDownTexture);
			_hardBtn.useHandCursor = true;
			
			_overlay = new Quad(800, 600, 0);//Black quad
			_overlay.alpha = 0.5;
			
			_xBtnUpTexture = _model.fpMinesweeperTextureAtlas.getTexture("xBtnUp");
			_xBtnDownTexture = _model.fpMinesweeperTextureAtlas.getTexture("xBtnDown");
			_xBtn = new Button;
			
			_xBtn.defaultSkin = new Image(_xBtnUpTexture);
			_xBtn.downSkin = new Image(_xBtnDownTexture);
			_xBtn.useHandCursor = true;
			
			_flyInSound = new DifficultyFlyIn;
			
			_difficultyChoiceSound = new DifficultyChoice;
		}	
		
		
		private function addListeners():void
		{
			_easyBtn.addEventListener(Event.TRIGGERED, onEasyBtnTriggered);
			_mediumBtn.addEventListener(Event.TRIGGERED, onMediumBtnTriggered);
			_hardBtn.addEventListener(Event.TRIGGERED, onHardBtnTriggered);
			_xBtn.addEventListener(Event.TRIGGERED, onXBtnTriggered);
			
		}
		
		
		private function buildScreen():void
		{
			_stage.addChild(_overlay);
			_stage.addChild(_difficultyPopup);

			_overlay.visible = false;
			_difficultyPopup.visible = false;
			
			_xBtn.x = 450;
			_xBtn.y = 340;
			
			_easyBtn.x = 106;
			_easyBtn.y = 90;
			
			_mediumBtn.x = 106;
			_mediumBtn.y = 171;
			
			_hardBtn.x = 106.;
			_hardBtn.y = 281;
		}
		
		
		public function setUpSelf():void
		{
			
			if (_addedAlready == false)
			{
				_addedAlready = true;
				_stage.addChild(_overlay);
				_stage.addChild(_difficultyPopup);
				
				_difficultyPopup.addChild(_easyBtn);
				_difficultyPopup.addChild(_mediumBtn);
				_difficultyPopup.addChild(_hardBtn);
				_difficultyPopup.addChild(_xBtn);
				
			}
			
			_overlay.visible = true;
			_difficultyPopup.visible = true;
			
			_difficultyPopup.x = _popupStartPos.x;
			_difficultyPopup.y = _popupStartPos.y;
			
			TweenMax.to(_difficultyPopup, 3, {bezier:[{x:-200, y:200}, {x:145, y:125}], orientToBezier:false, ease:Bounce.easeOut});
			_flyInSound.play();
		}
		
		
		
		private function onXBtnTriggered():void
		{
			TweenMax.to(_difficultyPopup, 1, {x:900, y:1200, onComplete:onDifficultyPopupTweenedOut});
		}
		
		
		private function onDifficultyPopupTweenedOut():void
		{
			_overlay.visible = false;
			_model.goingBackToStart = true;
			
			setThisPopupToStartPos();
		}
		
		
		
		private function onHardBtnTriggered():void
		{
			trace("hard clicked");
			_model.difficultySelected = _model.configu.HARD;
			_gameScreen.beginNewGame();
			_difficultyPopup.visible = false;
			_overlay.visible = false;
			setThisPopupToStartPos();
			_model.startScreenClose = true;
			_difficultyChoiceSound.play();
		}
		
		
		private function onMediumBtnTriggered():void
		{
			trace("medium clicked");
			_model.difficultySelected = _model.configu.MEDIUM;
			_gameScreen.beginNewGame();
			_difficultyPopup.visible = false;
			_overlay.visible = false;
			setThisPopupToStartPos();
			_model.startScreenClose = true;
			_difficultyChoiceSound.play();
		}
		
		
		private function onEasyBtnTriggered():void
		{
			trace("easy clicked");
			_model.difficultySelected = _model.configu.EASY;
			_gameScreen.beginNewGame();
			_difficultyPopup.visible = false;
			_overlay.visible = false;
			_model.startScreenClose = true;
			setThisPopupToStartPos();
			_model.startScreenClose = true;
			_difficultyChoiceSound.play();
		}
		
		
		private function setThisPopupToStartPos():void
		{
			_difficultyPopup.x = _popupStartPos.x;
			_difficultyPopup.y = _popupStartPos.y;
		}
		
			
		
	}
}