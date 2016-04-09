package characters
{
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import objects.CharacterObject;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

public class TonyPizzaGuy extends CharacterObject
{
    private var X_OFFSET = 13;
    private var _tonyTimer:Timer;

    public function TonyPizzaGuy()
    {

        super();
    }

    override public function buildCharacter():void
    {

        infoText = '<body><font size="19" align="center"><center>- Tony Mazzarolli -</center></font>\nTony has lived his whole life in Brooklyn, New York.  He ' +
                "loves the hustle and bustle of the big city, and he's a die-hard Yankees fan. He is the manager "+
                "and head chef at a popular pizza shop. Customers love his sauce, made from fresh tomatoes " +
                "and his secret blend of natural herbs and spices." +
                "\n- Special Ability -\n" +
                '"The Bomb-eroni Pie"\n' +
                "Who doesn't love bombs on their pizza? When Tony's special ability " +
                "is activated tasty bomb-chovies appear on the pizza pie. When Tony's " +
                "head is exploded the pizza explodes as well, giving you a nice big sauce and " +
                "cheese covered helping of bonus brains.</body>";


        ON_SCREEN_X = 5;
        ON_SCREEN_Y = -35;

        speechBubblePoint = new Point(0,0);
        thoughtBubblePoint = new Point(0,0);

        // Name of the Character.
        charName = "Tony Mazzarolli";
        shortName = "tony";
        upgradeCostMultiplier = 5;

        upgradeBrainsMinArray =     	 [150, 160, 185, 200, 225, 240, 260, 280, 330];
        upgradeBrainsVarianceArray =     [110, 115, 120, 125, 130, 135, 140, 145, 150];

        upgradeTimeRewardArray =    [14400, 14100, 13800, 13480, 13140, 12780 , 12400, 12000, 11580];

        upgradeSpecialRewardArray =  [130, 140, 160, 190, 230, 280, 340, 400, 490];


        // Sprite containing entire character assets on the stage.
        charSprite = new Sprite();
        addChild(charSprite);
        charSpriteOriginalX = 0;
        charSprite.x = charSpriteOriginalX;

        // Character's body.
        charBody = new Image(Assets.getTextureAtlas(3).getTexture("TonyBody"));


        charBody.pivotX = charBody.width * 0.5;
        charBody.x = Main.GAME_W/2 + X_OFFSET;
        charBody.y = 170;
        charSprite.addChild(charBody);


        LEFT_SIDE_PANNING_CUTOFF_X = -65;
        RIGHT_SIDE_PANNING_CUTOFF_X = 70;

        // Character's head.

        charHead = new Sprite();
        var charHeadImage = new Image(Assets.getTextureAtlas(3).getTexture("TonyHead"));
        charHeadImage.pivotX = charHeadImage.width * 0.5;
        charHeadImage.pivotY = charHeadImage.height * 0.5;
        charHead.addChild(charHeadImage);

        charHead.x = charBody.x - 33;
        charHead.y = charBody.y + 38;

        // Position charsprite.
        originalHeadX = charHead.x;
        originalHeadY = charHead.y;
        originalHeadWidth = charHead.width;
        originalHeadHeight = charHead.height;
        charSprite.addChild(charHead);


        headExplodedPoint = new Point(charHead.x, charHead.y + 55);

        specialSprite = new Sprite();
        charSprite.addChild(specialSprite);
        var bomeroni:Image = new Image(Assets.getTextureAtlas(3).getTexture("Bomberoni"));
        specialSprite.addChild(bomeroni);
        bomeroni.scaleX = 1;
        bomeroni.scaleY = 1;
        bomeroni.x = charBody.x - 25;
        bomeroni.y = charBody.y + 109;
        specialSprite.visible = false;

        // Timer Tf
        timerTF = new TextField(200, 60, "", "HoboStd", 20, 0x000000);
        charSprite.addChild(timerTF);
        timerTF.border = false;
        timerTF.hAlign = "center";

        timerTF.pivotX = timerTF.width * 0.5;
        timerTF.x = Main.GAME_W * 0.5 - 15;
        timerTF.y = charHead.y - 112;
        timerTF.visible = true;

        trace("tony's charHead.y: " + charHead.y);

    }

    override public function startExplodeTimer(seconds:int):void
    {
        trace("growing back tony, seconds: " + seconds);
        _tonyTimer = new Timer(1000, seconds);
        _tonyTimer.addEventListener(TimerEvent.TIMER, onGrowBackTimerTick);
        _tonyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onGrowBackTimerComplete);
        secondsLeftForHeadToGrowBack = seconds;

        trace("# tony startExplodeTimer!");
        trace("Seconds left: " + SECONDS_FOR_HEAD_TO_GROW_BACK);

        timerTF.text = "" + Util.nicelyFormatSeconds(seconds);
        timerTF.visible = true;
        _tonyTimer.start();
    }


    override public function killTimer():void
    {
        if (_tonyTimer != null)
        {
            if (_tonyTimer.running) {
                _tonyTimer.stop();
            }

            _tonyTimer.removeEventListener(TimerEvent.TIMER, onGrowBackTimerTick);
            _tonyTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onGrowBackTimerComplete);
            _tonyTimer = null;
        }

    }


}
}