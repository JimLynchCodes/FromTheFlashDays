package com.gamebook.lobby.states
{
	import com.electrotank.electroserver5.ElectroServer;
	import com.gamebook.lobby.ui.LoginScreenJ;
	
	import flash.display.Sprite;
	import com.gamebook.lobby.LobbyFlow;
	
	public class LoginState extends Sprite implements IState
	{
		private var _es:ElectroServer;
		public var _lobbyFlow:LobbyFlow;
		private var theLogin:LoginScreenJ;
		public function LoginState(lobbyFlow:LobbyFlow, es:ElectroServer)
		{
			_lobbyFlow = lobbyFlow;
			_es = es;
			init();
		}
		
		private function init():void
		{
			createLoginScreen();
		}
		
		private function createLoginScreen():void
		{
				theLogin = new LoginScreenJ(this);
				theLogin._es = _es;
				addChild(theLogin);
				
		}
		
		public function update():void
		{
		}
		
		public function destroy():void
		{
		}
	}
}