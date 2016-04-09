package pre_game.src {
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import playerio.Client;
	import playerio.Connection;
	import playerio.DatabaseObject;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	
	
	public class PreGameMain extends MovieClip {
		
		
		public function PreGameMain() {
			// constructor code
			init();
		}
		
		private function init():void
		{
			trace("going?");
			
			var sampleDic:Dictionary = new Dictionary ();
			sampleDic["register"] = "true";
			sampleDic["username"] = "shithead";
			sampleDic["password"] = "Password1";
			sampleDic["email"] = "user@gtgfd.com";
			sampleDic["gender"] = "female";
			sampleDic["birthdate"] = "2014-04-22";
			
			var basicDic:Dictionary = new Dictionary();
			basicDic["username"] = "bob";
			basicDic["password"] = "password";
			basicDic["auth"] = "";
			
			//			PlayerIO.connect(stage, "mjack-dev-jxmuuaa4j0ofwnvniaq", "asdasd", "asdadwssad", null, null, onFinishedAuthenticating, onErrorAuthenticating);
			
			//			var username:String = "guest"+Math.floor(Math.random()*500);
			var username:String = "juiceball" + Math.floor(Math.random() * 500);
			;
			
			
			
//			PlayerIO.connect(stage,"mjack-dev-jxmuuaa4j0ofwnvniaq","public",username,"",null,handleConnect,
//				onErrorAuthenticating);
			
			PlayerIO.connect(stage,"mjack-dev-jxmuuaa4j0ofwnvniaq","public",username,"",null,handleConnect,
				onErrorAuthenticating);

			
			
		}
		
		
		private function onErrorAuthenticating(error:PlayerIOError ):void  {
			
			trace("error: " + error);
			//Error registering.
			//Check error.Message to find out in what way it failed,
			//if any registration data was missing or invalid, etc.
		}
		
		
		private function handleConnect (client:Client):void {
			//Success!
			//The user is now registered and connected.
			
			trace("done" + client);
//			trace("gg" + client.connectUserId, " ", client.bigDB.loadMyPlayerObject());
			
//			var object:Object = {};
//			client.bigDB.loadMyPlayerObject(onDatabaseCall);
			
//			client.multiplayer.developmentServer = "127.0.0.1:8184";
			
//			client.multiplayer.createJoinRoom("room4", "FridgeMagnets", true, null, null, onRoomJoin, errorHandler);
			
			client.multiplayer.developmentServer = "localhost:8184";  //Connects us to the local development server instead of the online servers.
			client.multiplayer.createJoinRoom("test2", "FridgeMagnets",true, {},	{},	onRoomJoin,	errorHandler	); //Makes us join or create the room "test"	
			
			//			if (!client.bigDB.loadMyPlayerObject())
			//			{
			//				client.bigDB.loadOrCreate("PlayerObjects", "players", onFound, onNotFound);
			//			}
			//			else
			//			{
			//				trace("worked");
			//			}
			
			
			
			trace("room join");
			
		}
		
		private function onRoomJoin(connection:Connection):void
		{
		trace("room built " + connection, connection.roomId);	
		
		
		}
		
		private function errorHandler(error:PlayerIOError):void
		{
		trace("room error " + error);	
			
		}
		
		private function onDatabaseCall (o:DatabaseObject):void {
			//Success!
			//The user is now registered and connected.
			
			trace("on db call " + o);
			trace("nameo " + o.name);
			
			var occ:DatabaseObject;
			if(!o.name) // that checks if playerobject has that or not. if not it's null
			{
				o.name = "juiceball";
				o.highscore = "5";
				
				o.save();
				trace("saved");
			}
			
			//			trace("done" + client);
		}
		
		
	}
	
}
