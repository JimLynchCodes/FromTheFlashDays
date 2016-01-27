package com.gamebook.lobby.states
{
	
//	import com.gamebook.dig.elements.Item;
	import com.electrotank.electroserver5.ElectroServer;
	import com.gamebook.dig.elements.Trowel;
	import com.gamebook.lobby.Lobby;
	import com.gamebook.lobby.LobbyFlow;
	import com.gamebook.lobby.Main;
	import com.gamebook.lobby.ui.BuyMorePopup;
	import com.gamebook.lobby.ui.ItemButton;
	import com.gamebook.model.StorageModel;
	import com.gamebook.util.PhpManager;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	import flash.ui.Mouse;
	
	import playerio.Client;
	
	public class ShopState extends Sprite implements IState
	{
		private var _lobbyFlow:LobbyFlow;
		private var shopScreen:ShopScreenAsset;
		private var userTrowel:Trowel;
		private var buyMoreCurrencyBtn:SimpleButton;
		private var buyWith$Btn:SimpleButton;
		private var buyWithCoinsBtn:SimpleButton;
		private var equipBtn:SimpleButton;
		private var backBtn:SimpleButton;
		private var itemDescriptionTF:TextField;
		private var itemTitle:TextField;
		private var dollarCostTF:TextField;
		private var coinCostTF:TextField;
		private var pageTF:TextField;
		private var rightArrowBtn:SimpleButton;
		private var leftArrowBtn:SimpleButton;
		private var content:Object;
		private var _itemBtnAry:Array = [];
		private var loadedCursors:ApplicationDomain;
		private var _myUsername:String;
		private var _es:ElectroServer;
		private var phpManager:PhpManager;
		private var buyMorePopup:BuyMorePopup;
		private var _currentCoinCost:int;
		private var _currentDatabaseVar:String;
		private var cantAffordTF:TextField;
		private var _currentClassName:String;
		private var currentTrowelClass:Class;
		private var currentTrowelClassName:String;
		private var tipLevelRequirementTF:TextField;
		private var tipItemNameTF:TextField;
		private var tipDollarPriceTF:TextField;
		private var tipCoinPriceTF:TextField;
		private var toolTip:Sprite;
		private var itemContainer:Sprite;
		private var hoveringItem:Boolean;
		private var currentPage:int = 1;
		private var currentPageTF:TextField;
		private var totalPagesTF:TextField;
		private var jsonArray:Object;
		private var jsonObjLength:int;
		private var totalPages:int;
		private var itemBtnsOutAry:Array = [];
		private var currentOffsetY:Number;
		private var currentOffsetX:Number;
		private var hWinsTF:TextField;
		private var hExpTF:TextField;
		private var hLevelTF:TextField;
		private var hDiamondsTF:TextField;
		private var hCoinsTF:TextField;
		private var c:Client;
		private var _currentDollarCost:int;
		
		
		public function ShopState(lobbyFlow:LobbyFlow, es:ElectroServer)
		{
			_es = es;
			_lobbyFlow = lobbyFlow;
			trace("shop stating");

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		
			
		}
		
		protected function onAddedToStage(event:Event):void
		{
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeft);
			init();
		}
		
		protected function mouseLeft(event:Event):void
		{
			userTrowel.visible = false;
		}
		
		private function init():void
		{
			assignVars();
		
			addListeners();
			
			loadCursorSwf();
			
		}
		
		private function addListeners():void
		{
			backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);
			buyMoreCurrencyBtn.addEventListener(MouseEvent.CLICK, onBuyMoreCurrencyBtnClick);
			buyWithCoinsBtn.addEventListener(MouseEvent.CLICK, onBuyWithCoinsBtnClick);
			equipBtn.addEventListener(MouseEvent.CLICK, onEquipBtnClick);
			
			leftArrowBtn.addEventListener(MouseEvent.CLICK, onArrowBtnClick);
			rightArrowBtn.addEventListener(MouseEvent.CLICK, onArrowBtnClick);
			
		}
		
		protected function onArrowBtnClick(event:MouseEvent):void
		{
			removeCurrentItemBtns();
			
			switch(event.currentTarget.name)
			{
				case "leftArrowBtn":
					trace("leftArrow clicked" + currentPage);					
					
					if (currentPage > 1)
					{
						currentPage--;
						currentPageTF.text = "" + currentPage;
					}
					
					break ;
					
				case "rightArrowBtn":

					if (currentPage < totalPages)
					{
						currentPage++;
						currentPageTF.text = "" + currentPage;
					}
					
					trace("rightArrow clicked" + currentPage);					
					break;
			}

			
		
			addChosenItemBtns();
		
		}
		
		private function addChosenItemBtns():void
		{
			var beginIndex:int = (currentPage - 1) * 9;
			
			for (var c:int = beginIndex; c < (beginIndex + 9); c++)
			{
				if (_itemBtnAry.length > c)
				{
					itemContainer.addChild(_itemBtnAry[c]);
					
					var slot:int = (c - beginIndex);
					
					_itemBtnAry[c].x = 23 + (slot%3) * 67;
					_itemBtnAry[c].y = 20 + Math.floor(slot/3) * 66;
					
					itemBtnsOutAry.push(_itemBtnAry[c]);
					
				}
			}
		}
		
		private function removeCurrentItemBtns():void
		{
//			var beginIndex:int = (currentPage * 9 - 1);
//			var finishIndex:int = (currentPage - 1) * 9;
//			
			for (var b:int = (itemBtnsOutAry.length - 1); b >= 0; b--)
			{
				trace("in da loop");
				if (itemBtnsOutAry[b].parent)
				{
					itemContainer.removeChild(itemBtnsOutAry[b]);
					itemBtnsOutAry.splice(b, 1);
					
				}
			}
			
		}
		
		protected function onEquipBtnClick(event:MouseEvent):void
		{
			
			equipBtn.visible = false;
			trace("currentTrowelClass " + currentTrowelClass);
			userTrowel.equipNewCursor(currentTrowelClassName);
			
			StorageModel.currentCursorClassName = currentTrowelClassName
			
			phpManager.updateSig.add(onCurrentCursorUpdated);
			phpManager.updateCurrentCursor(_myUsername, currentTrowelClassName)
				
			phpManager.offsetSetSig.add(onOffsetSet);
			
			trace("updating cursor offset " + currentOffsetX, currentOffsetY);
			phpManager.updateCursorOffset(_myUsername, currentOffsetX, currentOffsetY)
				
				StorageModel.myCurrentOffsetX = currentOffsetX;
				StorageModel.myCurrentOffsetY = currentOffsetY;
				
//			Mouse.show();
		}
		
		private function onOffsetSet(responds:Boolean):void
		{
			trace("offset has been set: " + responds);
		}
		
		private function onCurrentCursorUpdated(success:Boolean):void
		{
			trace("update trowel worked?: " + success);
			phpManager.updateSig.remove(onCurrentCursorUpdated);
		}
		
		protected function onBuyWithCoinsBtnClick(event:MouseEvent):void
		{
			
			phpManager.enoughCoinsCheckSig.add(onEnoughCoinsChecked);
			phpManager.checkIfHasEnoughCoins(_myUsername, _currentCoinCost)
		
			
		}
		
		private function onEnoughCoinsChecked(exists:Boolean):void
		{
			
			trace("exists" + exists);
			if (exists)
			{
				trace("you can afford it");
				
				 phpManager.subtractAmountFromCoins(_myUsername, _currentCoinCost);
				
				 phpManager.unlockSig.add(onItemUnlocked);
				 phpManager.unlockItem(_myUsername, _currentDatabaseVar);
				 
				 trace("subtracting off " + _currentCoinCost);
				 StorageModel.myCoins = StorageModel.myCoins - _currentCoinCost;
				
			}
			else
			{
				trace("you can't afford it");
				cantAffordTF.visible = true;
			}
		}
		
		private function onItemUnlocked(exists:Boolean):void
		{
			if (exists)
			{
				trace("item unlocked alright");
				buyWith$Btn.visible = false;			
				buyWithCoinsBtn.visible = false;			
				equipBtn.visible = true;	  
				
				hCoinsTF.text = "" + StorageModel.myCoins;
				
			}
			else
			{
				trace("problem unlocking item");
				
			}
		}
		
		protected function onBuyMoreCurrencyBtnClick(event:MouseEvent):void
		{
			buyMorePopup = BuyMorePopup.getInstance();
			this.addChild(buyMorePopup);
			buyMorePopup.flyTo(BuyMorePopup.IN_Y);
			
			setTrowelToFront();
			
		}
		
		protected function onBackBtnClick(event:MouseEvent):void
		{
			_lobbyFlow.changeState(LobbyFlow.LOBBY_STATE);
			
			_lobbyFlow.reFreshSig.dispatch();
//			this.parent.removeChild(this);
			
			
			
		}
		
		private function setTrowelToFront():void
		{
			this.setChildIndex(userTrowel, numChildren - 1);
		}
		
		private function loadCursorJson():void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			request.url = "https://s3.amazonaws.com/FirstBucketJim/cursorData.json";
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
			jsonArray = JSON.parse(loader.data);
			
			trace(jsonArray.list);
			jsonObjLength = jsonArray.items.length
			trace("length " + jsonObjLength);
			
