package com.gamebook.util
{
	import com.gamebook.dig.elements.UserTrowel;
	
	import flash.display.Sprite;
	
	public class SingletonSprite extends Sprite
	{
		
		
		private static var instance:UserTrowel;
		private static var allowInstantiation:Boolean;
		
		
		
		public function SingletonSprite()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
		}
		
		public function init():void
		{
			// TODO Auto Generated method stub
			
		}		
		
		public static function getInstance():UserTrowel {
			if (instance == null) {
				allowInstantiation = true;
				
				instance = new UserTrowel();
				
				allowInstantiation = false;
			}
			
			return instance;
		}
		
		
	}
}