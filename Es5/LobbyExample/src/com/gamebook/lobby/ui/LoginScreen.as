package com.gamebook.lobby.ui {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
//	import fl.controls.Button;
//	import fl.controls.TextInput;
	
	/**
	 * ...
	 * @author Jobe Makar - jobe@electrotank.com
	 */
	public class LoginScreen extends MovieClip{
		
		public static const OK:String = "ok";
		
		private var _username:String;
		
		private var _input:TextField;
		private var _usernameTF:TextField;
		private var _submitBtn:SimpleButton;
		
		public function LoginScreen() {
			
			//create background and position it
//			var bg:PopuupBackground = new PopuupBackground();
//			addChild(bg);
//			bg.width = 260;
//			bg.height = 150;
			
			//create input field and position it
//			_input = new TextInput();
//			_input.x = 33;
//			_input.y = 57;
//			_input.width = 185;
//			addChild(_input);
			_usernameTF = this["usernameTxt"];
			
			//create submit button and position it
//			var btn:Button = new Button();
//			btn.label = "Submit";
//			btn.x = 76;
//			btn.y = 90;
//			addChild(btn);
			_submitBtn = this["submitBtn"];
			_submitBtn.addEventListener(MouseEvent.CLICK, onClick);
			
			//create directive and position it
//			var txt:TextLabel = new TextLabel();
//			txt.x = 130;
//			txt.y = 40;
//			txt.label_txt.text = "User Name";
//			addChild(txt);
		}
		
		private function onClick(e:MouseEvent):void {
			if (_usernameTF.text != "") {
				_username = _usernameTF.text;
				dispatchEvent(new Event(OK));
			}
		}
		
		public function get username():String { return _username; }
		
	}
	
}