/**
 * Created by Alex Krivtsov on 02.12.2015.
 */
package {
import flexunit.framework.Assert;

public class UtilTest {
    public const timeReg:RegExp = /\d{0,2}:\d{1,2}:\d{1,2}/;

    [Before(async, ui)]
    public function setUp():void {

    }

    [After]
    public function tearDown():void {

    }

    [Test]
    public function testComebackFromWatchingAd():void {
        Assert.fail("Not implemented yet. Will be done with working stage if there'll be need.");
    }

    [Test]
    public function testGetHumanReadableCurrentThingToBuy():void {
        /*const namesToTest:Array = ["Headmond X. Splodington", "Olivia Swiggles", "Fitness Francesca", "Tony Mazzarolli"];
        const namesToPass:Array = ["headmondBUY_CHARACTE", "oliviaBUY_CHARACTE", "francescaBUY_CHARACTE", "tonyBUY_CHARACTE"];
        for (var i:int = 0; i < namesToPass.length; i++) {
            Assert.assertEquals(namesToTest[i], Util.getHumanReadableCurrentThingToBuy(namesToPass[i]));
        }*/
        Assert.fail("Not implemented yet. Will be done with working stage if there'll be need.");
    }

    [Test]
    public function testGetCharObjectFromCharChoiceBtn():void {

        /*for (var i:int = 0; i < 4; i++) {
            var charChoisBtn:CharChoiceButton = new CharChoiceButton(i);
            Assert.assertObjectEquals(Constants.allCharactersMasterList[i], Util.getCharObjectFromCharChoiceBtn(charChoisBtn));
        }*/
        Assert.fail("Not implemented yet. Will be done with working stage if there'll be need.");
    }

    [Test]
    public function testTweenPopup():void {
        Assert.fail("Not implemented yet. Will be done with working stage if there'll be need.");
    }

    [Test]
    public function testNicelyFormatSeconds():void {
        var time:Date = new Date();
        var ago:Date = new Date(time.time);
        ago.minutes -= 1;
        ago.hours -= 1;
        var diff:int = time.time - ago.time;
        Assert.assertMatch(timeReg, Util.nicelyFormatSeconds(diff));
    }
}
}
