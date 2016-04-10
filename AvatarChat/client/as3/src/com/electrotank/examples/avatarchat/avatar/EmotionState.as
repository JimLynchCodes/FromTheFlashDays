package com.electrotank.examples.avatarchat.avatar {
	/**
	 * An avatar can be in one of several emotional states. Those states are enumerated here.
	 */
	public class EmotionState {
		
		public static const DEFAULT:EmotionState = new EmotionState(LOCK, 0);
		public static const HAPPY:EmotionState = new EmotionState(LOCK, 1);
		public static const SAD:EmotionState = new EmotionState(LOCK, 2);
		public static const SURPRISED:EmotionState = new EmotionState(LOCK, 3);
		public static const CONFUSED:EmotionState = new EmotionState(LOCK, 4);
		
		/**
		 * @private
		 */
		private static const LOCK:Object = {};
		
		//--------------------------------------------------------------------------
		//
		//  Class 
		//
		//--------------------------------------------------------------------------
		
		private static function get all():Vector.<EmotionState> {
			return Vector.<EmotionState> ([
				DEFAULT,
				HAPPY,
				SAD,
				SURPRISED,
				CONFUSED
			]);
		}
		
		public static function getStateFor(key:int):EmotionState {
			for each (var avatarState:EmotionState in all) {
				if (avatarState.key == key)
					return avatarState;
			}
			
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
			
		/**
		 * <code>AvatarState</code> constructor.
		 */
		public function EmotionState(lock:Object, key:int) {
			if (lock != LOCK)
				throw new Error("Cannot instantiate enum.");
				
			_key = key;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _key:int;
		
		/**
		 * A letter representing the state.
		 */
		public function get key():int { return _key; }
		
	}
	
}
