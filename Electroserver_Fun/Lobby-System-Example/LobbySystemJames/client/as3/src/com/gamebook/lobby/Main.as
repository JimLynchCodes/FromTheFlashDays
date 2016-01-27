package com.gamebook.lobby {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mochi.as3.MochiAd;
	
	import playerio.BigDB;
	import playerio.Client;
	import playerio.DatabaseObject;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	
	/**
	 * ...
	 * @author Jobe Makar - jobe@electrotank.com
	 */
	
	[SWF(frameRate="40", width="600", height="480", backgroundColor="0x333333")]
	
	public dynamic class Main extends MovieClip {
		public static var PRODUCTION:Boolean = false;
		
		public function Main():void {
			trace("main started");
			//create the chat flow
			
			
				// connection established
			
			var lobbyFlow:LobbyFlow = new LobbyFlow();
			addChild(lobbyFlow);
			
//			var mochiMC:MovieClip = new MovieClip();
//			MochiAd.showPreGameAd({clip:root, id:"970db54f9a0b450c", res:"600x480"});
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			
		}
		
		private function handleConnect(c:Client):void
		{
			trace("lala connected");	
//			c.payVault.getBuyCoinsInfo(
//				"paypal",
//				{
//					coinAmount:"1000",
//					currency:"USD",
//					item_name:"1000 coins"
//				},
//				// success handler
//				function(info:Object):void{
//					//Open paypal in new window
//					navigateToURL(new URLRequest(info.paypalurl), "_blank")
//				},
//				// error handler
//				function (e:PlayerIOError):void{
//					trace("Unable to buy coins", e)
//				}
//				
//				
//				
//			)
				
				
			c.bigDB.loadMyPlayerObject(gotMyPlayerOBject, didntGetPlayerOvbject 	)
				

			var obj:Object = {"poopy":String, "yo":String};
				
//			c.bigDB.createObject("PlayerObjects", "testUser", obj, dbCreateworked, cantgetPlayerOb 	)
			c.bigDB.createObject("highscores", null, {username:"Peter", Score:100}, dbCreateworked, cantgetPlayerOb);
				
				
		}
		
		protected function onRightClick(event:MouseEvent):void
		{
			trace("right been clicked!");
		}
		
		private function cantgetPlayerOb():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function dbCreateworked(o:DatabaseObject):void
		{
			trace("oh my");
		}
		
		private function didntGetPlayerOvbject():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function gotMyPlayerOBject(o:DatabaseObject):void
		{
			trace("got" + o.key + o.table);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			
		}		
		
	}
	
}