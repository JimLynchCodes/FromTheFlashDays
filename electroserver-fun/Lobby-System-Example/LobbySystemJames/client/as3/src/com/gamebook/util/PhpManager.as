package com.gamebook.util
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.system.Security;
	
	import org.osflash.signals.Signal;

	public class PhpManager
	{
		
		private static var instance:PhpManager;
		private static var allowInstantiation:Boolean;
		
		private var con:NetConnection;
		private var res:Responder;
		public var levelSig:Signal = new Signal();
		public var winsSig:Signal = new Signal();
		public var expSig:Signal = new Signal();
		public var emailExistenceCheckSig:Signal = new Signal();
		public var getNameFromEmailSig:Signal = new Signal();
		public var getPasswordFromNameSig:Signal = new Signal();
		public var nameExistenceCheckSig:Signal = new Signal();
		public var insertUserSig:Signal = new Signal();
		public var coinSig:Signal = new Signal();
		public var updateSig:Signal = new Signal();
		public var cursorCheckSig:Signal = new Signal();
		public var enoughCoinsCheckSig:Signal = new Signal();
		public var unlockSig:Signal = new Signal();
		public var setExpSig:Signal = new Signal();
		public var offsetCheckSig:Signal = new Signal();
		public var offsetSetSig:Signal = new Signal();
		
		public function PhpManager()
		{
			
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
		}
		
		public static function getInstance():PhpManager {
			if (instance == null) {
				allowInstantiation = true;
				
				instance = new PhpManager();
				
				allowInstantiation = false;
			}

			return instance;
		}
		
		
		private function init():void
		{
			
			Security.allowDomain("*");
//			Security.loadPolicyFile("https://xmlFiles.s3.amazonaws.com/crossdomain.xml")
			
			if (con == null)
			{
				con = new NetConnection();
				con.connect("http://50.16.191.209/Amfphp/index.php");
				
			}
			
//			res = new Responder(onResult, onFault);
//		
//		
//			function onResult(responds:Object):void
//			{
//				trace("responds" + responds);
//				
//			}
//			
//			
//			function onFault(responds:Object):void
//			{
//				for(var i:int = 0; i < responds.length; i++)
//				{
//					trace(responds[i]);
//				}
//			}
//		
//			con.call("QuestionDbUtil.lookupLevel", res, );			
		}
			
		public function getStringVarFromUsername(variable:String, username:String):String
		{
			var value:String = new String;
			
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds good " + responds);
			}
			
			function onFault(responds:Object):void
			{
				trace("fault");
				
			}
			
			
			var _thingsToSend:Array = [variable, username]
			con.call("Prod.QuestionDbUtil.getStringVar", res, _thingsToSend);
			
			trace("done");
			
			return value;
		}
		
		public function getLevel(username:String):int
		{
			
			var value:int = new int;
			
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds good " + responds);
				value = int(responds);
			}
			
			function onFault(responds:Object):void
			{
				trace("fault");
				
			}
			
			
