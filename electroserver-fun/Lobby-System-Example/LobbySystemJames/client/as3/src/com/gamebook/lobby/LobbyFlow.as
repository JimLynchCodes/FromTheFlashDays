package com.gamebook.lobby {
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.api.ConnectionClosedEvent;
	import com.electrotank.electroserver5.api.ConnectionResponse;
	import com.electrotank.electroserver5.api.ErrorType;
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.LeaveRoomRequest;
	import com.electrotank.electroserver5.api.LoginRequest;
	import com.electrotank.electroserver5.api.LoginResponse;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.PluginRequest;
	import com.electrotank.electroserver5.zone.Room;
	import com.gamebook.dig.DigGame;
	import com.gamebook.dig.PluginConstants;
	import com.gamebook.lobby.states.IState;
	import com.gamebook.lobby.states.LoginState;
	import com.gamebook.lobby.states.ShopState;
	import com.gamebook.lobby.ui.ErrorScreen;
	import com.gamebook.lobby.ui.LoginScreenJ;
	import com.gamebook.model.StorageModel;
	import com.gamebook.util.PhpManager;
	import com.greensock.TweenLite;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Jobe Makar - jobe@electrotank.com
	 */
	public class LobbyFlow extends
		Sprite{
		
		
		public static const LOGIN_STATE	            	: int = 3;
		public static const PLAY_STATE	            	: int = 12;
		public static const SHOP_STATE	                : int = 15;
		public static const LOBBY_STATE             	: int = 20;
		
		public static const TEST_STATE                  : int = 99;
		
		public static var currentState:com.gamebook.lobby.states.IState;
		public  var currentStateNum:int;
		
		private var _es:ElectroServer;
		private var _lobby:Lobby;
		private var _game:DigGame;
		private var _loginInputTxt:TextField;
		private var loginBtn:SimpleButton;
		private var login:LoginScreenAsset2;
		private var _passInputTxt:TextField;
		private var fro:Sprite;
		private var searchIndicator:SearchIndicator;
		private var registerBtn:SimpleButton;
		private var _emailInputTxt:TextField;
		private var guestBtn:SimpleButton;
		private var loginErrorTF:TextField;
		private var theLogin:LoginScreenJ;
		private var content:*;
		private var loadedCursors:Object;
		public var reFreshSig:Signal = new Signal();
		public var _lc:LoaderContext;
		
		public function LobbyFlow() {
			trace("full");
			
			initialize();
//			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		protected function onAddedToStage(event:Event):void
		{
			trace("added");
		}
		
		public function initialize():void {

			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
//			Security.loadPolicyFile("http://www.goldenliongames.com/uploads/2/0/5/4/20545110/crossdomain.xml")
				
			//create a new ElectroServer instance
			_es = new ElectroServer();
			//add event listeners - new format is _es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			_es.engine.addEventListener(MessageType.ConnectionResponse.name, onConnectionResponse);
//			_es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			_es.engine.addEventListener(MessageType.ConnectionClosedEvent.name, onConnectionClosed);
			
			_es.loadAndConnect("https://s3.amazonaws.com/xmlFiles/settings.xml");
//			_es.loadAndConnect("settings.xml");
			
			reFreshSig.add(onLobbyListNeedsRefresh);
			trace("yer");
		
			loadCursorSwf();
		}
		
		private function onLobbyListNeedsRefresh():void
		{
//			_lobby.reFreshSig
		}
		
		private function loadCursorSwf():void
		{
			
			
			Security.loadPolicyFile("https://s3.amazonaws.com/FirstBucketJim/crossdomain.xml");
			var loader:Loader = new Loader();
			
			_lc = new LoaderContext();
			_lc.checkPolicyFile = true;
			_lc.applicationDomain = ApplicationDomain.currentDomain;
			
			if (Main.PRODUCTION)
			{
				_lc.securityDomain = SecurityDomain.currentDomain;
			}
			loader.contentLoaderInfo.addEventListener ( flash.events.Event.COMPLETE, onComplete );
			loader.contentLoaderInfo.addEventListener ( flash.events.ProgressEvent.PROGRESS, onProgress);
			loader.load(new URLRequest("https://s3.amazonaws.com/FirstBucketJim/cursors.swf"), _lc);
	
		
		
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			
		}
		
		protected function onComplete(event:Event):void
		{
			trace("swf loaded!" + event.target.applicationDomain);
			
			content = event.currentTarget.content as MovieClip;
			
			loadedCursors = event.target.applicationDomain
			StorageModel.loadedCursors = event.target.applicationDomain;
			
			
//			StorageModel.GreenTrowel = loadedCursors.getDefinition("GreenTrowel") as Class;
//			StorageModel.BlackTrowel = loadedCursors.getDefinition("BlackTrowel") as Class;
//			StorageModel.Trowel = loadedCursors.getDefinition("Trowel") as Class;
//			StorageModel.BlueTrowel = loadedCursors.getDefinition("BlueTrowel") as Class;
				
		}
		
		/**
		 * Called when a user is connected and logged in. It creates a chat room screen.
		 */
//		public function createLobby():void{
//			trace("creating lobby");
//			
//			_lobby = new Lobby(this, _es);
//			_lobby.es = _es;
//			_lobby.addEventListener(Lobby.JOINED_GAME, onJoinedGame);
//			_lobby.initialize(true);
//			addChild(_lobby);
//			
//			
//			trace(fro);
//			
//			if (theLogin)
//			{
//				removeChild(theLogin);
//				theLogin = null;
//			}
//			
//		}
		
		/**
		 * If the Lobby says you joined a game, then remove the lobby and create the game.
		 *		but for me it's just seearching
		 * */
//		private function onJoinedGame(e:Event):void {
//			//create a new game and give it the ElectroServer reference as well as a room
//		
////			if (!_game)
////			{
//			_game = new DigGame();
//				
////			}
//			_game.es = _es;
//			_game.room = _lobby.gameRoom;
//			_game.gameRoomEnteredSig.add(onEnteringGameRoom);
//			
//			//listen for when the game is done
//			_game.addEventListener(DigGame.BACK_TO_LOBBY, onDigGameBackToLobby);
//			_lobby.addEventListener(Lobby.SEARCH_CANCELED, onDigGameSearchCanceled);
//			
//			//initialize the game and add it to the screen
//			_game.initialize();
//			
//			
//			searchIndicator = new SearchIndicator;
//			
//			
//			
//			
//		}
		
//		protected function onDigGameSearchCanceled(event:Event):void
//		{
////			_game.destroy();
////			removeChild(_game);
////			_game.removeEventListener(DigGame.BACK_TO_LOBBY, onDigGameBackToLobby);
////			_game = null;
//			
////			_game.shutDownGame();
//			
//			var lrr:LeaveRoomRequest = new LeaveRoomRequest();
//			lrr.roomId = _game._room.id;
//			lrr.zoneId = _game._room.zoneId;
//			
//			_es.engine.send(lrr);
//			
////			onEnteringGameRoom();
////			createLobby();
//			_lobby.addEventListener(Lobby.JOINED_GAME, onJoinedGame);
//			_lobby.initialize(false);
//
//			
//					
//			_game.destroy();
//		}		
		
		private function onEnteringGameRoom():void
		{
			
//			addChild(_game);
//			
//			//tell the lobby it is about to be removed (it will clean up), then remove it
//			trace("enetering game room");
//			if (_lobby)
//			{
//				_lobby.destroy();
//				removeChild(_lobby);
//				_lobby = null;
//				
//			}
		}
		
		
		/**
		 * Called when the game says it is done. Remove the game, create the lobby.
		 */
//		private function onDigGameBackToLobby(e:Event):void {
//			trace("back to lobby heard");
//			//destroy and remove the game
//			_game.destroy();
//			removeChild(_game);
//			_game.removeEventListener(DigGame.BACK_TO_LOBBY, onDigGameBackToLobby);
//			_game = null;
//			
//			//create the lobby
//			createLobby();
//		}
		
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
			trace("responded " + e.successful);
			if (e.successful) {
				trace("success");
//				createLoginScreen();
				
				changeState(LobbyFlow.LOGIN_STATE);
			} else {
				showError("Failed to connect.");
			}
		}
		
		public function changeState(state:int):void
		{
			trace("changing game state to: " + state);
			var removed:Boolean = false;
			
			if(currentState != null) {
				_removeUpdateListener();
				currentState.destroy();
				stage.removeChild(Sprite(currentState));
				currentState = null;
				currentStateNum = -1000;
				removed = true;	
			}
			
			switch(state) {
				
				case LOGIN_STATE:
					currentState = new LoginState(this, _es);
					break;
				
				case PLAY_STATE:
					currentState = new DigGame(this);
					break;
				
				case LOBBY_STATE:
					currentState = new Lobby(this, _es);
//					_lobby.es = _es;
					
					break;
				
				case SHOP_STATE:
//					currentState = new SearchState(this);
					currentState = new ShopState(this, _es);
					break;
				
				case TEST_STATE:
					//					currentState = new Test(this, _model);
					break;
			}
			
			stage.addChild(Sprite(currentState));
			
			trace("state is now " + currentState);
			if(removed) {
				// Add update listeners back
				_addUpdateListener();
				removed = false;
			}
			
		}
		
		/**
		 * Creates a screen where a user can enter a username
		 */
		/**
		 * 
		 * 
		 */
		
		private function _addUpdateListener():void {
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function _removeUpdateListener():void {
			removeEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void 
		{
			currentState.update();
		}
		
//		private function createLoginScreen():void{
//			theLogin = new LoginScreenJ(this);
//			theLogin._es = _es;
//			addChild(theLogin);
//			
			
			
//			
//			login = new LoginScreenAsset2();
////			login.x = 400 - login.width / 2;
////			login.y = 300 - login.height / 2;
////			var fuck:FuckBro
//			
//			addChild(login);
//			
//			var phpManager:PhpManager = PhpManager.getInstance();
//			phpManager.checkIfNameExists("zaz");
//			phpManager.checkIfNameExists("doofus");
//			
//			
//			
//			
//			_loginInputTxt = login["loginInputTxt"] as TextField;
//			_passInputTxt = login["passInputTxt"] as TextField;
//			_emailInputTxt = login["emailInputTxt"] as TextField;
//			loginErrorTF = login["loginErrorTxt"] as TextField;
//			loginErrorTF.visible = false;
//			loginBtn = login["loginBtn"] as SimpleButton;
//			registerBtn = login["registerBtn"] as SimpleButton;
////			registerBtn.addEventListener(MouseEvent.CLICK, onRegisterBtnClciked);
//			guestBtn = login["guestBtn"] as SimpleButton;
//			guestBtn.addEventListener(MouseEvent.CLICK, onGuestBtnClicked);
//			
//			registerBtn = login["registerBtn"] as SimpleButton;
//			registerBtn.addEventListener(MouseEvent.CLICK, onRegisterBtnClicked);
////			var fuck:Fuck = new Fuck();
////			addChild(fuck);
//			
//			registerPopup = new 
//			
//			
//			//			var gameScreen:GameScreenAsset = new GameScreenAsset();
////			this.addChild(gameScreen);
//			trace("added login");
//			loginBtn.addEventListener(MouseEvent.CLICK, onLoginSubmit);
//		}
//		
//		protected function onRegisterBtnClicked(event:MouseEvent):void
//		{
//			TweenLite.to(
//		}
//		
//		protected function onGuestBtnClicked(event:MouseEvent):void
//		{
//			
//			
//			var randomNum:int = Math.random()*3000;
//			
//			//create the request
//			var lr:LoginRequest = new LoginRequest();
//			lr.userName = "Guest" + randomNum;
//			lr.password = "";
//			//send it
//			_es.engine.send(lr);
//			
//			//			screen.removeEventListener(LoginScreen.OK, onLoginSubmit);
//			removeChild(login);
//			
//		}
//		
////		protected function onRegisterBtnClciked(event:MouseEvent):void
////		{
////			trace("sending request");
////			var esob:EsObject = new EsObject();
////			esob.setString(PluginConstants.ACTION, PluginConstants.TAG_REGISTER);
////			//			esob.setInteger(PluginConstants.X, _trowel.x);
////			//			esob.setInteger(PluginConstants.Y, _trowel.y);
////			
////			esob.setString(PluginConstants.TAG_PASSWORD, _passInputTxt.text);
////			esob.setString(PluginConstants.TAG_EMAIL, _emailInputTxt.text);
////			
////			sendToDbPlugin(esob);
////		}
////		
////		private function sendToDbPlugin(esob:EsObject):void {
////			//build the request
////			var pr:PluginRequest = new PluginRequest();
////			pr.parameters = esob;
//////			pr.roomId = _room.id;
//////			pr.zoneId = _room.zoneId;
////			pr.pluginName = PluginConstants.DB_PLUGIN_NAME;
////			
////			//send it
////			_es.engine.send(pr);
////			trace("sent");
////		}
//		
//		
//		/**
//		 * Called as a result of the OK event on the login screen. Creates and sends a login request to the server
//		 */
//		private function onLoginSubmit(e:MouseEvent):void {
//			
//			loginBtn.removeEventListener(MouseEvent.CLICK, onLoginSubmit);
////			var screen:LoginScreen = e.target as LoginScreen;
//			var usernameEntered:String = _loginInputTxt.text;
//			var passwordEntered:String = _passInputTxt.text;
//			
//			//create the request
//			var lr:LoginRequest = new LoginRequest();
//			lr.userName = usernameEntered;
//			lr.password = passwordEntered;
//			//send it
//			_es.engine.send(lr);
//			
////			screen.removeEventListener(LoginScreen.OK, onLoginSubmit);
//			
//		}
//		
//		/**
//		 * Called when the server responds to the login request. If successful, create the chat room screen
//		 */
//		public function onLoginResponse(e:LoginResponse):void {
//			if (e.successful) {
//				
//				trace("login response esOb size" + e.esObject.getSize());
//				
//				if (e.esObject.getSize() == 0)
//				{
//					trace("is a guest");
//				}
//				else
//				{
//					trace("not a guest");
//				}
//				
////				trace("login response esObj " + e.esObject.getString("Status"));
//				trace("login successful!");
//				removeChild(login);
//				createLobby();
//			} else {
//				
//				loginErrorTF.visible = true;
//				loginErrorTF.alpha = 1;
//				loginErrorTF.text = "Incorrect username or password.";
//				loginBtn.addEventListener(MouseEvent.CLICK, onLoginSubmit);
////				showError(e.error.name);
//				TweenLite.to(loginErrorTF, 6, {alpha:.6});
//			}
//		}
		
		public function onConnectionClosed(e:ConnectionClosedEvent):void {
			
			trace("	connectionId " + e.	connectionId);
			trace("connection closed!");
			
			var connectionClosedPopup:DisconnectedPopup = new DisconnectedPopup();
			this.addChild(connectionClosedPopup);
			connectionClosedPopup.x = stage.width * 0.5;	
			connectionClosedPopup.y = stage.height * 0.5;	
		
			
			showError("Connection was closed");
		}
		
	}
	
}