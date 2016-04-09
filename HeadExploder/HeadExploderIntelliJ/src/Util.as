/**
 * Created by Jim on 8/25/2015.
 */
package {
import objects.CharChoiceButton;
import objects.CharacterObject;

import starling.core.Starling;
import starling.display.Sprite;

public class Util {
    public function Util() {
    }

    private static var _minutesToGrowBack:Number;
    private static var _hoursToGrowBack:Number;


    public static function nicelyFormatSeconds(secondsLeft:int):String
    {
//		_model.currentCharacterOnScreen.timerTF.visible = true;
//		_model.currentCharacterOnScreen.timerTF.text = "" + secondsLeft;

        var fullString:String = "";
        var minsAndSecondsText:String = "";
        var secondsText:String;
        var minutesText:String;

        trace("total seconds: " + secondsLeft);

        if (secondsLeft > 60)
        {
            _minutesToGrowBack = int(Math.floor(secondsLeft / 60));

            trace("whole minutes: " + _minutesToGrowBack);
            secondsLeft = secondsLeft % 60;

            if (secondsLeft < 10) {
//                timerTF.text = "" + _minutesToGrowBack + ":0"+ secondsLeft;
                fullString = "" + _minutesToGrowBack + ":0"+ secondsLeft;
                minsAndSecondsText = "" + _minutesToGrowBack + ":0"+ secondsLeft;
                secondsText = "0" + secondsLeft;
            }
            else {
//                timerTF.text = "" + _minutesToGrowBack + ":"+ secondsLeft;
                fullString = "" + _minutesToGrowBack + ":"+ secondsLeft;
                minsAndSecondsText = "" + _minutesToGrowBack + ":"+ secondsLeft;
                secondsText = "" + secondsLeft;
            }

        }
        else
        {
            fullString = "" + secondsLeft;
        }

        if (_minutesToGrowBack > 60)
        {

            _hoursToGrowBack = int(_minutesToGrowBack / 60);
            _minutesToGrowBack = _minutesToGrowBack % 60;
            trace("hours and new minutes: " + _hoursToGrowBack + ", " + _minutesToGrowBack);

            if (_minutesToGrowBack < 10) {
                minutesText = "0" + _minutesToGrowBack;
            }
            else {
                minutesText = "" + _minutesToGrowBack;
            }

            fullString = "" + _hoursToGrowBack + ":" + minutesText + ":" + secondsText;
//            timerTF.text = "" + _hoursToGrowBack + ":" + minutesText + ":" + secondsText;

        }

        return fullString;
    }

    public static function comebackFromWatchingAd():void
    {
        var model:Model = Model.getInstance();
        model.blockerQuad.visible = false;
        model.game._gameDecorator._searchingforAdPopupSprite.visible = false;
    }

    public static function tweenPopup(popup:Sprite, inView:Boolean, hideBlockerQuad:Boolean = true):void
    {
        //			trace("popup");
        var model:Model = Model.getInstance();

        // the variable "inView" represents whether the popup is
        // moving inView (on the screen) or not inView (off the screen).
        var destinationY:int;

        if (inView)
        {
            destinationY = Constants.POPUP_Y_ON_SCREEN;
            model.blockerQuad.visible = true;
        }
        else
        {

            trace("InView is false");
            destinationY = Constants.POPUP_Y_OFF_SCREEN;
            if (popup == model.specialPopupSprite)
            {
                trace("popup is special" + model.menuPopupSprite.y + " vs " + Constants.POPUP_Y_ON_SCREEN);
                if (model.menuPopupSprite.y == Constants.POPUP_Y_OFF_SCREEN)
                {

                    trace("making visible false" +  model.blockerQuad.visible);

                }
            }

            if (popup == model.menuPopupSprite)
            {
                trace("popup is menu" + model.specialPopupSprite.y);
                if (model.specialPopupSprite.y == Constants.POPUP_Y_OFF_SCREEN)
                {

                    trace("making visible false" +  model.blockerQuad.visible);
                }
            }

            if (hideBlockerQuad)
            {
                model.blockerQuad.visible = false;
            }



        }

        Starling.juggler.tween(popup, 1, { //x: 155,
            y: destinationY
            //												   pivotX: charHead.width/2 + 500,
            //												   pivotY : charHead.height/2 + 700,
            // scaleX : 0.1, scaleY : 0.1,
            // onComplete:OnHeadExploded
        })
    }


    public static function getCharObjectFromCharChoiceBtn(charChoiceBtnSelected:CharChoiceButton):CharacterObject {
        var correspondingCharacter:CharacterObject = null;

        var model:Model = Model.getInstance();
        for each (var charOb:CharacterObject in Constants.allCharactersMasterList)
        {
            trace("checking _model.characterList object charb ob: " + charOb + " " + charOb.shortName);
            trace("checking against_model.currentCharChoiceBtnSelected.shortName : " + model.currentCharChoiceBtnSelected.shortName);

            if (charOb.shortName.toString() == model.currentCharChoiceBtnSelected.shortName.toString())
            {
                correspondingCharacter = charOb;
                trace("selected the corresponding char!!!! " + correspondingCharacter.shortName);
            }

        }

        trace("The corresponding character is: " + correspondingCharacter);
        return correspondingCharacter;
    }

    public static function getHumanReadableCurrentThingToBuy(currentThingToBuy:String):String {

        var humanReadableText:String = "";
        var model:Model = Model.getInstance();
        var nextLevel:int = 0;

                if (currentThingToBuy.indexOf(Constants.BUY_CHARACTER) != -1)
        {
            humanReadableText = model.currentCharChoiceBtnSelected.charName;
        }
        else if (currentThingToBuy.indexOf(Constants.BUY_UPGRADE_BRAINS) != -1)
        {
            nextLevel = model.userDataSharedObject.data[
                    model.currentCharChoiceBtnSelected.shortName + Constants.UPGRADE_BRAINS_LEVEL] + 1;
            humanReadableText = "Brains upgrade level " + nextLevel;
        }
        else if (currentThingToBuy.indexOf(Constants.BUY_UPGRADE_TIME) != -1)
        {
            trace("Original upgrade value: " +  model.userDataSharedObject.data[
                    model.currentCharChoiceBtnSelected.shortName + Constants.UPGRADE_TIME_LEVEL]);

            nextLevel =  model.userDataSharedObject.data[
            model.currentCharChoiceBtnSelected.shortName + Constants.UPGRADE_TIME_LEVEL] + 1;
            humanReadableText = "Time upgrade level " + nextLevel;
        }
        else if (currentThingToBuy.indexOf(Constants.BUY_UPGRADE_SPECIAL) != -1)
        {
            nextLevel = model.userDataSharedObject.data[
                    model.currentCharChoiceBtnSelected.shortName + Constants.UPGRADE_SPECIAL_LEVEL] + 1;
            humanReadableText = "Special upgrade level " + nextLevel;
        }

        return humanReadableText;
    }
}
}
