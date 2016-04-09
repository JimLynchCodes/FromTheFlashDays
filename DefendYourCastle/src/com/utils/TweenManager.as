package com.utils
{
	import com.greensock.TweenLite;

	public class TweenManager
	{
		public function TweenManager()
		{
		}
		
		
		public static function tweenOffTop(popup:*):void
		{
			TweenLite.to(popup, 1, {y:-700});
		}
		
		public static function tweenInTop(popup:*):void
		{
			TweenLite.to(popup, 1, {y:100});
		}
		
		
		
		
	}
}