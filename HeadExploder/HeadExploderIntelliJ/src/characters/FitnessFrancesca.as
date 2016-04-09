package characters
{
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import objects.CharacterObject;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

public class FitnessFrancesca extends CharacterObject
{
    private var X_OFFSET = -6;
    private var _francescaTimer:Timer;

    public function FitnessFrancesca()
    {

        super();
    }

    override public function buildCharacter():void
    {

        infoText = '<body><font size="19" align="center"><center>- Fitness Francesca -</center></font>\nFrancesca is all about staying in shape and eating healthy. She was ' +
                "a track superstar in high school and can squat some impressive weight. She can rep out butterfly pullups " +
                "and plans to some day become a trainer." +
                "\n- Special Ability -\n" +
                '"Protein Shake"\n' +
                "After one of Francesca's tough workouts her muscles are starving for some protein. Use The special within " +
                "20 minutes of exploding her head for a nice boost in brains.";



        upgradeCostMultiplier = 2.5;

        upgradeBrainsMinArray =     	 [70, 80, 95, 125, 155, 170, 205, 240, 285];
        upgradeBrainsVarianceArray =     [50, 60, 70, 80, 100, 130, 160, 190, 240];
        upgradeTimeRewardArray =    [3600, 3480, 3360, 3240, 3120, 3000, 2880, 2760, 2640];
        upgradeSpecialRewardArray =  [60, 75, 90, 110, 135, 160, 195, 210, 255];
        ON_SCREEN_X = 0;
        ON_SCREEN_Y = 0;

        speechBubblePoint = new Point(0,0);
        thoughtBubblePoint = new Point(0,0);

        // Name of the Character.
        charName = "Fitness Francesca";
        shortName = "francesca";
        charSprite = new Sprite();
        addChild(charSprite);
        charSpriteOriginalX = 0;
        charSprite.x = charSpriteOriginalX;
        // Add to the array of characters.
        LEFT_SIDE_PANNING_CUTOFF_X = -80;
        RIGHT_SIDE_PANNING_CUTOFF_X = 95;


        // Character's body.
        charBody = new Image(Assets.getTextureAtlas(3).getTexture("FrancescaBody"));


        charBody.pivotX = charBody.width * 0.5;
        charBody.x = Main.GAME_W/2 + X_OFFSET;
        charBody.y = 222;
        charSprite.addChild(charBody);


        // Character's head.
        charHead = new Sprite();
        var charHeadImage = new Image(Assets.getTextureAtlas(3).getTexture("FrancescaHead"));
        charHeadImage.pivotX = charHeadImage.width * 0.5;
        charHeadImage.pivotY = charHeadImage.height * 0.5;
        charHead.addChild(charHeadImage);

        // Position charsprite.
        originalHeadX = charHead.x;
        originalHeadY = charHead.y;
        originalHeadWidth = charHead.width;
        originalHeadHeight = charHead.height;
        charSprite.addChild(charHead);

        charHead.x = charBody.x+ 5;
        charHead.y = charBody.y - 45;


        headExplodedPoint = new Point(charHead.x - 4, charHead.y + 49);

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
        timerTF.y = charHead.y - 116;
        timerTF.visible = true;

        trace("francesca's charHead.y: " + charHead.y);

    }

    override public function startExplodeTimer(seconds:int):void
    {
        trace("growing back francesca, seconds: " + seconds);
        _francescaTimer = new Timer(1000, seconds);
        _francescaTimer.addEventListener(TimerEvent.TIMER, onGrowBackTimerTick);
        _francescaTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onGrowBackTimerComplete);
        secondsLeftForHeadToGrowBack = seconds;

        trace("# Cindy startExplodeTimer!");
        trace("Seconds left: " + SECONDS_FOR_HEAD_TO_GROW_BACK);

        timerTF.text = "" + Util.nicelyFormatSeconds(seconds);
        timerTF.visible = true;
        _francescaTimer.start();
    }

    override public function killTimer():void
    {
        if (_francescaTimer != null)
        {
            if (_francescaTimer.running) {
                _francescaTimer.stop();
            }

            _francescaTimer.removeEventListener(TimerEvent.TIMER, onGrowBackTimerTick);
            _francescaTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onGrowBackTimerComplete);
            _francescaTimer = null;
        }

    }


}
}