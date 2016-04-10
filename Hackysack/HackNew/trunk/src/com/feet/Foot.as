package com.feet
{
	import flash.display.Sprite;
	
	public class Foot extends Sprite
	{
		private var _model:Object;
		
		
		public function Foot(model:Object)
		{
			_model = model;
			super();
			trace("feet");
		}
	}
}