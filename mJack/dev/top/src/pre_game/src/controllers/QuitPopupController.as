package pre_game.src.controllers
{
	import com.models.Model;
	import com.utils.LoadingSprite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	public class QuitPopupController extends Sprite
	{
		private static var instance:QuitPopupController;
		private static var allowInstantiation:Boolean;
		
		public function QuitPopupController()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
			
		}
		
		
		public static function getInstance():QuitPopupController {
			if (instance == null) {
				allowInstantiation = true;
				
				instance = new QuitPopupController();
				
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
//			Model.someInteger = 5;
		}

		public function handleclick(m:MouseEvent):void
		{
			trace("handling message")

		}
		
		
		private function assignVars():void
		{
			
				
		}
		
		
		private function addListeners():void
		{
			
			
		}
		
		
	}	
}