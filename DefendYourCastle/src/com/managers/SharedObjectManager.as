package com.managers
{
	
	import flash.net.SharedObject;
	
	public class SharedObjectManager
	{
		public var so:SharedObject;
		
		private static var instance				: SharedObjectManager;
		private static var allowInstantiation	: Boolean;
		
		private const LOCAL_OBJECT_NAME			: String = 'zombieflambe_demo';
		
		/***
		 * Gets the singleton instance of SharedObjectManager or creates a new one
		 */
		public static function getInstance():SharedObjectManager {
			if (instance == null) {
				allowInstantiation = true;
				
				instance = new SharedObjectManager();
				
				allowInstantiation = false;
			}
			return instance;
		}
		
		public function SharedObjectManager() {
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
		}
		
		
		private function init():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		
		
		
		
		
	}
}