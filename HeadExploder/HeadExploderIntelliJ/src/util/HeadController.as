/**
 * Created by Jim on 9/28/2015.
 */
package util {
import objects.CharacterObject;

import starling.animation.Transitions;
import starling.animation.Tween;

import starling.core.Starling;

public class HeadController {
    private var _model:Model;
    private static var instance:HeadController = new HeadController();
    private var explodedDate:Date;
    private var finishedDate:Date;

    public function HeadController()
    {
        _model = Model.getInstance();
        if(instance)
        {
            throw new Error ("We cannot create a new instance.Please use GameDecorator.getInstance()");
        }
    }

    public static function getInstance():HeadController
    {

        return instance;
    }

    public function stopHeadGrowing(b:Boolean, character:CharacterObject):void {
        character.killTimer();
    }


    public function startHeadGrowing(justPressed:Boolean, character:CharacterObject, secondsToGrow:int = 0):void
    {

        _model.game._gameDecorator.explodeBtn.alpha = Constants.EXPLODE_BTN_DISABLED_ALPHA;
        character.charHead.scaleX = 0.03;
        character.charHead.scaleY = 0.03;
        character.charHead.x = character.headExplodedPoint.x;
        character.charHead.y = character.headExplodedPoint.y;
        trace("SHRINKING HEAD");

        trace("$# Starting head growing: " + secondsToGrow);
        trace("characer: "+ character);

        character.timerTF.visible = true;


        trace("model: " + _model);
        trace("_model.userDataSharedObject.data[Constants.EXPLODED_DATE + " + character.shortName + ": " + _model.userDataSharedObject.data[character.shortName + Constants.EXPLODED_DATE])
        trace("_model.userDataSharedObject.data[Constants.FINISHED_DATE + " + character.shortName + ": " + _model.userDataSharedObject.data[character.shortName + Constants.FINISHED_DATE])

        explodedDate = _model.userDataSharedObject.data[character.shortName + Constants.EXPLODED_DATE];
        finishedDate = _model.userDataSharedObject.data[character.shortName + Constants.FINISHED_DATE];

        trace("is seconds to grow 0? " + secondsToGrow);
        if (secondsToGrow == 0)
        {

            var millisecondsFullHeadGrowth:Number = Number(finishedDate) - Number(explodedDate);
            var currentDate:Date = new Date();

            var elapsedMillisecondsSinceExplosion:int = Number(currentDate) - Number(explodedDate);

            var percentageGrown:Number = Number(elapsedMillisecondsSinceExplosion) / Number(millisecondsFullHeadGrowth);
            trace("percent grown????? = " + percentageGrown);


            trace("original head y: " + character.headY + " exploded y: " + character.headExplodedPoint.y);
            trace("original head x: " + character.headX + " exploded x: " + character.headExplodedPoint.x);

            if (!justPressed)
            {
                character.charHead.scaleX = percentageGrown;
                character.charHead.scaleY = percentageGrown;
                character.charHead.y = character.headExplodedPoint.y - percentageGrown * (character.headExplodedPoint.y - character.originalHeadY )
                character.charHead.x = character.headExplodedPoint.x - percentageGrown * (character.headExplodedPoint.x - character.originalHeadX )
                trace("For percentage: " + percentageGrown + " the head y is now: " + character.charHead.y);
            }

            if (secondsToGrow != 0)
            {
                character.secondsLeftForHeadToGrowBack = secondsToGrow;
            }

            var millisecondsLeftToGrow:Number = millisecondsFullHeadGrowth - elapsedMillisecondsSinceExplosion;
            character.secondsLeftForHeadToGrowBack = millisecondsLeftToGrow / 1000;
            secondsToGrow = millisecondsLeftToGrow / 1000;

            trace("# starting explode timer for: " + character.shortName)
        }

        trace("$# Still: " + secondsToGrow);

        character.startExplodeTimer(secondsToGrow);

        var args:Array = [character];
        var headSizeInitialTweenArray:Array = [millisecondsLeftToGrow];

        var tween:Tween = new Tween(character.charHead, secondsToGrow, Transitions.LINEAR);
        tween.moveTo(character.originalHeadX, character.originalHeadY);
        tween.scaleTo(1);
        tween.onCompleteArgs = args;
        tween.onComplete = onHeadGrownBackTween;
        character.headGrowingTween = tween;

        Starling.juggler.add(tween);

    }

    private function onHeadShrunk(justPressed:Boolean, character:CharacterObject, secondsToGrow:int):void {
        _model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.CURRENTLY_GROWING] = true;
        startHeadGrowing(true, character, secondsToGrow);
    }

    protected function onHeadGrownBackTween(char:CharacterObject):void
    {

        trace("head has grown back tween!");
        _model.game._gameDecorator.explodeBtn.alpha = 1;

        char.timerTF.visible = false;


    }


    public function shrinkHeadAndStartGrowing(justPressed:Boolean, char:CharacterObject, secondsToGrow:int):void {
                trace("in shrink head growing _model.userDataSharedObject.data[Constants.EXPLODED_DATE + " + char.shortName + ": " + _model.userDataSharedObject.data[Constants.EXPLODED_DATE + char.shortName]);
        trace("what's the charOb? " + char);
        trace("_model.currentCharacterOnScreen.charHead : " + char.charHead);


        trace("moving to exploded point for " + char.shortName + ": " + char.headExplodedPoint.x + ", " + char.headExplodedPoint.y)
        var args:Array = [justPressed, char, secondsToGrow];
        Starling.juggler.tween(char.charHead, 1, {
            x: char.headExplodedPoint.x,
            y: char.headExplodedPoint.y,
            scaleX : .03, scaleY : 0.03,
            onComplete:onHeadShrunk,
            onCompleteArgs:args})
    }
}
}
