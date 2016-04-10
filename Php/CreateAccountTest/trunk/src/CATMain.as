package  {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import fl.controls.List;
	import fl.data.DataProvider;
	
	
	public class CATMain extends MovieClip {
		
		
		
		private var _usernameTF:TextField;
		private var _passwordTF:TextField;
		private var _rankTF:TextField;
		
		
		private var _phpBtn:SimpleButton;
		private var con:NetConnection;
		private var res:Responder;
		private var _newBtn:SimpleButton;
		private var _saveBtn:SimpleButton;
		private var _deleteBtn:SimpleButton;
		private var _status_txt:TextField;
		private var billres:Responder;
		private var gw:NetConnection;
		
		
		
		public function CATMain() {
			// constructor code
			trace("cat-dog");
			init();
		}
		
		
		private function init():void
		{
			assignVars();
			addListeners();
			
			initPhp();
		}
		
		
		private function assignVars():void
		{
			_phpBtn = getChildByName("phpButton") as SimpleButton;
			_usernameTF = getChildByName("usernameTxt") as TextField;
			_passwordTF = getChildByName("passwordTxt") as TextField;
			_rankTF = getChildByName("rankTxt") as TextField;
			
			_newBtn = getChildByName("newBtn") as SimpleButton;
			_saveBtn = getChildByName("saveBtn") as SimpleButton;
			_deleteBtn = getChildByName("deleteBtn") as SimpleButton;
			
			_status_txt = getChildByName("satusTxt") as TextField;
		}
		
		private function addListeners():void
		{
			_phpBtn.addEventListener(MouseEvent.CLICK, onPhpButtonClick);
			
			_newBtn.addEventListener(MouseEvent.CLICK, onNewBtnClick);
			_saveBtn.addEventListener(MouseEvent.CLICK, onSaveBtnClick);
			_deleteBtn.addEventListener(MouseEvent.CLICK, onDeleteBtnClick);
			
		}
		
		protected function onDeleteBtnClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function onSaveBtnClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function onNewBtnClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function onPhpButtonClick(event:MouseEvent):void
		{
			trace("php button clicked");
			
			
//			initPhpSecondMethod();
			callDbLookUp();
			
		}
		
		private function initPhpSecondMethod():void
		{
			trace("doing it");
			
			var phpVars:URLVariables = new URLVariables();
			
			var phpFileRequest:URLRequest = new URLRequest("https://s3.amazonaws.com/phpBoy/TutsPlusTest.php");
			
			phpFileRequest.method = URLRequestMethod.POST;
			
			phpFileRequest.data = phpVars;
			
			var phpLoader:URLLoader = new URLLoader();
			phpLoader.dataFormat = URLLoaderDataFormat.TEXT;
			phpLoader.addEventListener(Event.COMPLETE, showResult);
			
			phpVars.systemCall = "checkLogin";
			phpVars.username = _usernameTF.text;
			phpVars.password = _passwordTF.text;
			
			phpLoader.load(phpFileRequest);
		}
		
		protected function showResult(event:Event):void
		{
			trace("output text " + event.target.data.systemResult);
			
		}
		
		private function callDbLookUp():void
		{
			// TODO Auto Generated method stub
			
		}		
		
		private function initPhp():void
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
			
			
//			gw.call("Email.send", res, "mrdotjim@gmail.com", "LoginNigger Information", "Congratulations!\nYou have just made a new account " +
//				"with golden lion games! Please save this email as a reference in case you forgot your username or password.\n\n Username: _username " +
//				"\n\nPassword: _password\n\n Have a ncie day. Enjoy!", "Golden Lion Games");

//			trace("connecting");
//			con = new NetConnection();
//			con.connect("http://50.16.191.209/index.php");
//			billres = new Responder(billyBob, onFault);
//			res = new Responder(reader1, stringFault);
//			
//		
//			// 1st example
////			con.call("DirectoryTest.TalkBack.talk_back", res, "jimmy");
//			
//			//2nd example
//			
//		//	var lilAry:Array = ["hello", "earth"];
//		//	con.call("DirectoryTest.TalkBack.putTogether", res, lilAry);
//			
//			
//			trace("done initializing");
//			
////			read();
//			
//			gw.call("BlackBullDbGo2.read", res);
//			
			var _oneUserAry:Array = ["jerome", "potpies", 4];
			var emptyRes:Responder = new Responder(onEmptyRsponse, onEmptyFault);
			gw.call("BlackBullDbGo2.create", emptyRes, _oneUserAry);
		}
		
		private function onEmptyFault(response:Object):void
		{
			trace("worked");
			
		}
		
		private function onEmptyRsponse(response:Object):void
		{
			trace("didnt");
		}
		
		private function reader1(x:String):void
		{
			trace("yup");
		}
		
		private function read():void
		{
			var responder:Responder = new Responder(readResult, onFault);
			var responder2:Responder = new Responder(billyBob, onFault);
			
			
			
			
		}
		
		private function billyBob (result:Object):void
		{
			
			
		}
		
		private function readResult(result:Object):void
		{
			if (result == false)
			{
				_status_txt.text = "Error reading records.";
			}
			else
			{
			
				var list:List = new List
				var dp:DataProvider = new DataProvider();
				
				
				for (var i:uint = 0; i < result.length; i++)
				{
					trace(result);
//					dp.addItem({name:result[i]['name'],
//								pword:result[i]['pword'],
//								rank:result[i]['rank']});
								
				}
//				list.dataProvider = dp;
			}
		}
		
		private function stringFault(x:String):void
		{
			trace("faulyboy");
		}
		
		private function onFault(responds:Object):void
		{
//			trace("fault! was " + String(responds.description));
			trace("fault" + String(responds.description));
		}
		
	}
	
}
