package 
{
import characters.FemaleCindy;
import characters.FitnessFrancesca;
import characters.Headmond;
import characters.TonyPizzaGuy;

public class Constants
	{

		// ====== CurrentThingToBuy Constants =======
	    // Ios: jam123
		// these constants all have shortName prefix, no spaces
		public static const BUY_UPGRADE_BRAINS:String = "BUY_UPGRADE_BRAINS";
		public static const BUY_UPGRADE_TIME:String = "BUY_UPGRADE_TIME";
		public static const BUY_UPGRADE_SPECIAL:String = "BUY_UPGRADE_SPECIAL";
		public static const BUY_CHARACTER:String = "BUY_CHARACTER";

		// ====== SharedObject Constants ======
		// these constants all have shortName prefix, no spaces

		public static const APP_FIRST_OPENED:Boolean;
		public static const FRANCESA_DATE_LAST_EXPLODED:Date;
		public static const CHAR_CURRENTLY_ON_SCREEN:String = "CHAR_CURRENTLY_ON_SCREEN";
		public static const UNLOCKED:String = "UNLOCKED";
		public static const UPGRADE_BRAINS_LEVEL:String = "UPGRADE_BRAINS_LEVEL";
		public static const UPGRADE_TIME_LEVEL:String = "UPGRADE_TIME_LEVEL";
		public static const UPGRADE_SPECIAL_LEVEL:String = "UPGRADE_SPECIAL_LEVEL";

		public static const CURRENTLY_GROWING:String = "CURRENTLY_GROWING";
		public static const SPECIAL_CLICKABLE:String = "SPECIAL_CLICKABLE";
		public static const EXPLODED_DATE:String = "EXPLODED_DATE";
		public static const FINISHED_DATE:String = "FINISHED_DATE";


		// ====== Game Constants ======
		public static const FLOATER_FLOAT_DURATION:Number = 6;
		public static var BRAINS_UPGRADE_NAME:String = "Brains Received: ";
		public static var TIME_UPGRADE_NAME:String = "Growth Time: ";
		public static var allCharactersMasterList:Array = [new Headmond(), new FemaleCindy(), new FitnessFrancesca(), new TonyPizzaGuy()];
		public static var STARTING_BRAINS_COUNT:int = 999;
		public static const POPUP_Y_OFF_SCREEN:int = -1200;
		public static const POPUP_Y_ON_SCREEN:int = 87;

		public static const SWIPE_TO_SCROLL_MESSAGE:String = "(Swipe the text above to scroll).";
		
		public static var HELP_TEXT:String = "- Click the Explode button to blow up your characters’ heads and collect brains!\n\n"
										   + "- The Explode button can only be pressed after the character’s head has fully grown back.\n\n"
										   + "- Spend brains at the shop to get upgrades and new characters!\n\n\n\n\n"
				 						   + " Send feedback or questions to\n"
				                           + " jim@wisdomofjim.com"
				;
	public static const SPECIAL_TEXT:String = "Do you want to watch a video ad and use this character's special ability?";
	public static const HEADMOND_INFO:String = "Do you want to watch a video ad and use this character's special ability?" +
			"Do you want to watch a video ad and use this character's special ability?" + "Do you want to watch a video ad and use this character's special ability?";
	public static var SPECIAL_ACTIVATED:String = "SPECIAL_ACTIVATED";
	public static const EXPLODE_BTN_DISABLED_ALPHA:Number = .5;
	public static var SHOP_ARROW_STEP:Number = 20;
	public static var CODE:String = "CODE";
	public static var PREVIOUS_BRAINS_WON_AMOUNT:String = "PREVIOUS_BRAINS_WON_AMOUNT";
	public static const CODES_PROMPT:String = "Enter Code";

	public function Constants() {
	}
}




}