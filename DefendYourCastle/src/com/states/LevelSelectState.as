package com.states
{
	import com.assets.Assets;
	import com.models.GameModel;
	import com.models.RUXModel;
	import com.objects.LevelDataObj;
	import com.views.DcMainView;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import dragonBones.objects.DataParser;
	
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class LevelSelectState extends Sprite implements IDCState
	{
		
		private var _mainView:DcMainView;
		private var _model:Object;
		private var _levelSelectSprite:Sprite;
		private var _levelSelectPopup:Image;
		private var fireParticles:PDParticleSystem
		private var _levelSquareAry:Array = [];
		
		public function LevelSelectState(mainView:DcMainView, model:Object)
		{
			_mainView = mainView;
			_model = model
			
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
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
			fireParticles.stop();
			removeChild(fireParticles);
			Starling.juggler.remove(fireParticles);
			
			_levelSelectSprite.removeFromParent(true);
		}
		
		private function buildScreen():void
		{
			
			_levelSelectSprite = new Sprite;
			this.addChild(_levelSelectSprite);
			
			_levelSelectPopup = new Image(Assets.fullPopupTest);
			_levelSelectSprite.addChild(_levelSelectPopup);
			
			var titleTF:TextField = new TextField(450, 200, "LEVEL SELECT" , "BasicWhiteFont", 50, 0xFFFFFF);
			titleTF.hAlign = "center";
			titleTF.x = 40;
			titleTF.y = -40;
			_levelSelectSprite.addChild(titleTF);
			
			
			var nextBtn:Button = new Button();
			nextBtn.defaultSkin = new Image(Assets.greenBtnT);
			nextBtn.label = "Play Game";
			nextBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			nextBtn.x = 686
			nextBtn.y = 550
			nextBtn.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_levelSelectSprite.addChild(nextBtn);
			nextBtn.addEventListener(starling.events.Event.TRIGGERED, onNextBtnClicked)
			
			var quitBtn:Button = new Button();
			quitBtn.defaultSkin = new Image(Assets.greenBtnT);
			quitBtn.label = "Quit";
			quitBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			quitBtn.x = 100
			quitBtn.y = 550
			quitBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_levelSelectSprite.addChild(quitBtn);
			quitBtn.addEventListener(starling.events.Event.TRIGGERED, onQuitBtnClicked)
			
			fireParticles = new PDParticleSystem(new XML(new Assets.FireParticle()),
				Texture.fromBitmap(new Assets.FireParticleImage));
			fireParticles.start();
			addChild(fireParticles);
			fireParticles.x = 100;
			fireParticles.start();
			fireParticles.y = 100
			Starling.juggler.add(fireParticles);
			
			layoutLevelButtons();
			
		}
		
		private function layoutLevelButtons():void
		{
			
			for (var c:int = 0; c < 6; c++)
			{
			for (var d:int = 0; d < 3; d++)
			{
				var square:Button = new Button();
				square.defaultSkin = new Image(Assets.levelBox);
				square.defaultSelectedSkin = new Image(Assets.slottySelect);
				square.label = "" + (c+1) + (d*6);
				square.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
				
				_levelSquareAry.push(square);
				//				trace(square.width);	
				
				_levelSelectSprite.addChild(square);
				square.x = 120 + (c) * (square.defaultSkin.width + 15) 
				square.y = 160 + (d) * (square.defaultSkin.height + 10);
				square.isToggle = true;
				square.isSelected = false;
				//				trace(square.height);	
				
				square.addEventListener(starling.events.Event.TRIGGERED, onSquareClicked)
				
				
			}
			}
			
			
			// top buttons
			
			
			var heartLevelBox:Button = new Button();
			heartLevelBox.defaultSkin = new Image(Assets.heartLevelBox);
//			heartLevelBox.defaultSelectedSkin = new Image(Assets.slottySelect);
			heartLevelBox.label = "";
			heartLevelBox.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			_levelSelectSprite.addChild(heartLevelBox);
			heartLevelBox.x = 550 
			heartLevelBox.y = 20;
//			square.addEventListener(starling.events.Event.TRIGGERED, onSquareClicked)
				
			var throwOnlyBox:Button = new Button();
			throwOnlyBox.defaultSkin = new Image(Assets.throwOnlyBox);
//			throwOnlyBox.defaultSelectedSkin = new Image(Assets.slottySelect);
			throwOnlyBox.label = "";
			throwOnlyBox.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			_levelSelectSprite.addChild(throwOnlyBox);
			throwOnlyBox.x = 650 
			throwOnlyBox.y = 20;
//			square.addEventListener(starling.events.Event.TRIGGERED, onSquareClicked)
				
			var magicOnlyBox:Button = new Button();
			magicOnlyBox.defaultSkin = new Image(Assets.magicOnlyBox);
//			magicOnlyBox.defaultSelectedSkin = new Image(Assets.slottySelect);
			magicOnlyBox.label = "";
			magicOnlyBox.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			_levelSelectSprite.addChild(magicOnlyBox);
			magicOnlyBox.x = 745 
			magicOnlyBox.y = 20;
//			square.addEventListener(starling.events.Event.TRIGGERED, onSquareClicked)
				
			var impossibleModeBox:Button = new Button();
			impossibleModeBox.defaultSkin = new Image(Assets.impossibleModeBox);
//			impossibleModeBox.defaultSelectedSkin = new Image(Assets.slottySelect);
			impossibleModeBox.label = "";
			impossibleModeBox.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			_levelSelectSprite.addChild(impossibleModeBox);
			impossibleModeBox.x = 845
			impossibleModeBox.y = 20;
//			square.addEventListener(starling.events.Event.TRIGGERED, onSquareClicked)
				
			
			
		}
		
		private function onSquareClicked(e:starling.events.Event):void
		{
			unSelectAllSquares();
			var square:Button = e.currentTarget as Button;
			trace("is selected " + square.isSelected);
		}
		
		private function unSelectAllSquares():void
		{
			for (var j:int = 0; j < _levelSquareAry.length; j++)
			{
				_levelSquareAry[j].isSelected = false;
			}
		}
		
		private function onQuitBtnClicked():void
		{
			_mainView.changeState(DcMainView.SET_POWERUP_STATE);
			
			
		}
		
		private function onNextBtnClicked():void
		{

			
			loadJson();	
			
		}		
		
		private function loadJson():void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
//			request.url = "/json/Level1.txt";
//			request.url = "http://www.goldenliongames.com/uploads/2/0/5/4/20545110/level1.txt";
//			request.url = "https://s3.amazonaws.com/DefendTheCastle/Level1.txt";
			request.url = "/json/Level1.txt";
			
			loader.addEventListener(flash.events.Event.COMPLETE, onLoaderComplete);
			
			try{
				loader.load(request);
			} catch (error:Error) {
				trace("Cannot load : " + error.message);
			}
		}		
		
		protected function onLoaderComplete(event:flash.events.Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			
			trace("loader.data " + loader.data);
			
			var jsonArray:Object = JSON.parse(loader.data);
			
			trace(jsonArray.LevelInfo);
			trace(jsonArray.Enemies);
			
				// json is in seconds, convert it to milliseconds
			GameModel.levelTimeLengthMil = jsonArray.LevelInfo[0].TimeLength * 1000;

			GameModel.winRewardGold = jsonArray.LevelInfo[0].WinRewardGold * 1000;
			
			trace(jsonArray.LevelInfo[0].WinRewardGold)		
			trace(jsonArray.Enemies.length)		
			
			var numberOfEnemies:int = jsonArray.Enemies.length;
			
			// reset the enemyDataAry
			GameModel.enemyDataAry = [];
			
			for(var i:int = 0; i < numberOfEnemies; i++)
			{
				var enemyDataObj:LevelDataObj = new LevelDataObj;
				enemyDataObj.type = jsonArray.Enemies[i].Type
				enemyDataObj.speed = jsonArray.Enemies[i].Speed
				enemyDataObj.goldRewardOnDeath = jsonArray.Enemies[i].GoldRewardOnDeath
				enemyDataObj.floorY = jsonArray.Enemies[i].FloorY
				enemyDataObj.timeSent = jsonArray.Enemies[i].TimeSent * 1000
				enemyDataObj.health = jsonArray.Enemies[i].Health
				enemyDataObj.damage = jsonArray.Enemies[i].Damage
				enemyDataObj.weight = jsonArray.Enemies[i].Weight
				enemyDataObj.stopX = jsonArray.Enemies[i].StopX
//				enemyDataObj.stopX = jsonArray.Enemies[i].Damage
				
				GameModel.enemyDataAry.push(enemyDataObj);
			
			
			}
			
			trace(GameModel.enemyDataAry[2].type);
			
			
			beginPlaying();
			
		}		
		
		private function beginPlaying():void
		{
			_mainView.changeState(DcMainView.PLAY_STATE);
			
		}		
		
	}
}