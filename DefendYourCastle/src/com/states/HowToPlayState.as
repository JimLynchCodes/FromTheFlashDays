package com.states
{
	import com.assets.Assets;
	import com.views.DcMainView;
	
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class HowToPlayState extends Sprite implements IDCState
	{
		
		private var _mainView:DcMainView;
		private var _model:Object;
		private var _howToPlaySprite:Sprite;
		private var _howToPlayPopup:Image;
		
		public function HowToPlayState(mainView:DcMainView, model:Object)
		{
			_mainView = mainView;
			_model = model
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			trace("da main been added, sir");
			buildScreen();
		}
		
		
		public function update():void
		{
		}
		
		public function destroy():void
		{
			_howToPlaySprite.removeFromParent(true);
			
		}
		
		private function buildScreen():void
		{
			
			_howToPlaySprite = new Sprite;
			this.addChild(_howToPlaySprite);
			
			_howToPlayPopup = new Image(Assets.fullPopupTest);
			_howToPlaySprite.addChild(_howToPlayPopup);
			
			var titleTF:TextField = new TextField(450, 200, "HOW TO PLAY" , "BasicWhiteFont", 50, 0xFFFFFF);
			titleTF.hAlign = "center";
			titleTF.x = 200;
			titleTF.y = -40;
			_howToPlaySprite.addChild(titleTF);
			
			var nextBtn:Button = new Button();
			nextBtn.defaultSkin = new Image(Assets.greenBtnT);
			nextBtn.label = "Next";
			nextBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			nextBtn.x = 706
			nextBtn.y = 409
			nextBtn.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_howToPlaySprite.addChild(nextBtn);
			nextBtn.addEventListener(starling.events.Event.TRIGGERED, onNextBtnClicked)
			
			var quitBtn:Button = new Button();
			quitBtn.defaultSkin = new Image(Assets.greenBtnT);
			quitBtn.label = "Quit";
			quitBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			quitBtn.x = 141
			quitBtn.y = 409
			quitBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_howToPlaySprite.addChild(quitBtn);
			quitBtn.addEventListener(starling.events.Event.TRIGGERED, onQuitBtnClicked)
			
			
			
		}
		
		private function onQuitBtnClicked():void
		{
			_mainView.changeState(DcMainView.MAIN_MENU_STATE);
			
		}
		
		private function onNextBtnClicked():void
		{
			// TODO Auto Generated method stub
			
		}		
		
	}
}