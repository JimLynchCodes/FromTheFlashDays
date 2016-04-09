package com.states
{
	import com.assets.Assets;
	import com.greensock.TweenLite;
	import com.trash.NewViewIos;
	import com.utils.TweenManager;
	import com.views.DcMainView;
	
	import feathers.controls.Button;
	import feathers.controls.IScrollBar;
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class ShopState extends Sprite implements IDCState
	{
		private var _mainView:DcMainView;
		private var _model:Object;
		private var _shopSprite:Sprite;
		private var _shopPopup:Image;
		private var _areYouSureSprite:Sprite;
		private var _santa:Image;
		private var hContainer:ScrollContainer;
		private var _invSquareAry:Array = [];
		private var vContainer:ScrollContainer;
		private var _shopSquareAry:Array = [];
		
		public function ShopState(mainView:DcMainView, model:Object)
		{
			_mainView = mainView;
			_model = model
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			trace("da main been added, sir");
			buildScreen();
			buildInventoryScroller();
			buildShopItemScroller();
//			buildScreen();
			
			buildPopup();
			
		}
		
		private function buildShopItemScroller():void
		{
			var currentY:Number = 0;
			
			
			
			
			// scroll container
			vContainer = new ScrollContainer();
//			var shopLayout:VerticalLayout = new VerticalLayout();
//			shopLayout.gap = 10;
//			vContainer.layout = shopLayout;
			vContainer.x = 70;
			vContainer.y = 150;
			vContainer.width = 500;
			vContainer.height = 250;
			vContainer.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			_shopSprite.addChild( vContainer );
			
			vContainer.scrollerProperties.horizontalScrollBarFactory = function():IScrollBar
			{
				var scrollBar:ScrollBar = new ScrollBar();
				//skin the scroll bar here
				//				scrollBar.trackLayoutMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
				
				
				scrollBar.thumbProperties.defaultSkin = new Image( Assets.scroller );
				scrollBar.thumbProperties.downSkin = new Image( Assets.scroller );
				
				return scrollBar;
			}
				
				
			var powerupsTF:TextField = new TextField(200, 200, "Powerups" , "BasicWhiteFont", 30, 0xFFFFFF);
			powerupsTF.hAlign = "center";
			powerupsTF.x = 00;
			powerupsTF.y = -40;
			vContainer.addChild(powerupsTF);
			currentY += 200;
			
			for (var b:int = 0; b < 3; b++)
			{
			// fill with powerup squares
			for (var i:int = 0; i < 20; i++)
			{
				var square:Button = new Button();
				square.defaultSkin = new Image(Assets.gamePowUpBtn);
				square.defaultSelectedSkin = new Image(Assets.slottySelect);
				square.label = "" + i;
				square.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
				
				_shopSquareAry.push(square);
				
				//				trace(square.width);	
				
				vContainer.addChild(square);
				square.x = 20 + 90 * b;
				trace(square.x + " is the x");
				square.y = 20 + 100+ 90 * i;
				square.isToggle = true;
				square.isSelected = false;
				//				trace(square.height);	
				
				currentY += 80 + 90
				
				square.addEventListener(starling.events.Event.TRIGGERED, onInvSquareClicked)
				
				//				square.addEventListener(TouchEvent.TOUCH, onSquareTouch)
				
			}	
			
			trace("b's " + b);
			}
			
			var castleTF:TextField = new TextField(200, 200, "Castle Upgrades" , "BasicWhiteFont", 30, 0xFFFFFF);
			castleTF.hAlign = "center";
			castleTF.x = 200;
			castleTF.y = currentY;
			vContainer.addChild(castleTF);
			currentY += 200;
			
			for (var b:int = 0; b < 3; b++)
			{
			// fill with powerup squares
			for (var i:int = 0; i < 20; i++)
			{
				var square:Button = new Button();
				square.defaultSkin = new Image(Assets.gamePowUpBtn);
				square.defaultSelectedSkin = new Image(Assets.slottySelect);
				square.label = "" + i;
				square.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
				
				_shopSquareAry.push(square);
				
				//				trace(square.width);	
				
				vContainer.addChild(square);
				square.x = 20 + 90 * b;
				trace(square.x + " is the x");
				
				
				square.y = currentY + 90
//				square.y = 20 + 100+ 90 * i;
				square.isToggle = true;
				square.isSelected = false;
				//				trace(square.height);	
				
				square.addEventListener(starling.events.Event.TRIGGERED, onInvSquareClicked)
				
				//				square.addEventListener(TouchEvent.TOUCH, onSquareTouch)
				
			}	
			
			trace("b's " + b);
			}
			
		}
		
		private function buildInventoryScroller():void
		{
				// scroll container
				hContainer = new ScrollContainer();
//				var layout:HorizontalLayout = new HorizontalLayout();
//				layout.gap = 10;
//				hContainer.layout = layout;
				hContainer.x = 70;
				hContainer.y = 400;
				hContainer.width = 500;
				hContainer.height = 170;
				hContainer.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
				_shopSprite.addChild( hContainer );
				
//				hContainer.scrollerProperties.horizontalScrollBarFactory = function():IScrollBar
//				{
//					var scrollBar:ScrollBar = new ScrollBar();
//					//skin the scroll bar here
//					//				scrollBar.trackLayoutMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
//					
//					
//					scrollBar.thumbProperties.defaultSkin = new Image( Assets.scroller );
//					scrollBar.thumbProperties.downSkin = new Image( Assets.scroller );
//					
//					return scrollBar;
//				}
				
				// fill with powerup squares
				for (var i:int = 0; i < 20; i++)
				{
					var square:Button = new Button();
					square.defaultSkin = new Image(Assets.gamePowUpBtn);
					square.defaultSelectedSkin = new Image(Assets.gamePowUpBtn);
					square.label = "" + i;
					square.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
					
					_invSquareAry.push(square);
					//				trace(square.width);	
					
					hContainer.addChild(square);
					square.x = 20 + i * (square.defaultSkin.width + 10) 
					square.y = 20;
					square.isToggle = true;
					square.isSelected = false;
					//				trace(square.height);	
					
					square.addEventListener(starling.events.Event.TRIGGERED, onInvSquareClicked)
					
					//				square.addEventListener(TouchEvent.TOUCH, onSquareTouch)
					
				
				
				
			}	
			
		}
		
		private function onInvSquareClicked():void
		{
			trace("inv square clicked");
		}
		
		private function buildPopup():void
		{
			// create are you sure popup
			_areYouSureSprite = new Sprite();
			addChild(_areYouSureSprite);
			_areYouSureSprite.y = -600;
			
			var _areYouSurePopup:Image = new Image(Assets.smallPopupTest);
			_areYouSureSprite.addChild(_areYouSurePopup);
			
			var areYouSureWords:TextField = new TextField(450, 200, "Are you sure you want to buy _____ for _____ coins?" , "BasicWhiteFont", 50, 0xFFFFFF);
			areYouSureWords.hAlign = "center";
			areYouSureWords.pivotX = areYouSureWords.width * 0.5;
			areYouSureWords.x = _areYouSurePopup.width * 0.5;
			areYouSureWords.y = 140;
			_areYouSureSprite.addChild(areYouSureWords);
			
			var areYouSureTitleTF:TextField = new TextField(450, 200, "Are You Sure?" , "BasicWhiteFont", 20, 0xFFFFFF);
			areYouSureTitleTF.hAlign = "center";
			areYouSureTitleTF.pivotX = areYouSureTitleTF.width * 0.5
			areYouSureTitleTF.x = 200;
			areYouSureTitleTF.y = 0;
			_areYouSureSprite.addChild(areYouSureTitleTF)
				
			var sureYes:Button = new Button();
			sureYes.defaultSkin = new Image(Assets.greenBtnT);
			sureYes.label = "Yes";
			sureYes.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			sureYes.x = 320
			sureYes.y = 360
//			sureYes.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_areYouSureSprite.addChild(sureYes);
			sureYes.addEventListener(starling.events.Event.TRIGGERED, onSureYesBtnClicked)
					
			var sureNo:Button = new Button();
			sureNo.defaultSkin = new Image(Assets.greenBtnT);
			sureNo.label = "No";
			sureNo.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			sureNo.x = 120
			sureNo.y = 360;
//			sureNo.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_areYouSureSprite.addChild(sureNo);
			sureNo.addEventListener(starling.events.Event.TRIGGERED, onSureNoBtnClicked)
					
				
		}
		
		private function onSureYesBtnClicked():void
		{
			// save the item into SaveModel
			TweenManager.tweenOffTop(_areYouSureSprite);
		}
		
		private function onSureNoBtnClicked():void
		{
			TweenManager.tweenOffTop(_areYouSureSprite);
			
		}
		
		private function buildScreen():void
		{
			
			_shopSprite = new Sprite;
			this.addChild(_shopSprite);
			
			_shopPopup = new Image(Assets.fullPopupTest);
			_shopSprite.addChild(_shopPopup);
			
			_santa = new Image(Assets.santa);
			_shopSprite.addChild(_santa);
			_santa.x = 627;
			_santa.y = 260;
			
			var moneyBox:Image = new Image(Assets.moneyBox);
			_shopSprite.addChild(moneyBox);
			
//			var shopPreviewArea:Image = new Image(Assets.shopPreviewArea);
//			_shopSprite.addChild(shopPreviewArea);
//			shopPreviewArea.x = 360;
//			shopPreviewArea.y = 200;
			
			var shopUpgradeArea:Image = new Image(Assets.shopUpgradeArea);
			_shopSprite.addChild(shopUpgradeArea);
			shopUpgradeArea.x = 360;
			shopUpgradeArea.y = 200;
			
			
			var titleTF:TextField = new TextField(450, 200, "SHOP" , "BasicWhiteFont", 50, 0xFFFFFF);
			titleTF.hAlign = "center";
			titleTF.x = 200;
			titleTF.y = -40;
			_shopSprite.addChild(titleTF);
			
			var powerUpTitle:TextField = new TextField(450, 200, "Upgrade Chart" , "BasicWhiteFont", 30, 0xFFFFFF);
			powerUpTitle.hAlign = "left";
			powerUpTitle.x = 406;
			powerUpTitle.y = 70;
			_shopSprite.addChild(powerUpTitle);
			
			var attribute1:TextField = new TextField(150, 40, "attibute1" , "BasicWhiteFont", 18, 0xFFFFFF);
			attribute1.hAlign = "center";
			attribute1.x = 406;
			attribute1.y = 204;
			_shopSprite.addChild(attribute1);
			
			var attribute1value:TextField = new TextField(150, 40, "GG" , "BasicWhiteFont", 18, 0xFFFFFF);
			attribute1value.hAlign = "center";
			attribute1value.x = 506;
			attribute1value.y = 204;
			_shopSprite.addChild(attribute1value);
			
			var attribute2:TextField = new TextField(150, 40, "attribute2" , "BasicWhiteFont", 18, 0xFFFFFF);
			attribute2.hAlign = "center";
			attribute2.x = 406;
			attribute2.y = 256;
			_shopSprite.addChild(attribute2);
			
			var attribute2value:TextField = new TextField(150, 40, "GG" , "BasicWhiteFont", 18, 0xFFFFFF);
			attribute2value.hAlign = "center";
			attribute2value.x = 506;
			attribute2value.y = 256;
			_shopSprite.addChild(attribute2value);
			
			var buyCurrencyBtn:Button = new Button();
			buyCurrencyBtn.defaultSkin = new Image(Assets.addMoneyBtn);
			buyCurrencyBtn.label = "G";
			buyCurrencyBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			buyCurrencyBtn.x = 160
			buyCurrencyBtn.y = 20
			buyCurrencyBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_shopSprite.addChild(buyCurrencyBtn);
			buyCurrencyBtn.addEventListener(starling.events.Event.TRIGGERED, onBuyCurencyBtnClicked)
				
			
			
			var setPowerupsBtn:Button = new Button();
			setPowerupsBtn.defaultSkin = new Image(Assets.greenBtnT);
			setPowerupsBtn.label = "Set Powerups";
			setPowerupsBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			setPowerupsBtn.x = 686
			setPowerupsBtn.y = 550
			setPowerupsBtn.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_shopSprite.addChild(setPowerupsBtn);
			setPowerupsBtn.addEventListener(starling.events.Event.TRIGGERED, onSetPowerupsBtnClicked)
			
			var quitBtn:Button = new Button();
			quitBtn.defaultSkin = new Image(Assets.greenBtnT);
			quitBtn.label = "QUIT";
			quitBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			quitBtn.x = 100
			quitBtn.y = 550
			quitBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_shopSprite.addChild(quitBtn);
			quitBtn.addEventListener(starling.events.Event.TRIGGERED, onQuitBtnClicked)
			
			var buyItemBtn:Button = new Button();
			buyItemBtn.defaultSkin = new Image(Assets.greenBtnT);
			buyItemBtn.label = "Upgrade";
			buyItemBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			buyItemBtn.x = 360
			buyItemBtn.y = 358
			buyItemBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_shopSprite.addChild(buyItemBtn);
			buyItemBtn.addEventListener(starling.events.Event.TRIGGERED, onbuyItemBtnClicked)
			
			var achievementsBtn:Button = new Button();
			achievementsBtn.defaultSkin = new Image(Assets.greenBtnT);
			achievementsBtn.label = "Achievements";
			achievementsBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			achievementsBtn.x = 660
			achievementsBtn.y = 160;
			achievementsBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_shopSprite.addChild(achievementsBtn);
			achievementsBtn.addEventListener(starling.events.Event.TRIGGERED, onAchievementsBtnClicked)
			
			
			
		}
		
		private function onbuyItemBtnClicked():void
		{
			TweenLite.to(_areYouSureSprite, 1, {y:10});
		}
		
		
		
		private function onBuyCurencyBtnClicked():void
		{
			trace("buy clcked");
			_mainView.changeState(DcMainView.BUY_CURRENCY_STATE);
			
		}
		
		private function onAchievementsBtnClicked():void
		{
			_mainView.changeState(DcMainView.ACHIEVEMENTS_STATE);
		}
		
		private function onQuitBtnClicked():void
		{
			
			_mainView.changeState(DcMainView.LOAD_GAME_STATE);
			
		}
		
		private function onSetPowerupsBtnClicked():void
		{
			_mainView.changeState(DcMainView.SET_POWERUP_STATE);
		}
		
		public function update():void
		{
		}
		
		public function destroy():void
		{
			
			_shopSprite.removeFromParent(true);
		}
	}
}