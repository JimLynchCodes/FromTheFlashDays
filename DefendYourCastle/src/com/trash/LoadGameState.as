package com.trash
{
	import com.assets.Assets;
	
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import com.states.IDCState;
	import com.views.DcMainView;
	
	public class LoadGameState extends Sprite implements IDCState
	{
		
		private var _mainView:DcMainView;
		private var _model:Object;
		private var _loadGameSprite:Sprite;
		private var _loadGamePopup:Image;
		
		public function LoadGameState(mainView:DcMainView, model:Object)
		{
			_mainView = mainView;
			_model = model
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			trace("load game state created");
			buildScreen();
		}
		
		
		private function buildScreen():void
		{
			
			_loadGameSprite = new Sprite;
			this.addChild(_loadGameSprite);
			
			_loadGamePopup = new Image(Assets.genericPopup);
			_loadGameSprite.addChild(_loadGamePopup);
			
			
			var game1Btn:Button = new Button();
			game1Btn.defaultSkin = new Image(Assets.greenBtnT);
			game1Btn.label = "Game 1";
			game1Btn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			game1Btn.x = 120
			game1Btn.y = 208
			game1Btn.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_loadGameSprite.addChild(game1Btn);
			game1Btn.addEventListener(starling.events.Event.TRIGGERED, onGame1BtnClicked)
			
			var game2Btn:Button = new Button();
			game2Btn.defaultSkin = new Image(Assets.greenBtnT);
			game2Btn.label = "Game 2";
			game2Btn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			game2Btn.x = 120
			game2Btn.y = 208
			game2Btn.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_loadGameSprite.addChild(game2Btn);
			game2Btn.addEventListener(starling.events.Event.TRIGGERED, onGame1BtnClicked)
			
			var game3Btn:Button = new Button();
			game3Btn.defaultSkin = new Image(Assets.greenBtnT);
			game3Btn.label = "Game 3";
			game3Btn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			game3Btn.x = 120
			game3Btn.y = 208
			game3Btn.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_loadGameSprite.addChild(game3Btn);
			game3Btn.addEventListener(starling.events.Event.TRIGGERED, onGame1BtnClicked)
			
			var quitBtn:Button = new Button();
			quitBtn.defaultSkin = new Image(Assets.greenBtnT);
			quitBtn.label = "Quit";
			quitBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			quitBtn.x = 220
			quitBtn.y = 208
			quitBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_loadGameSprite.addChild(quitBtn);
			quitBtn.addEventListener(starling.events.Event.TRIGGERED, onQuitBtnClicked)
			
			
			
		}
		
		private function onGame1BtnClicked():void
		{
			_mainView.changeState(DcMainView.SHOP_STATE);
			
		}
		
		private function onQuitBtnClicked():void
		{
			_mainView.changeState(DcMainView.MAIN_MENU_STATE);
			
		}
		
		public function update():void
		{
		}
		
		public function destroy():void
		{
		}
	}
}