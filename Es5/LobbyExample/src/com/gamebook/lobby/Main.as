package com.gamebook.lobby {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author Jobe Makar - jobe@electrotank.com
	 */
	public class Main extends Sprite {
		private var _stage:Object;
		
		public function Main():void {
			
			//create the chat flow
			trace("Main");
			_stage = stage;
			var lobbyFlow:LobbyFlow = new LobbyFlow(_stage);
			addChild(lobbyFlow);
		}
		
		
	}
	
}