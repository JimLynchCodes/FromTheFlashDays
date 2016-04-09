package pre_game.src.helpers
{
	
	import flash.display.Sprite;
	
	import playerio.Client;
	import playerio.DatabaseObject;
	import playerio.PlayerIOError;
	
	import pre_game.src.model.PreGameModelo;
	
	
	public class PlayerioDbCall extends Sprite
	{
		private static var instance:PlayerioDbCall;
		private static var allowInstantiation:Boolean;
		private static var _pioClient:Client;
		private static var _textDisplayer:TextDisplayer;
		private var _preGameModel:PreGameModelo;
		
		public function PlayerioDbCall()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
			
		}
		
		
		public static function getInstance(client: Client, preGameScreen:PreGameScreen):PlayerioDbCall {
			if (instance == null) {
				allowInstantiation = true;
				
				instance = new PlayerioDbCall();
				_textDisplayer = TextDisplayer.getInstance(preGameScreen);
				
				_pioClient = client;
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
		
		
		public function pullPlayerInfo(playerName : String):void
		{
			trace("setting player infor for: " + playerName);
			
			_pioClient.bigDB.loadMyPlayerObject(onDatabaseCall, errorHandler);
			
			
		}
		
		private function onDatabaseCall (o:DatabaseObject):void {
			//Success!
			//The user is now registered and connected.
			
			trace("on db call " + o);
		//	trace("nameo " + o.something);
			//trace("woAH " + o.coolGuyOb["obString"]);
//			trace("woAH " + o.coolGuyOb["innerOb"]["loopa"]);
			trace("o ob name" + o.name);
			
			trace(" ohh " + o.key);
		//	_textDisplayer.displayInfoFromDbObject(o);
			
			// put the information in my textfields
			
			
		}
		
		private function errorHandler(error:PlayerIOError):void
		{
			trace("room error " + error);	
			
		}
		
		private function assignVars():void
		{
			_preGameModel = PreGameModelo.getInstance();
				
		}
		
		
		private function addListeners():void
		{
			
			
		}
		
		
	}	
}