package
{
	import flash.display.Sprite;
	
	import pre_game.src.PreGameInteractive;
	import pre_game.src.PreGameMain;
	
	public class mJackFB extends Sprite
	{
		public function mJackFB()
		{
			var preGame:PreGameInteractive = new PreGameInteractive();
			addChild(preGame);
		}
	}
}