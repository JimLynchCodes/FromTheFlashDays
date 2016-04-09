/**
 * Created by bobolicious3000 on 11/4/15.
 */
package util {

[Suite]
public class HeadControllerTest {
    private static var _model:Model;
    public function HeadControllerTest() {
    }

    [BeforeClass]
    public static function setUp():void {
        trace("setting")
        _model = Model.getInstance();

        trace("current char: " + _model.currentCharacterOnScreen);

    }

    [AfterClass]
    public static function tearDown():void {
trace("tearing");
    }

    [Test]
    public function testStartHeadGrowing():void {
trace("testStartHeadGrowing");
        trace("the model was: " + _model);
    }

    [Test]
    public function testStopHeadGrowing():void {
        trace("testStopHeadGrowing");
    }

    [Test]
    public function testShrinkHeadAndStartGrowing():void {
        trace("testShrinkHeadAndStartGrowing");
    }
}
}
