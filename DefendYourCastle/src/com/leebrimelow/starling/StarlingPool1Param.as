package com.leebrimelow.starling
{
	import com.utils.RungeKuttaMover;
	
	import starling.display.DisplayObject;

	public class StarlingPool1Param
	{
		public var items:Array;
		private var counter:int;
		
		public function StarlingPool1Param(type:Class, len:int, param:*)
		{
			items = new Array();
			counter = len;
			
			var i:int = len;
			while(--i > -1)
				items[i] = new type(param);
		}
		
		public function getSprite():RungeKuttaMover
		{
			if(counter > 0) {
				counter--;
				return items.pop();
			} else {
				throw new Error("You exhausted the pool!");
			}
		}
		
		public function returnSprite(s:DisplayObject):void
		{
			items[counter++] = s;
		}
		
		public function destroy():void
		{
			items = null;
		}
	}
}