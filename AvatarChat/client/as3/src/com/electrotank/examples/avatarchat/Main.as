package com.electrotank.examples.avatarchat {
	import flash.display.Sprite;
	import flash.events.Event;
	
	// Logger imports
	import com.electrotank.electroserver5.util.ES5TraceAdapter;
	import com.electrotank.logging.adapter.Log;
	import com.electrotank.logging.adapter.ILogger;
	
	
	public class Main extends Sprite {
		
		//add this so we can see the logs get traced
		Log.setLogAdapter(new ES5TraceAdapter());
			
		public function Main():void {
			
			//create the chat flow
			var lobbyFlow:LobbyFlow = new LobbyFlow();
			addChild(lobbyFlow);
		}
		
		
	}
	
}