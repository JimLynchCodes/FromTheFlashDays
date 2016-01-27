package com.gamebook.lobby.ui
{
	import com.gamebook.model.StorageModel;
	import com.greensock.TweenLite;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class BuyMorePopup extends Sprite
	{
		
		public static const IN_Y:int = 16;
		public static const OUT_Y:int = -600;
		
		private var xPos:int = 63;
		private static var instance:BuyMorePopup;
		private static var allowInstantiation:Boolean;
		private var backBtn:SimpleButton;
		private var $20selectBtn:SimpleButton;
		private var $10selectBtn:SimpleButton;
		private var $5selectBtn:SimpleButton;
		private var $2selectBtn:SimpleButton;
		private var $1selectBtn:SimpleButton;
		
		
		
		public function BuyMorePopup()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
		}
		
		public function init():void
		{
			trace("init");
			
			assignVars();
			addListeners();
			
			backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);
		}		
		
		private function assignVars():void
		{
			
			var buyMoreAsset:BuyMorePopupAsset = new BuyMorePopupAsset;
			addChild(buyMoreAsset);
			
			backBtn = SimpleButton(buyMoreAsset["backBtn"]);
			$1selectBtn = SimpleButton(buyMoreAsset["select1"]);
			$2selectBtn = SimpleButton(buyMoreAsset["select2"]);
			$5selectBtn = SimpleButton(buyMoreAsset["select5"]);
			$10selectBtn = SimpleButton(buyMoreAsset["select10"]);
			$20selectBtn = SimpleButton(buyMoreAsset["select20"]);
			// TODO Auto Generated method stub
			
		}
		
		private function addListeners():void
		{
			$1selectBtn.addEventListener(MouseEvent.CLICK, onBuyBtnClick);
			$2selectBtn.addEventListener(MouseEvent.CLICK, onBuyBtnClick);
			$5selectBtn.addEventListener(MouseEvent.CLICK, onBuyBtnClick);
			$10selectBtn.addEventListener(MouseEvent.CLICK, onBuyBtnClick);
			$20selectBtn.addEventListener(MouseEvent.CLICK, onBuyBtnClick);
			
		}
		
		protected function onBuyBtnClick(event:MouseEvent):void
		{
			trace("select button clicked" + event.currentTarget.name)
			
			var amount:String = new String;
			var currency:String = new String;
			var itemName:String = new String;
			
			
			switch(event.currentTarget.name)
			{
				case "select1":
					amount = "100";
					currency = "USD"
					itemName = "100 Diamonds"
					break;
				
				case "select2":
					amount = "215";
					currency = "USD"
					itemName = "215 Diamonds"
					break;
				
				case "select5":
					amount = "625";
					currency = "USD"
					itemName = "625 Diamonds"
					break;
				
				case "select10":
					amount = "1400";
					currency = "USD"
					itemName = "1400 Diamonds"
					break;
				
				case "select20":
					amount = "3200";
					currency = "USD"
					itemName = "3200 Diamonds"
					break;
				
			}

					navigateToURL(new URLRequest("http://api.playerio.com/payvault/paypal/coinsredirect?gameid=study-battle-rzw9dxleqeqxturzz5nbyg&connectuserid=" + StorageModel.myUsername + "&connection=public&coinamount=" + amount +" + &currency=" + currency + "&item_name=" + itemName + ""), "_blank")
			
			
			
		}
		
		protected function onBackBtnClick(event:MouseEvent):void
		{
			flyTo(OUT_Y);
		}
		
		public static function getInstance():BuyMorePopup {
			if (instance == null) {
				allowInstantiation = true;
				
				instance = new BuyMorePopup();
				
				allowInstantiation = false;
			}
			
			return instance;
		}
		
		
		public function flyTo(yPos:int):void
		{
//			TweenLite.to(this, 3, {y:yPos});
			this.y = yPos;
			this.x = xPos;
		}
		
		
		
		
	}
}