//			var _thingsToSend:Array = [variable, username]
			
			con.call("Prod.QuestionDbUtil.lookupLevel", res, username);
			
			trace("done");
			
			return value;
			
			
			
		}
		
		
		public function getLevel2(name:String):void
		{
			res = new Responder(onResult, onFault);
			
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var level:int = int(responds);
				levelSig.dispatch(level);
				
			}
			
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionDbUtil2.lookupLevel", res,name);
			trace("called");
		}
		
		public function getWins(name:String):void
		{
			res = new Responder(onResult, onFault);
			
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var wins:int = int(responds);
				winsSig.dispatch(wins);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionDbUtil2.lookupWins", res,name);
			trace("called");
		}
		
		public function getExp(name:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var exp:int = int(responds);
				expSig.dispatch(exp);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionDbUtil2.lookupExp", res,name);
			trace("called");
		}
		
		public function getCoins(name:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var coins:int = int(responds);
				coinSig.dispatch(coins);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionDbUtil2.lookupCoins", res,name);
			trace("called");
		}
		
		public function getUsernameFromEmail(email:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var name:String = (responds).toString();
				getNameFromEmailSig.dispatch(name);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionDbUtil2.getNameFromEmail", res,email);
			trace("called");
		}
		
		public function getPasswordFromName(name:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var password:String = (responds).toString();
				getPasswordFromNameSig.dispatch(password);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionDbUtil2.getPasswordFromName", res,name);
			trace("called");
		}
		
		public function addOneWin(name:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var success:String = (responds).toString() + " wins";
				updateSig.dispatch(success, "wins", 1);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionDbUtil2.addOneWin", res,name);
			trace("called");
		}
		
		public function addOneLevel(name:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var success:String = (responds).toString() + " level";
				updateSig.dispatch(success, "level", 1);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionDbUtil2.addOneLevel", res,name);
			trace("called");
		}
		
		public function addToExp(name:String, delta:int):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var success:String = (responds).toString() + " exp";
				updateSig.dispatch(success, "exp", delta);
				
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionDbUtil2.addToExp", res,name, delta);
			trace("called");
		}
		
		public function getCurrentCursorClass(name:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var className:String = (responds).toString();
				cursorCheckSig.dispatch(className);
				
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.CursorDBUtil.getCurrentCursor", res,name);
			trace("called");
		}
		
		
		public function addToCoins(name:String, delta:int):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var success:String = (responds).toString() + " coinage";
				updateSig.dispatch(success, "coin", delta);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionDbUtil2.addToCoins", res,name, delta);
			trace("called");
		}
		
		public function updateCurrentCursor(name:String, cursorClassName:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var success:String = (responds).toString() + " coinage";
				updateSig.dispatch(success);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.CursorDBUtil.updateCurrentCursor", res,name, cursorClassName);
			trace("called");
		}
		
		public function subtractAmountFromCoins(name:String, amount:int):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var success:String = (responds).toString() + " coinage";
				updateSig.dispatch(success, "coin", amount);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionDbUtil2.subtractAmountFromCoins", res,name, amount);
			trace("called");
		}
		
		
		
		
		public function checkIfNameExists(name:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace(name + " responds" + responds);
				var exists:Boolean = Boolean(responds);
					nameExistenceCheckSig.dispatch(exists);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionDbUtil2.checkIfNameExists", res,name);
			trace("checking for" + name);
		}
		
		public function checkIfEmailExists(email:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace(email + " responds" + responds);
				var exists:Boolean = Boolean(responds);
				emailExistenceCheckSig.dispatch(exists);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			trace("checking for existence of email: " + email);
			con.call("Prod.QuestionDbUtil2.checkIfEmailExists", res,email);
			trace("checking " + email);
		}
		
		public function checkIfHasEnoughCoins(name:String, coinAmount:int):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace(coinAmount + " responds" + responds);
				var exists:Boolean = Boolean(responds);
				enoughCoinsCheckSig.dispatch(exists);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			trace("checking coin amount " + coinAmount);
			con.call("Prod.QuestionDbUtil2.checkIfCoinsMoreThanAmount", res,name, coinAmount);
		}
		
		public function setExp(name:String, coinAmount:int):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace(coinAmount + " responds" + responds);
				var newExp:int = int(responds);
				setExpSig.dispatch(newExp);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			trace("checking exp amount " + coinAmount);
			con.call("Prod.QuestionDbUtil2.checkIfCoinsMoreThanAmount", res,name, coinAmount);
		}
		
		public function getCursorOffset(name:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds yay curs" + responds);
				if (responds == false)
				{
					trace("ahh, get cursor offset responded false!");
				}
				else
				{
					var offsetAry:Array = (responds) as Array;
					offsetCheckSig.dispatch(responds);
					
				}
			}
			
			function onFault(responds:Object):void
			{
				trace("cursor offset responds badly");
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			trace("getting offset amount for" + name);
			con.call("Prod.CursorDBUtil.getOffset", res,name);
		}
		
		public function updateCursorOffset(name:String, offsetX:Number, offsetY:Number):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace("responds" + responds);
				var offsetAry:Boolean = Boolean(responds);
				offsetSetSig.dispatch(responds);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			trace("getting offset amount for" + name);
			con.call("Prod.CursorDBUtil.updateCursorOffset", res,name, offsetX, offsetY);
		}
		
		
		public function sendForgotEmail(email:String, name:String, pword:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace(email + " responds" + responds);
//				var exists:Boolean = Boolean(exists);
//				emailExistenceCheckSig.dispatch(exists);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionEmailer.sendEmail", res, email, "Login Credentials Request", "Here are your Trivia Battle Credentials\n\n" +
				"Username: " + name + "   Password: " + pword + "\n\n Thanks for playing Trivia Battle!\n\n\nSincerely,\nYour Friends at Trivia Battle", "info@goldenliongames.com", "Trivia Battle");
			trace("email sent!");
		}

		
		public function sendWelcomeEmail(email:String, name:String, pword:String):void
		{
			res = new Responder(onResult, onFault);
			
			function onResult(responds:Object):void
			{
				trace(email + " responds" + responds);
				//				var exists:Boolean = Boolean(exists);
				//				emailExistenceCheckSig.dispatch(exists);
			}
			
			function onFault(responds:Object):void
			{
				for(var i:int = 0; i < responds.length; i++)
				{
					trace(responds[i]);
				}
			}
			
			con.call("Prod.QuestionEmailer.sendEmail", res, email, "Welcome to Study Battle, " + name +"!\n\n", "It's always a great day here in Study Battle Land!\n" +
				"Whether you are study for the SAT exam, testing your own english vocabulary knowledge, or just enjoy real time human competition, we hope you will find" +
				" what you are looking for in Study Battle. Here at Golden Lion Games we continue to raise the bar for free online games so feel free to reply to this email " +
				"if you any questions, comments, or suggestions. We love hearing from users! We hope you will enjoy the game and learn more than just a thing or two." +
				" We want you to be the happiest, smartest person to ever live. So go on, get out there and start playing!\n\n" +
				"www.goldenliongames.com/study-battle.html\n\nYour login credentials  -  Username: " + name + "   Password: " + pword + "\n\nThanks for playing Study Battle!" +
				"\n\n\nSincerely,\nYour Friends at Study Battle", "info@goldenliongames.com", "Study Battle");
			trace("email sent!");
		}

		public function insertNewUser(name:String, email:String, password:String):void
		{
			res = new Responder(onResult, onFault);
			var itemsTableRes:Responder = new Responder(onItemResult, onItemFault);
			
			function onItemResult(responds:Object):void
			{
				trace("insert new user into items table responds: " + responds);
			}
			
			
			function onItemFault(responds:Object):void
			{
				trace("insert new user faulted");
			}
			
			function onResult(responds:Object):void
			{
				trace("insert new user responds: " + responds);
				insertUserSig.dispatch(responds); 
			}
			
			
			function onFault(responds:Object):void
			{
				trace("insert new user faulted");
			}
			
			con.call("Prod.QuestionDbUtil2.insertNewUser", res, name, email, password);
			con.call("Prod.QuestionDbUtil2.insertNewUserIntoItemsTable", itemsTableRes, name);
			
			trace("called");
		}

		public function checkIfCursorOwned(name:String, databaseVar:String):void
		{
			res = new Responder(onResult, onFault);
			
			
			function onResult(responds:Object):void
			{
				trace("insert new user responds" + responds);
				var exists:int = int(responds);
				cursorCheckSig.dispatch(exists);
			}
			
			
			function onFault(responds:Object):void
			{
				trace("insert new user faulted");
			}
			
			con.call("Prod.CursorDBUtil.checkIfItemOwned", res, name, databaseVar);
			trace("called");
		}
		
		public function unlockItem(name:String, databaseVar:String):void
		{
			res = new Responder(onResult, onFault);
			
			
			function onResult(responds:Object):void
			{
				trace("insert new user responds" + responds);
				var exists:Boolean = Boolean(responds);
				unlockSig.dispatch(exists);
			}
			
			
			function onFault(responds:Object):void
			{
				trace("insert new user faulted");
			}
			
			con.call("Prod.CursorDBUtil.unlockItem", res, name, databaseVar);
			trace("called");
		}
		
		
		public function getIntVarFromUsername(variable:String, username:String):int
		{
			var value:int = new int;
			
			
			return value;
		}
		
		
		
		
		
			
		
	}
}