/**
 * Created by Alex Krivtsov on 03.12.2015.
 */
package util {
import flash.events.Event;

import flexunit.framework.Assert;

public class EslStorageManagerTest {
    public var storage:EslStorageManager;
    private var testName:String = "testStorage";
    private var testValue:String = "testValue";

    [Test(order=1)]
    public function testBeginningVar():void {
        var storageVar:String = storage.getVar(testName);
        if(storageVar)
        Assert.assertNoMatch(testValue, storageVar);
        else
        Assert.assertNull(storageVar);
    }

    [Test(order=3)]
    public function testGetVar():void {
        storage.setVar(testName, testValue);
        Assert.assertEquals(testValue, storage.getVar(testName));
    }

    [Test(order=2,expects="Error")]
    public function testGetInstance():void {
        var errorneousCallConstractor:EslStorageManager = new EslStorageManager();
    }

    [Before]
    public function setUp():void {
        storage = EslStorageManager.getInstance();
    }

    [After]
    public function tearDown():void {
        storage.setVar(testName, "");
    }
}
}
