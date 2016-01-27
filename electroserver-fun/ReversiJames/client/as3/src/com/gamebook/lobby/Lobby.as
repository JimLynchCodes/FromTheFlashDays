package com.gamebook.lobby {
	
	//ElectroServer imports
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.api.SearchCriteria;
	import com.electrotank.electroserver5.api.ServerGame;
	import com.electrotank.electroserver5.api.ErrorType;
	import com.electrotank.electroserver5.api.JoinRoomEvent;
	import com.electrotank.electroserver5.api.LeaveRoomEvent;
	import com.electrotank.electroserver5.api.PrivateMessageEvent;
	import com.electrotank.electroserver5.api.PublicMessageEvent;
	import com.electrotank.electroserver5.api.UserUpdateEvent;
	import com.electrotank.electroserver5.api.ZoneUpdateEvent;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.CreateRoomRequest;
	import com.electrotank.electroserver5.api.FindGamesRequest;
	import com.electrotank.electroserver5.api.JoinGameRequest;
	import com.electrotank.electroserver5.api.LeaveRoomRequest;
	import com.electrotank.electroserver5.api.PrivateMessageRequest;
	import com.electrotank.electroserver5.api.PublicMessageRequest;
	import com.electrotank.electroserver5.api.QuickJoinGameRequest;
	import com.electrotank.electroserver5.api.CreateOrJoinGameResponse;
	import com.electrotank.electroserver5.api.FindGamesResponse;
	import com.electrotank.electroserver5.api.GenericErrorResponse;
	import com.electrotank.electroserver5.api.PluginMessageEvent;
	import com.electrotank.electroserver5.api.PluginRequest;
	import com.electrotank.electroserver5.zone.Room;
	import com.electrotank.electroserver5.user.User;
	import com.electrotank.electroserver5.zone.Zone;
	import com.gamebook.reversi.GameConstants;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	//application imports
	//import com.gamebook.lobby.ui.CreateRoomScreen;
	import com.gamebook.lobby.ui.PopuupBackground;
	import com.gamebook.lobby.ui.TextLabel;
	
	//Flash component imports
	import fl.controls.Button;
	import fl.controls.List;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import fl.data.DataProvider;
	
	//Flash imports
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Lobby extends MovieClip {
		
		public static const JOINED_GAME:String = "joinedGame";
		
		//ElectroServer instance
		private var _es:ElectroServer;
		
		//room you are in
		private var _room:Room;
		
		private var _gameRoom:Room;
		private var _gameDetails:EsObject;
		
		//UI components
		private var _userList:List;
		private var _gameList:List;
		private var _history:TextArea;
		private var _message:TextInput;
		private var _joinGame:Button;
		private var _send:Button;
		
		//chat room label
		private var _chatRoomLabel:TextLabel;
		
		private var _quickJoinGame:Button;
		private var _pendingRoomName:String;
		private var inLobby:Boolean = false;
		private var _me:String;
		
		public function Lobby() {
			
		}
		
		public function initialize():void {
			//add ElectroServer listeners- new format is _es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			_es.engine.addEventListener(MessageType.JoinRoomEvent.name, onJoinRoomEvent);
			_es.engine.addEventListener(MessageType.PublicMessageEvent.name, onPublicMessageEvent);
			_es.engine.addEventListener(MessageType.PrivateMessageEvent.name, onPrivateMessageEvent);
			_es.engine.addEventListener(MessageType.UserUpdateEvent.name, onUserUpdateEvent);
			//_es.engine.addEventListener(MessageType.FindGamesResponse.name, onFindGamesResponse);
			_es.engine.addEventListener(MessageType.GenericErrorResponse.name, onGenericErrorResponse);
			_es.engine.addEventListener(MessageType.CreateOrJoinGameResponse.name, onCreateOrJoinGameResponse);
			_es.engine.addEventListener(MessageType.PluginMessageEvent.name, onPluginMessageEvent);
			
			
			//build UI elements
			buildUIElements();
			
			//join a default room
			joinRoom("Lobby");
		}
		
		public function destroy():void {
			var lrr:LeaveRoomRequest = new LeaveRoomRequest();
			lrr.roomId = _room.id;
			lrr.zoneId = _room.zoneId;
			_es.engine.send(lrr);
			
			_es.engine.removeEventListener(MessageType.JoinRoomEvent.name, onJoinRoomEvent);
			_es.engine.removeEventListener(MessageType.PublicMessageEvent.name, onPublicMessageEvent);
			_es.engine.removeEventListener(MessageType.PrivateMessageEvent.name, onPrivateMessageEvent);
			_es.engine.removeEventListener(MessageType.UserUpdateEvent.name, onUserUpdateEvent);
			//_es.engine.removeEventListener(MessageType.FindGamesResponse.name, onFindGamesResponse);
			_es.engine.removeEventListener(MessageType.GenericErrorResponse.name, onGenericErrorResponse);
			_es.engine.removeEventListener(MessageType.CreateOrJoinGameResponse.name, onCreateOrJoinGameResponse);
			_es.engine.removeEventListener(MessageType.PluginMessageEvent.name, onPluginMessageEvent);
			
		}
		
		private function quickJoin():void {
			_quickJoinGame.enabled = false;
			
			var qjr:QuickJoinGameRequest = new QuickJoinGameRequest();
			qjr.gameType = GameConstants.PLUGIN_NAME;  // Note: if this lobby has more than one game, we will have to look up the game type
			qjr.zoneName = GameConstants.ZONE_NAME;
			qjr.createOnly = false;
			_es.engine.send(qjr);
		}
		
		private function getBasicQuickJoinRequest():QuickJoinGameRequest {
			var qjr:QuickJoinGameRequest = new QuickJoinGameRequest();
			qjr.gameType = GameConstants.PLUGIN_NAME;
			qjr.zoneName = GameConstants.ZONE_NAME;
			qjr.hidden = false;
			qjr.locked = false;
			qjr.createOnly = false;
			
			var initOb:EsObject = new EsObject();
			initOb.setString(GameConstants.PLAYER_NAME, _me);
			initOb.setBoolean(GameConstants.AI_OPPONENT, true);

			qjr.gameDetails = initOb;

			return qjr;
    }
		
		
		private function joinGame(gameToJoin:AvailGame):void {
			trace("game clicked: " + gameToJoin.name);
			
			var qjr:QuickJoinGameRequest = getBasicQuickJoinRequest();
			var initOb : EsObject = qjr.gameDetails;
			switch (gameToJoin.gameId) {
				case LobbyConstants.PIXEL_GAME:
					qjr.createOnly = true;  // make a new game with AI opponent
					qjr.hidden = true;      // don't let anybody else join it
					_es.engine.send(qjr);
					break;
				case LobbyConstants.QUICK_JOIN:
					qjr.createOnly = false;  // join any game, no AI opponent unless a human isn't found
					initOb.setBoolean(GameConstants.AI_OPPONENT, false);
					_es.engine.send(qjr);
					break;
				case LobbyConstants.CREATE_NEW:
					qjr.createOnly = true;  // make a new game and wait for human opponent
					initOb.setBoolean(GameConstants.AI_OPPONENT, false);
					initOb.setInteger(GameConstants.COUNTDOWN, 
						GameConstants.COUNTDOWN_SECONDS_FOR_CREATE_NEW_GAME);
					_es.engine.send(qjr);
					break;
				default:
					var jgr:JoinGameRequest = new JoinGameRequest();
					jgr.gameId = gameToJoin.gameId;
					_es.engine.send(jgr);
			}
		}
		
		public function onCreateOrJoinGameResponse(e:CreateOrJoinGameResponse):void {
			if (e.successful) {
				if (e.gameDetails) {
					_gameDetails = e.gameDetails as EsObject;
				}
				// join room event happens next; it will finish the job
			} else {
				_quickJoinGame.enabled = true;
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
		 * Called when a user name in the list is selected
		 */
		private function onUserSelected(e:Event):void {
			if (_userList.selectedItem != null) {
				
				//grab the User object off of the list item
				var user:User = _userList.selectedItem.data as User;
				
				//add private message syntax to the message entry field
				_message.text = "/" + user.userName + ": ";
			}
		}
		
		/**
		 * Called when the send button is clicked
		 */
		private function onSendClick(e:MouseEvent):void {
			
			//if there is text to send, then proceed
			if (_message.text.length > 0) {
				
				//get the message to send
				var msg:String = _message.text;
				
				//check to see if it is a public or private message
				if (msg.charAt(0) == "/" && msg.indexOf(":") != -1) {
					//private message
					
					//parse the message to get who it is meant to go to
					var to:String = msg.substr(1, msg.indexOf(":") - 1);
					
					//parse the message to get the message content and strip out the 'to' value
					msg = msg.substr(msg.indexOf(":")+2);
					
					//create the request object
					var prmr:PrivateMessageRequest = new PrivateMessageRequest();
					prmr.userNames = [to];
					prmr.message = msg;
					
					//send it
					_es.engine.send(prmr);
					
				} else {
					//public message
					
					//create the request object
					var pmr:PublicMessageRequest = new PublicMessageRequest();
					pmr.message = _message.text;
					pmr.roomId = _room.id;
					pmr.zoneId = _room.zoneId;
					
					//send it
					_es.engine.send(pmr);
				}
				
				//clear the message input field
				_message.text = "";
				
				//give the message field focus
				stage.focus = _message;
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
				var lrr:LeaveRoomRequest = new LeaveRoomRequest();
				lrr.roomId = _room.id;
				lrr.zoneId = _room.zoneId;
				
				//send it
				_es.engine.send(lrr);
			}
			
			//create the request to join a lobby "game"
			var qjr:QuickJoinGameRequest = new QuickJoinGameRequest();
			qjr.gameType = LobbyConstants.PLUGIN_NAME;
			qjr.zoneName = LobbyConstants.ZONE_NAME;
			qjr.hidden = false;
			qjr.locked = false;
			qjr.createOnly = false;
		
			var initOb: EsObject = new EsObject();
		
			qjr.gameDetails = initOb;
		
			_es.engine.send(qjr);
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
			var descript:String = e.roomDescription;
			if (descript == LobbyConstants.PLUGIN_NAME) {
				//grab and store the reference to the room you just joined, IF it is a lobby room
				_room = _es.managerHelper.zoneManager.zoneById(e.zoneId).roomById(e.roomId);
				_chatRoomLabel.label_txt.text = descript;
				inLobby = true;
				refreshUserList();
			} else {
				// this is a game room you just joined.  tell LobbyFlow you joined the game
				_gameRoom = _es.managerHelper.zoneManager.zoneById(e.zoneId).roomById(e.roomId);
				dispatchEvent(new Event(JOINED_GAME));
			}
		}
		
		/**
		 * Called when you receive a chat message from the room you are in
		 */
		public function onPublicMessageEvent(e:PublicMessageEvent):void {
			
			//add a chat message to the history field
			_history.appendText(e.userName + ": " + e.message + "\n");
		}
		
		/**
		 * Called when you receive a chat message from another user
		 */
		public function onPrivateMessageEvent(e:PrivateMessageEvent):void {
			
			//add a chat message to the history field
			_history.appendText("[private] "+ e.userName + ": " + e.message + "\n");
		}
		
		/**
		 * This is called when the user list for the room youa re in changes
		 */
		public function onUserUpdateEvent(e:UserUpdateEvent):void {
			refreshUserList();
		}
		
		/**
		 * Used to refresh the names in the user list
		 */
		private function refreshUserList():void {
			//get the user list
			var users:Array = _room.users;
			
			//create a new data provider for the list component
			var dp:DataProvider = new DataProvider();
			
			//loop through the user list and add each user to the data provider
			for (var i:int = 0; i < users.length;++i) {
				var user:User = users[i];
				dp.addItem( { label:user.userName, data:user} );
			}
			
			//tell the component to use this data
			_userList.dataProvider = dp;
		}
		
		/**
		 * Used to refresh the games in the game list
		 */
		private function refresGameList(games:Array):void {
			var lastSelectedGameId:int = -1;
			var indexToSelect:int = -1;
			if (_gameList.selectedItem != null) {
				lastSelectedGameId = AvailGame(_gameList.selectedItem.data).gameId;
			}
			
			//create a new data provider for the list component
			var dp:DataProvider = new DataProvider();
			
			//loop through the rooom list and add each room to the data provider
			for (var i:int = 0; i < games.length;++i) {
				var game:AvailGame = games[i];
				var label:String = game.name;
				dp.addItem( { label:label, data:game } );
				
				if (game.gameId == lastSelectedGameId) {
					indexToSelect = i;
				}
			}
			
			//tell the component to use this data
			_gameList.dataProvider = dp;
			
			if (indexToSelect > -1) {
				_joinGame.enabled = true;
				_gameList.selectedIndex = indexToSelect;
			} else {
				_joinGame.enabled = false;
			}
		}
		
		/**
		 * Add all of the user interface elements
		 */
		private function buildUIElements():void{
			
			//background of the chat history area
			var bg1:PopuupBackground = new PopuupBackground();
			bg1.x = 30;
			bg1.y = 142;
			bg1.width = 428;
			bg1.height = 328;
			addChild(bg1);
			
			//background of the user list area
			var bg2:PopuupBackground = new PopuupBackground();
			bg2.x = 493;
			bg2.y = 142;
			bg2.width = 260;
			bg2.height = 150;
			addChild(bg2);
			
			//background of the game list area
			var bg3:PopuupBackground = new PopuupBackground();
			bg3.x = 493;
			bg3.y = 295;
			bg3.width = 260;
			bg3.height = 176;
			addChild(bg3);
			
			//text label in the chat history area
			var txt1:TextLabel = new TextLabel();
			txt1.label_txt.text = "Chat";
			txt1.x = 220;
			txt1.y = 160;
			addChild(txt1);
			_chatRoomLabel = txt1;
			
			//text label in the user list area
			var txt2:TextLabel = new TextLabel();
			txt2.label_txt.text = "Users";
			txt2.x = 620;
			txt2.y = 160;
			addChild(txt2);
			
			//text label in the game list area
			var txt3:TextLabel = new TextLabel();
			txt3.label_txt.text = "Games";
			txt3.x = 625;
			txt3.y = 312;
			addChild(txt3);
			
			//history TextArea component used to show the chat log
			_history = new TextArea();
			_history.editable = false;
			_history.x = 50;
			_history.y = 181;
			_history.width = 389;
			_history.height = 207;
			addChild(_history);
			
			//used to allow users to enter new chat messages
			_message = new TextInput();
			_message.x = 50;
			_message.y = 400;
			_message.width = 390;
			addChild(_message);
			
			//used to send a chat message
			_send = new Button();
			_send.label = "send";
			_send.x = 340;
			_send.y = 430;
			addChild(_send);
			_send.addEventListener(MouseEvent.CLICK, onSendClick);
			
			//used to display the user list
			_userList = new List();
			_userList.x = 513;
			_userList.y = 170;
			_userList.width = 222;
			_userList.height = 103;
			_userList.addEventListener(Event.CHANGE, onUserSelected);
			addChild(_userList);
			
			//used to display the game list
			_gameList = new List();
			_gameList.x = 513;
			_gameList.y = 323;
			_gameList.width = 222;
			_gameList.height = 103;
			_gameList.addEventListener(Event.CHANGE, onGameSelected);
			addChild(_gameList);
			
			//used to launch the create room screen
			_joinGame = new Button();
			_joinGame.addEventListener(MouseEvent.CLICK, onJoinGameClicked);
			_joinGame.x = 634;
			_joinGame.y = 431;
			_joinGame.label = "Join Game";
			addChild(_joinGame);
			
			_joinGame.enabled = false;
			
			//used to launch the create room screen
			//_quickJoinGame = new Button();
			//_quickJoinGame.addEventListener(MouseEvent.CLICK, onQuickJoinClicked);
			//_quickJoinGame.x = 513;
			//_quickJoinGame.y = 431;
			//_quickJoinGame.label = "Quick Join";
			//addChild(_quickJoinGame);
			
		}
		
		private function onGameSelected(e:Event):void {
			_joinGame.enabled = true;
		}
		
		private function onJoinGameClicked(e:MouseEvent):void {
			trace(_gameList.selectedItem)
			if (_gameList.selectedItem != null) {
				var gameToJoin:AvailGame = _gameList.selectedItem.data as AvailGame;
				joinGame(gameToJoin);
			}
		}
		
		private function onQuickJoinClicked(e:MouseEvent):void {
			quickJoin();
		}
		
		public function set es(value:ElectroServer):void {
			_es = value;
		}
		
		public function get gameRoom():Room { return _gameRoom; }
		
		public function get gameDetails():EsObject { return _gameDetails; }
		
		public function set me(value:String):void {
			_me = value;
		}
		public function get me():String { return _me; }
	
		/**
		 * Called when a message is received from a plugin
		 */
		public function onPluginMessageEvent(e:PluginMessageEvent):void {
			if (e.pluginName != LobbyConstants.PLUGIN_NAME) {
				// we aren't interested, don't know how to process it
				return;
			}
			var esob:EsObject = e.parameters;
			//trace the EsObject payload; comment this out after debugging finishes!
			trace("Plugin event: " + esob.toString());
			
			//get the action which determines what we do next
			var action:String = esob.getString(LobbyConstants.ACTION);
			switch (action) {
				case LobbyConstants.GAMES_FOUND:
					handleGamesFoundEvent(esob);
					break;
				case LobbyConstants.NO_GAMES_FOUND:
					handleGamesFoundEvent();
					break;
				default:
					trace("Action not handled: " + action);
			}
		}
		
		public function handleGamesFoundEvent(esob:EsObject = null) : void {
			var games:Array = new Array();
			if (esob) {
				var esobs:Array = esob.getEsObjectArray(LobbyConstants.GAMES_FOUND);
			
				for (var ii:int = 0; ii < LobbyConstants.NUM_ROWS; ii++) {
					if (ii < esobs.length) {
						var ag:AvailGame = new AvailGame(esobs[ii]);
						games.push(ag);
					}
				}
			}
			
			// now push the default games
			var botGame:AvailGame = new AvailGame();
			botGame.setAI();
			games.push(botGame);
			
			var quickGame:AvailGame = new AvailGame();
			quickGame.setQuickJoin();
			games.push(quickGame);
			
			var createGame:AvailGame = new AvailGame();
			createGame.setCreateNew();
			games.push(createGame);
			
			
			// finally, update the UI
			refresGameList(games);
		}
		
	
	}
	
}