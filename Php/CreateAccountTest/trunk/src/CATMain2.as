package
{
	import flash.display.Sprite;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public class CATMain2 extends Sprite
	{
		private var con:NetConnection;
		private var res:Responder;
		public function CATMain2()
		{
			init();
		}
		
		public function init():void
		{
			assignVars();
			addListeners();
			
			doThePhp();
		}
		
		private function doThePhp():void
		{
			con = new NetConnection();
			con.connect("50.16.191.209/Amfphp/index.php");
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds good " + responds);
			}
			
			function onFault(responds:Object):void
			{
				trace("fault");
				
			}
			
			var _things:Array = ["hipper", "yhuha"]
//			con.call("TalkBack.talk_back", res, "hey");
//			con.call("TalkBack.insert", res, _things);
//			con.call("TalkBack.getSomething", res);
//			con.call("TalkBack.insertNice", res, _things);
//			con.call("TalkBack.selectPasswordFromName", res, "sanlo");
//			con.call("TalkBack.poop", res);
//			con.call("TalkBack.easyLookup", res);
//			con.call("TalkBack.updateEasyBoy", res);
//			con.call("TalkBack.getSomething2", res);
			con.call("TalkBack.updateEasy", res);
			
			trace("done");
			
		}
		
		private function assignVars():void
		{
		
		}
		
		private function addListeners():void
		{
				
		}
		
	}
}