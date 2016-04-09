package objects {

import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import org.gestouch.gestures.PanGesture;

import starling.animation.IAnimatable;
import starling.animation.Tween;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

public class CharacterObject extends Sprite {
    public var charName:String;
    public var shortName:String;
    public var _myTimer:Timer;

    public var ON_SCREEN_X:int = 300;
    public var ON_SCREEN_Y;
    public var Y_OFFSET_FROM_EXPLODE_BTN:int = 20;

    public var SECONDS_FOR_HEAD_TO_GROW_BACK:int = 15;

    public var charSprite:Sprite;
    public var charBody:Image;
    public var charHead:Sprite;

    public var originalHeadX;
    public var originalHeadY;
    public var originalHeadWidth:Number;
    public var originalHeadHeight:Number;

    public var upgradeBrainsCostArrayBrains:Array =    [null, null, null, null, null, null, null, null, null];
    public var upgradeBrainsCostArrayCoins:Array =     [null, null, null, null, null, null, null, null, null];

    public var upgradeBrainsSellBackArrayBrains:Array = [null, null, null, null, null, null, null, null, null];
    public var upgradeBrainsSellBackArrayCoins:Array =  [null, null, null, null, null, null, null, null, null];

    public var upgradeBrainsMinArray =                  [null, null, null, null, null, null, null, null, null];
    public var upgradeBrainsVarianceArray =             [null, null, null, null, null, null, null, null, null];

    public var upgradeTimeCostArray = [180, 250, 400, 620, 900, 1230, 1640, 2150, 2780];
    public var upgradeTimeRewardArray = [1000, 1000, 11900, 10000, 9200, 8000, 6500, 5000, 3600];

    public var upgradeSpecialCostArray = [230, 300, 450, 670, 950, 1280, 1690, 2200, 2830];
    public var upgradeSpecialRewardArray = [125, 175, 225, 300, 350, 400, 475, 575, 700];

    public var headY:Number = 170;
    public var headX:Number = 110;

    public var OFF_SCREEN_LEFT_X = -800;
    public var OFF_SCREEN_RIGHT_X = 500;

    public var speechBubblePoint:Point;
    public var thoughtBubblePoint:Point;

    public var speechBubble:Sprite;
    public var thoughtBubble:Sprite;

    public var upgradeCostMultiplier:int = 0;
    public var timerTF:TextField;
    public var infoText:String = "";

    protected var _model:Model;
    public var secondsLeftForHeadToGrowBack:int;
    protected var _growBackTimer:Timer;
    public var headExplodedPoint:Point = new Point(0, 0);
    public var specialSprite:Sprite;
    public var charSpriteOriginalX:Number;
    public var panGesture:PanGesture;
    public var LEFT_SIDE_PANNING_CUTOFF_X:Number;
    public var RIGHT_SIDE_PANNING_CUTOFF_X:Number;
    public var headGrowingTween:Tween;

    public var sayingsArray:Array = [];

    public function CharacterObject() {
        _model = Model.getInstance();
        buildCharacter();

//        createBubblePopups();
    }

//    private function createBubblePopups():void {
//        trace("Creating popups...");
//        createThoughtBubble();
//        createSpeechBubble();
//    }
//
//    private function createSpeechBubble():void {
//        speechBubble = new Sprite();
//        var speechBubbleImage:Image = new Image(Assets.getTextureAtlas(3).getTexture("SpeechBubble"));
//        trace("Get that texture!: " + speechBubbleImage);
//        speechBubble.addChild(speechBubbleImage);
//        addChild(speechBubble);
////        speechBubble.visible = false;
//    }
//
//    private function createThoughtBubble():void {
//        thoughtBubble = new Sprite();
//        var thoughtBubbleImage:Image = new Image(Assets.getTextureAtlas(3).getTexture("ThoughtBubble"));
//        trace("Get that texture!: " + thoughtBubbleImage);
//        thoughtBubble.addChild(thoughtBubbleImage);
//        addChild(thoughtBubble);
////        thoughtBubble.visible = false;
//    }

    virtual public function buildCharacter():void {

    }

    virtual public function startExplodeTimer(seconds:int):void {
        trace("generic startExplodeTimer");
//			trace("Seconds left: " + _model.currentCharacterOnScreen.SECONDS_FOR_HEAD_TO_GROW_BACK);
//			_growBackTimer = new Timer(1000, _model.currentCharacterOnScreen.SECONDS_FOR_HEAD_TO_GROW_BACK);
//			_growBackTimer.addEventListener(TimerEvent.TIMER, onGrowBackTimerTick);
//			_growBackTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onGrowBackTimerComplete);
//			_growBackTimer.start();
    }


    public function killTimer():void {
        if (_myTimer != null) {
            if (_myTimer.running) {
                _myTimer.stop();
            }

            _myTimer.removeEventListener(TimerEvent.TIMER, onGrowBackTimerTick);
            _myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onGrowBackTimerComplete);
            _myTimer = null;
        }
    }

    protected function onGrowBackTimerComplete(event:TimerEvent):void {
        trace("TIMER COMPLETE");
        trace(event.currentTarget);
        trace(event.target);
        timerTF.visible = false;
        killTimer();
        _model.userDataSharedObject.data[shortName + Constants.CURRENTLY_GROWING] = false;
        _model.userDataSharedObject.flush();
//		_growBackTimer.removeEventListener(TimerEvent.TIMER, onGrowBackTimerTick);
//		_growBackTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onGrowBackTimerComplete);
//		_growBackTimer.stop();
    }

    protected function onGrowBackTimerTick(event:TimerEvent):void {

        secondsLeftForHeadToGrowBack--;
//		trace("ticking... " + secondsLeftForHeadToGrowBack);

//		trace("charhead.y: " + charHead.y)

        var niceTimeString:String = Util.nicelyFormatSeconds(secondsLeftForHeadToGrowBack);
//		trace("Displaying nice time- " + niceTimeString);
        timerTF.text = niceTimeString;
    }

    virtual public function getNewHead():void {

    }
}
}