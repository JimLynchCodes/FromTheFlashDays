package inner_game.src {
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import inner_game.src.helpers.InGameMessageManager;
	import inner_game.src.model.InnerGameModel;
	
	import playerio.Client;
	import playerio.Connection;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	
	import pre_game.src.PowerupDisplayController;
	import flash.display.Sprite;
	
	
	public class InGameMain extends MovieClip {
		
		private var _stage:Object;
		private var _inGameModel:InnerGameModel;
		
		private var _powerupDisplayController:PowerupDisplayController;
		private var _opponentInitialName:String;
		private var _myInitialName:String;
		private var _pioClient:Client;
		private var _nmconnection:Connection;
		private var _connection:Connection;
		private var _messageManager:InGameMessageManager;
		private var _decorator:Object;
		private var _inGameScreen:Sprite;
		
		public function InGameMain($stage:Object = null, myName:String = null, opponentName:String = null) 
		{
			if (!$stage) {
				_stage = stage
			}
			else {
				_stage = $stage;
			}
			
			init();
			trace("stage" + _stage);
		}
		
		private function init():void
		{
			trace("going main?");
			
			assignVars();
			addListeners();
			
			beginPlayerIoLogin();
		}
		
		private function addListeners():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function assignVars():void
		{
			_inGameModel = InnerGameModel.getInstance();
//			_inGameModel.inGameScreen = this;
			_inGameModel.stage = _stage;
			
			
			CONFIG::IN_FLASH_PROFESSIONAL
				{
					
					_myInitialName = "phillip";
					_opponentInitialName = "simplePhillip";
					_inGameModel.myName = "phillip"
					_inGameModel.opponentName = "simplePhillip";
					_inGameModel.myPass = "poop";
					_inGameScreen = this["inGameScreen"];
				}
				
				CONFIG::IN_FLASH_BUILDER
				{
					
					_myInitialName = "simplePhillip";
					_opponentInitialName = "phillip";
					_inGameModel.myName = "simplePhillip"
					_inGameModel.opponentName = "phillip";
					_inGameModel.myPass = "test";
					
//					_inGameScreen = new InGameScreen();
//					_stage.addChild(_inGameScreen)
					
					_inGameScreen = new InGameScreen()
					addChild(_inGameScreen);
					
				}
				
				_inGameModel.inGameScreen = _inGameScreen;
				trace("in game screen from model: " + _inGameModel.inGameScreen);
				
		}
		
		private function beginPlayerIoLogin():void
		{
			var authDictionary:Dictionary = new Dictionary();
			
			authDictionary["userId"] = _inGameModel.myName;
			authDictionary["password"] = _inGameModel.myPass;
			
			PlayerIO.authenticate(stage,
				"mjack-dev-jxmuuaa4j0ofwnvniaq",            
				"public",                             	    
				authDictionary,        						
				null,                    					
				onAuthenticate,								
				onAuthenticationFail);
		}		
		
		private function onAuthenticationFail(error:PlayerIOError):void
		{
			trace("authentication error " + error);
		}
		
		private function onAuthenticate(client:Client):void
		{
			_pioClient = client;
			
//			_dbCaller = PlayerioDbCall.getInstance(_pioClient, _preGameScreen);
			
//			trace("in authenticate " + _preGameModel.opponentName);
			
			client.multiplayer.developmentServer = "127.0.0.1:8184";
			
			trace("authenticated " + client.multiplayer, client.connectUserId);
			
			var roomString:String = "room 15";
			
			client.multiplayer.createJoinRoom(
				roomString,                   //Join service room
				"InGameYo",                       //Type of room
				false,                              //Invisible
				null,                               //No room data
				null,    
				onRoomJoined,
				onRoomJoinFail
			);
			
		}
		
		private function onRoomJoinFail(error:PlayerIOError):void
		{
			trace("room join error " + error);
			
			// TODO
			// displayErrorPopup();   -that goes back to lobby
		}
		
		private function onRoomJoined(connection:Connection):void
		{
			
//			_messageManager = PlayerioMessageManager.getInstance(connection);
			////		
			_connection = connection;
			trace("connected: " + connection);
			
			_messageManager = InGameMessageManager.getInstance(_connection);
			_inGameModel.connection = connection;
//			_decorator = InGameDecorator.getInstance();
			
//			trace("bajinga" + _preGameModel.opponentName);
			
			
//			_dbCaller.pullPlayerInfo(_preGameModel.myName)
//			_dbCaller.pullPlayerInfo(_preGameModel.opponentName)
		}
		
		private function onErrorAuthenticating(error:PlayerIOError ):void  {
			
			trace("error: " + error);
		}
		
		
		
		private function onRoomJoin(connection:Connection):void
		{
		trace("room built " + connection, connection.roomId);	
		
		
		}
		
		private function errorHandler(error:PlayerIOError):void
		{
		trace("room error " + error);	
			
		}
		
		
		
	}
	
}
