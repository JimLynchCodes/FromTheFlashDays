package characters
{
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import objects.CharacterObject;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class FemaleCindy extends CharacterObject
	{
		private var X_OFFSET = 20;
		private var _cindyTimer:Timer;

		public function FemaleCindy()
		{

			super();
		}

			override public function buildCharacter():void
		{

			infoText = '<body><font size="19" align="center"><center>- Olivia Swiggles -</center></font>\nOlivia is a city girl who loves margaritas and shopping. She\'s ' +
					   "cute and has a great peronality, but unfortunately exploding her head doen't yield much brains. On the bright side, her " +
					   'head grows back quickly.' +
						"\n- Special Ability -\n" +
						'"Sugar Rush Explosion"\n' +
						'Olivia\'s special ability gives her a piece of cake and a hefty dose of sugar. This sugar allows her ' +
						"head to grow back faster. Explode Olivia's head with her special activated, and her head will take " +
						'less time to grow back.</body>';


				upgradeCostMultiplier = 1.5;

				upgradeBrainsMinArray =     	 [60, 70, 80, 95, 115, 150, 180, 205, 240];
				upgradeBrainsVarianceArray =     [15, 18, 21, 24, 27, 30, 33, 36, 40];
				upgradeTimeRewardArray =    [1500, 1450, 1400, 1350, 1300, 1250 , 1190, 1120, 1020];
				upgradeSpecialRewardArray =  [55, 70, 85, 105, 130, 155, 180, 205, 240];

				ON_SCREEN_X = 5;
			ON_SCREEN_Y = -35;

			speechBubblePoint = new Point(0,0);
			thoughtBubblePoint = new Point(0,0);

			charName = "Olivia Swiggles";
			shortName = "olivia";

			// Sprite containing entire character assets on the stage.
			charSprite = new Sprite();

			addChild(charSprite);
				charSpriteOriginalX = 0;
				charSprite.x = charSpriteOriginalX;
				LEFT_SIDE_PANNING_CUTOFF_X = -70;
				RIGHT_SIDE_PANNING_CUTOFF_X = 101;

			// Character's body.
			charBody = new Image(Assets.getTextureAtlas(3).getTexture("Char2Body"));
			charBody.pivotX = charBody.width * 0.5;
			charBody.x = Main.GAME_W/2 + X_OFFSET;
			charBody.y = 260;
			charSprite.addChild(charBody);


			// Character's head.
				charHead = new Sprite();
			var charHeadImage = new Image(Assets.getTextureAtlas(3).getTexture("Char2Head"));
				charHeadImage.pivotX = charHeadImage.width * 0.5;
				charHeadImage.pivotY = charHeadImage.height * 0.5;

								charHead.addChild(charHeadImage);
			charHead.x =  charBody.x - 10;
				charHead.y = charBody.y - 43;

				trace("Cindy's normal head pos: " + charHead.x + ", " + charHead.y);
			// Position charsprite.
			originalHeadX = charHead.x;
			originalHeadY = charHead.y;
				originalHeadWidth = charHead.width;
				originalHeadHeight = charHead.height;
			charSprite.addChild(charHead);


				headExplodedPoint = new Point(charHead.x - 8, charHead.y + 48);

				specialSprite = new Sprite();
				charSprite.addChild(specialSprite);
				var cake:Image = new Image(Assets.getTextureAtlas(3).getTexture("pieceofcake"));
				specialSprite.addChild(cake);
				cake.scaleX = 1.75;
				cake.scaleY = 1.75;
				cake.x = charBody.x - 7;
				cake.y = charBody.y + 7;
				specialSprite.visible = false;

			// Timer Tf
			timerTF = new TextField(200, 60, "", "HoboStd", 20, 0x000000);
			charSprite.addChild(timerTF);
			timerTF.border = false;
			timerTF.hAlign = "center";

			timerTF.pivotX = timerTF.width * 0.5;
			timerTF.x = Main.GAME_W * 0.5;
			timerTF.y = charHead.y - 120;
			timerTF.visible = true;

				trace("olivia's charHead.y: " + charHead.y);

		}

	override public function startExplodeTimer(seconds:int):void
	{
		trace("growing back olivia, seconds: " + seconds);

		if (seconds > 0)
		{
			_cindyTimer = new Timer(1000, seconds);
			_cindyTimer.addEventListener(TimerEvent.TIMER, onGrowBackTimerTick);
			_cindyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onGrowBackTimerComplete);
			secondsLeftForHeadToGrowBack = seconds;

			trace("# Cindy startExplodeTimer!");
			trace("Seconds left: " + SECONDS_FOR_HEAD_TO_GROW_BACK);

			timerTF.text = "" + Util.nicelyFormatSeconds(seconds);
			timerTF.visible = true;
			_cindyTimer.start();
		}

	}

	override public function killTimer():void
	{
		if (_cindyTimer != null)
		{
			if (_cindyTimer.running) {
				_cindyTimer.stop();
			}

			_cindyTimer.removeEventListener(TimerEvent.TIMER, onGrowBackTimerTick);
			_cindyTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onGrowBackTimerComplete);
			_cindyTimer = null;
		}

	}


	}
}