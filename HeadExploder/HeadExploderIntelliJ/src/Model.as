package 
{
import flash.display.Shape;
import flash.display.Stage;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.SharedObject;

import objects.CharChoiceButton;

import objects.CharacterObject;

import starling.core.Starling;
import starling.display.Quad;

import starling.display.Sprite;
import starling.utils.AssetManager;

public class Model
	{
 
        	/** Only one instance of the model locator **/

        	public var userDataSharedObject:SharedObject = SharedObject.getLocal("userData");

		private static var instance:Model = new Model();
		public var flashStage:Stage;
		public var mStarling:Starling;
		public var userScore:int = 0;
	public var characterList:Array = [];
		public var helpPopupSprite:Sprite;
		public var specialPopupSprite:Sprite;
		public var charChoiceButtonArray:Vector.<CharChoiceButton> = new Vector.<CharChoiceButton>;
		private var _currentThingToBuy:String;
		public var currentCostToBuyBrains:int;
		public var currentCostToBuyCoins:int;
		public var currentThingToSell:String;
		public var currentSellBackPriceBrains:int;
		public var currentSellBackPriceCoins:int;
		public var isSoundOn:Boolean;
		public var isMusicOn:Boolean;
		private var _currentCharacterOnScreen:CharacterObject;
		public var characterArea:Sprite;
		public var charactersCurrentlySliding:Boolean;
		public var currentCharChoiceBtnSelected:CharChoiceButton;
	public var game:Game;
	public var platform:String;
	public var splashScreen:Shape;
	public var infoPopupSprite:Sprite;
	public var blockerQuad:Quad;
	public var menuPopupSprite:Sprite;
	public var gameHeaderSprite:Sprite;
	public var assetManager:AssetManager;
	public var explosionSound:Sound;
	public var explosionSoundChannel:SoundChannel;
	public var codesPopupSprite:Sprite;
	public var adDidntFillPopupSprite:Sprite;
	public var taDaSoundChannel:SoundChannel;
	public var taDaSound:Sound;
	 	
		public function Model()
		{
			if(instance)
			{
				throw new Error ("We cannot create a new instance. Please use Model.getInstance()");
			}
		}
		
		public function get currentThingToBuy():String
		{
			return _currentThingToBuy;
		}

		public function set currentThingToBuy(value:String):void
		{
			trace("changing current thing: " + value);
			_currentThingToBuy = value;
		}

		public static function getInstance():Model
		{
			return instance;
		}


	public function set currentCharacterOnScreen(value:CharacterObject):void {
		trace("Changing Value of currentChar: " + value);
		_currentCharacterOnScreen = value;
	}

	public function get currentCharacterOnScreen():CharacterObject {
		return _currentCharacterOnScreen;
	}
}
}