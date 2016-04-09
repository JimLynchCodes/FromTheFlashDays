/**
 * Created by bobolicious3000 on 10/17/15.
 */
package util {
import starling.core.Starling;

public class CharSlidingManager {

    private var _model:Model;
    private static var instance:CharSlidingManager = new CharSlidingManager();

    public function CharSlidingManager() {

    _model = Model.getInstance();
    if(instance)
    {
        throw new Error ("We cannot create a new instance.Please use CharSlidingManager.getInstance()");
    }
}

public static function getInstance():CharSlidingManager
{

    return instance;
}

    public function onUserSlidesChar(direction:String, fromButtonPress:Boolean):void
    {
        trace("direction: " + direction);
        if (direction == "LEFT")
        {


            if (_model.characterList.length > 1)
            {


                var direction:String;
                var oldIndex:int = _model.userDataSharedObject.data.currentCharacterIndex;
                direction = "LEFT";
                if (_model.userDataSharedObject.data.currentCharacterIndex == 0)
                {
                    _model.userDataSharedObject.data.currentCharacterIndex = _model.characterList.length - 1;
                }
                else
                {
                    _model.userDataSharedObject.data.currentCharacterIndex -= 1;
                }


                slideCharacters(_model.userDataSharedObject.data.currentCharacterIndex, oldIndex, direction);
            }
        }

        else if (direction == "RIGHT")
        {

            if (_model.characterList.length > 1)
            {
                trace("Right Arrow button clicked");
                var direction:String;
                var oldIndex:int = _model.userDataSharedObject.data.currentCharacterIndex;
                direction = "RIGHT";
                if (_model.userDataSharedObject.data.currentCharacterIndex == _model.characterList.length - 1)
                {
                    _model.userDataSharedObject.data.currentCharacterIndex = 0;
                    trace("Looping back around to 0");
                }
                else
                {
                    _model.userDataSharedObject.data.currentCharacterIndex += 1;
                }

                _model.userDataSharedObject.flush();

                trace("new: " + _model.userDataSharedObject.data.currentCharacterIndex +" , old: " + oldIndex);
                slideCharacters(_model.userDataSharedObject.data.currentCharacterIndex, oldIndex, direction);
            }
        }
        else {
            trace("direction was something else: " + direction);
        }

    }


    private function slideCharacters(newIndex:int, oldIndex:int, direction:String):void
    {
        trace("newIndex: " + newIndex + " oldndex: " + oldIndex);
        _model.userDataSharedObject.data.currentCharIndexOnScreen = newIndex;
        _model.userDataSharedObject.flush();

        _model.currentCharacterOnScreen = _model.characterList[newIndex];
        _model.userDataSharedObject.data[Constants.CHAR_CURRENTLY_ON_SCREEN] = _model.characterList[newIndex].shortName;
        trace("Changing CHAR_CURRENTLY_ON_SCREEN to: " + _model.characterList[newIndex].shortName);


        var oldCharX:int;
        var newCharX:int;

        if (direction =="LEFT")
        {
            // Characters slide left.
            trace("char: " + _model.characterList[oldIndex] + " , " + _model.characterList[oldIndex].shortName);
            oldCharX = 	_model.characterList[oldIndex].OFF_SCREEN_LEFT_X;
            _model.characterList[newIndex].charSprite.x = _model.characterList[newIndex].OFF_SCREEN_RIGHT_X;

        }
        else
        {
            // Characters slide right.
            _model.characterList[newIndex].charSprite.x = _model.characterList[newIndex].OFF_SCREEN_LEFT_X;
            oldCharX = 	_model.characterList[oldIndex].OFF_SCREEN_RIGHT_X;

        }



        Starling.juggler.tween(_model.characterList[oldIndex].charSprite, _model.game._gameDecorator.CHAR_TRANSITION_DURATION, { //x: 155,
            x: oldCharX
            //				onComplete:onBrainsFloaterComplete
        });

        _model.charactersCurrentlySliding = true;

        trace("Sliding " + _model.characterList[newIndex].shortName + " to x: " + _model.characterList[newIndex].ON_SCREEN_X + "_model.characterList[newIndex].x: " + _model.characterList[newIndex].x);
        //			_model.characterList[newIndex].charSprite.x = _model.characterList[newIndex].ON_SCREEN_X;
        _model.characterList[newIndex].charSprite.visible = true;
        _model.characterList[newIndex].visible = true;

        Starling.juggler.tween(_model.characterList[newIndex].charSprite, _model.game._gameDecorator.CHAR_TRANSITION_DURATION, { //x: 155,
            x: _model.characterList[newIndex].ON_SCREEN_X,
            //				x:0
            onComplete:onCharSlidIn
        });

        trace("new index char: " + _model.characterList[newIndex].charName +
                " and old index char: " + _model.characterList[oldIndex].charName);

    }

    private function onCharSlidIn():void
    {
        if (_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.SPECIAL_ACTIVATED] == false)
        {
            _model.game._gameDecorator.watchForSpecialButton.alpha = 1;
        }
        else
        {
            _model.game._gameDecorator.watchForSpecialButton.alpha = Constants.EXPLODE_BTN_DISABLED_ALPHA;
//				var filter:Colghtness(-.35)
//				watchForSpecialBorMatrixFilter = new ColorMatrixFilter();
////			filter.invert();
//				filter.adjustBriutton.filter = filter;
        }

        if (_model.userDataSharedObject.data[_model.currentCharacterOnScreen.shortName + Constants.CURRENTLY_GROWING] == true)
        {
            _model.game._gameDecorator.explodeBtn.alpha = Constants.EXPLODE_BTN_DISABLED_ALPHA;
        }
        else
        {
            _model.game._gameDecorator.explodeBtn.alpha = 1;
        }


        _model.charactersCurrentlySliding = false;
    }


}
}
