package com.states
{
	import com.assets.Assets;
	import com.trash.NewViewIos;
	import com.views.DcMainView;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Color;
	
	public class GameWonState extends Sprite implements IDCState
	{
		
		private var _model:Object;
		private var _mainView:DcMainView;
		private var _playAgainBtn:Button;
		
		public function GameWonState(mainView:DcMainView, model:Object)
		{
			_mainView = mainView;
			_model = model
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function update():void
		{
		}
		
		public function destroy():void
		{
		}
		
		
		private function onAddedToStage():void
		{
			init();
			
		}
		
		private function init():void
		{
			buildScreen();			
		}
		
		private function buildScreen():void
		{
			
			_playAgainBtn = new starling.display.Button(Assets.smallPopupTest, "PLAY AGAIN");
			_playAgainBtn.fontName = "KomikaAxis";
			_playAgainBtn.fontSize = 20;
			_playAgainBtn.fontColor = Color.WHITE;
			_playAgainBtn.x = stage.stageWidth / 2;
			_playAgainBtn.y = stage.stageHeight / 2;
			_playAgainBtn.pivotX = _playAgainBtn.width / 2;
			_playAgainBtn.pivotY = _playAgainBtn.height / 2;
			//			_playAgainBtn.rotation += .25;
			addChild(_playAgainBtn);
			_playAgainBtn.addEventListener(Event.TRIGGERED, onBackToShopBtnTriggered);			
		}
		
		private function onBackToShopBtnTriggered():void
		{
			_mainView.changeState(NewViewIos.SHOP_STATE);
		}
	}
}