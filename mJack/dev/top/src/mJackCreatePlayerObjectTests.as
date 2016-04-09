package
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import playerio.BigDB;
	import playerio.Client;
	import playerio.DatabaseObject;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	
	[Live]
	public class mJackCreatePlayerObjectTests extends Sprite
	{
	
		
		
		public function mJackCreatePlayerObjectTests()
		{
			init();	
			trace("mJack beginning");
		}
		
		[LiveCodeUpdateListener]
		private function init():void
		{
//			var rect:Recty = new Recty;
//			stage.addChild(rect);
//			rect.x = 100;
			
			
//			var rect2:Recty = new Recty;
//			stage.addChild(rect2);
//			rect2.x = 0;
			
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
			var username:String = "juiceball";
			
			PlayerIO.connect(stage,"mjack-dev-jxmuuaa4j0ofwnvniaq","public",username,"",null,handleConnect,
				onErrorAuthenticating);
			
			
			
			
//			PlayerIO.authenticate(stage,
//				"mjack-dev-jxmuuaa4j0ofwnvniaq","simple",            //Your game id
//				basicDic, null, onFinishedAuthenticating, onErrorAuthenticating);
//			trace("authenticating");
			
		}
		
//		
//		new Dictionary<string, string> {        //Authentication arguments
//			{"register", "true"},               //Register a user
//			{"username", "[username]"},         //Username - required
//			{"password", "[password]"},         //Password - required
//			{"email", "[user@example.com]"},    //Email - optional
//			{"gender", "female"},               //Example of custom data - Gender
//			{"birthdate", "2014-04-22"},        //Example of custom data - Birthdate
		                                   //PlayerInsight segments
		private function handleConnect (client:Client):void {
			//Success!
			//The user is now registered and connected.
			
			trace("done" + client);
			trace("gg" + client.connectUserId, " ", client.bigDB.loadMyPlayerObject());
	
			var object:Object = {};
			client.bigDB.loadMyPlayerObject(onDatabaseCall);

			
//			if (!client.bigDB.loadMyPlayerObject())
//			{
//				client.bigDB.loadOrCreate("PlayerObjects", "players", onFound, onNotFound);
//			}
//			else
//			{
//				trace("worked");
//			}
			
			
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
		private function onFound (client:Client):void {
			//Success!
			//The user is now registered and connected.
			
			trace("done" + client);
		}
		private function onNotFound (error:PlayerIOError ):void {
			//Success!
			//The user is now registered and connected.
			
			trace("done" + error);
		}
		private function onFinishedAuthenticating (client:Client):void {
			//Success!
			//The user is now registered and connected.
			
			trace("done" + client);
		}
		
		private function onErrorAuthenticating(error:PlayerIOError ):void  {
			
			trace("error: " + error);
			//Error registering.
			//Check error.Message to find out in what way it failed,
			//if any registration data was missing or invalid, etc.
		}
		
		
	}
}