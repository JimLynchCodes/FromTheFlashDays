package com.gamebook.lobby.ui {
//	import fl.controls.Button;
//	import fl.controls.TextInput;
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.api.LoginRequest;
	import com.electrotank.electroserver5.api.LoginResponse;
	import com.electrotank.electroserver5.api.MessageType;
	import com.gamebook.lobby.LobbyFlow;
	import com.gamebook.lobby.states.LoginState;
	import com.gamebook.model.StorageModel;
	import com.gamebook.util.PhpManager;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import playerio.Client;
	import playerio.PayVault;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	
	/**
	 * ...
	 * @author Jobe Makar - jobe@electrotank.com
	 */
	public class LoginScreenJ extends MovieClip{
		
		public static const OK:String = "ok";
		
		private var _username:String;
		
		private var searchIndicator:SearchIndicator;
		private var registerBtn:SimpleButton;
		private var _emailInputTxt:TextField;
		private var guestBtn:SimpleButton;
		private var loginErrorTF:TextField;
		private var theLogin:LoginScreenJ;
		public var _es:ElectroServer;
		
		
//		private var _input:TextInput;
		private var login:LoginScreenAsset2;
		private var _loginInputTxt:TextField;
		private var loginBtn:SimpleButton;
		private var registerPopup:Sprite;
		private var _passInputTxt:TextField;
		private var _loginState:LoginState;
		private var sendBtnOnForgot:SimpleButton;
		private var backBtnOnForgot:SimpleButton;
		private var emailInputTxtOnForgot:TextField;
		private var forgotErrorTxt:TextField;
		private var forgotSuccess:Sprite;
		private var forgotPopup:Sprite;
		private var forgotBtn:SimpleButton;
		private var registerBtnOnRegister:SimpleButton;
		private var backBtnOnRegister:SimpleButton;
		private var registerSuccess:Sprite;
		private var nameInputOnRegisterTxt:TextField;
		private var emailInputOnRegisterTxt:TextField;
		private var passwordOnRegisterTxt:TextField;
		private var passConfirmOnRegisterTxt:TextField;
		private var regiusterErrorTxt:TextField;
		private var registerErrorTxt:TextField;
		private var registerTxt:Sprite;
		private var phpManager:PhpManager;
		private var enteredEmail:String;
		private var _recoveredName:String;
		private var confirmPasswordTxt:String;
		private var passwordTxt:String;
		private var emailEntered:String;
		private var nameEntered:String;
		private var passwordEntered:String;
		private var usernameEntered:String;
		
		public function LoginScreenJ(loginState:LoginState) {
			
			_loginState = loginState;
		
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
		}
		
		protected function onAddedToStage(event:Event):void
		{
			
			
			init();
			
		}
		
		private function init():void
		{
			
			_es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			
			
				// assign vars for the login screen(s)
			login = new LoginScreenAsset2();
			addChild(login);

			if (!phpManager)
			{
				phpManager = PhpManager.getInstance();
			}

//			phpManager.checkIfNameExists("zaz");
//			phpManager.checkIfNameExists("doofus");
			
			
				// register popup
			registerPopup = login["registerPopup"] as Sprite;
			registerTxt = login["registerPopup"]["registerTxt"] as Sprite;
			registerErrorTxt = login["registerPopup"]["registerTxt"]["registerErrorTxt"] as TextField;
			registerErrorTxt.visible = false;
			passConfirmOnRegisterTxt = login["registerPopup"]["registerTxt"]["passConfirmOnRegisterTxt"] as TextField;
			passwordOnRegisterTxt = login["registerPopup"]["registerTxt"]["passwordOnRegisterTxt"] as TextField;
			emailInputOnRegisterTxt = login["registerPopup"]["registerTxt"]["emailInputOnRegisterTxt"] as TextField  ;
			nameInputOnRegisterTxt = login["registerPopup"]["registerTxt"]["nameInputOnRegisterTxt"] as TextField;
			passConfirmOnRegisterTxt.displayAsPassword = true;
			passwordOnRegisterTxt.displayAsPassword = true;
			
			
			
			registerSuccess = login["registerPopup"]["registerSuccess"] as Sprite;
			registerSuccess.visible = false;
			
			backBtnOnRegister = login["registerPopup"]["backBtnOnRegister"] as SimpleButton;
			registerBtnOnRegister = login["registerPopup"]["registerOnRegisterBtn"] as SimpleButton;
			backBtnOnRegister.addEventListener(MouseEvent.CLICK, onBackBtnOnRegisterClicked);
			registerBtnOnRegister.addEventListener(MouseEvent.CLICK, onRegisterBtnOnRegisterClicked);
			
			
			   
			
			
				// forgot popup
			forgotPopup = login["forgotPopup"] as Sprite;
			forgotSuccess = login["forgotPopup"]["forgotSuccess"] as Sprite;
			forgotErrorTxt = login["forgotPopup"]["forgotErrorTxt"] as TextField;
			forgotSuccess.visible = false;
			forgotErrorTxt.visible = false;
			emailInputTxtOnForgot = login["forgotPopup"]["emailInputTxtOnForgot"] as TextField;
			
			backBtnOnForgot = login["forgotPopup"]["backBtnOnForgot"] as SimpleButton;
			backBtnOnForgot.addEventListener(MouseEvent.CLICK, onBackBtnOnForgotBtnClicked);
			sendBtnOnForgot = login["forgotPopup"]["sendBtnOnForgot"] as SimpleButton;
			sendBtnOnForgot.addEventListener(MouseEvent.CLICK, onSendBtnOnForgotBtnClicked);
			
			
				// main login screen
			_loginInputTxt = login["loginInputTxt"] as TextField;
			_passInputTxt = login["passInputTxt"] as TextField;
			_passInputTxt.displayAsPassword = true;
			_emailInputTxt = login["emailInputTxt"] as TextField;
			loginErrorTF = login["loginErrorTxt"] as TextField;
			loginErrorTF.visible = false;
			loginBtn = login["loginBtn"] as SimpleButton;
			registerBtn = login["registerBtn"] as SimpleButton;
			
			
			guestBtn = login["guestBtn"] as SimpleButton;
			guestBtn.addEventListener(MouseEvent.CLICK, onGuestBtnClicked);
			
			registerBtn = login["registerBtn"] as SimpleButton;
			registerBtn.addEventListener(MouseEvent.CLICK, onRegisterBtnClicked);

			forgotBtn = login["forgotBtn"] as SimpleButton;
			forgotBtn.addEventListener(MouseEvent.CLICK, onForgotBtnClicked);
			
			
			//			var fuck:Fuck = new Fuck();
			//			addChild(fuck);
			
			stage.focus = _loginInputTxt;
			setMainTabIndices()
				
				//			var gameScreen:GameScreenAsset = new GameScreenAsset();
				//			this.addChild(gameScreen);
				trace("added login");
			loginBtn.addEventListener(MouseEvent.CLICK, onLoginSubmit);
		}
		
		private function setMainTabIndices():void
		{
			
			trace("set mains");
			passConfirmOnRegisterTxt.tabEnabled = false;
			passwordOnRegisterTxt.tabEnabled = false;
			emailInputOnRegisterTxt.tabEnabled = false; 
			nameInputOnRegisterTxt.tabEnabled = false;
//			registerBtnOnRegister.tabEnabled = false;
			
			
			_loginInputTxt.tabEnabled = true;
			_passInputTxt.tabEnabled = true;
			loginBtn.tabEnabled = true;
			
			_loginInputTxt.tabIndex = 1;
			_passInputTxt.tabIndex = 2;
			loginBtn.tabIndex = 3;

			
			
		}

		private function setRegisterTabIndices():void
		{
			trace("set registers");
			nameInputOnRegisterTxt.tabIndex = 1;
			emailInputOnRegisterTxt.tabIndex = 2; 
			passwordOnRegisterTxt.tabIndex = 3;
			passConfirmOnRegisterTxt.tabIndex = 4; 
			registerBtnOnRegister.tabIndex = 5; 
			
			loginBtn.tabIndex = 0;
			
			passConfirmOnRegisterTxt.tabEnabled = true;
			passwordOnRegisterTxt.tabEnabled = true;
			emailInputOnRegisterTxt.tabEnabled = true; 
			nameInputOnRegisterTxt.tabEnabled = true;
			registerBtnOnRegister.tabEnabled = true;
			
			
			_loginInputTxt.tabEnabled = false;
			_passInputTxt.tabEnabled = false;
//			loginBtn.tabEnabled = false;
			
		}
		
		protected function onRegisterBtnOnRegisterClicked(event:MouseEvent):void
		{
			/**
			 *   Registration checks consists of 4 steps:
			 * 		1. Check that username isn't already registered
			 * 		2. check that email isn't already registered
			 * 		3. check that password is at least 6 characters
			 * 		4. check that password matches confirm password
			 */
			
			nameEntered = nameInputOnRegisterTxt.text;
			

			phpManager.nameExistenceCheckSig.add(onRegisterNameExistenceCheckResponse);
			phpManager.checkIfNameExists(nameEntered);
			
		}
		
		private function onRegisterNameExistenceCheckResponse(exists:Boolean):void
		{
			phpManager.nameExistenceCheckSig.remove(onRegisterNameExistenceCheckResponse);
			
			if (exists)
			{
				trace("that name exists in db");
				
				registerErrorTxt.text = "Username is already registered.";
				registerErrorTxt.visible = true;
				
			}
			else
			{
				
				emailEntered = emailInputOnRegisterTxt.text;
				phpManager.emailExistenceCheckSig.add(onRegisterEmailExistenceCheckResponse);
				phpManager.checkIfEmailExists(emailEntered);
				
			}
		}
		
		private function onRegisterEmailExistenceCheckResponse(exists:Boolean):void
		{
			phpManager.emailExistenceCheckSig.remove(onRegisterEmailExistenceCheckResponse);
		
			if (exists)
			{
				trace("that email exists in db");
				
				registerErrorTxt.text = "Email is already registered.";
				registerErrorTxt.visible = true;
				
				
			}
			else
			{
				checkPasswordFieldAndAddUser();				
			}
		
		
		
		
		}
		
		private function checkPasswordFieldAndAddUser():void
		{
			passwordTxt = passwordOnRegisterTxt.text;
			confirmPasswordTxt = passConfirmOnRegisterTxt.text; 

			if (passwordTxt.length <= 5)
			{
				registerErrorTxt.text = "Password must be at least 6 characters.";
				registerErrorTxt.visible = true;
				
			}
			else if (passwordTxt != confirmPasswordTxt) 
			{
				registerErrorTxt.text = "Entered passwords don't match.";
				registerErrorTxt.visible = true;
			}
			else
			{
				// all checks cleared and we can enter the information. Woohoo!
				phpManager.insertUserSig.add(onRegisterSuccess);
				phpManager.insertNewUser(nameEntered, emailEntered, passwordTxt);
				
				phpManager.sendWelcomeEmail(emailEntered, nameEntered, passwordTxt);
			}
			
			
			
		}
		
		private function onRegisterSuccess(success:Boolean):void
		{
			
			phpManager.insertUserSig.remove(onRegisterSuccess);
			
			registerErrorTxt.visible = false;
			registerTxt.visible = false;
			registerSuccess.visible = true;
			
		}
		
		protected function onBackBtnOnRegisterClicked(event:MouseEvent):void
		{
			setMainTabIndices();
			TweenLite.to(registerPopup, 1, {y:-500, onComplete:registerPanelFinishedTweeningOut});
		}
		
		private function registerPanelFinishedTweeningOut():void
		{
//			registerErrorTxt.visible = false;
			registerTxt.visible = true;
			registerSuccess.visible = false;
			registerErrorTxt.visible = false;
			
			nameInputOnRegisterTxt.text = "";
			emailInputOnRegisterTxt.text = "";
			passwordOnRegisterTxt.text = "";
			passConfirmOnRegisterTxt.text = "";
		}
		
		protected function onForgotBtnClicked(event:MouseEvent):void
		{
			TweenLite.to(forgotPopup, 1, {x:96});
		}
		
		protected function onBackBtnOnForgotBtnClicked(event:MouseEvent):void
		{
			TweenLite.to(forgotPopup, 1, {x:-436, onComplete:forgotPanelFinishedTweeningOut});
		}
		
		private function forgotPanelFinishedTweeningOut():void
		{
			//			registerErrorTxt.visible = false;
			
			forgotSuccess.visible = false;
			forgotErrorTxt.visible = true;
			forgotErrorTxt.text = "";
			emailInputTxtOnForgot.text = "";
		}
		
		protected function onSendBtnOnForgotBtnClicked(event:MouseEvent):void
		{
			enteredEmail = emailInputTxtOnForgot.text;
			trace("entered email " + enteredEmail);
				
			
			phpManager.emailExistenceCheckSig.add(onForgotEmailExistenceCheckResponse);
			phpManager.checkIfEmailExists(enteredEmail);
		}
		
		private function onForgotEmailExistenceCheckResponse(exists:Boolean):void
		{
			phpManager.emailExistenceCheckSig.remove(onForgotEmailExistenceCheckResponse);
			
			trace("email check : " + exists);
			
			if (exists)
			{
				trace("that email exists in db");
				
				forgotSuccess.visible = true;
				forgotErrorTxt.visible = false;
				phpManager.getNameFromEmailSig.add(onNameFromEmailResponse);
				phpManager.getUsernameFromEmail(enteredEmail);
				emailInputTxtOnForgot.text = "";
				
				
			}
			else
			{
				forgotSuccess.visible = false;
				forgotErrorTxt.visible = true;
				forgotErrorTxt.text = "Account not found for this email."
				trace("that email DOES NOT exist in db");
				
			}
			
		}
		
		private function onNameFromEmailResponse(name:String):void
		{
			_recoveredName = name;
			
			trace("_recoveredName" + _recoveredName)
			phpManager.getNameFromEmailSig.remove(onNameFromEmailResponse);
	
			trace("in name response:" + name);		
			phpManager.getPasswordFromNameSig.add(onPasswordFromNameResponse);
			phpManager.getPasswordFromName(name);
			
			
		}		
		
		private function onPasswordFromNameResponse(pword:String):void
		{
			phpManager.getPasswordFromNameSig.remove(onPasswordFromNameResponse);
			
			trace("found the forgotton stuff, username: " + _recoveredName + " password: " + pword + " and email: " + enteredEmail);
			
			phpManager.sendForgotEmail(enteredEmail, _recoveredName, pword);
			
		}		
		
		
		
		
		
		protected function onRegisterBtnClicked(event:MouseEvent):void
		{
			registerBtn.addEventListener(MouseEvent.CLICK, onRegisterBtnClicked);
			
			TweenLite.to(registerPopup, 1, {y:81});
			
			setRegisterTabIndices();
		}
		
		protected function onGuestBtnClicked(event:MouseEvent):void
		{
			
			
			var randomNum:int = Math.random()*3000;
			
			//create the request
			var lr:LoginRequest = new LoginRequest();
			lr.userName = "Guest" + randomNum;
			lr.password = "";
			//send it
			_es.engine.send(lr);
			
			//			screen.removeEventListener(LoginScreen.OK, onLoginSubmit);
			removeChild(login);
			
			StorageModel.iAmGuest = true;
			
		}
		
		//		protected function onRegisterBtnClciked(event:MouseEvent):void
		//		{
		//			trace("sending request");
		//			var esob:EsObject = new EsObject();
		//			esob.setString(PluginConstants.ACTION, PluginConstants.TAG_REGISTER);
		//			//			esob.setInteger(PluginConstants.X, _trowel.x);
		//			//			esob.setInteger(PluginConstants.Y, _trowel.y);
		//			
		//			esob.setString(PluginConstants.TAG_PASSWORD, _passInputTxt.text);
		//			esob.setString(PluginConstants.TAG_EMAIL, _emailInputTxt.text);
		//			
		//			sendToDbPlugin(esob);
		//		}
		//		
		//		private function sendToDbPlugin(esob:EsObject):void {
		//			//build the request
		//			var pr:PluginRequest = new PluginRequest();
		//			pr.parameters = esob;
		////			pr.roomId = _room.id;
		////			pr.zoneId = _room.zoneId;
		//			pr.pluginName = PluginConstants.DB_PLUGIN_NAME;
		//			
		//			//send it
		//			_es.engine.send(pr);
		//			trace("sent");
		//		}
		
		
		/**
		 * Called as a result of the OK event on the login screen. Creates and sends a login request to the server
		 */
		private function onLoginSubmit(e:MouseEvent):void {
			
			loginBtn.removeEventListener(MouseEvent.CLICK, onLoginSubmit);
			//			var screen:LoginScreen = e.target as LoginScreen;
			usernameEntered = _loginInputTxt.text;
			passwordEntered = _passInputTxt.text;
			
			
				phpManager.nameExistenceCheckSig.add(onLoginNameExistenceCheckResponse);
				phpManager.checkIfNameExists(usernameEntered);
			//create the request
			
			
			//			screen.removeEventListener(LoginScreen.OK, onLoginSubmit);
			
		}
		
		private function onLoginNameExistenceCheckResponse(exists:Boolean):void
		{
			trace("name existence: " + exists);
			
			if (exists)
			{
				trace("sending login request");
				
				var lr:LoginRequest = new LoginRequest();
				lr.userName = usernameEntered;
				lr.password = passwordEntered;
				//send it
				_es.engine.send(lr);
			}
			else
			{
				phpManager.emailExistenceCheckSig.add(onLoginEmailExistenceCheckResponse);
				phpManager.checkIfEmailExists(usernameEntered);
				
			}
		}
		
		private function onLoginEmailExistenceCheckResponse(exists:Boolean):void
		{
			
			trace("email existence: " + exists);

			if (true)
			{
				phpManager.getNameFromEmailSig.add(onLoginGotUsernameFromEmail);
				phpManager.getUsernameFromEmail(usernameEntered);
				
			}
			else
			{
				var lr:LoginRequest = new LoginRequest();
				lr.userName = usernameEntered;
				lr.password = passwordEntered;
				//send it
				_es.engine.send(lr);
			}
		}
		
		private function onLoginGotUsernameFromEmail(name:String):void
		{
			trace("email found and loggin in with " + name + " " + passwordEntered);
				
			var lr:LoginRequest = new LoginRequest();
			lr.userName = name;
			lr.password = passwordEntered;
			//send it
			_es.engine.send(lr);
		}
		
		/**
		 * Called when the server responds to the login request. If successful, create the chat room screen
		 */
		public function onLoginResponse(e:LoginResponse):void {
			if (e.successful) {
				
				trace("login response esOb size" + e.esObject.getSize());
				
				if (e.esObject.getSize() == 0)
				{
					trace("is a guest");
						// if not a guest do after checking player io stuff
					_loginState._lobbyFlow.changeState(LobbyFlow.LOBBY_STATE);
				}
				else
				{
					
					var myUsername:String = _es.managerHelper.userManager.me.userName;
					StorageModel.myUsername = myUsername;
					
					trace("logged in and not a guest: " + myUsername);
					
					PlayerIO.connect(stage,"study-battle-rzw9dxleqeqxturzz5nbyg","public", myUsername,"","", handlePlayerIOConnect);
					
				}
				
				//				trace("login response esObj " + e.esObject.getString("Status"));
				trace("login successful!");

				// LOGIN NOT BEING REMOVED FROM STAGE				
//				removeChild(login);
				
				
				
			} else {
				
				loginErrorTF.visible = true;
				loginErrorTF.alpha = 1;
				loginErrorTF.text = "Incorrect username or password.";
				loginBtn.addEventListener(MouseEvent.CLICK, onLoginSubmit);
				//				showError(e.error.name);
				TweenLite.to(loginErrorTF, 6, {alpha:.6});
			}
		}
		
		private function handlePlayerIOConnect(c:Client):void
		{
			
			StorageModel.playerIOClient = c;
				_loginState._lobbyFlow.changeState(LobbyFlow.LOBBY_STATE);
			
			c.payVault.refresh(onRefreshedOk, onRefreshFail);
			function onRefreshedOk():void
			{
				trace(" I have " + c.payVault.coins);
				
//				/**
//				 *  To add player io coins
//				 */
//				
//				c.payVault.credit(10, "because", onCredited, onCreditFail);
//				function onCredited():void
//				{
//					trace(" I have " + c.payVault.coins);
//				}
//				function onCreditFail(e:PlayerIOError):void
//				{
//					trace("playerio credit failed", e);
//				}
				
				
			}
			function onRefreshFail():void
			{
				trace("playerio refresh failed");
			}
			
			
			
//				trace("lala connected");	
//							c.payVault.getBuyCoinsInfo(
//								"paypal",
//								{
//									coinamount:"75",
//									currency:"USD",
//									item_name:"100 coins",
//									sandbox:"true"
//								},
//								
//								
//								// success handler
//								function(info:Object):void{
//									//Open paypal in new window
//									trace("opening");
//									navigateToURL(new URLRequest(info.paypalurl), "_blank")
//								},
//								// error handler
//								function (e:PlayerIOError):void{
//									trace("Unable to buy coins", e)
//								}
//								
//								
//								
//							)
				
				
//				c.bigDB.loadMyPlayerObject(gotMyPlayerOBject, didntGetPlayerOvbject 	)
//				
//				
//				var obj:Object = {"poopy":String, "yo":String};
//				
//				//			c.bigDB.createObject("PlayerObjects", "testUser", obj, dbCreateworked, cantgetPlayerOb 	)
//				c.bigDB.createObject("highscores", null, {username:"Peter", Score:100}, dbCreateworked, cantgetPlayerOb);
				
				
			
		}
		
		private function onClick(e:MouseEvent):void {
//			if (_input.text != "") {
//				_username = _input.text;
//				dispatchEvent(new Event(OK));
//			}
		}
		
		public function get username():String { return _username; }
		
	}
	
}