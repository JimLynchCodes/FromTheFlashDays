package helpers
{
	import flash.display.Sprite;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public class PEFPhpGuy extends Sprite
	{
		private var _model:Object;
		private var gw:NetConnection;
		private var res:Responder;
		
		
		public function PEFPhpGuy(model)
		{
			_model = model;
			init();
			trace("php class initialized");
		}
		
		private function init():void
		{
			trace("doing actual php stuff");
			gw = new NetConnection();
			gw.connect("http://50.16.191.209/index.php");
			
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds");
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
		
			
			gw.call("Email.send", res, "mrdotjim@gmail.com", "Login Information", "Congratulations!\nYou have just made a new account " +
				"with golden lion games! Please save this email as a reference in case you forgot your username or password.\n\n Username: _username " +
				"\n\nPassword: _password\n\n Have a ncie day. Enjoy!", "Golden Lion Games");

//			gw.close();
		}
		
		
		public function sendRegisterEmail():void
		{
			gw.call("Email.send", res, "mrdotjim@gmail.com", "Login Information", "Your password currently is password.");
			
		}
		
		
	}
}