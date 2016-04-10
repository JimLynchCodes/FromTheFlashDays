package balls
{
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	public class Ball extends Sprite
	{
		private var _initialY:Number;
		private var _ball:Sprite;
		
		public function Ball(initialY:Number)
		{
			_initialY = initialY;
			init();
		}
		
		private function init():void
		{
			assignVars();
			addListeners();
		}
		
		private function assignVars():void
		{
			var ballClass:Class = getDefinitionByName("Ball") as Class;
			_ball = new ballClass();
			
		}
		
		private function addListeners():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}