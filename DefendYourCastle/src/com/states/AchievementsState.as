package com.states
{
	import com.assets.Assets;
	import com.greensock.TweenLite;
	import com.models.GameModel;
	import com.models.SaveModel;
	import com.objects.LevelDataObj;
	import com.ui.buttons.loadGameButton.AchievementButton;
	import com.utils.TweenManager;
	import com.views.DcMainView;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class AchievementsState extends Sprite implements IDCState
	{
		
		private var _mainView:DcMainView;
		private var _model:Object;
		private var _achievementsSprite:Sprite;
		private var _achievementsPopup:Image;
		private var explanationPopupSprite:Sprite;
		private var _achieveDescSprite:Sprite;
		private var _achieveSquareAry:Array = [];
		private var loader2:Loader;
		private var achieveDescTitleTF:TextField;
		private var achieveDescWords:TextField;
		
		public function AchievementsState(mainView:DcMainView, model:Object)
		{
			_mainView = mainView;
			_model = model
			
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			trace("da main been added, sir");
			buildScreen();
			loadJson();
			
			
		}
		
		
		private function loadJson():void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			
//			loader2 = new Loader()
			
//			var loaderContext:LoaderContext = new LoaderContext();
//			loaderContext.applicationDomain = ApplicationDomain.currentDomain;
//			loaderContext.securityDomain = SecurityDomain.currentDomain; // Sets the security 
//			context to resolve Error # 2121
			
			
			//			request.url = "/json/Level1.txt";
			//			request.url = "http://www.goldenliongames.com/uploads/2/0/5/4/20545110/level1.txt";
			request.url = "/json/Achievements.txt";
			
			loader.addEventListener(flash.events.Event.COMPLETE, onLoaderComplete);
//			loader2.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoaderComplete);
			
			try{
//				loader2.load(request, loaderContext);
				loader.load(request);
			} catch (error:Error) {
				trace("Cannot load : " + error.message);
			}
		}	
		
		protected function onLoaderComplete(event:flash.events.Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
//			var loader:* = loader2.contentLoaderInfo.content;
			trace("loader.data " + loader.data);
			var jsonArray:Object = JSON.parse(loader.data);
			trace(jsonArray.First18);
			
			var achievemnents:int = jsonArray.First18.length;
			
			// reset the enemyDataAry
			GameModel.enemyDataAry = [];
			
			
			var c:int = 0;
			var d:int = 0;
			for(var i:int = 0; i < achievemnents; i++)
			{
				
//				var enemyDataObj:LevelDataObj = new LevelDataObj;
//				enemyDataObj.type = jsonArray.Enemies[i].Type
//				enemyDataObj.speed = jsonArray.Enemies[i].Speed
//				enemyDataObj.goldRewardOnDeath = jsonArray.Enemies[i].GoldRewardOnDeath
//				enemyDataObj.floorY = jsonArray.Enemies[i].FloorY
//				enemyDataObj.timeSent = jsonArray.Enemies[i].TimeSent * 1000
//				enemyDataObj.health = jsonArray.Enemies[i].Health
//				enemyDataObj.damage = jsonArray.Enemies[i].Damage
//				
//				GameModel.enemyDataAry.push(enemyDataObj);
				
//				layoutAchievementButtons();
				
				var square:AchievementButton = new AchievementButton();
				square.defaultSkin = new Image(Assets.levelBox);
				square.defaultSelectedSkin = new Image(Assets.slottySelect);
				square.label = "" + (i)
				square.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
				
				_achieveSquareAry.push(square);
				//				trace(square.width);	
				
				addChild(square);
				square.x = 120 + (c) * (square.defaultSkin.width + 15) 
				square.y = 160 + (d) * (square.defaultSkin.height + 10);
				square.isToggle = true;
				square.isSelected = false;
				//				trace(square.height);	
				
				square.titleTxt = jsonArray.First18[i].Title
				square.explanation = jsonArray.First18[i].Explanation
				square.varName = jsonArray.First18[i].VarName
					
				trace("jug" + SaveModel[square.varName]);	
				
				// if (SaveModel[square.varName] == true) show unlocked picture else show regular
				
				
				
				//					square.addEventListener(starling.events.Event.TRIGGERED, onSquareClicked)
				square.addEventListener(starling.events.Event.TRIGGERED, onAchievement1BtnClicked)
				
				
				c++
				
				if(c == 6)
				{
					c = 0;
					d++;
				}
				
				if(d == 3)
				{
					d = 0;
				}
				
			}
			
			buildPopup();
		}
		
//		private function layoutAchievementButtons():void
//		{
//			for (var c:int = 0; c < 6; c++)
//			{
//				for (var d:int = 0; d < 3; d++)
//				{
//					var square:Button = new Button();
//					square.defaultSkin = new Image(Assets.levelBox);
//					square.defaultSelectedSkin = new Image(Assets.slottySelect);
//					square.label = "" + (c+d)
//					square.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
//					
//					_achieveSquareAry.push(square);
//					//				trace(square.width);	
//					
//					addChild(square);
//					square.x = 120 + (c) * (square.defaultSkin.width + 15) 
//					square.y = 160 + (d) * (square.defaultSkin.height + 10);
//					square.isToggle = true;
//					square.isSelected = false;
//					//				trace(square.height);	
//					
////					square.addEventListener(starling.events.Event.TRIGGERED, onSquareClicked)
//					square.addEventListener(starling.events.Event.TRIGGERED, onAchievement1BtnClicked)
//
//					
//				}
//			}
//		}
		
		private function onSquareClicked():void
		{
			trace("square clicked");
		}
		
		private function buildPopup():void
		{
			// create achievement description popup
			_achieveDescSprite = new Sprite();
			addChild(_achieveDescSprite);
			_achieveDescSprite.y = -600;
			
			var _achieveDescPopup:Image = new Image(Assets.smallPopupTest);
			_achieveDescSprite.addChild(_achieveDescPopup);
			
			achieveDescWords = new TextField(450, 200, "Beat a level using only the meteor powerup" , "BasicWhiteFont", 20, 0xFFFFFF);
			achieveDescWords.hAlign = "center";
			achieveDescWords.pivotX = achieveDescWords.width * 0.5;
			achieveDescWords.x = _achieveDescPopup.width * 0.5;
			achieveDescWords.y = 140;
			_achieveDescSprite.addChild(achieveDescWords);
			
			achieveDescTitleTF = new TextField(450, 200, "Achievement Name" , "BasicWhiteFont", 50, 0xFFFFFF);
			achieveDescTitleTF.hAlign = "center";
			achieveDescTitleTF.pivotX = achieveDescTitleTF.width * 0.5
			achieveDescTitleTF.x = 200;
			achieveDescTitleTF.y = 0;
			_achieveDescSprite.addChild(achieveDescTitleTF)
			
			var okBtn:Button = new Button();
			okBtn.defaultSkin = new Image(Assets.greenBtnT);
			okBtn.label = "Ok";
			okBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			okBtn.x = 190
			okBtn.y = 360
			//			okBtn.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_achieveDescSprite.addChild(okBtn);
			okBtn.addEventListener(starling.events.Event.TRIGGERED, onOkBtnClicked)
//			okBtn.addEventListener(starling.events.Event.TRIGGERED, onAchievement1BtnClicked)

			
			
		}
		
		private function onOkBtnClicked():void
		{
			TweenManager.tweenOffTop(_achieveDescSprite);
			
		}		
		
		public function update():void
		{
		}
		
		public function destroy():void
		{
			_achievementsSprite.removeFromParent(true);
			
		}
		
		private function buildScreen():void
		{
			
			_achievementsSprite = new Sprite;
			this.addChild(_achievementsSprite);
			
			_achievementsPopup = new Image(Assets.fullPopupTest);
			_achievementsSprite.addChild(_achievementsPopup);
			
			var titleTF = new TextField(450, 200, "ACHIEVEMENTS" , "BasicWhiteFont", 50, 0xFFFFFF);
			titleTF.hAlign = "center";
			titleTF.x = 200;
			titleTF.y = -40;
			_achievementsSprite.addChild(titleTF);
//			
//			var achievement1Btn:Button = new Button();
//			achievement1Btn.defaultSkin = new Image(Assets.greenBtnT);
//			achievement1Btn.label = "Achievement1";
//			achievement1Btn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
//			achievement1Btn.x = 120
//			achievement1Btn.y = 208
//			achievement1Btn.labelOffsetX = - 10; 
//			//			startBtn.name = jsonArray.staff[i].RestId
//			_achievementsSprite.addChild(achievement1Btn);
//			achievement1Btn.addEventListener(starling.events.Event.TRIGGERED, onAchievement1BtnClicked)
			
				
				
			var rewardsBtn:Button = new Button();
			rewardsBtn.defaultSkin = new Image(Assets.greenBtnT);
			rewardsBtn.label = "REWARDS";
			rewardsBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			rewardsBtn.x = 686
			rewardsBtn.y = 550
			rewardsBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_achievementsSprite.addChild(rewardsBtn);
			rewardsBtn.addEventListener(starling.events.Event.TRIGGERED, onRewardsBtnClicked)
				
			var quitBtn:Button = new Button();
			quitBtn.defaultSkin = new Image(Assets.greenBtnT);
			quitBtn.label = "Quit";
			quitBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			quitBtn.x = 100
			quitBtn.y = 550
			quitBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_achievementsSprite.addChild(quitBtn);
			quitBtn.addEventListener(starling.events.Event.TRIGGERED, onQuitBtnClicked)
			
			
			// create explanation popup
				
			explanationPopupSprite = new Sprite;
			addChild(explanationPopupSprite);	
			
			// textfield
			// ok btn
			// achieved
			
				
			
		}
		
		private function onQuitBtnClicked():void
		{
			_mainView.changeState(DcMainView.SHOP_STATE);
			
		}
		
		private function onAchievement1BtnClicked(e:starling.events.Event):void
		{
			trace("clicked" + e.currentTarget);
			
			// tween in achievement description popup
			TweenManager.tweenInTop(_achieveDescSprite);
			
			var btn:AchievementButton = e.currentTarget as AchievementButton 
			achieveDescTitleTF.text = btn.titleTxt;
			achieveDescWords.text = btn.explanation;
			
			
			
		}		
		
		private function onRewardsBtnClicked():void
		{
			_mainView.changeState(DcMainView.ACHIEVEMENT_REWARDS_STATE);
			
		}		
		
	}
}