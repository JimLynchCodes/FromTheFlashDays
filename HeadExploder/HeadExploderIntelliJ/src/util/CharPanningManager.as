/**
 * Created by bobolicious3000 on 10/17/15.
 */
package util {


import objects.CharacterObject;

import org.gestouch.events.GestureEvent;
import org.gestouch.gestures.PanGesture;

import org.gestouch.gestures.TapGesture;

public class CharPanningManager {
    private var _model:Model;
    private static var instance:CharPanningManager = new CharPanningManager();
    private var _charSlidingManager:CharSlidingManager;

    public function CharPanningManager() {

        _model = Model.getInstance();
        if (instance) {
            throw new Error("We cannot create a new instance.Please use CharPanningManager.getInstance()");
        }
        
        _charSlidingManager = CharSlidingManager.getInstance();
    }

    public static function getInstance():CharPanningManager {

        return instance;
    }

    public function addPanningToChar(charObj:CharacterObject):void
    {

    }


    public function setupForPanning(charOb:CharacterObject):void {

        trace("Setting up for panning.. " + charOb.shortName);
        charOb.panGesture = new PanGesture(charOb.charSprite);
        charOb.panGesture.maxNumTouchesRequired = 2;
        charOb.panGesture.addEventListener(org.gestouch.events.GestureEvent.GESTURE_BEGAN, onPan);
        charOb.panGesture.addEventListener(org.gestouch.events.GestureEvent.GESTURE_CHANGED, onPan);
        charOb.panGesture.addEventListener(org.gestouch.events.GestureEvent.GESTURE_ENDED, onPanEnded);
        
    }
    
        private function onPanEnded(event:GestureEvent):void {
            trace("pan ended!");

            if (_model.currentCharacterOnScreen.charSprite.x > _model.currentCharacterOnScreen.RIGHT_SIDE_PANNING_CUTOFF_X)
            {
                trace("move him off the Right side");
                _charSlidingManager.onUserSlidesChar("RIGHT", false);


            }
            else if (_model.currentCharacterOnScreen.charSprite.x < _model.currentCharacterOnScreen.LEFT_SIDE_PANNING_CUTOFF_X)
            {
                trace("move him off the left side");
                _charSlidingManager.onUserSlidesChar("LEFT", false);

            }
            else
            {
                trace("move him back to center.");

                _model.currentCharacterOnScreen.charSprite.x = _model.currentCharacterOnScreen.charSpriteOriginalX;
            }

            
    }

    private function onPan(event:GestureEvent):void {

        const gesture:PanGesture = event.target as PanGesture;
        trace("What's target: " + event.target + " and currentTarget: " + event.currentTarget);

        trace("got pan!" + gesture.offsetX + " " + gesture.offsetY + ", Headmond's x position: " + _model.currentCharacterOnScreen.charSprite.x);
        _model.currentCharacterOnScreen.charSprite.x += gesture.offsetX * 0.5;

    }

    private function onGestureBegan(event:GestureEvent):void {
        trace("gesture began" + event);
    }
    
}
}
