package com.states
{
	import com.assets.Assets;
	import com.characters.Robot;
	import com.models.GameModel;
	import com.trash.DCViewIos;
	import com.trash.NewViewIos;
	import com.views.DcMainView;
	import com.zf.ui.buttons.loadGameButton.LoadGameButton;
	
	import dragonBones.animation.WorldClock;
	
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class MainMenuState extends Sprite implements IDCState
	{
		private var _mainView:DcMainView;
		private var _model:Object;
		private var _bkgd:Image;
		private var _logo:Button;
		private var newGameBtnT:Button;
		private var _mainMenuSprite:Sprite;
		private var _mainMenuPopup:Image;
		
		public function MainMenuState(mainView:DcMainView, model:Object)
		{
			_mainView = mainView;
			_model = model
				
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			trace("da main been added, sir");
			buildScreen();
			addListeners();
		}
		
		private function addListeners():void
		{
//			_logo.addEventListener(Event.TRIGGERED, onClick);
			
		}
		
//		private function onClick():void
//		{
////			trace("clicked");
////			_mainView.changeState(NewViewIos.PLAY_STATE);
//		}
		
		private function buildScreen():void
		{
			
			_mainMenuSprite = new Sprite;
			this.addChild(_mainMenuSprite);
			
			_mainMenuPopup = new Image(Assets.fullPopupTest);
			_mainMenuSprite.addChild(_mainMenuPopup);
			
			var titleTF:TextField = new TextField(450, 200, "MAIN MENU" , "BasicWhiteFont", 50, 0xFFFFFF);
			titleTF.hAlign = "center";
			titleTF.x = 200;
			titleTF.y = -40;
			_mainMenuSprite.addChild(titleTF);
			
			var startBtn:Button = new Button();
			startBtn.defaultSkin = new Image(Assets.greenBtnT);
			startBtn.label = "Start";
			startBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			startBtn.x = 404
			startBtn.y = 448
			startBtn.labelOffsetX = - 10; 
//			startBtn.name = jsonArray.staff[i].RestId
			_mainMenuSprite.addChild(startBtn);
			startBtn.addEventListener(starling.events.Event.TRIGGERED, onStartBtnClicked)
				
			var creditsBtn:Button = new Button();
			creditsBtn.defaultSkin = new Image(Assets.greenBtnT);
			creditsBtn.label = "Credits";
			creditsBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			creditsBtn.x = 586
			creditsBtn.y = 550
			creditsBtn.labelOffsetX = - 10; 
//			creditsBtn.name = jsonArray.staff[i].RestId
			_mainMenuSprite.addChild(creditsBtn);
			creditsBtn.addEventListener(starling.events.Event.TRIGGERED, onCreditsBtnClicked)
				
//			var settingsBtn:Button = new Button();
//			settingsBtn.defaultSkin = new Image(Assets.greenBtnT);
//			settingsBtn.label = "Settings";
//			settingsBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
//			settingsBtn.x = 320
//			settingsBtn.y = 208
//			settingsBtn.labelOffsetX = - 10; 
////			settingsBtn.name = jsonArray.staff[i].RestId
//			_mainMenuSprite.addChild(settingsBtn);
//			settingsBtn.addEventListener(starling.events.Event.TRIGGERED, onSettingsBtnClicked)
				
			var sfxToggleBtn:Button = new Button();
			sfxToggleBtn.defaultSkin = new Image(Assets.greenBtnT);
			sfxToggleBtn.label = "SfX";
			sfxToggleBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			sfxToggleBtn.x = 250
			sfxToggleBtn.y = 550
			sfxToggleBtn.labelOffsetX = - 10; 
//			sfxToggleBtn.name = jsonArray.staff[i].RestId
			_mainMenuSprite.addChild(sfxToggleBtn);
			sfxToggleBtn.addEventListener(starling.events.Event.TRIGGERED, onSfxToggleBtnClicked)
				
			var musicToggleBtn:Button = new Button();
			musicToggleBtn.defaultSkin = new Image(Assets.greenBtnT);
			musicToggleBtn.label = "BgMusic";
			musicToggleBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			musicToggleBtn.x = 100;
			musicToggleBtn.y = 550
			musicToggleBtn.labelOffsetX = - 10; 
//			musicToggleBtn.name = jsonArray.staff[i].RestId
			_mainMenuSprite.addChild(musicToggleBtn);
			musicToggleBtn.addEventListener(starling.events.Event.TRIGGERED, onMusicToggleBtnClicked)
				
			
			var howToPlayBtn:Button = new Button();
			howToPlayBtn.defaultSkin = new Image(Assets.greenBtnT);
			howToPlayBtn.label = "How To Play";
			howToPlayBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			howToPlayBtn.x = 736
			howToPlayBtn.y = 550;
			howToPlayBtn.labelOffsetX = - 10; 
//			settingsBtn.name = jsonArray.staff[i].RestId
			_mainMenuSprite.addChild(howToPlayBtn);
			howToPlayBtn.addEventListener(starling.events.Event.TRIGGERED, onHowToPlayBtnClicked)
				
			
//			_bkgd = new Image(Assets.bkgdT);
//			stage.addChild(_bkgd);
//			
//			trace(Assets.logoT);
//			_logo = new Button(Assets.logoT);
//			_logo.x = 75;
//			_logo.y = 75;
//			addChild(_logo);
//			
//			trace(Assets.newGameBtnT);
//			newGameBtnT = new Button(Assets.newGameBtnT);
//			newGameBtnT.x = 75;
//			newGameBtnT.y = 75;
//			addChild(newGameBtnT);
//			
//			trace(Assets.number);
//			Assets.number += 4;
//			trace(Assets.number);
//			
//			var robot:Robot = new Robot();
//			addChild(robot);
			
			
//			_game1 = new LoadGameButton('Game 1', 'game1');
//			_game1.x = 50;
//			_game1.y = 450;
//			_game1.onGameSelected.add(_onGameSelected);
//			addChild(_game1);
//			
//			_game2 = new LoadGameButton('Game 2', 'game2');
//			_game2.x = 300;
//			_game2.y = 450;
//			_game2.onGameSelected.add(_onGameSelected);
//			addChild(_game2);
//			
//			_game3 = new LoadGameButton('Game 3', 'game3');
//			_game3.x = 525;
//			_game3.y = 450;
//			_game3.onGameSelected.add(_onGameSelected);
//			addChild(_game3);
			
		}
		
		private function onMusicToggleBtnClicked():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onSfxToggleBtnClicked():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onHowToPlayBtnClicked():void
		{
			_mainView.changeState(DcMainView.HOW_TO_PLAY_STATE);			
		}
		
		private function onStartBtnClicked():void
		{
			_mainView.changeState(DcMainView.LOAD_GAME_STATE);	
			
		}
		
		private function onSettingsBtnClicked():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onCreditsBtnClicked():void
		{
			_mainView.changeState(DcMainView.CREDITS_STATE);	
			
		}
		
		
		public function update():void
		{
			WorldClock.clock.advanceTime(-1);
			
		}
		
		public function destroy():void
		{
			_mainMenuSprite.removeFromParent(true);
//			_logo.removeFromParent(true);
//			_logo = null;
		}
	}
}