package com.gamebook.lobby {
	
	//ElectroServer imports
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.api.CreateOrJoinGameResponse;
	import com.electrotank.electroserver5.api.CreateRoomRequest;
	import com.electrotank.electroserver5.api.ErrorType;
	import com.electrotank.electroserver5.api.FindGamesRequest;
	import com.electrotank.electroserver5.api.FindGamesResponse;
	import com.electrotank.electroserver5.api.GenericErrorResponse;
	import com.electrotank.electroserver5.api.JoinGameRequest;
	import com.electrotank.electroserver5.api.JoinRoomEvent;
	import com.electrotank.electroserver5.api.LeaveRoomEvent;
	import com.electrotank.electroserver5.api.LeaveRoomRequest;
	import com.electrotank.electroserver5.api.LogOutRequest;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.PrivateMessageEvent;
	import com.electrotank.electroserver5.api.PrivateMessageRequest;
	import com.electrotank.electroserver5.api.PublicMessageEvent;
	import com.electrotank.electroserver5.api.PublicMessageRequest;
	import com.electrotank.electroserver5.api.QuickJoinGameRequest;
	import com.electrotank.electroserver5.api.SearchCriteria;
	import com.electrotank.electroserver5.api.ServerGame;
	import com.electrotank.electroserver5.api.UserUpdateEvent;
	import com.electrotank.electroserver5.api.ZoneUpdateEvent;
	import com.electrotank.electroserver5.user.User;
	import com.electrotank.electroserver5.zone.Room;
	import com.electrotank.electroserver5.zone.Zone;
	import com.gamebook.dig.DigGame;
	import com.gamebook.dig.PluginConstants;
	import com.gamebook.dig.elements.Trowel;
	import com.gamebook.lobby.states.IState;
	import com.gamebook.lobby.ui.CreateRoomScreen;
	import com.gamebook.lobby.ui.PopuupBackground;
	import com.gamebook.lobby.ui.TextLabel;
	import com.gamebook.model.StorageModel;
	import com.gamebook.util.LevelUpManager;
	import com.gamebook.util.PhpManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import mx.containers.HDividedBox;
	
	import fl.controls.List;
	import fl.data.DataProvider;
	
	import playerio.Client;
	import playerio.PlayerIOError;
	
	/**
	 * ...
	 * @author Jobe Makar - jobe@electrotank.com
	 */
	public class Lobby extends MovieClip implements IState{
		
		public static const JOINED_GAME:String = "joinedGame";
		public static const SEARCH_CANCELED:String = "searchCanceled";
		
		//ElectroServer instance
		public var _es:ElectroServer;
		
		//room you are in
		private var _room:Room;
		
		private var _gameRoom:Room;
		
		//UI components
//		private var _userList:List;
//		private var _gameList:List;
//		private var _history:TextArea;
//		private var _message:TextInput;
//		private var _joinGame:Button;
//		private var _send:Button;
		
		//chat room label
//		private var _chatRoomLabel:TextLabel;
		
		//screen used to allow a user to create a screen
		private var _joinGameScreen:CreateRoomScreen;
		
		private var _gameListRefreshTimer:Timer;
//		private var _quickJoinGame:Button;
		private var _pendingRoomName:String;
		private var _message:Object;
//		private var _lobby:Sprite;
		private var _send:SimpleButton;
		private var _quickJoinGame:SimpleButton;
		private var _searchIndicator:MovieClip;
		private var _cancelBtn:SimpleButton;
		private var _chatOutputTF:TextField;
		private var _chatInputTF:TextField;
		private var _userList:List;
		private var _welcomeTF:TextField;
		private var _myUsername:String;
		private var phpManager:PhpManager;
		private var _levelTF:TextField;
		private var _winsTF:TextField;
		private var _expTF:TextField;
		public var myWins:int;
		public var myLevel:int;
		public var myExp:int;
		private var _coinsTF:TextField;
		private var _lobbyFlow:LobbyFlow;
		private var _game:DigGame;
		private var _lobby:Object;
		private var trowel:Trowel;
		private var toShopBtn:SimpleButton;
		private var _cursorClass:Class;
		private var c:Client;
		private var _diamondsTF:TextField;
		private var _logoutBtn:SimpleButton;
		
		public function Lobby(lobbyFlow:LobbyFlow, es:ElectroServer){
			_lobbyFlow = lobbyFlow;
			_es = es;

			_myUsername = _es.managerHelper.userManager.me.userName;
			
			phpManager = PhpManager.getInstance();
			
			trace("new lobby " + StorageModel.currentCursorClassName);
			
			
			trace("building new lobby");
			
			this.addEventListener(Lobby.JOINED_GAME, onJoinedGame);
			initialize(true);
			
			
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		
		protected function onAddedToStage(event:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyPress);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}
		
		private function onCursorClassCheck(cursorClassName:String):void
		{
			phpManager.cursorCheckSig.remove(onCursorClassCheck);
			trace("responded alright " + cursorClassName);
			trowel = new Trowel(cursorClassName);
			StorageModel.currentCursorClassName = cursorClassName;
			this.addChild(trowel);
			Mouse.hide();
		}
		
		private function mouseMoved(e:MouseEvent):void {
			updateTrowelPosition();
			e.updateAfterEvent();
		}
		
		private function updateTrowelPosition():void{
			//			if (!_trowel.digging) {
			if (trowel)
			{
				trowel.visible = true;
				trowel.x = mouseX;
				trowel.y = mouseY;
				
//				trace("trowel x " + trowel.x + "and y: " + trowel.y);
			}
			//			}
		}
		
		private function onJoinedGame(e:Event):void {
			//create a new game and give it the ElectroServer reference as well as a room
			//			if (!_game)
			//			{
			_game = new DigGame(_lobbyFlow);
			
			_chatInputTF.text = "";
			//			}
			_game._es = _es;
//			_game.room = gameRoom;
//			_game._room = gameRoom;
			_game.room = StorageModel.gameRoom;
//			_game.zone = gameRoom.zoneId;
			_game.gameRoomEnteredSig.add(onEnteringGameRoom);
			
//			trace("!joined game " + _game._es);
//			trace("!joined game " + _game._room);
//			trace("!joined game " + _game.room);
//			trace("!joined game " + _game.room.zoneId);
//			trace("!joined game " + _game.room.id);
			
			//listen for when the game is done
			_game.addEventListener(DigGame.BACK_TO_LOBBY, onDigGameBackToLobby);
			addEventListener(Lobby.SEARCH_CANCELED, onDigGameSearchCanceled);
			
			//initialize the game and add it to the screen
			_game.initialize();
			
//			destroy();
			
//			searchIndicator = new SearchIndicator;
			
			addChild(_game);
			
			
			
		}
		
		private function onDigGameBackToLobby(e:Event):void {
			trace("back to lobby heard");
			
			buildUIElements();
			joinRoom("Lobby");
			
			
			//destroy and remove the game
//			_game.destroy();
//			removeChild(_game);
			_game.removeEventListener(DigGame.BACK_TO_LOBBY, onDigGameBackToLobby);
//			_game.removeEventListener(Lobby.BACK_FROM_SHOP, onBackToLobbyFromShop);
			_game = null;
			
			//create the lobby
//			createLobby();
			
//			_lobbyFlow.changeState(LobbyFlow.LOBBY_STATE);
		}
		
		protected function onBackToLobbyFromShop(event:Event):void
		{
			refreshUserList();
		}
		
		protected function onDigGameSearchCanceled(event:Event):void
		{
			//			_game.destroy();
			//			removeChild(_game);
			//			_game.removeEventListener(DigGame.BACK_TO_LOBBY, onDigGameBackToLobby);
			//			_game = null;
			
			//			_game.shutDownGame();
			
			trace("search canceled about to eleave room " + _gameRoom.id, _gameRoom.zoneId);
			
//			var lrr:LeaveRoomRequest = new LeaveRoomRequest();
//			lrr.roomId = _gameRoom.id;
//			lrr.zoneId = _gameRoom.zoneId;
			
//			_es.engine.send(lrr);
			
			trace("left alright");
			
			//			onEnteringGameRoom();
			//			createLobby();
			addEventListener(Lobby.JOINED_GAME, onJoinedGame);
//			initialize(false);
			
			
			
			_game.destroy();
		}
		
		protected function onMouseLeave(event:Event):void
		{
			if (trowel)
			{
			trowel.visible = false;
				
			}
			
		}
		private function onEnteringGameRoom():void
		{
//			_lobbyFlow.changeState(LobbyFlow.PLAY_STATE);
//			trowel = new Trowel();
			if (trowel)
			{
				if (trowel.parent == this)
				{
				this.removeChild(trowel);
				}
			}
			
			var lrr:LeaveRoomRequest = new LeaveRoomRequest();
			lrr.roomId = _room.id;
			lrr.zoneId = _room.zoneId;
			
			_es.engine.send(lrr);
			
			destroy();
			
			Mouse.hide();
			
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
		}
		
		public function initialize(createUI:Boolean):void {
			//add ElectroServer listeners- new format is _es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			_es.engine.addEventListener(MessageType.JoinRoomEvent.name, onJoinRoomEvent);
			_es.engine.addEventListener(MessageType.PublicMessageEvent.name, onPublicMessageEvent);
			_es.engine.addEventListener(MessageType.PrivateMessageEvent.name, onPrivateMessageEvent);
			_es.engine.addEventListener(MessageType.UserUpdateEvent.name, onUserUpdateEvent);
			_es.engine.addEventListener(MessageType.FindGamesResponse.name, onFindGamesResponse);
			_es.engine.addEventListener(MessageType.GenericErrorResponse.name, onGenericErrorResponse);
			_es.engine.addEventListener(MessageType.CreateOrJoinGameResponse.name, onCreateOrJoinGameResponse);
			_es.engine.addEventListener(MessageType.ServerKickUserEvent.name, onServerKickUserEvent);
			
			trace("adding listeners back in");
			
			_gameListRefreshTimer = new Timer(2000);
			_gameListRefreshTimer.start();
			_gameListRefreshTimer.addEventListener(TimerEvent.TIMER, onGameListRefreshTimer);
			
			if (createUI)
			{
			//build UI elements
			buildUIElements();
				
			}
			
			//join a default room
			joinRoom("Lobby");
			trace("joining the default lobby room")
			
//			refreshUserList();
			
			
			// http://www.shutterstock.com/pic.mhtml?id=135251414
			// http://www.shutterstock.com/pic.mhtml?id=59954380
			// http://www.dreamstime.com/stock-photos-shop-store-market-background-image14152553
		}
		
		protected function onServerKickUserEvent(event:Event):void
		{
			trace(" user has been kicked!");
		}
		
		public function destroy():void {
//			var lrr:LeaveRoomRequest = new LeaveRoomRequest();
//			lrr.roomId = _room.id;
//			lrr.zoneId = _room.zoneId;
//			_es.engine.send(lrr);
			
//			_es.engine.removeEventListener(MessageType.JoinRoomEvent.name, onJoinRoomEvent);
//			_es.engine.removeEventListener(MessageType.PublicMessageEvent.name, onPublicMessageEvent);
			_es.engine.removeEventListener(MessageType.PrivateMessageEvent.name, onPrivateMessageEvent);
//			_es.engine.removeEventListener(MessageType.UserUpdateEvent.name, onUserUpdateEvent);
//			_es.engine.removeEventListener(MessageType.FindGamesResponse.name, onFindGamesResponse);
//			_es.engine.removeEventListener(MessageType.GenericErrorResponse.name, onGenericErrorResponse);
//			_es.engine.removeEventListener(MessageType.CreateOrJoinGameResponse.name, onCreateOrJoinGameResponse);

//			if (_gameListRefreshTimer.running)
//			{
			
			if (stage)
			{
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyPress);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
				stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);	
				
			}
			
			
			
//				_gameListRefreshTimer.stop();
//			if (trowel)
//			{
//				removeChild(trowel);
//			}
//			}
			_gameListRefreshTimer.removeEventListener(TimerEvent.TIMER, onGameListRefreshTimer);
//			_gameListRefreshTimer = null;
		}
		
		private function quickJoin():void {
//			_quickJoinGame.enabled = false;
			
			var qjr:QuickJoinGameRequest = new QuickJoinGameRequest();
			qjr.gameType = PluginConstants.GAME_NAME;
			qjr.zoneName = "GameZone";
			qjr.createOnly = false;
			
			_es.engine.send(qjr);
		}
		
		private function joinGame(serverGame:ServerGame):void {
			var jgr:JoinGameRequest = new JoinGameRequest();
			jgr.gameId = serverGame.id;
			_es.engine.send(jgr);
		}
		
		public function onCreateOrJoinGameResponse(e:CreateOrJoinGameResponse):void {
			if (e.successful) {
				_gameRoom =  _es.managerHelper.zoneManager.zoneById(e.zoneId).roomById(e.roomId);
//				_gameRoom.id = e.roomId;
//				_gameRoom.zoneId = e.zoneId;
				
				StorageModel.gameRoom = _gameRoom;
//				destroy();
				
				trace("just joined a game " + _gameRoom.id,  gameRoom.zoneId);
				
				dispatchEvent(new Event(JOINED_GAME));
			} else {
//				_quickJoinGame.enabled = true;
				trace(e.error.name);
				if (e.error == ErrorType.GameDoesntExist) {
					trace("This game hasn't been registered with the server. Do that first.");
				}
			}
		}
		
		/**
		 * An error happened on the server because of something the client did. This captures it and traces it.
		 */
		public function onGenericErrorResponse(e:GenericErrorResponse):void {
			trace(e.errorType.name);
		}
		
		/**
		 * Request the game list from the server
		 */
		private function onGameListRefreshTimer(e:TimerEvent):void {
			//create request
			var fgr:FindGamesRequest = new FindGamesRequest();
			
			//create search criteria that will filter the game list
			var criteria:SearchCriteria = new SearchCriteria();
			criteria.gameType = PluginConstants.GAME_NAME;
			criteria.gameId = -1;
			
			//add the search criteria to the request
			fgr.searchCriteria = criteria;
			
			//send it
			_es.engine.send(fgr);
			
		}
		
		/**
		 * Called when a response is received for the FindGamesRequest
		 */
		public function onFindGamesResponse(e:FindGamesResponse):void {
			trace("number games found: " + e.games.length);
			refresGameList(e.games);
		}
		
		public function update():void
		{
			
		}
		
		
		/**
		 * Called when a user name in the list is selected
		 */
		private function onUserSelected(e:Event):void {
//			if (_userList.selectedItem != null) {
				
				//grab the User object off of the list item
//				var user:User = _userList.selectedItem.data as User;
				
				//add private message syntax to the message entry field
//				_message.text = "/" + user.userName + ": ";
//			}
		}
		
		/**
		 * Called when the send button is clicked
		 */
		private function onSendClick(e:MouseEvent):void {
			
			sendChatMessage();
			}
		
		private function sendChatMessage():void
		{
			//if there is text to send, then proceed
			if (_chatInputTF.text.length > 0) {
				
				//get the message to send
				var msg:String = _chatInputTF.text;
				
				//check to see if it is a public or private message
				if (msg.charAt(0) == "/" && msg.indexOf(":") != -1) {
					//private message
					
					//parse the message to get who it is meant to go to
//					var to:String = msg.substr(1, msg.indexOf(":") - 1);
//					
//					//parse the message to get the message content and strip out the 'to' value
//					msg = msg.substr(msg.indexOf(":")+2);
//					
//					//create the request object
//					var prmr:PrivateMessageRequest = new PrivateMessageRequest();
//					prmr.userNames = [to];
//					prmr.message = msg;
//					
//					//send it
//					_es.engine.send(prmr);
					
				} else {
					//public message
					
					//create the request object
					var pmr:PublicMessageRequest = new PublicMessageRequest();
					pmr.message = _chatInputTF.text;
//					pmr.roomId = _room.id;
//					pmr.zoneId = _room.zoneId;
					pmr.roomId = StorageModel.lobbyRoom.id;
					pmr.zoneId = StorageModel.lobbyRoom.zoneId;
					
					trace("sending out that message and shit " + pmr.message);
					//send it
					_es.engine.send(pmr);
				}
				
				//clear the message input field
				_chatInputTF.text = "";
				
				//give the message field focus
				//				stage.focus = _message;
		}
	}
		
		/**
		 * Attempt to create or join the room specified
		 */
		private function joinRoom(roomName:String):void {
			_pendingRoomName = roomName;
			
			//if currently in a room, leave the room
			if (_room != null) {
				//create the request
//				var lrr:LeaveRoomRequest = new LeaveRoomRequest();
//				lrr.roomId = _room.id;
//				lrr.zoneId = _room.zoneId;
				
				//send it
//				_es.engine.send(lrr);
			}
			
			//create the request
			var crr:CreateRoomRequest = new CreateRoomRequest();
			crr.roomName = roomName;
			crr.zoneName = "chat";
			crr.usingLanguageFilter = true;
			//send it
			_es.engine.send(crr);
		}
		
		/**
		 * Called when the server says you joined a room
		 */
		public function onJoinRoomEvent(e:JoinRoomEvent):void {
			/*
			This function gets called every time you join a room, including a game. But we only want to react here if you joined a room intended for chat.
			There is another event fired when you join a game, and it is handled here: onCreateOrJoinGameResponse
			*/
			//room = _es.managerHelper.zoneManager.zoneById(event.zoneId).roomById(event.roomId);
			
			var eventRoom:Room = _es.managerHelper.zoneManager.zoneById(e.zoneId).roomById(e.roomId);
			
			if (eventRoom.name == _pendingRoomName) {
				//the room you joined
				_room = eventRoom;
				StorageModel.lobbyRoom = eventRoom;
				//update the display to say the name of the room
//				_chatRoomLabel.label_txt.text = eventRoom.name;
				
				//refresh the lists
				refreshUserList();
			}
		}
		
		/**
		 * Called when you receive a chat message from the room you are in
		 */
		public function onPublicMessageEvent(e:PublicMessageEvent):void {
			
			//add a chat message to the history field
//			_history.appendText(e.userName + ": " + e.message + "\n");
			_chatOutputTF.text += "" + e.userName + ": " + e.message + "\n";
			_chatOutputTF.scrollV = _chatOutputTF.maxScrollV;
			
		}
		
		/**
		 * Called when you receive a chat message from another user
		 */
		public function onPrivateMessageEvent(e:PrivateMessageEvent):void {
			
			//add a chat message to the history field
//			_history.appendText("[private] "+ e.userName + ": " + e.message + "\n");
			_chatOutputTF.text += "[private] " + e.userName + ": " + e.message + "\n";
		
		}
		
		/**
		 * This is called when the user list for the room youa re in changes
		 */
		public function onUserUpdateEvent(e:UserUpdateEvent):void {
			trace("user epdate event");
			
			refreshUserList();
		}
		
		/**
		 * Used to refresh the names in the user list
		 */
		private function refreshUserList():void {
			trace("refreshing user list");
			//get the user list
			
			trace(StorageModel.lobbyRoom.users + " users in lobby");
			var users:Array = StorageModel.lobbyRoom.users;
			
			//create a new data provider for the list component
			var dp:DataProvider = new DataProvider();
			
			//loop through the user list and add each user to the data provider
			for (var i:int = 0; i < users.length;++i) {
				var user:User = users[i];
				dp.addItem( { label:user.userName, data:user} );
			}
			
			//tell the component to use this data
			_userList.dataProvider = dp;
			trace("set user list");
		}
		
		/**
		 * Used to refresh the games in the game list
		 */
		private function refresGameList(games:Array):void {
			var lastSelectedGameId:int = -1;
			var indexToSelect:int = -1;
//			if (_gameList.selectedItem != null) {
//				lastSelectedGameId = ServerGame(_gameList.selectedItem.data).id;
//			}
//			
//			//create a new data provider for the list component
//			var dp:DataProvider = new DataProvider();
//			
//			//loop through the rooom list and add each room to the data provider
//			for (var i:int = 0; i < games.length;++i) {
//				var game:ServerGame = games[i];
//				var label:String = "Game " + game.id;
//				label += " [" + (game.locked  ? "full" : "open") + "]";
//				dp.addItem( { label:label, data:game } );
//				
//				if (game.id == lastSelectedGameId) {
//					indexToSelect = i;
//				}
//			}
			
			//tell the component to use this data
//			_gameList.dataProvider = dp;
//			
//			if (indexToSelect > -1) {
//				_joinGame.enabled = true;
//				_gameList.selectedIndex = indexToSelect;
//			} else {
//				_joinGame.enabled = false;
//			}
		}
		
		/**
		 * Add all of the user interface elements
		 */
		private function buildUIElements():void{
			
//			//background of the chat history area
//			var bg1:PopuupBackground = new PopuupBackground();
//			bg1.x = 30;
//			bg1.y = 142;
//			bg1.width = 428;
//			bg1.height = 328;
//			addChild(bg1);
//			
//			//background of the user list area
//			var bg2:PopuupBackground = new PopuupBackground();
//			bg2.x = 493;
//			bg2.y = 142;
//			bg2.width = 260;
//			bg2.height = 150;
//			addChild(bg2);
//			
//			//background of the game list area
//			var bg3:PopuupBackground = new PopuupBackground();
//			bg3.x = 493;
//			bg3.y = 295;
//			bg3.width = 260;
//			bg3.height = 176;
//			addChild(bg3);
//			
//			//text label in the chat history area
//			var txt1:TextLabel = new TextLabel();
//			txt1.label_txt.text = "Chat";
//			txt1.x = 220;
//			txt1.y = 160;
//			addChild(txt1);
////			_chatRoomLabel = txt1;
//			
			//text label in the user list area
//			var txt2:TextLabel = new TextLabel();
//			txt2.label_txt.text = "Users";
//			txt2.x = 620;
//			txt2.y = 160;
//			addChild(txt2);
//			
//			//text label in the game list area
//			var txt3:TextLabel = new TextLabel();
//			txt3.label_txt.text = "Games";
//			txt3.x = 625;
//			txt3.y = 312;
//			addChild(txt3);
			
			
			
			var lobbyAsset:LobbyAssetGrah = new LobbyAssetGrah();
			addChild(lobbyAsset);
			
			
			_chatInputTF = lobbyAsset["chatInput"] as TextField;
			_chatOutputTF = lobbyAsset["chatOutput"] as TextField;
			_levelTF = lobbyAsset["header"]["levelTxt"] as TextField;
			_winsTF = lobbyAsset["header"]["winsTxt"] as TextField;
			_expTF = lobbyAsset["header"]["expTxt"] as TextField;
			_coinsTF = lobbyAsset["header"]["coinsTxt"] as TextField;
			_diamondsTF = lobbyAsset["header"]["diamondsTxt"] as TextField;
//			_chatOutputTF.htmlText = "true";
			_chatOutputTF.multiline = true;
//			_chatOutputTF.selectable = false;
			_chatOutputTF.border = false;
			_chatOutputTF.wordWrap = true;
//			_chatOutputTF.mouseWheelEnabled = true;
//			_chatOutputTF.addEventListener(MouseEvent.MOUSE_WHEEL, onChatOutputMouseWheel);
			
			/**
			 *  Mouase wheel works in final swf, not flash pro debugger for some reason.
			 */
			
			phpManager.getLevel2(_myUsername);
			phpManager.levelSig.add(onLevelReceived);
			phpManager.getWins(_myUsername);
			phpManager.winsSig.add(onWinsReceived);
			phpManager.getExp(_myUsername);
			phpManager.expSig.add(onExpReceived);
			phpManager.getCoins(_myUsername);
			phpManager.coinSig.add(onCoinsReceived);
			
			
			if (!StorageModel.iAmGuest)
			{
				
				c = StorageModel.playerIOClient;
				
				c.payVault.refresh(onRefreshedOk, onRefreshFail);
				function onRefreshedOk():void
				{
					trace(" I have " + c.payVault.coins);
					_diamondsTF.text = "" + c.payVault.coins;
				}
				function onRefreshFail():void
				{
					trace("refresh diamonds failed");
				}
			}
			
//			trace("myLevel" + _myLevel);
			
			//			_p2Level = phpManager.getVarFromUsername("level", _myUsername) 	
			//			_p2Wins = phpManager.getVarFromUsername("wins", _myUsername) 	
			
			
//			_welcomeTF = lobbyAsset["welcomeTxt"] as TextField;
//			_welcomeTF.text = "Welcome, " + _myUsername;
			
			
			_send = lobbyAsset["sendChatBtn"] as SimpleButton;
			_send.addEventListener(MouseEvent.CLICK, onSendClick);
			
			_quickJoinGame = lobbyAsset["joinGameBtn"] as SimpleButton;
			_quickJoinGame.addEventListener(MouseEvent.CLICK, onQuickJoinClicked);
			
			_searchIndicator = lobbyAsset["searchIndicator"] as MovieClip;
			_cancelBtn = lobbyAsset["cancelBtn"] as SimpleButton;
			_logoutBtn = lobbyAsset["logoutBtn"] as SimpleButton;
			_cancelBtn.addEventListener(MouseEvent.CLICK, onCancelBtnClicked);
			_logoutBtn.addEventListener(MouseEvent.CLICK, onLogoutBtnClicked);
			
			
//			_searchIndicator.gotoAndPlay
			_searchIndicator.visible = false;
			_cancelBtn.visible = false;
			
			_userList = lobbyAsset["userList"] as List;
			
			trace("user list " + _userList);
			
//			addChild(_lobby);
			
			toShopBtn = SimpleButton(lobbyAsset["toShopBtn"]);
			toShopBtn.addEventListener(MouseEvent.CLICK, onToShopBtnClicked);
			//history TextArea component used to show the chat log
//			_history = new TextArea();
//			_history.editable = false;
//			_history.x = 50;
//			_history.y = 181;
//			_history.width = 389;
//			_history.height = 207;
//			addChild(_history);
			
			
			setInitialChatMessage();
			//used to allow users to enter new chat messages
//			_message = new TextInput();
//			_message.x = 50;
//			_message.y = 400;
//			_message.width = 390;
//			addChild(_message);
			
			//used to send a chat message
//			_send.label = "send";
//			_send.x = 340;
//			_send.y = 430;
//			addChild(_send);
			//used to display the user list
//			_userList = new List();
//			_userList.x = 513;
//			_userList.y = 170;
//			_userList.width = 222;
//			_userList.height = 103;
//			_userList.addEventListener(Event.CHANGE, onUserSelected);
//			addChild(_userList);
			
			//used to display the game list
//			_gameList = new List();
//			_gameList.x = 513;
//			_gameList.y = 323;
//			_gameList.width = 222;
//			_gameList.height = 103;
//			_gameList.addEventListener(Event.CHANGE, onGameSelected);
//			addChild(_gameList);
			
			//used to launch the create room screen
//			_joinGame = new Button();
//			_joinGame.addEventListener(MouseEvent.CLICK, onJoinGameClicked);
//			_joinGame.x = 634;
//			_joinGame.y = 431;
//			_joinGame.label = "Join Game";
//			addChild(_joinGame);
//			
//			_joinGame.enabled = false;
			
			//used to launch the create room screen
//			_quickJoinGame.x = 513;
//			_quickJoinGame.y = 431;
//			_quickJoinGame.label = "Quick Join";
//			addChild(_quickJoinGame);
			
			if (!StorageModel.currentCursorClassName)
			{
				phpManager.cursorCheckSig.add(onCursorClassCheck);
				phpManager.getCurrentCursorClass(_myUsername);
			}
			else
			{
				trowel = new Trowel(StorageModel.currentCursorClassName);
				this.addChild(trowel);
				Mouse.hide();
			}
			
			sendTrowelToFront();
			
		}
		
		private function setInitialChatMessage():void
		{
			var randy:Number = Math.random();
			
			switch(true)
			{
				case randy <= .2:
					_chatOutputTF.text = "Welcome your highness, " + _myUsername + "\n";
					break;
				
				case randy > .2 && randy <= .4:
					_chatOutputTF.text = "Welcome your loftiness, " + _myUsername + "\n";
					break;
				
				case randy > .4 && randy <= .5:
					_chatOutputTF.text = "Welcome wise traveler, " + _myUsername + "\n";
					break;
				
				case randy > .5:
					_chatOutputTF.text = "Welcome, " + _myUsername + "\n";
					break;
				
			}
			
		}
		
		protected function onLogoutBtnClicked(event:MouseEvent):void
		{
			
			var lr:LogOutRequest = new LogOutRequest();
			_es.engine.send(lr);
			
			_lobbyFlow.initialize();
			
			_lobbyFlow.changeState(LobbyFlow.LOGIN_STATE);
			Mouse.show()
		
		}
		
