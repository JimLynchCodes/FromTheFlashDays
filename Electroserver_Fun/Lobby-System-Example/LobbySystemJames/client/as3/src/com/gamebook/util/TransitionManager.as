package com.gamebook.util
{
	import com.greensock.TweenMax;

	public class TransitionManager
	{
		private static var _thing:Bubble;
		public function TransitionManager()
		{
		}
		
		
		public static function fadeOut(thing:Bubble):void
		{
			trace("THING " + thing);
		
			_thing = thing;
			
			if (thing!= null)
			{
				TweenMax.delayedCall(4, beginFading());
				
			}
			
		}
		
		private static function beginFading():Function
		{
			TweenMax.to(_thing, 10, {alpha:0});	
			return null;
		}		
		
	}
}