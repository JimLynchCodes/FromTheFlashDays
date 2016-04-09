package
{
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import inner_game.src.InGameMain;
	
//	import pre_game.src.PreGameMainNew;
	
	[SWF(width="950", height="550", backgroundColor="#ffffff", frameRate="30")]
	public class StateTester extends MovieClip
	{
		public function StateTester()
		{
			StageScaleMode.EXACT_FIT;
			init();
		}
		
		private function init():void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			trace("starting state tester");
			var testState:* = new InGameMain(stage);
//			var testState:* = new PreGameMainNew(stage);
			
			addChild(testState);
			
		}
	}
}