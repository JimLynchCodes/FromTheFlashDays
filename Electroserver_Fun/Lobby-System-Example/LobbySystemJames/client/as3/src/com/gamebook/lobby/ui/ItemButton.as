package com.gamebook.lobby.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class ItemButton extends MovieClip
	{
		
		public var itemName:String;
		public var description:String;
		public var itemClassName:String;
		public var databaseVar:String;
		public var coinCost:int;
		public var dollarCost:int;
		public var levelToUnlock:int;
		
		public var lockLayer:Sprite;
		public var bg:Sprite;
		
		
		private var _itemBox:ItemBtnAsset;
		public var offsetX:Number;
		public var offsetY:Number;
		
		
		
		public function ItemButton()
		{
			init();			
		}
		
		private function init():void
		{
			_itemBox = new ItemBtnAsset();	
			
			lockLayer = Sprite(_itemBox["lockLayer"]);	
			bg = Sprite(_itemBox["bg"]);	
			
			addChild(_itemBox);
		}		
		
		
	}
}