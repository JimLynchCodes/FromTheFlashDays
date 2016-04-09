package pre_game.src.helpers
{
	
	import flash.display.Sprite;
	
	import playerio.Connection;
	import playerio.Message;
	
	import pre_game.src.PowerupDisplayController;
	import pre_game.src.model.PreGameModelo;
	
	
	public class PlayerioMessageManager extends Sprite
	{
		private static var instance:PlayerioMessageManager;
		private static var allowInstantiation:Boolean;
		private static var _connection:Connection;
		private var _powerupDisplayController:PowerupDisplayController;
		private var _preGameModel:PreGameModelo;
		
		public function PlayerioMessageManager()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
			
		}
		
		
		public static function getInstance(connection:Connection):PlayerioMessageManager {
			if (instance == null) {
				allowInstantiation = true;
				_connection = connection;
				
				instance = new PlayerioMessageManager();
				
				
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
			
			
		}
		
		
		private function assignVars():void
		{
			_powerupDisplayController = PowerupDisplayController.getInstance();
			_preGameModel = PreGameModelo.getInstance();	
			
			
		}
		
		
		private function addListeners():void
		{
			_connection.addMessageHandler("TWO_PLAYERS_HAVE_ARRIVED", onMessageReceived);
			_connection.addMessageHandler("USER_INFO_OBJECT", onUserInfoObjectReceived);
			
			_connection.addMessageHandler("OPPONENT_CANCEL_CHOSEN", onUserInfoObjectReceived);
			_connection.addMessageHandler("OPPONENT_READY_CANCEL_CHOSEN", onUserInfoObjectReceived);
			_connection.addMessageHandler("OPPONENT_READY_CHOSEN", onUserInfoObjectReceived);
			_connection.addMessageHandler("OPPONENT_CLASS_CHOSEN", onUserInfoObjectReceived);
			_connection.addMessageHandler("OPPONENT_WANTS_TO_START_CHOSEN", onUserInfoObjectReceived);
			
			
//			connection.addMessageHandler("start", onMessageReceived);
//			connection.addMessageHandler("HelloWorld", onMessageReceived);
//			connection.addMessageHandler("userJoin", onMessageReceived);
//			connection.addMessageHandler("holla", onMessageReceived);
//			
//			connection.send("crap");
			
		}
		
		private function onUserInfoObjectReceived(m:Message):void
		{
		//	trace ("String em's" + m.getString(0) + m.getString(1), m.type);
			trace(m.type + " message received: " + m.getObject(0));
			
			trace(m.type);
		
		
				
				switch(m.type)
				{
					case "OPPONENT_READY_CANCEL_CHOSEN":
						
						_preGameModel.opponentIsReady = false;
						_preGameModel.opponentWantsToStart = false;
						trace("message received from " + m.getString(0) + " of type " + m.type);
						_powerupDisplayController.handleOpponentCancelled();
						break;
					
					case "OPPONENT_READY_CHOSEN":
						
						_preGameModel.opponentIsReady = true;
						trace("message received from " + m.getString(0) + " of type " + m.type);
						
						_powerupDisplayController.handleOpponentReady();
						break;
					
					case "OPPONENT_CLASS_CHOSEN":
						trace("opp class chosen message received from " + m.getString(0) + " of type " + m.type);
						_powerupDisplayController.displayPowerups("opponent");
						selectOpponentClassBtn(m.getString(1));
						break;
					
					case "OPPONENT_WANTS_TO_START_CHOSEN":
						trace("message received from " + m.getString(0) + " of type " + m.type);
						_powerupDisplayController.handleOpponentWantsToStart();
						break;
					
					case "":
						trace("message received from " + m.getString(0) + " of type " + m.type);
						break;
					
					default :
						trace("unrecognized message received from " + m.getString(0) + " of type " + m.type);
						break;
				}
			
			
			// check for both players ready
			if (m.type == "OPPONENT_READY_CHOSEN" && m.getString(0) == _preGameModel.myName) {
				
				if (_preGameModel.opponentIsReady)
				{
					// do the things that happen when both players are ready
					_powerupDisplayController.handleOpponentReady();
				}
				
				
			}
			
			
		
		}
		
		private function selectOpponentClassBtn(btnClicked:String):void
		{
			trace("opponent saw his bunnton click name as  " + btnClicked);
			
			switch(btnClicked)
			{
				case "classBtn1" :
					_powerupDisplayController.selectOpponentClassBtn(1)
					break;
				
				case "classBtn2" :
					_powerupDisplayController.selectOpponentClassBtn(2)
					break;
				
				case "classBtn3" :
					_powerupDisplayController.selectOpponentClassBtn(3)
					break;
				
				case "classBtn4" :
					_powerupDisplayController.selectOpponentClassBtn(4)
					break;
				
				case "classBtn5" :
					_powerupDisplayController.selectOpponentClassBtn(5)
					break;
				
				
			}
			
		}		
		
		private function onMessageReceived(m:Message):void
		{
			trace("message received: " + m.type);
		}		
		
	}	
}