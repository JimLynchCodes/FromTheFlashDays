package inner_game.src.views
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import inner_game.src.model.InnerGameModel;
	
	public class QuitPopup
	{
		
		private static var instance:QuitPopup;
		private static var allowInstantiation:Boolean;
		private var _inGameModel:InnerGameModel;
		private var _quitPopup:Sprite;
		private var _noBtn:Sprite;
		private var _yesBtn:Sprite;
		
		
		public function QuitPopup()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
			
		}
		
		public static function getInstance():QuitPopup			
		{
			if (instance == null) {
				allowInstantiation = true;
				instance = new QuitPopup();
				
				allowInstantiation = false;
//				trace("in pre game model");
			}
			return instance;
		}
		
		private function init():void
		{
			assignVars();
			addListeners();
		}
		
		private function addListeners():void
		{
			_yesBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void
		{
			_quitPopup.y = 1000;
		}
		
		private function assignVars():void
		{
			_quitPopup = _inGameModel.inGameScreen["quitPopup"];
			_yesBtn = _quitPopup["yesBtn"];
			_noBtn = _quitPopup["noBtn"];
		}		
		
		public function displaySelf():void
		{
			_quitPopup.y = 95;
			_quitPopup.x = 225;
		}
		
		
		
	}
}



