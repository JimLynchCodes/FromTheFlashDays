package com.electrotank.examples.avatarchat.player {
	
	import com.electrotank.examples.avatarchat.avatar.*;
	
	public class Player 	{
		
		private var _name:String;
		private var _isMe:Boolean;
		private var _emo:EmotionState;
		private var _control:AvatarControl;
		private var _avatar:GenericAvatar;

		public function Player() 		{		
		}
		
		public function get name():String { return _name; }
		
		public function set name(value:String):void {
			_name = value;
		}
		
		public function get isMe():Boolean { return _isMe; }
		
		public function set isMe(value:Boolean):void {
			_isMe = value;
		}
		
		public function get emo():EmotionState { return _emo; }
		
		public function set emo(value:EmotionState):void {
			_emo = value;
			_control.handleEmotionStateChange(value);
		}
		
		public function get control():AvatarControl { return _control; }
		
		public function set control(value:AvatarControl):void {
			_control = value;
		}

		public function get avatar():GenericAvatar { return _avatar; }
		
		public function set avatar(value:GenericAvatar):void {
			_avatar = value;
		}
		
		public function setPosition(x:int, y:int) : void {
			_control.handlePositionUpdate(x, y);
		}
		
		public function userLeft(): void {
			if (_avatar != null) {
				_avatar.handleUnload(null);
			}
		}
	}
	
}