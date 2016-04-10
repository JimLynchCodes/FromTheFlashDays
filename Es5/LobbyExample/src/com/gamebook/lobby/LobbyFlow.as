package com.gamebook.lobby {
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.api.ConnectionClosedEvent;
	import com.electrotank.electroserver5.api.ConnectionResponse;
	import com.electrotank.electroserver5.api.ErrorType;
	import com.electrotank.electroserver5.api.LoginRequest;
	import com.electrotank.electroserver5.api.LoginResponse;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.zone.Room;
	import com.gamebook.dig.DigGame;
	import com.gamebook.lobby.ui.ErrorScreen;
	import com.gamebook.lobby.ui.LoginScreen;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Jobe Makar - jobe@electrotank.com
	 */
	public class LobbyFlow extends MovieClip{
		
		private var _es:ElectroServer;
		private var _lobby:Lobby;
		private var _game:DigGame;
		private var _loginPopup:Sprite;
		private var _stage:Object;
		
		public function LobbyFlow(stage:Object) {
			_stage = stage;
			initialize();
			trace("Lobby Flow initialized");
		}
		
		private function initialize():void {
			
			
			_es = new ElectroServer();
			_es.engine.addEventListener(MessageType.ConnectionResponse.name, onConnectionResponse);
			// production
			_es.loadAndConnect("https://s3.amazonaws.com/LobbySystem/xml/settings.xml");
			
			// local
//						_es.loadAndConnect("https://s3.amazonaws.com/LobbySystem/xml/settingsLocal.xml");
			
			trace("loading it");
			//create a new ElectroServer instance
			
			
			
			
		}
		
		private function assignVars():void
		{
			
			
			var loginPopupClass:Class = getDefinitionByName("com.gamebook.lobby.ui.LoginScreen") as Class;
			_loginPopup = new loginPopupClass() as Sprite;
			
			var lobbyClass:Class = getDefinitionByName("com.gamebook.lobby.Lobby") as Class;
			_lobby = new lobbyClass(_es) as Lobby;
//			_stage.addChild(_lobby);
			
		}
		
		private function addListeners():void
		{
			//add event listeners - new format is _es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			
			_es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			_es.engine.addEventListener(MessageType.ConnectionClosedEvent.name, onConnectionClosed);
			
		}
		
		/**
		 * Called when a user is connected and logged in. It creates a chat room screen.
		 */
		private function createLobby():void{
//			_lobby.addEventListener(Lobby.JOINED_GAME, onJoinedGame);
//			_lobby.es = _es;
//			_lobby.initialize();
			_stage.addChild(_lobby);
		}
		
		/**
		 * If the Lobby says you joined a game, then remove the lobby and create the game.
		 */
		private function onJoinedGame(e:Event):void {
			//create a new game and give it the ElectroServer reference as well as a room
			_game = new DigGame();
			_game.es = _es;
			_game.room = _lobby.gameRoom;
			
			//listen for when the game is done
			_game.addEventListener(DigGame.BACK_TO_LOBBY, onDigGameBackToLobby);
			
			//initialize the game and add it to the screen
			_game.initialize();
			addChild(_game);
			
			//tell the lobby it is about to be removed (it will clean up), then remove it
			_lobby.destroy();
			removeChild(_lobby);
			_lobby = null;
		}
		
		/**
		 * Called when the game says it is done. Remove the game, create the lobby.
		 */
		private function onDigGameBackToLobby(e:Event):void {
			//destroy and remove the game
			_game.destroy();
			removeChild(_game);
			_game.removeEventListener(DigGame.BACK_TO_LOBBY, onDigGameBackToLobby);
			_game = null;
			
			//create the lobby
			createLobby();
		}
		
		/**
		 * This is used to display an error if one occurs
		 */
		private function showError(msg:String):void {
//			var alert:ErrorScreen = new ErrorScreen(msg);
//			alert.x = 300;
//			alert.y = 200;
//			alert.addEventListener(ErrorScreen.OK, onErrorScreenOk);
//			addChild(alert);
			
			trace("error message: " + msg);
		}
		
		/**
		 * Called as the result of an OK event on an error screen. Removes the error screen.
		 */
		private function onErrorScreenOk(e:Event):void {
			var alert:ErrorScreen = e.target as ErrorScreen;
			alert.removeEventListener(ErrorScreen.OK, onErrorScreenOk);
			removeChild(alert);
		}
		
		/**
		 * Called when a connection attempt has succeeded or failed
		 */
		public function onConnectionResponse(e:ConnectionResponse):void {
			
			trace("on Connection Response");
			
			if (e.successful) {
				
				assignVars();
				addListeners();
				createLoginScreen();
				trace("success");
			} else {
//				showError("Failed to connect.");
				trace("fail");
			}
		}
		
		/**
		 * Creates a screen where a user can enter a username
		 */
		private function createLoginScreen():void{
			trace("creating login screen");
			_loginPopup.x = 400 - _loginPopup.width / 2;
			_loginPopup.y = 300 - _loginPopup.height / 2;
			addChild(_loginPopup);
			
			_loginPopup.addEventListener(LoginScreen.OK, onLoginSubmit);
		}
		
		/**
		 * Called as a result of the OK event on the login screen. Creates and sends a login request to the server
		 */
		private function onLoginSubmit(e:Event):void {
//			var screen:LoginScreen = e.target as LoginScreen;
			
			//create the request
			var lr:LoginRequest = new LoginRequest();
			lr.userName = _loginPopup["usernameTxt"].text;
			
			//send it
			_es.engine.send(lr);
			
//			screen.removeEventListener(LoginScreen.OK, onLoginSubmit);
//			removeChild(screen);
		}
		
		/**
		 * Called when the server responds to the login request. If successful, create the chat room screen
		 */
		public function onLoginResponse(e:LoginResponse):void {
			if (e.successful) {
				createLobby();
				trace("successful login");
			} else {
//				showError(e.error.name);
				trace("error logging in: " + e.error.name);
			}
		}
		
		public function onConnectionClosed(e:ConnectionClosedEvent):void {
			showError("Connection was closed");
		}
		
	}
	
}