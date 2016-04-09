/**
 * Created by bobolicious3000 on 11/3/15.
 */
package util {
//import org.flexunit.assertThat;
//import org.flexunit.asserts.assertEquals;
import org.flexunit.async.Async;
import org.fluint.uiImpersonation.UIImpersonator;
import org.hamcrest.assertThatBoolean;

import org.hamcrest.assertThat;

import starling.core.Starling;

import starling.events.Event;

//import org.hamcrest.assertThatBoolean;

[Suite]
public class CheatCodeValidatorTest {
    private var _cheatCodeValidator:CheatCodeValidator;
    private var inputs:Array;


    private static var _starling:Starling;

    [BeforeClass(async,ui)]
    public static function beforeClass():void
    {
        _starling = new Starling(FlexUnitStarlingIntegration, UIImpersonator.testDisplay.stage);
        Async.proceedOnEvent(CheatCodeValidatorTest, UIImpersonator.testDisplay.stage, Event.COMPLETE, 1000);
        _starling.start();

        var model =Model.getInstance();
        model.mStarling = _starling;
//        model.game = _starling;
    }

    [AfterClass]
    public static function afterClass():void
    {
        _starling.stop();
        _starling.dispose();
        _starling = null;
    }

    [Before]
    public function setup():void
    {
        trace("Setting up");
        var model = Model.getInstance();

        var gameDecorator:GameDecorator =GameDecorator.getInstance();
        _cheatCodeValidator = new CheatCodeValidator(model, gameDecorator);
        inputs = ["gojim"];
    }

    [Test]
    public function CheatCodeValidatorTest() {

        var expected:String;
        var actual:String;

        for each (var code:String in inputs)
        {
//            actual = _cheatCodeValidator.validateCode(code)

//            assertThat(actual, code);
        }

//        assertThatBoolean("y", true);


    }

    [Test]
    public function testValidateCodeThxJimSuccess() {
        _cheatCodeValidator.validateCode("thxjim");




    }

    [Test]
    public function testValidateCodeKeepIt500Success() {




    }

    [Test]
    public function testValidateCodeUndoSuccess() {




    }

    [Test]
    public function testValidateCodeInvalidCode() {




    }


}
}
