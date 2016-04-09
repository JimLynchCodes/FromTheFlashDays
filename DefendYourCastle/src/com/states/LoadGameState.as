package com.states
{
	import com.assets.Assets;
	import com.models.SaveModel;
	import com.utils.TweenManager;
	import com.views.DcMainView;
	
	import flash.net.SharedObject;
	
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class LoadGameState extends Sprite implements IDCState
	{
		
		private var _mainView:DcMainView;
		private var _model:Object;
		private var _LoadGamePopup:Image;
		private var _loadGameSprite:Sprite;
		private var shared:SharedObject;
		private var _loadGameExtraBg:Image;
		private var gameSlot1Sprite:Sprite;
		private var game1Btn:Button;
		private var game1StartBtn:Button;
		private var game1DeleteBtn:Button;
		private var _sureSprite:Sprite;
		private var _reallySureSprite:Sprite;
		private var game2StartBtn:Button;
		private var game2DeleteBtn:Button;
		private var game3StartBtn:Button;
		private var game3DeleteBtn:Button;
		private var gameSlot2Sprite:Sprite;
		private var gameSlot3Sprite:Sprite;
		private var game3Btn:Button;
		private var game2Btn:Button;
		
		public function LoadGameState(mainView:DcMainView, model:Object)
		{
			_mainView = mainView;
			_model = model
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		private function onAddedToStage():void
		{
			buildScreen();
			buildPopups();
			
		}
		
		private function buildPopups():void
		{
			// create are you sure popup
			_sureSprite = new Sprite();
			addChild(_sureSprite);
			_sureSprite.y = -600;
			
			var _surePopup:Image = new Image(Assets.smallPopupTest);
			_sureSprite.addChild(_surePopup);
			
			var achieveDescWords:TextField = new TextField(450, 200, "Are you sure you want to delete game file __?" , "BasicWhiteFont", 50, 0xFFFFFF);
			achieveDescWords.hAlign = "center";
			achieveDescWords.pivotX = achieveDescWords.width * 0.5;
			achieveDescWords.x = _surePopup.width * 0.5;
			achieveDescWords.y = 140;
			_sureSprite.addChild(achieveDescWords);
			
			var achieveDescTitleTF:TextField = new TextField(450, 200, "Delete?!" , "BasicWhiteFont", 20, 0xFFFFFF);
			achieveDescTitleTF.hAlign = "center";
			achieveDescTitleTF.pivotX = achieveDescTitleTF.width * 0.5
			achieveDescTitleTF.x = 200;
			achieveDescTitleTF.y = 0;
			_sureSprite.addChild(achieveDescTitleTF)
			
			var yesBtn:Button = new Button();
			yesBtn.defaultSkin = new Image(Assets.greenBtnT);
			yesBtn.label = "Yes";
			yesBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			yesBtn.x = 190
			yesBtn.y = 340
			//			yesBtn.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_sureSprite.addChild(yesBtn);
			yesBtn.addEventListener(starling.events.Event.TRIGGERED, onSureYesBtnClicked)
				
			var noBtn:Button = new Button();
			noBtn.defaultSkin = new Image(Assets.greenBtnT);
			noBtn.label = "No";
			noBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			noBtn.x = 310
			noBtn.y = 340
			//			noBtn.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_sureSprite.addChild(noBtn);
			noBtn.addEventListener(starling.events.Event.TRIGGERED, onSureNoBtnClicked)
				
			// create really description popup
			_reallySureSprite = new Sprite();
			addChild(_reallySureSprite);
			_reallySureSprite.y = -600;
			
			var _reallySurePopup:Image = new Image(Assets.smallPopupTest);
			_reallySureSprite.addChild(_reallySurePopup);
			
			var achieveDescWords:TextField = new TextField(450, 200, "Are you really, really sure you want to erase this save file?" , "BasicWhiteFont", 50, 0xFFFFFF);
			achieveDescWords.hAlign = "center";
			achieveDescWords.pivotX = achieveDescWords.width * 0.5;
			achieveDescWords.x = _surePopup.width * 0.5;
			achieveDescWords.y = 140;
			_reallySureSprite.addChild(achieveDescWords);
			
			var achieveDescTitleTF:TextField = new TextField(450, 200, "Really??" , "BasicWhiteFont", 20, 0xFFFFFF);
			achieveDescTitleTF.hAlign = "center";
			achieveDescTitleTF.pivotX = achieveDescTitleTF.width * 0.5
			achieveDescTitleTF.x = 200;
			achieveDescTitleTF.y = 0;
			_reallySureSprite.addChild(achieveDescTitleTF)
			
			var yesBtn:Button = new Button();
			yesBtn.defaultSkin = new Image(Assets.greenBtnT);
			yesBtn.label = "Yes";
			yesBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			yesBtn.x = 190
			yesBtn.y = 360
			//			yesBtn.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_reallySureSprite.addChild(yesBtn);
			yesBtn.addEventListener(starling.events.Event.TRIGGERED, onReallyYesBtnClicked)
			
			var noBtn:Button = new Button();
			noBtn.defaultSkin = new Image(Assets.greenBtnT);
			noBtn.label = "No";
			noBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			noBtn.x = 190
			noBtn.y = 480
			//			noBtn.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_reallySureSprite.addChild(noBtn);
			noBtn.addEventListener(starling.events.Event.TRIGGERED, onReallyNoBtnClicked)
				
		}
		
		private function onSureYesBtnClicked():void
		{
			trace("sure yes");
			TweenManager.tweenInTop(_reallySureSprite);
			
		}
		
		private function onSureNoBtnClicked():void
		{
			trace("sure no");
			TweenManager.tweenOffTop(_sureSprite);
			
		}
		
		private function onReallyNoBtnClicked():void
		{
			TweenManager.tweenOffTop(_reallySureSprite);
		}
		
		private function onReallyYesBtnClicked():void
		{
			TweenManager.tweenOffTop(_sureSprite);
			TweenManager.tweenOffTop(_reallySureSprite);
			
			resetSlotBtns();
		}
		
		private function buildScreen():void
		{
			_loadGameSprite = new Sprite;
			this.addChild(_loadGameSprite);
			
			_LoadGamePopup = new Image(Assets.fullPopupTest);
			_loadGameSprite.addChild(_LoadGamePopup);
			
			_loadGameExtraBg = new Image(Assets.slotBgTest);
			_loadGameSprite.addChild(_loadGameExtraBg);
			_loadGameExtraBg.x = 400;
			_loadGameExtraBg.y = 75;
			
			
			var titleTF:TextField = new TextField(450, 200, "SELECT FILE" , "BasicWhiteFont", 50, 0xFFFFFF);
			titleTF.hAlign = "center";
			titleTF.x = 200;
			titleTF.y = -40;
			_loadGameSprite.addChild(titleTF);
			
			
			gameSlot1Sprite = new Sprite();
			_loadGameSprite.addChild(gameSlot1Sprite);
			gameSlot1Sprite.x = 550;
			gameSlot1Sprite.y = 208;
			
			
			game1Btn = new Button();
			game1Btn.defaultSkin = new Image(Assets.greenBtnT);
			game1Btn.label = "Game 1";
			game1Btn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			game1Btn.x = 10;
			game1Btn.y = 10
			game1Btn.labelOffsetX = - 10; 
			gameSlot1Sprite.addChild(game1Btn);
			game1Btn.name = "game1";
			game1Btn.addEventListener(starling.events.Event.TRIGGERED, onGame1BtnClicked)
			
			game1StartBtn = new Button();
			game1StartBtn.defaultSkin = new Image(Assets.greenBtnT);
			game1StartBtn.label = "Start";
			game1StartBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			game1StartBtn.x = 50;
			game1StartBtn.y = -20
			game1StartBtn.labelOffsetX = - 10; 
			gameSlot1Sprite.addChild(game1StartBtn);
			game1StartBtn.name = "game1";
			game1StartBtn.addEventListener(starling.events.Event.TRIGGERED, onGame1StartBtnClicked)
			game1StartBtn.visible = false;
				
			game1DeleteBtn = new Button();
			game1DeleteBtn.defaultSkin = new Image(Assets.greenBtnT);
			game1DeleteBtn.label = "Delete";
			game1DeleteBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			game1DeleteBtn.x = 50;
			game1DeleteBtn.y = 50
			game1DeleteBtn.labelOffsetX = - 10; 
			gameSlot1Sprite.addChild(game1DeleteBtn);
			game1DeleteBtn.name = "game1";
			game1DeleteBtn.addEventListener(starling.events.Event.TRIGGERED, onGame1DeleteBtnClicked)
			game1DeleteBtn.visible = false;
				
				
			gameSlot2Sprite = new Sprite();
			_loadGameSprite.addChild(gameSlot2Sprite);
			gameSlot2Sprite.x = 550;
			gameSlot2Sprite.y = 358;
				
			game2Btn = new Button();
			game2Btn.defaultSkin = new Image(Assets.greenBtnT);
			game2Btn.label = "Game 2";
			game2Btn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			game2Btn.x = 10
			game2Btn.y = 10
			game2Btn.labelOffsetX = - 10; 
			gameSlot2Sprite.addChild(game2Btn);
			game2Btn.name = "game2";
			game2Btn.addEventListener(starling.events.Event.TRIGGERED, onGame2BtnClicked)
			
			game2StartBtn = new Button();
			game2StartBtn.defaultSkin = new Image(Assets.greenBtnT);
			game2StartBtn.label = "Start";
			game2StartBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			game2StartBtn.x = 50;
			game2StartBtn.y = -20
			game2StartBtn.labelOffsetX = - 20; 
			gameSlot2Sprite.addChild(game2StartBtn);
			game2StartBtn.name = "game2";
			game2StartBtn.addEventListener(starling.events.Event.TRIGGERED, onGame2StartBtnClicked)
			game2StartBtn.visible = false;
			
			game2DeleteBtn = new Button();
			game2DeleteBtn.defaultSkin = new Image(Assets.greenBtnT);
			game2DeleteBtn.label = "Delete";
			game2DeleteBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			game2DeleteBtn.x = 50;
			game2DeleteBtn.y = 50
			game2DeleteBtn.labelOffsetX = - 20; 
			gameSlot2Sprite.addChild(game2DeleteBtn);
			game2DeleteBtn.name = "game2";
			game2DeleteBtn.addEventListener(starling.events.Event.TRIGGERED, onGame2DeleteBtnClicked)
			game2DeleteBtn.visible = false;
				
			
				
			gameSlot3Sprite = new Sprite();
			_loadGameSprite.addChild(gameSlot3Sprite);
			gameSlot3Sprite.x = 550;
			gameSlot3Sprite.y = 528;

			game3Btn = new Button();
			game3Btn.defaultSkin = new Image(Assets.greenBtnT);
			game3Btn.label = "Game 3";
			game3Btn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			game3Btn.x = 10
			game3Btn.y = 10
			game3Btn.labelOffsetX = - 10; 
			gameSlot3Sprite.addChild(game3Btn);
			game3Btn.name = "game3";
			game3Btn.addEventListener(starling.events.Event.TRIGGERED, onGame3BtnClicked)
				
			game3StartBtn = new Button();
			game3StartBtn.defaultSkin = new Image(Assets.greenBtnT);
			game3StartBtn.label = "Start";
			game3StartBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			game3StartBtn.x = 50;
			game3StartBtn.y = -20
			game3StartBtn.labelOffsetX = - 30; 
			gameSlot3Sprite.addChild(game3StartBtn);
			game3StartBtn.name = "game3";
			game3StartBtn.addEventListener(starling.events.Event.TRIGGERED, onGame3StartBtnClicked)
			game3StartBtn.visible = false;
			
			game3DeleteBtn = new Button();
			game3DeleteBtn.defaultSkin = new Image(Assets.greenBtnT);
			game3DeleteBtn.label = "Delete";
			game3DeleteBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			game3DeleteBtn.x = 50;
			game3DeleteBtn.y = 50
			game3DeleteBtn.labelOffsetX = - 30; 
			gameSlot3Sprite.addChild(game3DeleteBtn);
			game3DeleteBtn.name = "game3";
			game3DeleteBtn.addEventListener(starling.events.Event.TRIGGERED, onGame3DeleteBtnClicked)
			game3DeleteBtn.visible = false;
				
			var quitBtn:Button = new Button();
			quitBtn.defaultSkin = new Image(Assets.greenBtnT);
			quitBtn.label = "Quit";
			quitBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			quitBtn.x = 220
			quitBtn.y = 550
			quitBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_loadGameSprite.addChild(quitBtn);
			quitBtn.addEventListener(starling.events.Event.TRIGGERED, onQuitBtnClicked)
				
		}
		
		private function onGame3DeleteBtnClicked():void
		{
			TweenManager.tweenInTop(_sureSprite);
			
		}
		
		private function onGame3StartBtnClicked(e:Event):void
		{
			var btn:Button = e.currentTarget as Button;
			trace("event.currentTarget.name " + btn.name);
			loadSavedObject(btn.name);
			_mainView.changeState(DcMainView.SHOP_STATE);
			
		}
		
		private function onGame2DeleteBtnClicked():void
		{
			TweenManager.tweenInTop(_sureSprite);
			
		}
		
		private function onGame2StartBtnClicked(e:Event):void
		{
			var btn:Button = e.currentTarget as Button;
			trace("event.currentTarget.name " + btn.name);
			
			loadSavedObject(btn.name);
			
			_mainView.changeState(DcMainView.SHOP_STATE);
			
			
		}
		
		private function onGame1DeleteBtnClicked():void
		{
			TweenManager.tweenInTop(_sureSprite);
		}
		
		private function onGame1StartBtnClicked(e:Event):void
		{
			var btn:Button = e.currentTarget as Button;
			trace("event.currentTarget.name " + btn.name);
			loadSavedObject(btn.name);
			_mainView.changeState(DcMainView.SHOP_STATE);
			
		}
		
		private function onQuitBtnClicked():void
		{
			_mainView.changeState(DcMainView.MAIN_MENU_STATE);
		}
		
		private function loadSavedObject(gameName:String):void
		{
			shared = SharedObject.getLocal(gameName);
			SaveModel.sharedObj = shared;
			
			if (shared.data.g ==undefined) {
				shared.data.g = 1;
				trace("starting a new game on: " + gameName + " " + shared.data.g);
			}
			else {
				shared.data.g ++;
				trace("game data found on: " + gameName + "!" + shared.data.g);
				
				SaveModel.fillWithSavedData();
			}
//			show_text(shared.data.visits);
//			shared.close();
			
		}
		
		private function onGame3BtnClicked(e:Event):void
		{
			resetSlotBtns();
			
			trace("game button clicked");
			game3Btn.visible = false;
			
			game3DeleteBtn.visible = true;
			game3StartBtn.visible = true;
		}
		
		
		private function onGame2BtnClicked(e:Event):void
		{
			resetSlotBtns();
			
			trace("game button clicked");
			game2Btn.visible = false;
			
			game2DeleteBtn.visible = true;
			game2StartBtn.visible = true;
			
		}
		
		private function onGame1BtnClicked(e:Event):void
		{
			resetSlotBtns();
			
			trace("game button clicked");
			game1Btn.visible = false;
			
			game1DeleteBtn.visible = true;
			game1StartBtn.visible = true;
			
			
		}
		
		private function resetSlotBtns():void
		{
			game1DeleteBtn.visible = false;
			game1StartBtn.visible = false
			game1Btn.visible = true;
			
			game2DeleteBtn.visible = false;
			game2StartBtn.visible = false
			game2Btn.visible = true;
			
			game3DeleteBtn.visible = false;
			game3StartBtn.visible = false
			game3Btn.visible = true;
			
			
			
		}
		
		public function update():void
		{
		}
		
		public function destroy():void
		{
			_loadGameSprite.removeFromParent(true);
			
			
		}
	}
}