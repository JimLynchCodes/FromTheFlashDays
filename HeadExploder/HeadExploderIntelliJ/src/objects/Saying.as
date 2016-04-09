/**
 * Created by bobolicious3000 on 11/28/15.
 */
package objects {
public class Saying {

    public static const SPEECH = "SPEECH";
    public static const THOUGHT = "THOUGHT";

    private var _type:String;
    private var _message:String;
    private var _saidOnHeadAlmostGrownBack:Boolean;
    private var _saidOnHeadExploded:Boolean;
    private var _saidOnIdle:Boolean;

    public function Saying(message:String, type:String, saidOnIdle:Boolean = false,
                saidOnHeadAlmostGrownBack:Boolean = false, saidOnHeadExploded:Boolean = false) {
        _message = message;
        _type = type;
        _saidOnIdle = saidOnIdle;
        _saidOnHeadAlmostGrownBack = saidOnHeadAlmostGrownBack;
        _saidOnHeadExploded = saidOnHeadExploded;

    }

    public function get type():String {
        return _type;
    }

    public function set type(value:String):void {
        _type = value;
    }

    public function get message():String {
        return _message;
    }

    public function set message(value:String):void {
        _message = value;
    }

    public function get saidOnHeadAlmostGrownBack():Boolean {
        return _saidOnHeadAlmostGrownBack;
    }

    public function set saidOnHeadAlmostGrownBack(value:Boolean):void {
        _saidOnHeadAlmostGrownBack = value;
    }

    public function get saidOnHeadExploded():Boolean {
        return _saidOnHeadExploded;
    }

    public function set saidOnHeadExploded(value:Boolean):void {
        _saidOnHeadExploded = value;
    }

    public function get saidOnIdle():Boolean {
        return _saidOnIdle;
    }

    public function set saidOnIdle(value:Boolean):void {
        _saidOnIdle = value;
    }
}
}