//			var yPosition:Number = 0;
			
			totalPages = Math.ceil(jsonObjLength / 9);
			totalPagesTF.text = "" + totalPages;
			
			
			createAllItemButtons();
			
			
			displayFirstNineItemBt1ns();
			
			
//			for (var i:int = 0; i < _itemBtnAry.length; i++)
//			{
//				trace("clas names" + _itemBtnAry[i].itemClassName);
//				
//				if (_itemBtnAry[i].itemClassName == "GreenTrowel")
//				{
//					_itemBtnAry[i].bg.addChild(greenTrowel);
//					trace("ADDING GREEN TROWEL TO BG");
//				}
//				
//				if (_itemBtnAry[i].levelToUnlock <= StorageModel.myLevel)
//				{
//					_itemBtnAry[i].lockLayer.visible = false;
//				}
//				
//				
//			}
			
		}
		
		private function displayFirstNineItemBt1ns():void
		{
			for (var j:int = 0; j < 9 ; j++)
			{
				
				itemContainer.addChild(_itemBtnAry[j]);
				itemBtnsOutAry.push(_itemBtnAry[j]);
				
				
			}
			
			
		}
		
		private function createAllItemButtons():void
		{
			for (var i:int = 0; i < jsonObjLength; i++)
			{
				var tempItemBtn:ItemButton = new ItemButton(); 
				
				trace("x: " + tempItemBtn.x + " y: " + tempItemBtn.y);
				tempItemBtn.itemName = jsonArray.items[i].ItemName
				tempItemBtn.description = jsonArray.items[i].Description
				tempItemBtn.coinCost = jsonArray.items[i].coinCost
				tempItemBtn.dollarCost = jsonArray.items[i].dollarCost
				tempItemBtn.itemClassName = jsonArray.items[i].itemClassName
				tempItemBtn.databaseVar = jsonArray.items[i].databaseVar
				tempItemBtn.levelToUnlock = jsonArray.items[i].levelToUnlock
				tempItemBtn.offsetX = jsonArray.items[i].xOffset;
				tempItemBtn.offsetY = jsonArray.items[i].yOffset;
				
				trace("tempItemBtn stuff", tempItemBtn.itemName, tempItemBtn.description, tempItemBtn.coinCost, tempItemBtn.itemClassName);
//				itemContainer.addChild(tempItemBtn);
				//				tempItemBtn.x = 22;
				//				tempItemBtn.y = 165;
				
				_itemBtnAry.push(tempItemBtn);
				
				tempItemBtn.bg.addEventListener(MouseEvent.CLICK, onItemBtnClick);
				
				currentTrowelClass = loadedCursors.getDefinition(tempItemBtn.itemClassName) as Class;
				var tempTrowel:MovieClip = new currentTrowelClass();
				
				trace("column " + i%3);
				tempItemBtn.x = 23 + (i%3) * 67;
				tempItemBtn.y = 20 + Math.floor(i/3) * 66;
				
				
				tempItemBtn.bg.addChild(tempTrowel);
				tempTrowel.x = jsonArray.items[i].xOffset;
				tempTrowel.y = jsonArray.items[i].yOffset;
				
				
				
				trace("level t ounlock :" + tempItemBtn.levelToUnlock + " and my level: " + StorageModel.myLevel)
				
				if (tempItemBtn.levelToUnlock > StorageModel.myLevel)
				{
					tempItemBtn.lockLayer.visible = true;
					
					tempItemBtn.addEventListener(MouseEvent.ROLL_OVER, onLockRollOver);
					tempItemBtn.addEventListener(MouseEvent.ROLL_OUT, onLockRollOut);
				}
				else
				{
					tempItemBtn.lockLayer.visible = false;
				}
				
			}
			
		}
		
		protected function onLockRollOut(event:MouseEvent):void
		{
			toolTip.visible = false;
			hoveringItem = false;
			
		}
		
		protected function onLockRollOver(event:MouseEvent):void
		{
			trace("test item name " + event.currentTarget.itemName + "tipItemNameTF" + tipItemNameTF);
			
			toolTip.visible = true;
			toolTip.x = mouseX;  
			toolTip.y = mouseY;  
			
			hoveringItem = true;
			
			tipItemNameTF.text = event.currentTarget.itemName;
			tipCoinPriceTF.text = "C: " + event.currentTarget.coinCost;
			tipDollarPriceTF.text = "" + event.currentTarget.dollarCost;
			tipLevelRequirementTF.text = "Reach level " + event.currentTarget.levelToUnlock + " to unlock.";
		}
		
		protected function onItemBtnClick(event:MouseEvent):void
		{
//			trace("clicked " + event.currentTarget.name);
//			trace("clicked " + event.currentTarget.parent.parent.itemName);
//			trace("clicked " + event.currentTarget.parent);
			trace("clicked " + event.currentTarget.parent.parent);
			trace("clicked " + event.target.parent.parent); 
//			trace("clicked " + event.target.parent); 
//			trace("clicked " + event.target.parent.name); 

			var itemButton:ItemButton = event.currentTarget.parent.parent as ItemButton;
			
			trace("item button name " + itemButton.itemName);
			
			trace("clicked " + event.currentTarget.parent.parent.itemName);
			trace("clicked " + event.target.parent.parent.itemName); 

			
			
			
			
			
			//			trace("clicked " + event.currentTarget.itemName);
////			trace("clicked " + event.currentTarget.name);
//			trace("clicked " + event.currentTarget.name);
			
//			trace
						
			for (var i:int = 0; i < _itemBtnAry.length; i++)
			{
				
				if (_itemBtnAry[i].bg == event.currentTarget)
				{
					_itemBtnAry[i].itemName;
					trace("match muhfuckin found " + i + _itemBtnAry[i] + _itemBtnAry[i].dollarCost + _itemBtnAry[i].itemName);
				
					_myUsername = _es.managerHelper.userManager.me.userName;
					
					
					itemDescriptionTF.text = _itemBtnAry[i].description;
					
					coinCostTF.text = _itemBtnAry[i].coinCost
					dollarCostTF.text = _itemBtnAry[i].dollarCost
					itemTitle.text = _itemBtnAry[i].itemName
						
					_currentCoinCost = _itemBtnAry[i].coinCost;
					_currentDollarCost = _itemBtnAry[i].dollarCost
					_currentDatabaseVar = _itemBtnAry[i].databaseVar;
					_currentClassName = _itemBtnAry[i].itemClassName
					currentTrowelClassName = _itemBtnAry[i].itemClassName;
					currentOffsetX = _itemBtnAry[i].offsetX;
					currentOffsetY = _itemBtnAry[i].offsetY;
					
				phpManager = PhpManager.getInstance();
				phpManager.cursorCheckSig.add(onCursorOwnershipChecked);
				
				trace("php manager checking: " + _myUsername, _itemBtnAry[i].databaseVar);
				phpManager.checkIfCursorOwned(_myUsername, _itemBtnAry[i].databaseVar);
				
				}
				
			}
			
		}
		
		private function onCursorOwnershipChecked(owns:int):void
		{
			
			trace("owns" + owns) 
			
			if (owns == 1)
			{
				
				// if currently equipped
				
				equipBtn.visible = true;
				buyWith$Btn.visible = false;
				buyWithCoinsBtn.visible = false;	
			
				// else
			
			}
			else
			{
				equipBtn.visible = false;
				buyWith$Btn.visible = true;
				buyWithCoinsBtn.visible = true;
				
				
				
			}
			
			
			
		}
		
		private function loadCursorSwf():void
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			Security.loadPolicyFile("https://s3.amazonaws.com/FirstBucketJim/crossdomain2.xml");
			var loader:Loader = new Loader();
			
