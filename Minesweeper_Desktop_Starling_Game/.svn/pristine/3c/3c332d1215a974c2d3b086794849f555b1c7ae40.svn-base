package com.views.screens
{
	import com.greensock.TweenMax;
	import feathers.controls.Button;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	
	public class HowToPlayPopup extends Sprite
	{
		private var _model:Object;
		private var _stage:Object;
		private var _helpPopupBgTexture:Texture;
		private var _helpPopupBg:Image;
		private var _startBtn:Button;
		private var _xBtnDownTexture:Texture;
		private var _backBtnDownTexture:Texture;
		private var _backBtnUpTexture:Texture;
		private var _overlay:Quad;
		private var _helpPopupBgImage:Image;
		private var _helpBtn:Sprite;
		private var _helpPopup:Sprite;
		private var _backBtn:Button;
		private var _addedAlready:Boolean = false;
		private var helpSound:Help;
		
		
		public function HowToPlayPopup(model:Object, stage:Object)
		{
			_model = model;
			_stage = stage;
			
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
			_backBtn.x = 270;
			_backBtn.y = 330;
		}		
		
		
		private function assignVars():void
		{
			_helpPopupBgTexture = _model.fpMinesweeperTextureAtlas.getTexture("HowToPlayPanel");
			_helpPopupBgImage = new Image(_helpPopupBgTexture);
			_helpPopup = new Sprite();
			_helpPopup.addChild(_helpPopupBgImage);
			
			_backBtnUpTexture = _model.fpMinesweeperTextureAtlas.getTexture("BackHelpUpBtn");
			_backBtnDownTexture = _model.fpMinesweeperTextureAtlas.getTexture("BackHelpDownBtn");
			_backBtn = new Button;
			_backBtn.useHandCursor = true;
			_backBtn.defaultSkin = new Image(_backBtnUpTexture);
			_backBtn.downSkin = new Image(_backBtnDownTexture);
			
			_overlay = new Quad(800, 600, 0);
			_overlay.alpha = 0.5;
			
			helpSound = new Help; 
			
		}
		
		
		private function addListeners():void
		{
			_backBtn.addEventListener(Event.TRIGGERED, onBackBtnTriggered);
		}
		
		
		private function onBackBtnTriggered(e:Event):void
		{
			TweenMax.to(_helpPopup, .2, {y:-500, onComplete:onPopupTweenOutComplete}); 
			helpSound.play();
		}
		
		
		private function onPopupTweenOutComplete():void
		{
			_overlay.visible = false;
			_helpPopup.visible = false;
		}
		
		
		public function setUpSelf():void
		{
			if (_addedAlready == false)
			{
				_addedAlready = true;
				_stage.addChild(_overlay);
				_stage.addChild(_helpPopup);
				_helpPopup.addChild(_backBtn);
				
				_helpPopup.x = 200;
				_helpPopup.y = -800;
				
			}
			
			_overlay.visible = true;
			_helpPopup.visible = true;
			
			TweenMax.to(_helpPopup, .2, {y:100}); 
		}
		
		
		
		
	}
}