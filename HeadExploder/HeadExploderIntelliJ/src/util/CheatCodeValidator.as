/**
 * Created by Jim on 9/25/2015.
 */
package util {
import objects.CharacterObject;

import starling.animation.IAnimatable;

import starling.core.Starling;

public class CheatCodeValidator {
    private var _model:Model;
    private var _decorator:GameDecorator;
    private var _soundManager:SoundManager;

    public function CheatCodeValidator(model:Model, decorator:GameDecorator) {
        _model = model;
    _decorator = decorator;

        _soundManager = SoundManager.getInstance();
    }


    public function validateCode(codeString:String):String
    {
        trace("Validating code: " + codeString.toLowerCase());

        // Check thxjim
        if (codeString == "thxjim")
        {
            if (_model.userDataSharedObject.data[Constants.CODE + "thxjim"] == undefined ||
                    _model.userDataSharedObject.data[Constants.CODE + "thxjim"] == false)
            {
                _model.userDataSharedObject.data[Constants.CODE + "thxjim"] = true;
                _decorator.displayUserGettingBrains(_model.userDataSharedObject.data.brainCount , 2000, 2000, 0)
                trace("Code used! thxjim");
                _soundManager.playSound(_soundManager.SECRET);
                _model.game._gameDecorator.input.text = "";
                _model.game._gameDecorator.input.prompt = Constants.CODES_PROMPT;

                _model.userDataSharedObject.flush();
            }



        }

        // Check keep it 500
        else if (codeString == "keep it 500")
        {
        if (_model.userDataSharedObject.data[Constants.CODE + "keepit500"] == undefined ||
            _model.userDataSharedObject.data[Constants.CODE + "keepit500"] == false)
                    {
                        _model.userDataSharedObject.data[Constants.CODE + "keepit500"] = true;
                         _decorator.displayUserGettingBrains(_model.userDataSharedObject.data.brainCount, 500, 500, 0)
                        trace("Code used! keepit500");
                        _soundManager.playSound(_soundManager.SECRET);
                        _model.game._gameDecorator.input.text = "";
                        _model.game._gameDecorator.input.prompt = Constants.CODES_PROMPT;

                        _model.userDataSharedObject.flush();
                }

        }

        else if (codeString == "undo")
        {
            // UNDO can be used any number of times!
                trace("Code used! undo");
            _soundManager.playSound(_soundManager.SECRET);
            _model.game._gameDecorator.input.text = "";
            _model.game._gameDecorator.input.prompt = Constants.CODES_PROMPT;

            var brainWinnings:int = 0;

            for (var i:int = 0; i < _model.characterList.length; i++)
            {
                var charOb:CharacterObject =  _model.characterList[i];

                if (_model.userDataSharedObject.data[charOb.shortName + Constants.CURRENTLY_GROWING] == true)
                {

                    trace("orig: " + charOb.originalHeadWidth + ", " + charOb.originalHeadWidth);
                    trace("Char was growing: " + charOb.shortName);
                    trace("scalex: " + charOb.charHead.scaleX);
                    trace("scaley: " + charOb.charHead.scaleY);

                    Starling.juggler.remove(charOb.headGrowingTween);
                    charOb.charHead.scaleX = 1;
                    charOb.charHead.scaleY = 1;
                    charOb.charHead.x = charOb.originalHeadX;
                    charOb.charHead.y = charOb.originalHeadY;
                    _model.game._gameDecorator.explodeBtn.alpha = 1;
                    charOb.timerTF.text = "";

                    trace("the char head's width: " + charOb.charHead.width + " and height: " + charOb.charHead.height);
                    charOb.killTimer();

                    _model.userDataSharedObject.data[charOb.shortName + Constants.CURRENTLY_GROWING] = false;
                    _model.userDataSharedObject.flush();


                    if (_model.userDataSharedObject.data[charOb.shortName + Constants.PREVIOUS_BRAINS_WON_AMOUNT] == undefined)
                    {
                        brainWinnings += 0;
                    }
                    else
                    {
                        brainWinnings += _model.userDataSharedObject.data[charOb.shortName + Constants.PREVIOUS_BRAINS_WON_AMOUNT]
                    }

                }




            }

            if (brainWinnings > 0)
            {
                var brainsToSubtract:int = -1 * Math.floor(brainWinnings * 1.1);
                trace("Brain winnings was: " + brainWinnings + " and subtracting: " + brainsToSubtract);
                _decorator.displayUserGettingBrains(_model.userDataSharedObject.data.brainCount, brainsToSubtract, brainsToSubtract, 0);
            }

        }
        else
        {
//            playSound(Error)
            trace("code not recognised: " + codeString);
        }


        return codeString;

    }
}
}