//		
			var _lc:LoaderContext = new LoaderContext();
			_lc.checkPolicyFile = true;
			_lc.applicationDomain = ApplicationDomain.currentDomain;
			if (Main.PRODUCTION)
			{
				_lc.securityDomain = SecurityDomain.currentDomain;			
				
			}
			loader.contentLoaderInfo.addEventListener ( flash.events.Event.COMPLETE, onComplete );
			loader.contentLoaderInfo.addEventListener ( flash.events.ProgressEvent.PROGRESS, onProgress);
			loader.load(new URLRequest("https://s3.amazonaws.com/FirstBucketJim/cursors2.swf"), _lc);
		
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function onComplete(event:Event):void
		{
			trace("swf loaded!" + event.target.applicationDomain);
			
			content = event.currentTarget.content as MovieClip;
			
			loadedCursors = event.target.applicationDomain
			
//			var GreenTrowel:Class = event.target.applicationDomain.getDefinition("GreenTrowel") as Class;
			
//			var greenTrowel:MovieClip = new GreenTrowel() as MovieClip;
			
//			addChild(greenTrowel);
			
			
			loadCursorJson();

			
			setTrowelToFront();
		}
		
		private function assignVars():void
		{
			shopScreen = new ShopScreenAsset();	
			addChild(shopScreen);
			
//			phpManager = PhpManager.getInstance();
//			phpManager.cursorCheckSig.add(onCursorClassCheck);
//			phpManager.getCurrentCursorClass(_myUsername);
			
			userTrowel = new Trowel(StorageModel.currentCursorClassName);
			addChild(userTrowel);
			
			leftArrowBtn = SimpleButton(shopScreen["leftArrowBtn"])
			rightArrowBtn = SimpleButton(shopScreen["rightArrowBtn"])
			currentPageTF = TextField(shopScreen["currentPageTF"])
			totalPagesTF = TextField(shopScreen["totalPagesTF"])
			
//			item squares
			
			coinCostTF = TextField(shopScreen["coinCostTF"])
			dollarCostTF = TextField(shopScreen["dollarCostTF"])
			
			itemTitle = TextField(shopScreen["itemTitle"])
			cantAffordTF = TextField(shopScreen["cantAffordTxt"])
			cantAffordTF.visible = false;
//			itemPreview = Sprite(shopScreen["itemPreview"])
			itemDescriptionTF = TextField(shopScreen["itemDescription"])
			
			backBtn = SimpleButton(shopScreen["backBtn"])
			
			equipBtn = SimpleButton(shopScreen["equipBtn"])
			buyWithCoinsBtn = SimpleButton(shopScreen["buyWithCoinsBtn"])
			buyWith$Btn = SimpleButton(shopScreen["buyWith$Btn"])
				buyWith$Btn.addEventListener(MouseEvent.CLICK, onBuyWithDiamondsClick);
			equipBtn.visible = false;
			buyWithCoinsBtn.visible = false;
			buyWith$Btn.visible = false;
			
			buyMoreCurrencyBtn = SimpleButton(shopScreen["buyMoreCurrencyBtn"])
			
			toolTip = Sprite(shopScreen["shopToolTip"]);
			toolTip.mouseChildren = false;
			toolTip.mouseEnabled = false;
				
			tipCoinPriceTF = TextField(shopScreen["shopToolTip"]["tipCoinPrice"]);
			tipDollarPriceTF = TextField(shopScreen["shopToolTip"]["tipDollarPriceTxt"]);
			tipItemNameTF = TextField(shopScreen["shopToolTip"]["tipItemNameTxt"]);
			tipLevelRequirementTF = TextField(shopScreen["shopToolTip"]["tipLevelRequirementTxt"]);
			
			hCoinsTF = TextField(shopScreen["header"]["coinsTxt"]);
			hDiamondsTF = TextField(shopScreen["header"]["diamondsTxt"]);
			hLevelTF = TextField(shopScreen["header"]["levelTxt"]);
			hExpTF = TextField(shopScreen["header"]["expTxt"]);
			hWinsTF = TextField(shopScreen["header"]["winsTxt"]);
			
			hCoinsTF.text = "" + StorageModel.myCoins
//			hDiamondsTF.text = StorageModel.my
			hLevelTF.text = "Lvl: " + StorageModel.myLevel
			hExpTF.text = "Exp: " + StorageModel.myExp + " / " + StorageModel.expToNextLevel;
			hWinsTF.text = "Wins: " + StorageModel.myWins
				
			if (!StorageModel.iAmGuest)
			{
				// display diamonds
				c = StorageModel.playerIOClient;
				
				c.payVault.refresh(onRefreshedOk, onRefreshFail);
				function onRefreshedOk():void
				{
					trace(" I have " + c.payVault.coins);
					hDiamondsTF.text = "" + c.payVault.coins;
				}
				function onRefreshFail():void
				{
					trace("refresh diamonds failed");
				}
			}
			
			itemContainer = Sprite(shopScreen["itemContainer"]);
		}
		
		protected function onBuyWithDiamondsClick(event:MouseEvent):void
		{
			if (!StorageModel.iAmGuest)
			{
				c = StorageModel.playerIOClient;
				
				c.payVault.debit(_currentDollarCost, "buying item", debitOk, debitFail);
				function debitOk():void
				{
					trace("After debit I have " + c.payVault.coins);
					hDiamondsTF.text = "" + c.payVault.coins;
//					buyWith$Btn.visible = false;
//					buyWithCoinsBtn.visible = false;
//					equipBtn.visible = true;
					
					phpManager.unlockSig.add(onItemUnlocked);
					phpManager.unlockItem(_myUsername, _currentDatabaseVar);
					
				}
				function debitFail():void
				{
					trace("refresh diamonds failed");
				}
				
			}

			
			
		}
		
//		private function onCursorClassCheck(cursorClassName:String):void
//		{
//			trace("responded alright " + cursorClassName);
//			userTrowel = new Trowel(cursorClassName);
//			addChild(userTrowel);
//			Mouse.hide();
//		}
		
		private function mouseMoved(e:MouseEvent):void {
			updateTrowelPosition();
			e.updateAfterEvent();
			
			if (hoveringItem)
			{
				toolTip.x = mouseX;
				toolTip.y = mouseY;
			}
		}
		
		private function updateTrowelPosition():void{
			//			if (!_trowel.digging) {
			userTrowel.visible = true;
			userTrowel.x = mouseX;
			userTrowel.y = mouseY;
			//			}
		}
		
		public function update():void
		{
		}
		
		public function destroy():void
		{
		}
	}
}