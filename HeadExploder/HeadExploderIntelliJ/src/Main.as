package
{
import flash.display.Screen;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;


import starling.core.Starling;
import starling.display.Button;
import starling.display.Quad;
import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Event;


public class Main extends Sprite
{
	private var bgContainer:Sprite;
	public static var GAME_W:Number;
	public static var GAME_H:Number;
	private var buttonname:Array = ["PLAY","SETTINGS","MUSIC","INSTRUCTIONS"];

	private var game:Game;
	public static var scaleFactor:uint;
	public static var stageVideoAvailable:Boolean;

		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
 			Assets.contentScaleFactor = Starling.current.contentScaleFactor;
 		}
		
		private function onAddedToStage():void
		{
 			initMenu();
		}

		private function initMenu():void{
			game = new Game(stage);
			addChild(game);
			trace("Starting app with width: " + stage.stageWidth +
					" and height: " + stage.stageHeight + ".");
			
			var mainScreen:Screen = Screen.mainScreen;
			var screenBounds:Rectangle = mainScreen.bounds;
			
			/// Does not work - comes out 320 by 480
			trace("width: " +screenBounds.width + " height: " + screenBounds.height + " GAME_W :"+GAME_W+" GAME_H :"+GAME_H);
			trace("GAME_W: " + GAME_W + " GAME_H: " + GAME_W);

			var model:Model = Model.getInstance();
			model.flashStage.removeChild(model.splashScreen);
 		}
		
 
	}
}