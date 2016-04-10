package 
{
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.EsObjectRO;
	import com.electrotank.electroserver5.api.LoginRequest;
	import com.electrotank.electroserver5.api.LoginResponse;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.PluginMessageEvent;
	import com.electrotank.electroserver5.api.PluginRequest;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	
	
	public class DBLoginInEC2 extends Sprite
	{
		private var _lobbyPanel:Sprite;
		private var _loginPanel:Sprite;
		private var _loginBtn:SimpleButton;
		private var _userNameTF:TextField;
		private var _es:ElectroServer;
		private var _stage:Object;
		private var _passwordTF:TextField;
		private var _waitingPanel:Object;
		private var _waitingPanelTF:TextField;
		private var _rankTF:TextField;
		private var _increaseRankBtn:SimpleButton;
		private var _welcomeTF:TextField;
		
		
		public function DBLoginInEC2()
		{
			
			init();
			
			_stage.addChild(_waitingPanel);
			
			//load the connection settings, and connect
			_es.loadAndConnect("https://s3.amazonaws.com/LobbySystem/xml/settings.xml");
			
			
		}
		
		private function init():void
		{
			assignVars();
			addListeners();
		}
		
		private function assignVars():void
		{
			_es = new ElectroServer();
			
			var _lobbyPanelClass:Class = getDefinitionByName("lib_symbols.LobbyPanel") as Class;
			_lobbyPanel = new _lobbyPanelClass() as Sprite
				
			_welcomeTF = _lobbyPanel["welcomeTxt"];
			_rankTF = _lobbyPanel["rankTxt"];
			_increaseRankBtn = _lobbyPanel["increaseRankBtn"];
				
			var _loginPanelClass:Class = getDefinitionByName("lib_symbols.LoginPanel") as Class;
			_loginPanel = new _loginPanelClass() as Sprite
				
				
			_loginBtn = _loginPanel["loginBtn"];
			_userNameTF = _loginPanel["usernameTxt"];
			_passwordTF = _loginPanel["passwordTxt"];
			
			var _waitingPanelClass:Class = getDefinitionByName("lib_symbols.WaitingPanel") as Class;
			_waitingPanel = new _waitingPanelClass() as Sprite
			
			_waitingPanelTF = _waitingPanel["waitingPanelTxt"];
				
			_stage = stage;
				
		}
		
		private function addListeners():void
		{
			//listen for certain events to allow the application to flow, and to support chatting and user list updates
			_es.engine.addEventListener(MessageType.ConnectionResponse.name, onConnectionResponse);
			_es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			_es.engine.addEventListener(MessageType.PluginMessageEvent.name, onPluginMessageEvent);
			
			_loginBtn.addEventListener(MouseEvent.CLICK, onLoginBtnClick);
			
			_increaseRankBtn.addEventListener(MouseEvent.CLICK, addToRankClicked);
		}
		
		protected function onLoginBtnClick(event:MouseEvent):void
		{
			var userName:String = _userNameTF.text
			var password:String = _passwordTF.text
				
			
			// create a LoginRequest, and send it
			var lr:LoginRequest = new LoginRequest();
			lr.userName = userName;
			lr.password = password;
			
			trace("tryint to loging with username: " + userName + " and password: " + password);
			
			_es.engine.send(lr);
			
			_stage.removeChild(_loginPanel);
			_waitingPanel.visible = true;			
			
		}
		
		protected function onPluginMessageEvent(event:PluginMessageEvent):void
		{
			var esob:EsObject = event.parameters;
			var action:String = esob.getString(PluginConstants.ACTION);
			
			switch (action) {
				case PluginConstants.TAG_ADD_TO_RANK:
				case PluginConstants.TAG_GET_RANK:
					var rank:int = esob.getInteger(PluginConstants.TAG_GET_RANK);
					_rankTF.text = "RANK: " + rank;
					trace("received rank! " + rank);
					break;
				case PluginConstants.TAG_ERROR:
					var err:String = esob.getString(PluginConstants.TAG_ERROR);
					trace(err);
					break;
			}
			
		}
		
		/**
		 * Increases your rank by the amount specified by sending a properly formatted message to the plugin.
		 */
		private function addToRankClicked(m:MouseEvent):void {
			var ipr:PluginRequest = new PluginRequest();
			ipr.pluginName = "DatabasePlugin";
			
			var esob:EsObject = new EsObject();
			esob.setString(PluginConstants.ACTION, PluginConstants.TAG_ADD_TO_RANK);
			esob.setInteger(PluginConstants.TAG_ADD_TO_RANK, 3);
			ipr.parameters = esob;
			_es.engine.send(ipr)
			trace("sending add to rank request");
			
		}
		
		
		/**
		 * Loads your rank from the database by asking the plugin for it.
		 */
		private function getRank():void {
			var ipr:PluginRequest = new PluginRequest();
			ipr.pluginName = "DatabasePlugin";
			ipr.zoneId = -1;
			ipr.roomId = -1;
			
			var esob:EsObject = new EsObject();
			esob.setString(PluginConstants.ACTION, PluginConstants.TAG_GET_RANK);
			ipr.parameters = esob;
			_es.engine.send(ipr)
			trace("sending rank request");
		}
		
		
		
		protected function onLoginResponse(event:LoginResponse):void
		{
			if (event.successful) 
			{
				trace("login successful!");
				_waitingPanel.visible = false;
				_stage.addChild(_lobbyPanel);
				
				_welcomeTF.text = "Welcome, " + event.userName;
				getRank();
				
			}
			
			else
			{
				var esob:EsObjectRO = event.esObject;
				var msg:String = event.error.name;
				if (esob != null)
				{
					var str:String = esob.getString("Status");
					if (str != null && str.length > 0)
					{
						msg = str;
						_waitingPanelTF.text = "Login Failed: " + msg;		
						trace("Login Failed: " + msg);		
					}
				}
				
			}
			
		}
		
		protected function onConnectionResponse(event:Event):void
		{
			trace("connected!");
			
			_waitingPanel.visible = false;
			_stage.addChild(_loginPanel);
			
			
		}
	}
}