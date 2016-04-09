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
	
	public class PauseScreen extends Sprite
	{
		
		private var _view:DcMainView;
		
		
		
		public function PauseScreen(view:DcMainView)
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
			
			var resumeBtn:Button = new Button();
			resumeBtn.defaultSkin = new Image(Assets.greenBtnT);
			resumeBtn.label = "Quit";
			resumeBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			resumeBtn.x = 220
			resumeBtn.y = 308
			resumeBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			addChild(resumeBtn);
			resumeBtn.addEventListener(starling.events.Event.TRIGGERED, onResumeBtnClicked)
			
			var sfxBtn:Button = new Button();
			sfxBtn.defaultSkin = new Image(Assets.greenBtnT);
			sfxBtn.label = "Quit";
			sfxBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			sfxBtn.x = 220
			sfxBtn.y = 408
			sfxBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			addChild(sfxBtn);
			sfxBtn.addEventListener(starling.events.Event.TRIGGERED, onSfxBtnClicked)
			
			var musicBtn:Button = new Button();
			musicBtn.defaultSkin = new Image(Assets.greenBtnT);
			musicBtn.label = "Quit";
			musicBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			musicBtn.x = 220
			musicBtn.y = 508
			musicBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			addChild(musicBtn);
			musicBtn.addEventListener(starling.events.Event.TRIGGERED, onMusicBtnClicked)
			
		}
		
		private function onMusicBtnClicked():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onSfxBtnClicked():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onResumeBtnClicked():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onQuitBtnClicked():void
		{
			_view.changeState(NewViewIos.SHOP_STATE);
		}	
		
		
		
		
		
	}
}
import com.ui.panels;