//		protected function onChatOutputMouseWheel(event:MouseEvent):void
//		{
//			trace(event.delta)
//			{
//				
//			}
//		}
		
		private function sendTrowelToFront():void
		{
			if (trowel && trowel.parent == this)
			{
				this.setChildIndex(trowel, numChildren - 1);
				
			}
		}
		
		protected function onToShopBtnClicked(event:MouseEvent):void
		{
			
						var lrr:LeaveRoomRequest = new LeaveRoomRequest();
						lrr.roomId = _room.id;
						lrr.zoneId = _room.zoneId;
						_es.engine.send(lrr);
			
			_lobbyFlow.changeState(LobbyFlow.SHOP_STATE);
		}
		
		protected function onKeyPress(event:KeyboardEvent):void
		{
			trace("event enter code" + event.charCode);
				
			/**
			 *    ENTER is charCode 13
			 */
			
			if (event.charCode == 13)
			{
				trace("enter pressed");
				
				if (stage.focus == _chatInputTF)
				{
					//send 
					sendChatMessage();
				}
				else
				{
					stage.focus = _chatInputTF;
					_chatInputTF.text = "";
				}
				
			}
			
			
		}
		
		private function onCoinsReceived(coins:int):void
		{
			trace("my coins:" + coins);
			_coinsTF.text = "" + coins;
			phpManager.coinSig.remove(onCoinsReceived);
			StorageModel.myCoins = coins;
		}
		
		private function onWinsReceived(wins:int):void
		{
			trace("my wins:" + wins);
			_winsTF.text = "Wins: " + wins;
			phpManager.winsSig.remove(onWinsReceived);
			StorageModel.myWins = wins;
		}
		
		private function onLevelReceived(level:int):void
		{
			trace("my level is " + level);
			_levelTF.text = "Level: " + level;
			phpManager.levelSig.remove(onLevelReceived);
			StorageModel.myLevel = level;
		}
		
		private function onExpReceived(exp:int):void
		{
			trace("my exp is " + exp);
			_expTF.text = "Exp: " + exp + " / " + LevelUpManager.getExpForNexTLevel();
			phpManager.expSig.remove(onExpReceived);
			StorageModel.myExp = exp;
		}
		
		protected function onCancelBtnClicked(event:MouseEvent):void
		{
			
			_cancelBtn.visible = false;
			_searchIndicator.gotoAndPlay("stop");
			_searchIndicator.visible = false;
			_quickJoinGame.visible = true;
			
			dispatchEvent(new Event(Lobby.SEARCH_CANCELED));
			
		}
		
		private function onGameSelected(e:Event):void {
//			_joinGame.enabled = true;
		}
		
		private function onJoinGameClicked(e:MouseEvent):void {
//			trace(_gameList.selectedItem)
//			if (_gameList.selectedItem != null) {
//				var serverGame:ServerGame = _gameList.selectedItem.data as ServerGame;
//				joinGame(serverGame);
//			}
		}
		
		private function onQuickJoinClicked(e:MouseEvent):void {
			
			_cancelBtn.visible = true;
			_quickJoinGame.visible = false;
			_searchIndicator.visible = true;
			_searchIndicator.gotoAndPlay("searching");
			
			
			quickJoin();
		}
		
		public function set es(value:ElectroServer):void {
			_es = value;
		}
		
		public function get gameRoom():Room { return _gameRoom; }
		
	}
	
}