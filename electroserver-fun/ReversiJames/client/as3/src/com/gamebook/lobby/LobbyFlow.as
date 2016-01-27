package com.gamebook.lobby {
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.api.ErrorType;
	import com.electrotank.electroserver5.api.ConnectionClosedEvent;
	import com.electrotank.electroserver5.api.ConnectionResponse;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.LoginRequest;
	import com.electrotank.electroserver5.api.LoginResponse;
	import com.electrotank.electroserver5.zone.Room;
	import com.gamebook.reversi.ReversiFactory;
	import com.gamebook.shared.IGame;
	import com.gamebook.shared.IGameFactory;
	import com.gamebook.shared.SharedConstants;
	import com.gamebook.lobby.ui.ErrorScreen;
	import com.gamebook.lobby.ui.LoginScreen;
	import com.gamebook.reversi.Reversi;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class LobbyFlow extends MovieClip{
		
		private var _es:ElectroServer;
		private var _lobby:Lobby;
		private var _game:IGame;
		private var _gameFactory:IGameFactory;
		private var _readyToJoinGame:Boolean;
		private var _loader : Loader;
		private var _me: String;
		
		public function LobbyFlow() {
			initialize();
		}
		
		private function initialize():void {
			
			//create a new ElectroServer instance
			_es = new ElectroServer();
			_es.loadAndConnect("settings.xml");
			
			_es.engine.addEventListener(MessageType.ConnectionResponse.name, onConnectionResponse);
			_es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			_es.engine.addEventListener(MessageType.ConnectionClosedEvent.name, onConnectionClosed);
			
			_readyToJoinGame = false;
			//loadGameFromSWF("put file location here for the swf");
			
		}
		
		/**
		 * Called when a user is connected and logged in. It creates a chat room screen.
		 */
		private function createLobby():void{
			_lobby = new Lobby();
			_lobby.addEventListener(Lobby.JOINED_GAME, onJoinedGame);
			_lobby.es = _es;
			_lobby.me = _me;
			_lobby.initialize();
			addChild(_lobby);
		}
		
		/**
		 * Call this when you know which game swf the user will need.
		 * For this example, since there's just one, we call it early.
		 */
		public function loadGameFromSWF(fileLocation:String):void {
			//load the game SWF 
			_loader = new Loader();
			_loader.load(new URLRequest(fileLocation));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
		}
		
		/**
		 * Game SWF has been loaded. 
		 */
		private function onLoadComplete(e:Event):void {
			//cast to an IGame factory
			_gameFactory = _loader.content as IGameFactory;
			
			//clean up
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader = null;
			
			//we are ready to join a game now
			_readyToJoinGame = true;
		}
		
		
		/**
		 * If the Lobby says you joined a game, then remove the lobby and create the game.
		 */
		private function onJoinedGame(e:Event):void {
			//create a new game and give it the ElectroServer reference as well as a room
			if (null == _gameFactory) {
				// we didn't load it from a swf
				_gameFactory = new ReversiFactory();
			}
			
			_game = _gameFactory.getNewGame();
			_game.initialize(_es, _lobby.gameRoom, _lobby.gameDetails);
			
			//listen for when the game is done or the user clicks the back to lobby button
			_game.addEventListener(SharedConstants.BACK_TO_LOBBY, onBackToLobby);
			
			//add game to the screen
			addChild(_game as DisplayObject);
			
			//tell the lobby it is about to be removed (it will clean up), then remove it
			_lobby.destroy();
			removeChild(_lobby);
			_lobby = null;
		}
		
		/**
		 * Called when the game says it is done. Remove the game, create the lobby.
		 */
		private function onBackToLobby(e:Event):void {
			//destroy and remove the game
			_game.destroy();
			removeChild(_game as DisplayObject);
			_game.removeEventListener(SharedConstants.BACK_TO_LOBBY, onBackToLobby);
			_game = null;
			
			//create the lobby
			createLobby();
		}
		
		/**
		 * This is used to display an error if one occurs
		 */
		private function showError(msg:String):void {
			var alert:ErrorScreen = new ErrorScreen(msg);
			alert.x = 300;
			alert.y = 200;
			alert.addEventListener(ErrorScreen.OK, onErrorScreenOk);
			addChild(alert);
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
			if (e.successful) {
				createLoginScreen();
			} else {
				showError("Failed to connect.");
			}
		}
		
		/**
		 * Creates a screen where a user can enter a username
		 */
		private function createLoginScreen():void{
			var login:LoginScreen = new LoginScreen();
			login.x = 400 - login.width / 2;
			login.y = 300 - login.height / 2;
			addChild(login);
			
			login.addEventListener(LoginScreen.OK, onLoginSubmit);
		}
		
		/**
		 * Called as a result of the OK event on the login screen. Creates and sends a login request to the server
		 */
		private function onLoginSubmit(e:Event):void {
			var screen:LoginScreen = e.target as LoginScreen;
			
			//create the request
			var lr:LoginRequest = new LoginRequest();
			lr.userName = screen.username;
			
			//send it
			_es.engine.send(lr);
			
			screen.removeEventListener(LoginScreen.OK, onLoginSubmit);
			removeChild(screen);
		}
		
		/**
		 * Called when the server responds to the login request. If successful, create the chat room screen
		 */
		public function onLoginResponse(e:LoginResponse):void {
			if (e.successful) {
				_me = e.userName;
				createLobby();
			} else {
				showError(e.error.name);
			}
		}
		
		public function onConnectionClosed(e:ConnectionClosedEvent):void {
			showError("Connection was closed");
		}
		
	}
	
}