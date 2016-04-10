package com.electrotank.examples.avatarchat {

	
	//ElectroServer imports
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.api.SearchCriteria;
	import com.electrotank.electroserver5.api.ErrorType;
	import com.electrotank.electroserver5.api.JoinRoomEvent;
	import com.electrotank.electroserver5.api.LeaveRoomEvent;
	import com.electrotank.electroserver5.api.PublicMessageEvent;
	import com.electrotank.electroserver5.api.UserUpdateEvent;
	import com.electrotank.electroserver5.api.ZoneUpdateEvent;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.CreateRoomRequest;
	import com.electrotank.electroserver5.api.LeaveRoomRequest;
	import com.electrotank.electroserver5.api.PublicMessageRequest;
	import com.electrotank.electroserver5.api.GenericErrorResponse;
	import com.electrotank.electroserver5.api.PluginRequest;
	import com.electrotank.electroserver5.api.PluginListEntry;
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.PluginMessageEvent;
	import com.electrotank.electroserver5.zone.Room;
	import com.electrotank.electroserver5.user.User;
	import com.electrotank.electroserver5.zone.Zone;
	import com.electrotank.examples.avatarchat.avatar.GenericAvatar;
	import com.electrotank.examples.avatarchat.avatar.EmotionState;	
	import com.electrotank.examples.avatarchat.avatar.AvatarControl;	
	import com.electrotank.examples.avatarchat.player.Player;
	import com.electrotank.examples.avatarchat.player.PlayerManager;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	//application imports
	import com.electrotank.examples.avatarchat.ui.CreateRoomScreen;
	import com.electrotank.examples.avatarchat.ui.PopuupBackground;
	import com.electrotank.examples.avatarchat.ui.TextLabel;
	
	//Flash component imports
	import fl.controls.Button;
	import fl.controls.List;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import fl.data.DataProvider;
	
	//Flash imports
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;

	import com.electrotank.logging.adapter.ILogger;
	import com.electrotank.logging.adapter.Log;
	import com.electrotank.utils.LogUtil;

	public class ChatRoomScreen extends Sprite {
		
		private static const log:ILogger = Log.getLogger(LogUtil.categoryFor(prototype));		
		public static const PLUGIN_NAME:String = "AvatarChat";
		public static const EXTENSION_NAME:String = "AvatarChatExtension";
		
		//ElectroServer instance
		private var _es:ElectroServer;
		
		//room you are in
		private var _room:Room;
		
		//UI components
		private var _userList:List;
		private var _message:TextInput;
		private var _history:TextArea;
		private var _send:Button;
		private var _panel:PopuupBackground;
		
		//chat room label
		private var _chatRoomLabel:TextLabel;
		
		private var _pendingRoomName:String;
		private var _myName:String;
		
		// manages all the avatars
		private var _playerManager:PlayerManager;
		
		public function ChatRoomScreen() {}
		
		public function initialize():void {
			log.debug("ChatRoomScreen initializing");
			_playerManager = new PlayerManager();
			_myName = _es.managerHelper.userManager.me.userName;
			
			//add ElectroServer listeners
			_es.engine.addEventListener(MessageType.JoinRoomEvent.name, onJoinRoomEvent);
			_es.engine.addEventListener(MessageType.PublicMessageEvent.name, onPublicMessageEvent);
			_es.engine.addEventListener(MessageType.GenericErrorResponse.name, onGenericErrorResponse);
			_es.engine.addEventListener(MessageType.PluginMessageEvent.name, onPluginMessageEvent);

			//build UI elements
			buildUIElements();
			
			//join a default room
			joinRoom("AvatarChat");
		}
		
		public function destroy():void {
			var lrr:LeaveRoomRequest = new LeaveRoomRequest();
			lrr.roomId = _room.id;
			lrr.zoneId = _room.zoneId;
			_es.engine.send(lrr);
			
			_es.engine.removeEventListener(MessageType.JoinRoomEvent.name, onJoinRoomEvent);
			_es.engine.removeEventListener(MessageType.PublicMessageEvent.name, onPublicMessageEvent);
			_es.engine.removeEventListener(MessageType.GenericErrorResponse.name, onGenericErrorResponse);
			_panel.removeEventListener(MouseEvent.CLICK, onMouseClick);
			_message.removeEventListener(KeyboardEvent.KEY_DOWN,onEnterKeyDown);
			_send.removeEventListener(MouseEvent.CLICK, onSendClick);
		}
		
		/**
		 * An error happened on the server because of something the client did. This captures it and traces it.
		 */
		public function onGenericErrorResponse(e:GenericErrorResponse):void {
			log.debug(e.errorType.name);
		}
		
		/**
		 * Called when the send button is clicked
		 */
		private function onSendClick(e:MouseEvent):void {
			
			//if there is text to send, then proceed
			if (_message.text.length > 0) {
				
				//get the message to send
				var msg:String = _message.text;
				
				//create the request object
				var pmr:PublicMessageRequest = new PublicMessageRequest();
				pmr.message = _message.text;
				pmr.roomId = _room.id;
				pmr.zoneId = _room.zoneId;
					
				//send it
				_es.engine.send(pmr);
				
				//clear the message input field
				_message.text = "";
				
				//give the message field focus
				stage.focus = _message;
			}
		}
		
		/**
		 * Sends formatted EsObjects to the plugin
		 */
		private function sendToPlugin(esob:EsObject):void {
			//build the request
			var pr:PluginRequest = new PluginRequest();
			pr.parameters = esob;
			pr.roomId = _room.id;
			pr.zoneId = _room.zoneId;
			pr.pluginName = PLUGIN_NAME;
			
			//send it
			_es.engine.send(pr);
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
			
			//create the request
			var crr:CreateRoomRequest = new CreateRoomRequest();
			crr.roomName = roomName;
			crr.zoneName = "chat";
			
			//create the plugin
			var ple:PluginListEntry = new PluginListEntry();
			ple.extensionName = EXTENSION_NAME;
			ple.pluginHandle = PLUGIN_NAME;
			ple.pluginName = PLUGIN_NAME;
			
			crr.plugins = [ple];
			
			// turn off events we don't need to reduce number of socket messages
			crr.receivingRoomAttributeUpdates = false;
			crr.receivingRoomListUpdates = false;
			crr.receivingRoomVariableUpdates = false;
			crr.receivingUserListUpdates = false;	// will get these from the plugin
			crr.receivingUserVariableUpdates = false;
			crr.receivingVideoEvents = false;
			
			// turn on the standard chat filtering 
			crr.usingLanguageFilter = true;
			crr.usingFloodingFilter = true;
			
			//send it
			_es.engine.send(crr);
		}
		
		/**
		 * Called when a plugin message arrives.
		 * 
		 */
		private function onPluginMessageEvent(e:PluginMessageEvent):void {
			if (e.pluginName != PLUGIN_NAME) {
				// we aren't interested, don't know how to process it
				return;
			}
			var esob:EsObject = e.parameters;
			//trace the EsObject payload
			log.debug("Plugin event: " + esob);
			
			//get the action which determines what we do next
			var action:String = esob.getString(PluginTags.ACTION.key);
			switch (action) {
				case PluginTags.POSITION_UPDATE_EVENT.key:
					addOrUpdateUser(esob);
					break;
				case PluginTags.AVATAR_STATE_EVENT.key:
					addOrUpdateUser(esob);
					break;
				case PluginTags.USER_LIST_RESPONSE.key:
					handleUserListResponse(esob);
					break;
				case PluginTags.USER_ENTER_EVENT.key:
					handleUserEnterEvent(esob);
					break;
				case PluginTags.USER_EXIT_EVENT.key:
					handleUserExitEvent(esob);
					break;
				default:
					log.debug("Action not handled: " + action);					
			}
		}
		
		/**
		 * Called when the server says you joined a room
		 */
		public function onJoinRoomEvent(e:JoinRoomEvent):void {
			/*
			This function gets called every time you join a room, including a game. But we only want to react here if you joined a room intended for chat.
			*/
			//room = _es.managerHelper.zoneManager.zoneById(event.zoneId).roomById(event.roomId);
			
			var eventRoom:Room = _es.managerHelper.zoneManager.zoneById(e.zoneId).roomById(e.roomId);
			
			if (eventRoom.name == _pendingRoomName) {
				//the room you joined
				_room = eventRoom;
				
				//update the display to say the name of the room
				//_chatRoomLabel.label_txt.text = eventRoom.name;
				
				sendFirstPositionRequest();

				// ask plugin for the full user list
				sendUserListRequest();
				
			}
		}
		
		/**
		 *  Generates a random legal X position for an avatar
		 * 
		 */
		private function getRandomX(): int {
			return Math.round(GenericAvatar.AVATAR_WIDTH  + (_panel.width - GenericAvatar.AVATAR_WIDTH) * Math.random());
			//return Math.round(30 + 428 * Math.random());
		}
		
		/**
		 *  Generates a random legal Y position for an avatar
		 * 
		 */
		private function getRandomY(): int {
			return Math.round(_panel.y + 10 + (_panel.height - 2 * GenericAvatar.AVATAR_HEIGHT) * Math.random());
			//return Math.round(30 + 207 * Math.random());
		}
		
		private function sendFirstPositionRequest(): void {
			var esob:EsObject = new EsObject();
			esob.setString(PluginTags.ACTION.key, PluginTags.POSITION_UPDATE_REQUEST.key);
			esob.setInteger(PluginTags.TARGET_X.key, getRandomX());
			esob.setInteger(PluginTags.TARGET_Y.key, getRandomY());
			
			//send to the plugin
			sendToPlugin(esob);
			
		}

		private function sendUserListRequest(): void {
			var esob:EsObject = new EsObject();
			esob.setString(PluginTags.ACTION.key, PluginTags.USER_LIST_REQUEST.key);
			
			//send to the plugin
			sendToPlugin(esob);
			
		}
		
		/**
		 * Called when you receive a chat message from the room you are in
		 */
		public function onPublicMessageEvent(e:PublicMessageEvent):void {
			
			var name:String = e.userName;
			var p:Player = _playerManager.playerByName(name);
			if (p != null && p.control != null) {
				p.control.handlePublicMessage(e.message);
			}
			
			//add a chat message to the history field
			_history.appendText(e.userName + ": " + e.message + "\n");
		}
		
		private function handleUserListResponse(esob:EsObject): void {
			var players:Array = esob.getEsObjectArray(PluginTags.USER_STATE.key);
			for (var i:int = 0; i < players.length;++i) {
				var player_esob:EsObject = players[i];
				addOrUpdateUser(player_esob);
			}
			refreshUserList();
		}
		
		private function addOrUpdateUser(esob:EsObject):void {
				var name:String = esob.getString(PluginTags.USER_NAME.key);
				var p:Player = _playerManager.playerByName(name);
				if (p == null) {
					p = new Player();
					p.name = name;
					p.isMe = p.name == _myName;
					createAvatarForPlayer(p);
					_playerManager.addPlayer(p);
					// add the avatar to the display
					addChild(p.avatar);
					log.debug("Avatar added for " + p.name);
				}
				
				// TODO: get the emo and position too
				if (esob.doesPropertyExist(PluginTags.TARGET_X.key)) {
					var tx:int = esob.getInteger(PluginTags.TARGET_X.key);
					var ty:int = esob.getInteger(PluginTags.TARGET_Y.key);
					p.setPosition(tx, ty);
				}
				
				if (esob.doesPropertyExist(PluginTags.EMOTION_STATE.key)) {
					var emo:int = esob.getInteger(PluginTags.EMOTION_STATE.key);
					var emoType:EmotionState = EmotionState.getStateFor(emo);
					p.emo = emoType;
				}
				
		}
		
		private function handleUserEnterEvent(esob:EsObject): void {
			addOrUpdateUser(esob);
			refreshUserList();
		}
		
		private function handleUserExitEvent(esob:EsObject):void {
			var name:String = esob.getString(PluginTags.USER_NAME.key);
			var p:Player = _playerManager.playerByName(name);
			if (p != null) {
				removeChild(p.avatar);
				p.userLeft();
				_playerManager.removePlayer(name);
				refreshUserList();
				log.debug("Avatar removed for " + name);
			}
		}
		
		private function createAvatarForPlayer(p:Player): void {
			p.avatar = new GenericAvatar(p);
			if (p.emo == null) {
				p.emo = EmotionState.DEFAULT;
			}
		}
		
		/**
		 * Used to refresh the names in the user list
		 */
		private function refreshUserList():void {
			//get the user list
			var users:Array = _playerManager.players;
			
			//create a new data provider for the list component
			var dp:DataProvider = new DataProvider();
			
			//loop through the user list and add each user to the data provider
			for (var i:int = 0; i < users.length;++i) {
				var user:Player = users[i];
				dp.addItem( { label:user.name, data:user} );
			}
			
			//tell the component to use this data
			_userList.dataProvider = dp;
		}
		
		/**
		 * Add all of the user interface elements
		 */
		private function buildUIElements():void{
			
			//background of the avatar area
			_panel = new PopuupBackground();
			_panel.x = 5;// 30;
			_panel.y = 5;// 142;
			_panel.width = 790;// 428;
			_panel.height = 380;// 328;
			addChild(_panel);
			_panel.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			//background of the user list area
			var bg2:PopuupBackground = new PopuupBackground();
			bg2.x = 493;
			bg2.y = 400;// 142;
			bg2.width = 260;
			bg2.height = 190;
			addChild(bg2);
			
			//text label in the user list area
			var txt2:TextLabel = new TextLabel();
			txt2.label_txt.text = "Users";
			txt2.x = 620;
			txt2.y = 418;// 160;
			addChild(txt2);
			
			//used to allow users to enter new chat messages
			_message = new TextInput();
			_message.x = 15;
			_message.y = 400;
			_message.width = 350;
			_message.maxChars = 70;
			addChild(_message);
			_message.addEventListener(KeyboardEvent.KEY_DOWN,onEnterKeyDown);
			
			//used to send a chat message
			_send = new Button();
			_send.label = "send";
			_send.x = 370;
			_send.y = 400;
			addChild(_send);
			_send.addEventListener(MouseEvent.CLICK, onSendClick);
			
			//used to display the user list
			_userList = new List();
			_userList.x = 513;
			_userList.y = 428;// 170;
			_userList.width = 222;
			_userList.height = 143;
			addChild(_userList);
			
			//background of the chat history area
			var bg1:PopuupBackground = new PopuupBackground();
			bg1.x = 30;
			bg1.y = 442;
			bg1.width = 428;
			bg1.height = 150;
			addChild(bg1);

			//history TextArea component used to show the chat log
			_history = new TextArea();
			_history.editable = false;
			_history.x = 50;
			_history.y = 455;
			_history.width = 389;
			_history.height = 123;
			addChild(_history);
		}
		
		/**
		 *  Called when the user clicks in the _panel area.
		 *  Sends a position update request to the plugin.
		 * 
		 */
		private function onMouseClick(event:MouseEvent):void {
			var x:int = event.stageX;
			var y:int = event.stageY - GenericAvatar.AVATAR_HEIGHT;
			
			x = Math.max(x, GenericAvatar.AVATAR_WIDTH / 2 + _panel.x);
			x = Math.min(x, _panel.width - GenericAvatar.AVATAR_WIDTH / 2);
			
			y = Math.max(y, _panel.y + 10 - GenericAvatar.AVATAR_HEIGHT / 2);
			y = Math.min(y, _panel.height - 1.5 * GenericAvatar.AVATAR_HEIGHT ); 
			
			var esob:EsObject = new EsObject();
			esob.setString(PluginTags.ACTION.key, PluginTags.POSITION_UPDATE_REQUEST.key);
			esob.setInteger(PluginTags.TARGET_X.key, x);
			esob.setInteger(PluginTags.TARGET_Y.key, y);
			
			//send to the plugin
			sendToPlugin(esob);
			
		}
		
		private function onEnterKeyDown(event:KeyboardEvent):void{

			// if the key is ENTER
				if(event.charCode == 13){
					onSendClick(null);
				}
		}
			
		public function set es(value:ElectroServer):void {
			_es = value;
		}
		
	}
	
}