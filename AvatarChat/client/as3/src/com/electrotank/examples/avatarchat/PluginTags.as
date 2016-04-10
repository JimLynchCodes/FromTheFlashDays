package com.electrotank.examples.avatarchat {
	/**
	 * An avatar can be in one of several emotional states. Those states are enumerated here.
	 */
	public class PluginTags {
		
		public static const ACTION:PluginTags = new PluginTags(LOCK, "a");
		public static const ERROR:PluginTags = new PluginTags(LOCK, "err");
		public static const USER_LIST_REQUEST:PluginTags = new PluginTags(LOCK, "ul");
		public static const USER_LIST_RESPONSE:PluginTags = new PluginTags(LOCK, "ulr");
		public static const USER_ENTER_EVENT:PluginTags = new PluginTags(LOCK, "j");
		public static const USER_EXIT_EVENT:PluginTags = new PluginTags(LOCK, "x");
		public static const POSITION_UPDATE_REQUEST:PluginTags = new PluginTags(LOCK, "p");
		public static const POSITION_UPDATE_EVENT:PluginTags = new PluginTags(LOCK, "pe");
		public static const AVATAR_STATE_EVENT:PluginTags = new PluginTags(LOCK, "ave");
		public static const USER_NAME:PluginTags = new PluginTags(LOCK, "n");
		public static const USER_STATE:PluginTags = new PluginTags(LOCK, "s");
		public static const EMOTION_STATE:PluginTags = new PluginTags(LOCK, "em");
		public static const TARGET_X:PluginTags = new PluginTags(LOCK, "tx");
		public static const TARGET_Y:PluginTags = new PluginTags(LOCK, "ty");
		
		/**
		 * @private
		 */
		private static const LOCK:Object = {};
		
		//--------------------------------------------------------------------------
		//
		//  Class 
		//
		//--------------------------------------------------------------------------
		
		private static function get all():Vector.<PluginTags> {
			return Vector.<PluginTags> ([
				ACTION,
				ERROR,
				USER_LIST_REQUEST,
				USER_LIST_RESPONSE,
				USER_ENTER_EVENT,
				USER_EXIT_EVENT,
				POSITION_UPDATE_REQUEST,
				POSITION_UPDATE_EVENT,
				AVATAR_STATE_EVENT,
				USER_NAME,
				USER_STATE,
				EMOTION_STATE,
				TARGET_X,
				TARGET_Y
			]);
		}
		
		public static function getStateFor(key:String):PluginTags {
			for each (var avatarState:PluginTags in all) {
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
		 * <code>PluginTags</code> constructor.
		 */
		public function PluginTags(lock:Object, key:String) {
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
		private var _key:String;
		
		/**
		 * A string used for this PluginTag
		 */
		public function get key():String { return _key; }
		
	}
	
}
