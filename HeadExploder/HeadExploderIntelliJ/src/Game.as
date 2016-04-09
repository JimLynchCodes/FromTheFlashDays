package
{

import com.distriqt.extension.application.Application;
import com.ma.extensions.NativeLogger.NativeLoggerANE;

import objects.CharacterObject;

import starling.animation.DelayedCall;

import util.BubblePopupManager;


import util.HeadController;
import util.SoundManager;

import flash.events.GeolocationEvent;

import flash.events.ProgressEvent;
import flash.events.StatusEvent;

import flash.events.TimerEvent;
import flash.net.URLRequest;
import flash.sensors.Geolocation;
import flash.system.Capabilities;
import flash.utils.Timer;
	import flash.utils.getDefinitionByName;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;

	
	public class Game extends Sprite
	{
		trace("go");
		private var _char1body:Sprite;
		private var _char1head:Sprite;
		public var _gameDecorator:GameDecorator;
		
		private var _brains:int= 0;
		private var _headRegrowTimerChar1:Timer;
		private var charBody:Image;
		
		private var explodeAimation:MovieClip;
		private var _stage:starling.display.Stage;
		private var _originalCharHeadX:Number;
		private var _originalCharHeadY:Number;
		private var _main:HeadExploder;
		private var _model:Model;
		private var headGrowing:Boolean;

	private var DISTRIQT_APPLICATION_KEY:String = "765e7f4d5c275c4447e5f2c3b16252b374f5038aFQzLGksWT0ayuDOGsYaliydTbOno8vRPv6pGtGyApyW16/Opg5magfDidm+vwknfTOzk1yt0X+vxW76/3l7LlOAKVoj2KAMyx562bvMxizs+n/Eyz2Pd6LJ2HuLv5N/fq6JTwOb9mB0VTnC+P1kRDM+ElyNDi8Atcpy8BQsDqDMlnGitPpK3lDBT0PZ4329OJDSpx0M83DRQ32YfkRJJC/BFgdtpqVYkI3mQrz3l6Gpa0IZ/1sDQDBFlbYJ1S68misaRTI2BIezSHwyJLviyqk3gnPamhFF5peszUyTAlivp0Yq+//neRGZXqAx0eAEN8BcW5BiKLhEdMMp3ezYjrQ==";
	private var geo:Geolocation;
	private var _headController:HeadController;
	private var appIsActive:Boolean = false;
	private var _soundManager:util.SoundManager;
		private var _bubblePopupManager:BubblePopupManager;


		public function Game(stage:Stage)
		{
			Starling.current.nativeStage.frameRate = 60;
			_stage = stage;
			initGameScreen();
		}
		
		private function initGameScreen():void {
			_model = Model.getInstance();
			_model.game = this;
			_gameDecorator = GameDecorator.getInstance();
			_bubblePopupManager = BubblePopupManager.getInstance();
			addChild(_gameDecorator);

			_headController = HeadController.getInstance();
			_soundManager = util.SoundManager.getInstance();
			_gameDecorator.addGameBackground();
			_gameDecorator.addExplodeBtn();

			_gameDecorator.addGameHeader();
			_gameDecorator.buildGameCharacters();
			_gameDecorator.addBubblePopups();
			_gameDecorator.buildBlockerQuad();


			_gameDecorator.buildMenuPopup();
			_gameDecorator.buildCodesPopup()
			_gameDecorator.buildShopPopup();
			_gameDecorator.buildHelpPopup();
			_gameDecorator.buildSpecialPopup();
			_gameDecorator.buildConfirmPopup();
			_gameDecorator.buildAdDidntFillPopup();
			_gameDecorator.buildInfoPopup();
			_gameDecorator.buildSearchingForAdPopup();
			_gameDecorator.addFloaters();

//			_bubblePopupManager.displaySaying(_model.currentCharacterOnScreen.sayingsArray[0],
//					_model.currentCharacterOnScreen.speechBubblePoint,
//					_model.currentCharacterOnScreen.thoughtBubblePoint);

			var urlRequest:URLRequest = new URLRequest();
			trace("@@# User Agent" + urlRequest.userAgent);

			trace("geo supported? " + Geolocation.isSupported);
			if (Geolocation.isSupported) {
				geo = new Geolocation();
				trace("muted ge?! " + geo.muted);
				if (!geo.muted) {
					geo.addEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
					trace("adding update handler");
				}
				geo.addEventListener(StatusEvent.STATUS, geoStatusHandler);
			}


			// Testing - Rests app on compile.
			// ========================= = = = =======================================
			_model.userDataSharedObject.data[Constants.APP_FIRST_OPENED] = false;
			_model.userDataSharedObject.flush();

			// ========================= = = = =======================================

			//			_gameDecorator.buildConfirmPopup();
			if (_model.userDataSharedObject.data[Constants.APP_FIRST_OPENED] == undefined ||
					_model.userDataSharedObject.data[Constants.APP_FIRST_OPENED] == false)
			{
				_model.userDataSharedObject.data[Constants.APP_FIRST_OPENED] = true;
				trace("APP FIRST OPENED");
			// ===== For Testing ====
//			_model.userDataSharedObject.data.charactersUnlocked = 2;
//			_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.CURRENTLY_GROWING] = false;
			_model.userDataSharedObject.data["headmond" + Constants.BUY_CHARACTER] = true;
			_model.userDataSharedObject.data["headmond" + Constants.UPGRADE_BRAINS_LEVEL] = 0;
			_model.userDataSharedObject.data["headmond" + Constants.UPGRADE_SPECIAL_LEVEL] = 0;
			_model.userDataSharedObject.data["headmond" + Constants.UPGRADE_TIME_LEVEL] = 0;
//            _model.userDataSharedObject.data["olivia" + Constants.BUY_CHARACTER = true;
			_model.userDataSharedObject.data.currentCharacterIndex = 0;
			_model.userDataSharedObject.data[Constants.CHAR_CURRENTLY_ON_SCREEN] = "headmond";

//			_model.userDataSharedObject.data.brainCount = 10000;
			_model.userDataSharedObject.data.brainCount = Constants.STARTING_BRAINS_COUNT;
			_model.userDataSharedObject.data["olivia" + Constants.UNLOCKED] = false;
			_model.userDataSharedObject.data["olivia" + Constants.BUY_CHARACTER] = false;
				_model.userDataSharedObject.data["olivia" + Constants.CURRENTLY_GROWING] = false;
			_model.userDataSharedObject.data.currentCharIndexOnScreen = 0;

			_model.userDataSharedObject.data["francesca" + Constants.UNLOCKED] = false;
			_model.userDataSharedObject.data["francesca" + Constants.BUY_CHARACTER] = false;
				_model.userDataSharedObject.data["francesca" + Constants.SPECIAL_ACTIVATED] = false;

				_model.userDataSharedObject.data["headmond" + Constants.CURRENTLY_GROWING] = false;
				_model.userDataSharedObject.data["headmond" + Constants.FINISHED_DATE] = null;
				_model.userDataSharedObject.data["headmond" + Constants.EXPLODED_DATE] = null;
			_model.userDataSharedObject.data["headmond" + Constants.UPGRADE_SPECIAL_LEVEL] = 0;
			_model.userDataSharedObject.data["headmond" + Constants.UPGRADE_TIME_LEVEL] = 0;
			_model.userDataSharedObject.data["headmond" + Constants.SPECIAL_ACTIVATED] = false;

				_model.userDataSharedObject.data["francesca" + Constants.BUY_CHARACTER] = false;
				_model.userDataSharedObject.data["francesca" + Constants.CURRENTLY_GROWING] = false;
				_model.userDataSharedObject.data["tony" + Constants.CURRENTLY_GROWING] = false;
				_model.userDataSharedObject.data["tony" + Constants.SPECIAL_ACTIVATED] = false;

			if (_model.userDataSharedObject.data[Constants.CHAR_CURRENTLY_ON_SCREEN] == undefined) {
				_model.userDataSharedObject.data[Constants.CHAR_CURRENTLY_ON_SCREEN] = "headmond";
			}

				// create a new DelayedCall instance that has a 1.5s delay
// and uses the function onTimerTickDC as it's callback (onTimerTickDC gets called every 1.5s)
				var timerDC:DelayedCall = new DelayedCall(onTimerTickDC, 1);

// to keep track of when the whole enemy wave is done spawning
				timerDC.addEventListener(Event.REMOVE_FROM_JUGGLER, onTimerCompleteDC);

// when ready to start the next wave...
				Starling.juggler.add(timerDC);


		}
			_model.userDataSharedObject.flush();


			explodeAimation = new MovieClip(Assets.getTextureAtlas(2).getTextures("Explosion/ExplosionMc_"));
			addChild(explodeAimation);
			explodeAimation.addEventListener(Event.COMPLETE, onExplodeAnimComplete);
			explodeAimation.visible = false;

			explodeAimation.pivotX = explodeAimation.width * 0.5;
			explodeAimation.pivotY = explodeAimation.height * 0.5;

			trace("explodeAimation" + explodeAimation);

			_gameDecorator.explodeBtn.addEventListener(Event.TRIGGERED, onExplodeButtonClicked);

			trace("_model.currentCharacterOnScreen: + " + _model.currentCharacterOnScreen);
			trace("_model.currentCharacterOnScreen.charHead " + _model.currentCharacterOnScreen.charHead);
			explodeAimation.x = _gameDecorator.characterArea.x + _model.currentCharacterOnScreen.charHead.x - 50;
			explodeAimation.y = _gameDecorator.characterArea.y + _model.currentCharacterOnScreen.charHead.y - 20;


			Application.init( DISTRIQT_APPLICATION_KEY );
			if (Application.isSupported)
			{
				trace("distriqt Application is supported!");
				var uniqueId:String = Application.service.device.uniqueId();
				trace("## got unique id: " + uniqueId);
			}
			else
			{
				trace("distriqt Application is not supported.");
			}



		}

	private function onTimerCompleteDC(event:Event):void {
		trace("delayed call removed.");
	}

	private function onTimerTickDC():void {
		trace("delayed call done.")
		_soundManager.playSound(_soundManager.TADA);
	}


	private function geoStatusHandler(event:StatusEvent):void {
		if (geo.muted)
			geo.removeEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
		else
			geo.addEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
	}

	private function geoUpdateHandler(event:GeolocationEvent):void {
		trace("latitude : " + event.latitude.toString() + " longitude: " + event.longitude.toString());
	}

	private function onIdfaReturned(idfa:String):void {
		trace("IDFA returned!: " + idfa);
	}

	private function onProgress(num:Number):void {
		trace("Load progressing: " + num);
	}
		

		private function onExplodeButtonClicked(eve:Event):void
		{

			trace("explode clicked, user growing: " + _model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.CURRENTLY_GROWING]);

			var currentDate:Date = new Date();
			if (Number(currentDate) > Number(_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.FINISHED_DATE]))
			{
				_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.CURRENTLY_GROWING] = false;
				_model.userDataSharedObject.flush();
			}
			
			trace("Explode clicked, checking this SO: " + _model.currentCharacterOnScreen.shortName + Constants.CURRENTLY_GROWING  + " = " + _model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.CURRENTLY_GROWING]);
			if (!_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.CURRENTLY_GROWING])
			{

				NativeLoggerANE.getInstance().debug("Exploded!");

				_soundManager.playSound(_soundManager.EXPLOSION);

				trace("Showing explode animation: " + explodeAimation + " at x: " + explodeAimation.x + ", y: " + explodeAimation.y);

				Starling.juggler.add(explodeAimation);
                _model.currentCharacterOnScreen.charHead.visible = false;
				explodeAimation.visible = true;

				trace("Debugger?" + Capabilities.isDebugger)

				
				if (_model.currentCharacterOnScreen.upgradeBrainsMinArray [
					_model.userDataSharedObject.data[
						_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_BRAINS_LEVEL
													]
																			]== undefined) 
					{
						_model.currentCharacterOnScreen.upgradeBrainsMinArray [
							_model.userDataSharedObject.data[
								_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_BRAINS_LEVEL
							] 
																				] = 0;
					}
				
				trace("explode Btn clicked, _model.currentCharacterOnScreen: " + _model.currentCharacterOnScreen);
				

				var upgradeBrainsLevel:int = _model.userDataSharedObject.data[
						_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_BRAINS_LEVEL
																			 ];

				trace("upgradeBrainsLevel: " + upgradeBrainsLevel);															 	


				var brainsWonFromExplode:int = _model.currentCharacterOnScreen.upgradeBrainsMinArray[upgradeBrainsLevel] +
					Math.ceil(Math.random() * _model.currentCharacterOnScreen.upgradeBrainsVarianceArray[upgradeBrainsLevel]);

				var totalBrainAmount:int = brainsWonFromExplode
				var bonusBrains:int = 0;

				if (_model.currentCharacterOnScreen.shortName == "headmond" &&
					_model.userDataSharedObject.data["headmond" + Constants.SPECIAL_ACTIVATED] == true)
				{
					bonusBrains = _model.currentCharacterOnScreen.upgradeSpecialRewardArray[
							_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_SPECIAL_LEVEL]
																							]
					trace("giving bonus brains: " + bonusBrains);

					totalBrainAmount += bonusBrains;
				}


				trace("brainsWon: " +totalBrainAmount);

				// var brainsWon:int = 100;

				_gameDecorator.displayUserGettingBrains(_model.userDataSharedObject.data.brainCount, brainsWonFromExplode, totalBrainAmount, bonusBrains);
				_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.PREVIOUS_BRAINS_WON_AMOUNT] = totalBrainAmount;

				trace("brains :"+_brains);
				
				trace("tweening (shrinking) charHeadL " + _model.currentCharacterOnScreen.charHead);

				//			
				OnHeadExploded();

				_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.CURRENTLY_GROWING] = true;
				_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.SPECIAL_ACTIVATED] = false;

				_gameDecorator.watchForSpecialButton.alpha = 1;
			}
		}
		
		private function onExplodeAnimComplete():void
		{
			Starling.juggler.remove(explodeAimation);
			explodeAimation.visible = false;
		}
		

		protected function onChar1HeadGrowTimerComplete(event:TimerEvent):void
		{
			trace("head has grown back!");
		}
		
		private function OnHeadExploded():void{

			trace("! _model.currentCharacterOnScreen: " + _model.currentCharacterOnScreen);
			trace("! _model.currentCharacterOnScreen.speechBubblePoint: " + _model.currentCharacterOnScreen.speechBubblePoint);
			trace("! _model.currentCharacterOnScreen.thoughtBubblePoint: " + _model.currentCharacterOnScreen.thoughtBubblePoint);


			_gameDecorator.explodeBtn.alpha = Constants.EXPLODE_BTN_DISABLED_ALPHA;

            _model.currentCharacterOnScreen.charHead.visible = true;
			_model.currentCharacterOnScreen.specialSprite.visible = false;

			var currentTime:Date = new Date();

			var date:Date = new Date();

			var secondsToGrow:int;
					if (_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_TIME_LEVEL] == undefined)
					{
						_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_TIME_LEVEL] = 0
						secondsToGrow = _model.currentCharacterOnScreen.upgradeTimeRewardArray[0];
						_model.userDataSharedObject.flush();
					}
					else {


						secondsToGrow = _model.currentCharacterOnScreen.upgradeTimeRewardArray[
								_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_TIME_LEVEL]
								]

						if (_model.currentCharacterOnScreen.shortName == "francesca" &&
								_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.SPECIAL_ACTIVATED] == true)
						{
							secondsToGrow *= _model.currentCharacterOnScreen.upgradeSpecialRewardArray[
									_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_SPECIAL_LEVEL]
									]
						}
					}

			trace("$# Seconds to grow: " + secondsToGrow)
			var finishedDate:Date = new Date(date.fullYear, date.month,
				date.date, date.hours, date.minutes, date.seconds + secondsToGrow,
				date.milliseconds);

			trace("on the explosion, exploded: " + date);
			trace("on the explosion, finished: " + finishedDate);

			trace("milliseconds between: " + (finishedDate.valueOf() - date.valueOf()));

			_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.EXPLODED_DATE] = date;
			_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.FINISHED_DATE] = finishedDate;
			_model.userDataSharedObject.flush();

			trace("in here currentOnScreen: " + _model.currentCharacterOnScreen);
			// OLD SPOT WHERE HEAD STARTS GROWING
			_headController.shrinkHeadAndStartGrowing(true, _model.currentCharacterOnScreen, secondsToGrow);




		}


	public function activateCurrentCharsSpecial():void {

		trace("Activating char special: " + _model.currentCharacterOnScreen.shortName);
		trace("video ad completed. Current char shortName: " + _model.currentCharacterOnScreen.shortName + " has special level: " + _model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_SPECIAL_LEVEL])
		trace("Ad completed. Character's Special Sprite visible..")

		switch(_model.currentCharacterOnScreen.shortName)
		{
			case "headmond":
				_model.currentCharacterOnScreen.specialSprite.visible = true;
				_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.SPECIAL_ACTIVATED] = true;
				break;

			case "olivia":
				_model.currentCharacterOnScreen.specialSprite.visible = true;
				_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.SPECIAL_ACTIVATED] = true;
				break;

			case "francesca":
					trace("Activating francesca special.");
				var currentTime:Date = new Date;
				var secondsDifference:int = (Number(currentTime) - Number(_model.userDataSharedObject.data["francesca" + Constants.EXPLODED_DATE]));

					trace("Seconds difference from last explosion: " +secondsDifference);

					var specialLevel:int = 0;
				if (secondsDifference < (20 * 60 * 60)) {
					trace("award francesca special bonus")

					trace('_model.currentCharacterOnScreen.upgradeSpecialRewardArray[_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_SPECIAL_LEVEL]' + _model.currentCharacterOnScreen.upgradeSpecialRewardArray[
									_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_SPECIAL_LEVEL]
									]);

					if (_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_SPECIAL_LEVEL] == undefined) {
						_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_SPECIAL_LEVEL] = 0;
						_model.userDataSharedObject.flush();

					}
					else
					{
						specialLevel = _model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_SPECIAL_LEVEL];
					}

					var brainsFrancescaSpecial:int;


					trace("upgrade special level: " + _model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_SPECIAL_LEVEL]);
					trace("special reqards zero: " + _model.currentCharacterOnScreen.upgradeSpecialRewardArray[0]);
						brainsFrancescaSpecial = _model.currentCharacterOnScreen.upgradeSpecialRewardArray[
								_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.UPGRADE_SPECIAL_LEVEL]
								];

						trace("francesca getting brains for special: " + brainsFrancescaSpecial);
						_gameDecorator.displayUserGettingBrains(_model.userDataSharedObject.data.brainCount, brainsFrancescaSpecial, brainsFrancescaSpecial)



				}
				break;

			case "tony":
				_model.currentCharacterOnScreen.specialSprite.visible = true;
				_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.SPECIAL_ACTIVATED] = true;
				break;

			default:

				break;
		}

		_model.userDataSharedObject.flush();
		trace("flushing...");

	}

	public function appActivated():void {
		trace("activating app.")

		if (!appIsActive) {
			for (var i:int = 0; i < _model.characterList.length; i++) {
				var charOb:CharacterObject = _model.characterList[i];

				trace("is he growing? " + _model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.CURRENTLY_GROWING]);
				if (_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.CURRENTLY_GROWING] == true)
				{
					_headController.startHeadGrowing(false, _model.characterList[i]);
				}

			}
		}
	}

	public function appDeactivated():void
	{
		trace("deactivating app.")
		for (var i:int = 0; i < _model.characterList.length; i++)
		{
			var charOb:CharacterObject = _model.characterList[i];
			_headController.stopHeadGrowing(true, _model.characterList[i]);
		}



		if (Capabilities.version.toLowerCase().indexOf("ios") > -1)
		{
			for (var i:int = 0; i < _model.characterList.length; i++) {
				var charOb:CharacterObject = _model.characterList[i];

				charOb.killTimer();
			}
		}


	}
}
}