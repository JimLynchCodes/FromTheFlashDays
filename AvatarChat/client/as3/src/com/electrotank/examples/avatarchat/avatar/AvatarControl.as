package com.electrotank.examples.avatarchat.avatar {
	import com.electrotank.examples.avatarchat.player.Player;
	
	public class AvatarControl 	{
		
		private var _player:Player;
		private var _avatar:GenericAvatar;
		
		public function AvatarControl(player:Player, avatar:GenericAvatar) {
			_avatar = avatar;
			_player = player;
			
			_player.control = this;
		}
		
		public function handleEmotionStateChange(emo:EmotionState):void {
			_avatar.handleEmotionStateChange(emo);
		}
		
		public function handlePositionUpdate(toX:Number, toY:Number):void {
			_avatar.handlePositionUpdate(toX, toY);
		}
		
		public function handlePublicMessage(str:String):void {
			_avatar.updateSpeechBubble(str);
		}
		
		public function get name() : String {
			return _player.name;
		}

	}
	
}