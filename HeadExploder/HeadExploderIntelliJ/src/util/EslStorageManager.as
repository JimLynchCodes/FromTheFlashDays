/**
 * Created by bobolicious3000 on 11/30/15.
 */
package util {
import com.jirbo.airadc.AirAdColony;

import flash.data.EncryptedLocalStore;

import flash.events.StatusEvent;
import flash.events.TimerEvent;
import flash.system.Capabilities;
import flash.utils.ByteArray;
import flash.utils.Timer;

public class EslStorageManager {
    private var _model:Model;
    private static var instance:EslStorageManager = new EslStorageManager();

    public function EslStorageManager() {

        _model = Model.getInstance();
        if (instance) {
            throw new Error("We cannot create a new instance.Please use AdColonyAdManager.getInstance()");
        }

    }

    public static function getInstance():EslStorageManager {

        return instance;
    }

    public function setVar(name:String, value:String):void
    {
        var bytes:ByteArray = new ByteArray();
        bytes.writeUTFBytes(value);
        EncryptedLocalStore.setItem(name, bytes);
    }

    public function getVar(name):String
    {
        var storedValueByteArray:ByteArray = EncryptedLocalStore.getItem(name);
        return storedValueByteArray.toString();
    }

}

}