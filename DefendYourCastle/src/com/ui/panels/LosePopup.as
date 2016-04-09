package com.ui.panels
{
	import com.assets.Assets;
	import com.trash.NewViewIos;
	import com.views.DcMainView;
	
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Color;
	
	public class LosePopup extends Sprite
	{
		
		private var _view:DcMainView;
		
		
		
		public function LosePopup(view:DcMainView)
		{
			_view = view;
			init();			
			
		}
		
		private function init():void
		{
			buildScreen();			
		}		
		
		private function buildScreen():void
		{
			
			var bg:Image = new Image(Assets.genericPopup);
			addChild(bg);
			
			var quitBtn:Button = new Button();
			quitBtn.defaultSkin = new Image(Assets.greenBtnT);
			quitBtn.label = "Quit";
			quitBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			quitBtn.x = 220
			quitBtn.y = 208
			quitBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			addChild(quitBtn);
			quitBtn.addEventListener(starling.events.Event.TRIGGERED, onQuitBtnClicked)
			
		}
		
		private function onQuitBtnClicked():void
		{
			_view.changeState(NewViewIos.SHOP_STATE);
		}	
		
		
		
		
		
	}
}
import com.ui.panels;

