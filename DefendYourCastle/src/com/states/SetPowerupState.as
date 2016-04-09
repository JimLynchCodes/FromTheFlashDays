package com.states
{
	import com.assets.Assets;
	import com.objects.EnemyGuy;
	import com.views.DcMainView;
	
	import flash.geom.Point;
	
	import feathers.controls.Button;
	import feathers.controls.IScrollBar;
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.HorizontalLayout;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	
	public class SetPowerupState extends Sprite implements IDCState
	{
		
		private var _mainView:DcMainView;
		private var _model:Object;
		private var _setPowerupSprite:Sprite;
		private var _setPowerupPopup:Image;
		private var _slot1:Image;
		private var _slot2:Image;
		private var _slot3:Image;
		private var hContainer:ScrollContainer;
		private var _selectedSquare:Image;
		private var _offsetX:Number;
		private var _offsetY:Number;
		private var _squareAry:Array = [];
		
		public function SetPowerupState(mainView:DcMainView, model:Object)
		{
			_mainView = mainView;
			_model = model
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			trace("da main been added, sir");
			buildScreen();
			makeScrollContainer();
		}
		
		private function makeScrollContainer():void
		{
			// scroll container
			hContainer = new ScrollContainer();
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 10;
			hContainer.layout = layout;
			hContainer.x = 70;
			hContainer.y = 370;
			hContainer.width = 790;
			hContainer.height = 170;
			hContainer.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			_setPowerupSprite.addChild( hContainer );
			
			hContainer.scrollerProperties.horizontalScrollBarFactory = function():IScrollBar
			{
				var scrollBar:ScrollBar = new ScrollBar();
				//skin the scroll bar here
//				scrollBar.trackLayoutMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
				
				
				scrollBar.thumbProperties.defaultSkin = new Image( Assets.scroller );
				scrollBar.thumbProperties.downSkin = new Image( Assets.scroller );
				
				return scrollBar;
			}
			
				// fill with powerup squares
			for (var i:int = 0; i < 20; i++)
			{
				var square:Button = new Button();
				square.defaultSkin = new Image(Assets.gamePowUpBtn);
				square.defaultSelectedSkin = new Image(Assets.gamePowUpBtn);
				square.label = "" + i;
				square.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
				
				_squareAry.push(square);
//				trace(square.width);	
				
				hContainer.addChild(square);
				square.x = 20 + i * (square.defaultSkin.width + 10) 
				square.y = 20;
				square.isToggle = true;
				square.isSelected = false;
//				trace(square.height);	
				
				square.addEventListener(starling.events.Event.TRIGGERED, onSquareClicked)
				
//				square.addEventListener(TouchEvent.TOUCH, onSquareTouch)
					
			}
			
			
		}		
		
		private function onSquareClicked(e:Event):void
		{
			unSelectAllSquares();
			var square:Button = e.currentTarget as Button;
			trace("is selected " + square.isSelected);
		}
		
		private function unSelectAllSquares():void
		{
			for (var j:int = 0; j < _squareAry.length; j++)
			{
				_squareAry[j].isSelected = false;
			}
		}
		
//		private function onSquareTouch(e:TouchEvent):void
//		{
//			var touch:Touch = e.getTouch(e.target as DisplayObject);
//			var square:Image = e.currentTarget as Image;
//			//			trace("guyMC: " + guyMc);
//			
//
//			//			trace(guyMc);
//			if (touch)
//			{
//				var _fingerPos:Point = touch.getLocation(stage as DisplayObject) as Point;
//				
//				//				_isHeld = true;
////				var _fingerPos:Point = touch.getLocation(stage as DisplayObject) as Point;
//				
//				switch(touch.phase)
//				{
//					case "began":
//						trace("began");
//						_selectedSquare = square;
//						
////						var globalSquarePoint:Point = localToGlobal(new Point(square.x, square.y))
//						
//						
//						square.removeFromParent();
//						
//						_setPowerupSprite.addChild(square);
////						square.x = globalSquarePoint.x;
////						square.y = globalSquarePoint.y;
//						
//						
//						_offsetX = (_fingerPos.x - _selectedSquare.x);
//						_offsetY = (_fingerPos.y - _selectedSquare.y);
//						
//						
//						break;
//					
//					case "moved":
//						trace("moved");
//						
//						_selectedSquare.x = _fingerPos.x - _offsetX;
//						_selectedSquare.y = _fingerPos.y - _offsetY;
//						
//						break;
//					
//					
//				}
//			
//			}
//			
//		}
		
		public function update():void
		{
						
		}
		
		public function destroy():void
		{
			_setPowerupSprite.removeFromParent(true);
			
		}
		
		private function buildScreen():void
		{
			
			_setPowerupSprite = new Sprite;
			this.addChild(_setPowerupSprite);
			
			_setPowerupPopup = new Image(Assets.fullPopupTest);
			_setPowerupSprite.addChild(_setPowerupPopup);
			
			var elfGuy:Button = new Button()
			elfGuy.defaultSkin = new Image(Assets.elfGuy);
			_setPowerupSprite.addChild(elfGuy);
			elfGuy.x = 675;
			elfGuy.y = 202;
			
			_slot1 = new Image(Assets.slotty);
			_setPowerupSprite.addChild(_slot1);
			_slot1.x = 100;
			_slot1.y = 250;
			
			_slot2 = new Image(Assets.slotty);
			_setPowerupSprite.addChild(_slot2);
			_slot2.x = 250;
			_slot2.y = 250;
			
			_slot3 = new Image(Assets.slotty);
			_setPowerupSprite.addChild(_slot3);
			_slot3.x = 400;
			_slot3.y = 250;
			
			
			
			var titleTF:TextField = new TextField(450, 200, "SET POWERUPS" , "BasicWhiteFont", 50, 0xFFFFFF);
			titleTF.hAlign = "center";
			titleTF.x = 200;
			titleTF.y = -40;
			_setPowerupSprite.addChild(titleTF);
			
			var nextBtn:Button = new Button();
			nextBtn.defaultSkin = new Image(Assets.greenBtnT);
			nextBtn.label = "Next";
			nextBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			nextBtn.x = 686;
			nextBtn.y = 550;
			nextBtn.labelOffsetX = - 10; 
			//			startBtn.name = jsonArray.staff[i].RestId
			_setPowerupSprite.addChild(nextBtn);
			nextBtn.addEventListener(starling.events.Event.TRIGGERED, onNextBtnClicked)
			
			var quitBtn:Button = new Button();
			quitBtn.defaultSkin = new Image(Assets.greenBtnT);
			quitBtn.label = "Quit";
			quitBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			quitBtn.x = 100
			quitBtn.y = 550
			quitBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_setPowerupSprite.addChild(quitBtn);
			quitBtn.addEventListener(starling.events.Event.TRIGGERED, onQuitBtnClicked)
			
			var exchangeCurrencyBtn:Button = new Button();
			exchangeCurrencyBtn.defaultSkin = new Image(Assets.greenBtnT);
			exchangeCurrencyBtn.label = "Exchange Currency";
			exchangeCurrencyBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("BasicWhiteFont", 25);
			exchangeCurrencyBtn.x = 620
			exchangeCurrencyBtn.y = 108
			exchangeCurrencyBtn.labelOffsetX = - 10; 
			//			creditsBtn.name = jsonArray.staff[i].RestId
			_setPowerupSprite.addChild(exchangeCurrencyBtn);
			exchangeCurrencyBtn.addEventListener(starling.events.Event.TRIGGERED, onExchangeCurrencyBtnClicked)
				
				
			var moneyBox:Image = new Image(Assets.moneyBox);
			_setPowerupSprite.addChild(moneyBox);
			
		}
		
		
		private function onExchangeCurrencyBtnClicked():void
		{
			_mainView.changeState(DcMainView.EXCHANGE_CURRENCY_STATE);
			
		}
		
		private function onQuitBtnClicked():void
		{
			_mainView.changeState(DcMainView.SHOP_STATE);
			
		}
		
		private function onNextBtnClicked():void
		{
			_mainView.changeState(DcMainView.LEVEL_SELECT_STATE);
			
		}		
		
	}
}