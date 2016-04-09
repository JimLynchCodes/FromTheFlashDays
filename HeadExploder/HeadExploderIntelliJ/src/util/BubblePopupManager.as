/**
 * Created by bobolicious3000 on 11/19/15.
 */
package util {


import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import objects.CharacterObject;
import objects.Saying;

import starling.animation.DelayedCall;
import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class BubblePopupManager extends Sprite{
    public static var instance:BubblePopupManager = new BubblePopupManager();
    private var thoughtBubble:Sprite;
    public var speechBubble:Sprite;
    private var _model:Model;

    public var SPEECH:String = "SPEECH";
    public var THOUGHT:String = "THOUGHT";
    private var speechTf:TextField;
    private var thoughtTf:TextField;
    private var IDLE:String = "IDLE";
//    private var _fadeOutTimer:Timer;

    public function BubblePopupManager()
    {
        _model = Model.getInstance();
        if(instance)
        {
            throw new Error ("We cannot create a new instance.Please use BubblePopupManager.getInstance()");
        }


    }

    public static function getInstance():BubblePopupManager
    {
        return instance;
    }


    public function displayBubblePopup(character:CharacterObject, type:String):void
    {
        trace("Bubble popup for " + character.shortName + " is " + type + " at x:" + character.speechBubblePoint.x + " y: " + character.speechBubblePoint.y);
        if (type == SPEECH)
        {
            speechBubble.visible = true;
            speechBubble.alpha = 1;
            speechBubble.x = character.speechBubblePoint.x;
            speechBubble.y = character.speechBubblePoint.y;
        }
        else if (type == THOUGHT)
        {
            thoughtBubble.visible = true;
            thoughtBubble.alpha = 1;
            thoughtBubble.x = character.thoughtBubblePoint.x;
            thoughtBubble.y = character.thoughtBubblePoint.y;
        }
        else
        {
            trace("Trying to display bubble popup with unkown type: " + type);
        }
    }


    private function fadeOutBubblePopup(currentBubblePopup:Sprite):void
    {
        trace("delay finished");

        Starling.juggler.tween(currentBubblePopup, Constants.FLOATER_FLOAT_DURATION, { //x: 155,
//            y: currentBubblePopup.y + 30,
            alpha: 0.1,
            onComplete:onBubblePopupFaded,
            onCompleteArgs:new Array(currentBubblePopup)
        })
    }

    private function onBubblePopupFaded(currentBubblePopup:Sprite):void {
        trace("bubble popup faded.");
        currentBubblePopup.visible = false;
        currentBubblePopup.alpha = 1;
    }

    public function createBubblePopups():void {
        trace("_model.currentCharacterOnScreen " + _model.currentCharacterOnScreen.charName);
        createSpeechBubble();
        createThoughtBubble();

    }

    private function createSpeechBubble():void {
        speechBubble = new Sprite();
        var speechBubbleImage:Image = new Image(Assets.getTextureAtlas(3).getTexture("SpeechBubble"));
        speechBubbleImage.scaleX = 1.2;
        speechBubbleImage.scaleY = 1.2;
        trace("Get that texture!: " + speechBubbleImage);
        speechBubble.addChild(speechBubbleImage);
        addChild(speechBubble);
        speechBubble.visible = false;

        speechTf = new TextField(117, 56, "Head Exploder!", "HoboStd",  9, 0x000000);
        speechTf.hAlign = "center";
        speechTf.vAlign = "center";
        speechTf.border = false;
        speechTf.x = 13;
        speechTf.y = 4;
        speechBubble.addChild(speechTf);
    }

    private function createThoughtBubble():void {
        thoughtBubble = new Sprite();
        var thoughtBubbleImage:Image = new Image(Assets.getTextureAtlas(3).getTexture("ThoughtBubble"));
        thoughtBubbleImage.scaleX = 1.1;
        thoughtBubbleImage.scaleY = 1.1;
        trace("Get that texture!: " + thoughtBubbleImage);
        thoughtBubble.addChild(thoughtBubbleImage);
        addChild(thoughtBubble);
        thoughtBubble.visible = false;

        thoughtTf = new TextField(117, 56, "Head Exploder!", "HoboStd",  9, 0x000000);
        thoughtTf.hAlign = "center";
        thoughtTf.vAlign = "center";
        thoughtTf.border = false;
        thoughtTf.x = 13;
        thoughtTf.y = 4;
        thoughtBubble.addChild(thoughtTf);
    }

    public function displaySaying(saying:Saying, speechPoint:Point, thoughtPoint:Point):void {

        var currentBubblePopup:starling.display.Sprite;
        if (saying.type == Saying.SPEECH)
        {
            speechBubble.visible = true;
            speechBubble.x = speechPoint.x;
            speechBubble.y = speechPoint.y;
            speechTf.text = saying.message;
            currentBubblePopup = speechBubble;

        }
        if (saying.type == Saying.THOUGHT)
        {
            thoughtBubble.visible = true;
            thoughtBubble.x = thoughtPoint.x;
            thoughtBubble.y = thoughtPoint.y;
            thoughtTf.text = saying.message;
            currentBubblePopup = thoughtBubble;
        }

        var args:Array = [currentBubblePopup];
        var timerDC:DelayedCall = new DelayedCall(fadeOutBubblePopup, 10, args);
        Starling.juggler.add(timerDC);

        trace("displaying saying");
    }

    public function getSayingFromCharacter(character:CharacterObject, sayingSituation:String):Saying
    {

        var potentialSayingsForThisSituation:Array = [];

        for (var i:int = 0; i < character.sayingsArray.length; i++)
        {

            var saying:Saying = character.sayingsArray[i];

            if (sayingSituation == IDLE)
            {

                if (saying.saidOnIdle)
                {
                    potentialSayingsForThisSituation.push(saying);
                }
            }


          //  ..
          //  .
          //  .



        }



        return potentialSayingsForThisSituation[Math.floor(Math.random()*potentialSayingsForThisSituation.length)]

        trace("Saying situation: " + sayingSituation);



    }

}
}
