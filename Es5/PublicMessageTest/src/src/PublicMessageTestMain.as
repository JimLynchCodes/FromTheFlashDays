package 
{
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.api.ConnectionResponse;
	import com.electrotank.electroserver5.api.CreateRoomRequest;
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.JoinRoomEvent;
	import com.electrotank.electroserver5.api.LoginRequest;
	import com.electrotank.electroserver5.api.LoginResponse;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.PluginListEntry;
	import com.electrotank.electroserver5.api.PublicMessageEvent;
	import com.electrotank.electroserver5.api.PublicMessageRequest;
	import com.electrotank.electroserver5.api.RoomVariable;
	import com.electrotank.electroserver5.api.UserUpdateEvent;
	import com.electrotank.electroserver5.zone.Room;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import lib_symbols.LobbyPanel;
	import lib_symbols.LoginPanel;

	public class PublicMessageTestMain extends MovieClip
	{
		
		private var _es:ElectroServer = new ElectroServer();
		private var _room:Room;
		private var _loginPanelClass:Class;
		private var _loginPanel:LoginPanel;
		private var _lobbyPanelClass:Class;
		private var _lobbyPanel:LobbyPanel;
		private var _stage:Object;
		private var _loginBtn:SimpleButton;
		private var _loginUsernameTF:TextField;
		private var _lobbyRoomTF:TextField;
		private var _chatLogTF:TextField;
		private var _sendChatBtn:SimpleButton;
		private var _tempUsername:String;
		private var _myUsername:String;
		private var _chatInputTF;TextField
		
		
		
		public function PublicMessageTestMain() 
		{
			trace("Jay-zeus!");
			init();
		}
		
		private function init():void
		{
			trace("initializing");	
			assignVars();
			addListeners();
			
			_es.loadAndConnect("https://s3.amazonaws.com/LobbySystem/xml/settings.xml");
		}
		
		private function assignVars():void
		{
			_loginPanelClass = getDefinitionByName("lib_symbols.LoginPanel") as Class;
			_loginPanel = new LoginPanel() as LoginPanel;
			_loginBtn = _loginPanel["loginBtn"];
			_loginUsernameTF = _loginPanel["usernameTxt"];
			
			_lobbyPanelClass = getDefinitionByName("lib_symbols.LobbyPanel") as Class;
			_lobbyPanel = new _lobbyPanelClass() as LobbyPanel;
			_chatInputTF = _lobbyPanel["chatInputTxt"];
			_lobbyRoomTF = _lobbyPanel["lobbyRoomTxt"];
			_chatLogTF = _lobbyPanel["chatLogTxt"];
			_sendChatBtn = _lobbyPanel["sendChatBtn"];
			
		}
		
		private function addListeners():void
		{
			
			_loginBtn.addEventListener(MouseEvent.CLICK, onloginBtnClicked);
			_sendChatBtn.addEventListener(MouseEvent.CLICK, onSendBtnClicked);
			
			_es.engine.addEventListener(MessageType.ConnectionResponse.name, onConnectionResponse);
			_es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			_es.engine.addEventListener(MessageType.JoinRoomEvent.name, onJoinRoomEvent);
			_es.engine.addEventListener(MessageType.PublicMessageEvent.name, onPublicMessageEvent);
			_es.engine.addEventListener(MessageType.UserUpdateEvent.name, onRoomUserUpdateEvent);
			
			
		}		
		
		protected function onRoomUserUpdateEvent(event:UserUpdateEvent):void
		{
//			showUserList();
			trace(" " + event.action.name + " " + event.userName);
			
			
		}
		
		protected function onPublicMessageEvent(event:PublicMessageEvent):void
		{
			_chatLogTF.htmlText += "" + event.userName + ": " + event.message; 
		}
		
		protected function onSendBtnClicked(event:MouseEvent):void
		{
			
			if (_chatInputTF != "")
			{
				var pmr:PublicMessageRequest = new PublicMessageRequest();
				pmr.roomId = _room.id;
				pmr.zoneId = _room.zoneId;
				
				pmr.message = _chatInputTF.text
				_chatInputTF.text = "";
				
				_es.engine.send(pmr);
				trace("public message sent!");
				
			}
			
		}
		
		protected function onJoinRoomEvent(event:JoinRoomEvent):void
		{
			_room = _es.managerHelper.zoneManager.zoneById(event.zoneId).roomById(event.roomId); 
			
			trace("room joined " + _room.id);
			trace("room joined " + _room.name);
			 
				var userAry:Array = event.users
					
			for (i = 0; i < userAry.length; i++)
			{
				trace("user " + i + ": " +userAry[i].userName );
			}
			
			// do we have any room variables? wtf! room variables!
			// This is amazing! The server can send variables to the client! along with a message!
			for (var i:uint = 0; i<_room.roomVariables.length; i++)
			{
				var rv:RoomVariable = _room.roomVariables[i];
				var esob: EsObject = rv.value;
				trace("room var: " + i + ": " + esob.toString());
				
			}
		
			_lobbyRoomTF.text = "Room: " + _room.name;
			showUserList();
			_stage.addChild(_lobbyPanel);
			_chatLogTF.text = "Welcome to the game " + _myUsername; 
			
		
		}
		
		private function showUserList():void
		{
			trace("user list " + _room.users);
			
		}
		
		protected function onloginBtnClicked(event:MouseEvent):void
		{
			var lr:LoginRequest = new LoginRequest();
			lr.userName = _loginUsernameTF.text;
			_tempUsername = _loginUsernameTF.text;
			
			_es.engine.send(lr);
			
			_stage.removeChild(_loginPanel);
//			_addChild(_waitingPanel);
			
		}
		
		protected function onLoginResponse(event:LoginResponse):void
		{
			if (event.successful)
			{
				//successfully logged in, so join a room!
//				joinRoom();
				trace("logged in successfully! " + event.userName);
				_myUsername = event.userName;
				joinRoom();
				
			}
			else
			{
				trace("some error happened when trying to login");
			}
			
		}		
		
		
//		private function joinRoom():void
//		{
//			var crr:CreateRoomRequest = new CreateRoomRequest();
//			
//			crr.roomName = "Room1";
//			crr.zoneName = "TestZone";
//			
//			crr.usingLanguageFilter = true;
//			crr.usingFloodingFilter = true;
//			
//			/**
//			 *  Create the plugin assiciated with this room. Then as chat messages are sent they are intercepted by the server, modified, and sent back to the room
//			 */
//			
//			var ple:PluginListEntry = new PluginListEntry();
//			ple.extensionName = "PublicSendPublicMessage";
//			ple.pluginHandle = "PublicSendPublicMessage";
//			ple.pluginName = "PublicSendPublicMessage";
//			
//			crr.plugins = [ple];
//			
//			trace("sending create room request");
//			_es.engine.send(crr);
//			
//		}
		
		
		private function joinRoom():void{
			var crr:CreateRoomRequest = new CreateRoomRequest();
			
			trace("g");
			crr.roomName = "PluginSendPublicMessage";
			crr.zoneName = "TestZone";
			
			crr.usingLanguageFilter = true;
			crr.usingFloodingFilter = true;
			
			/**
			 * Create plugin associated with this room. Then as chat messages are sent they are intercepted by the server, modified, and sent back to the room
			 */
//			var ple:PluginListEntry = new PluginListEntry();
//			ple.extensionName = "PluginSendPublicMessage";
//			ple.pluginHandle = "PluginSendPublicMessage";
//			ple.pluginName = "PluginSendPublicMessage";
			
//			crr.plugins = [ple];
			crr.plugins = [];
			
			_es.engine.send(crr);
		}
		
		/**
		 * Fired when a connection to the server has either succeeded or failed.
		 */
		private function onConnectionResponse(e:ConnectionResponse):void {
			if (e.successful) {
				trace("connected");
				//add the login panel so the user can login
//				removeChild(waitingPanel);
				_stage = stage;
				
				_stage.addChild(_loginPanel);
				
//				addChild(loginPanel);
			} else {
				trace("connection failed");
//				waitingField.text = "Connection failed!";
			}
		}
		
	}
}