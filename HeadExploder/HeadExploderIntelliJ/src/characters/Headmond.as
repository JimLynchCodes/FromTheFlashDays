package characters {
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import objects.CharacterObject;
import objects.Saying;

import starling.animation.Transitions;
import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

public class Headmond extends CharacterObject {
    private var charHeadImage:Image;

    public function Headmond() {

        super();
    }

    override public function buildCharacter():void {


        infoText = '<font size="19" align="center"><center>- Headmond X. Splodington -</center></font>Headmond, like the other characters in this game, has a strange disease ' +
                "where his head grows back after being exploded. He grew up on a small farm in " +
                "Idaho and enjoys playing baseball.\n-- Special Ability --\n" +
                '"Bonus Brains"\nExplode Headmond\'s head with his special activated and you are rewarded extra brains determined by special ability upgrade level. After Headmond\'s special is activated he puts on stylish sunglasses.</body>';


        sayingsArray = [new Saying("Owww! That hurt's!", Saying.THOUGHT, false, false, true),
                        new Saying("Man, I love being a college graduate. If only i could get a job though...", "THOUGHT", true, false, false),
                        new Saying("What's up, Billy", Saying.SPEECH, true)
                        ];

        upgradeBrainsCostArrayBrains = [180, 250, 400, 620, 900, 1230, 1640, 2150, 2780];
        upgradeBrainsCostArrayCoins = [5, 6, 7, 8, 9, 10, 11, 12, 13];

        upgradeBrainsSellBackArrayBrains = [162, 225, 360, 558, 810, 1170, 1476, 1935, 2505];
        upgradeBrainsSellBackArrayCoins = [4, 5, 6, 7, 8, 9, 10, 11, 12];

        upgradeCostMultiplier = 1;

        upgradeBrainsMinArray = [35, 45, 55, 65, 75, 85, 95, 105, 120];
        upgradeBrainsVarianceArray = [30, 35, 40, 45, 50, 55, 65, 75, 85];

        upgradeTimeCostArray = [180, 250, 400, 620, 900, 1230, 1640, 2150, 2780];
        upgradeTimeRewardArray = [1000, 1000, 11900, 10000, 9200, 8000, 6500, 5000, 3600];

        upgradeSpecialCostArray = [230, 300, 450, 670, 950, 1280, 1690, 2200, 2830];
        upgradeSpecialRewardArray = [125, 175, 225, 300, 350, 400, 475, 575, 700];


        Y_OFFSET_FROM_EXPLODE_BTN = 20;

        ON_SCREEN_X = -70;
        ON_SCREEN_Y = 0;

        speechBubblePoint = new Point(182,120);
        thoughtBubblePoint = new Point(120,120);

        charSpriteOriginalX = -70;

        LEFT_SIDE_PANNING_CUTOFF_X = -135;
        RIGHT_SIDE_PANNING_CUTOFF_X = 25;

        // Name of the Character.
        charName = "Headmond X. Splodington";
        shortName = "headmond";

        charSprite = new Sprite();
        addChild(charSprite);
        charSprite.y = 5;
        charSprite.x = charSpriteOriginalX;

        // Character's body.
        charBody = new Image(Assets.getTextureAtlas(1).getTexture("CharBody1_0001"));
        charBody.x = Main.GAME_W / 2;
        charBody.y = 210;
        charSprite.addChild(charBody);

        // Character's head.
        charHead = new Sprite();
        charHead.x = charBody.x + 61;
        charHead.y = charBody.y - 10;

        charHeadImage = new Image(Assets.getTextureAtlas(1).getTexture("CharHead1_0001"));
        charHeadImage.pivotX = charHeadImage.width * 0.5;
        charHeadImage.pivotY = charHeadImage.height * 0.5;
//			charHeadImage.x = charBody.x + 61;
//			charHeadImage.y = charBody.y - 10;
        charHead.addChild(charHeadImage);

        // Position charsprite.
        originalHeadX = charHead.x;
        originalHeadY = charHead.y;
        originalHeadWidth = charHead.width;
        originalHeadHeight = charHead.height;

        trace("original char head y: " + originalHeadY)
        charSprite.addChild(charHead);

        headExplodedPoint = new Point(charHead.x + 2, charHead.y + 32);


        // Timer Tf
        Assets.loadBitmapFonts();

        timerTF = new TextField(200, 60, "", "HoboStd", 20, 0x000000);
        timerTF.border = false;

//			timerTF.x = charSprite.width * 0.4;
        timerTF.pivotX = timerTF.width * 0.5;
        timerTF.x = charBody.x + charBody.width * 0.5;

        timerTF.y = originalHeadY - 124;
        timerTF.visible = true;
//			timerTF.fontName = "AkzidenzGroteskBQ-BoldItalic"

        charSprite.addChild(timerTF);

        specialSprite = new Sprite();
        charHead.addChild(specialSprite);
        var sunglasses = new Image(Assets.getTextureAtlas(3).getTexture("sunglasses"));
        specialSprite.addChild(sunglasses);
        sunglasses.scaleX = .75;
        sunglasses.scaleY = .75;
        specialSprite.x = charHead.x;
        specialSprite.y = charHead.y;
        specialSprite.x = -37;
        specialSprite.y = -8;
        specialSprite.visible = false;

        trace("charHead @@# x: " + charHead.x + " y: " + charHead.y + " w: " + charHead.width + " h: " + charHead.height + " pivX: " + charHead.pivotX + " pivY: " + charHead.pivotY);
        trace("specialSprite @@# x: " + specialSprite.x + " y: " + specialSprite.y + " w: " + specialSprite.width + " h: " + specialSprite.height + " pivX: " + specialSprite.pivotX + " pivY: " + specialSprite.pivotY);


    }

    override public function startExplodeTimer(seconds:int):void {
        trace("# Headmond startExplodeTimer!");
        trace("Seconds left: " + seconds);
        if (seconds > 0) {
            if (_myTimer == null) {
                secondsLeftForHeadToGrowBack = seconds;
                _myTimer = new Timer(1000, seconds);
                _myTimer.addEventListener(TimerEvent.TIMER, onGrowBackTimerTick);
                _myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onGrowBackTimerComplete);

                timerTF.text = "" + Util.nicelyFormatSeconds(seconds);
                timerTF.visible = true;
                _myTimer.start();

            }
        }
    }

    override public function killTimer():void {
        if (_myTimer != null) {
            if (_myTimer.running) {
                _myTimer.stop();
            }

            _myTimer.removeEventListener(TimerEvent.TIMER, onGrowBackTimerTick);
            _myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onGrowBackTimerComplete);
            _myTimer = null;
        }

    }


    public override function getNewHead():void {
        trace("getting new head: " + shortName);

        Starling.juggler.tween(charHead, 0.5, {
            scaleX: 1, scaleY: 1,
            x: originalHeadX,
            y: originalHeadY,
            transition: Transitions.LINEAR

        });

    }


}
}
