package helpers
{
	import com.models.Model;
	import com.utils.LoadingSprite;
	
	import flash.display.Sprite;
	
	
	public class MusicManager extends Sprite
	{
		private static var instance:MusicManager;
		private static var allowInstantiation:Boolean;
		
		public function Singleton()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
			
		}
		
		
		public static function getInstance():MusicManager {
			if (instance == null) {
				allowInstantiation = true;
				
				instance = new MusicManager();
				
				allowInstantiation = false;
			}
			return instance;
		}

		
		private function init():void
		{
			trace("Helper Class Initialized.");
			assignVars();
			addListeners();
		}
		
			// encapsulate logic / calculations for other classes in public functions
		public static function helpOut():void
		{
			Model.someInteger = 5;
		}
		
		
		private function assignVars():void
		{
			
				
		}
		
		
		private function addListeners():void
		{
			
			
		}
		
		
	}	
}