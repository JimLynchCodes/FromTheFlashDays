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
	
	public class CreditsState extends Sprite implements IDCState
	{
		
		private var _mainView:DcMainView;
		private var _model:Object;
		private var _creditsSprite:Sprite;
		private var _creditsPopup:Image;
		
		public function CreditsState(mainView:DcMainView, model:Object)
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
		}
		
		private function buildScreen():void
		{
			
			_creditsSprite = new Sprite;
			this.addChild(_creditsSprite);
			
			_creditsPopup = new Image(Assets.fullPopupTest);
			_creditsSprite.addChild(_creditsPopup);
			
			var titleTF:TextField = new TextField(450, 200, "CREDITS" , "BasicWhiteFont", 50, 0xFFFFFF);
			titleTF.hAlign = "center";
			titleTF.x = 200;
			titleTF.y = -40;
			_creditsSprite.addChild(titleTF);
			
//			var nextBtn:Button = new Button();
//			nextBtn.defaultSkin = new Image(Assets.greenBtnT);
//			nextBtn.label = "Next";
//			nextBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
//			nextBtn.x = 120
//			nextBtn.y = 208
//			nextBtn.labelOffsetX = - 10; 
//			//			startBtn.name = jsonArray.staff[i].RestId
//			_creditsSprite.addChild(nextBtn);
//			nextBtn.addEventListener(starling.events.Event.TRIGGERED, onNextBtnClicked)
			
			var quitBtn:Button = new Button();
			quitBtn.defaultSkin = new Image(Assets.greenBtnT);
			quitBtn.label = "Quit";
			quitBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			quitBtn.x = 141
			quitBtn.y = 409
			quitBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_creditsSprite.addChild(quitBtn);
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