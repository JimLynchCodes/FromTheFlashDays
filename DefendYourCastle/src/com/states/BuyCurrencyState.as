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
	import starling.display.DisplayObject;
	
	public class BuyCurrencyState extends Sprite implements IDCState
	{
		
		private var _mainView:DcMainView;
		private var _model:Object;
		private var _buyCurrencySprite:Sprite;
		private var _buyCurrencyPopup:Image;
		private var _coinShop:Image;
		
		public function BuyCurrencyState(mainView:DcMainView, model:Object)
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
			_buyCurrencySprite.removeFromParent(true);
			
		}
		
		private function buildScreen():void
		{
			
			_buyCurrencySprite = new Sprite;
			this.addChild(_buyCurrencySprite);
			
			_buyCurrencyPopup = new Image(Assets.fullPopupTest);
			_buyCurrencySprite.addChild(_buyCurrencyPopup);
			
			_coinShop = new Image(Assets.coinShop);
			_buyCurrencySprite.addChild(_coinShop);
			_coinShop.x = 250;
			_coinShop.y = 200;
			
			var titleTF:TextField = new TextField(450, 200, "BUY CURRENCY" , "BasicWhiteFont", 50, 0xFFFFFF);
			titleTF.hAlign = "center";
			titleTF.x = 200;
			titleTF.y = -40;
			_buyCurrencySprite.addChild(titleTF);
			
//			var nextBtn:Button = new Button();
//			nextBtn.defaultSkin = new Image(Assets.greenBtnT);
//			nextBtn.label = "Next";
//			nextBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
//			nextBtn.x = 686
//			nextBtn.y = 550
//			nextBtn.labelOffsetX = - 10; 
//			//			startBtn.name = jsonArray.staff[i].RestId
//			_buyCurrencySprite.addChild(nextBtn);
//			nextBtn.addEventListener(starling.events.Event.TRIGGERED, onNextBtnClicked)
			
			var quitBtn:Button = new Button();
			quitBtn.defaultSkin = new Image(Assets.greenBtnT);
			quitBtn.label = "Quit";
			quitBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			quitBtn.x = 100
			quitBtn.y = 550
			quitBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_buyCurrencySprite.addChild(quitBtn);
			quitBtn.addEventListener(starling.events.Event.TRIGGERED, onQuitBtnClicked)
			
			
			
		}
		
		private function onQuitBtnClicked():void
		{
			_mainView.changeState(DcMainView.SHOP_STATE);
			
		}
		
		private function onNextBtnClicked():void
		{
			// TODO Auto Generated method stub
			
		}		
		
	}
}