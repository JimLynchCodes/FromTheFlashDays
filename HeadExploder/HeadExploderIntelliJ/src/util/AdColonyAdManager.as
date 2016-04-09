/**
 * Created by bobolicious3000 on 11/10/15.
 */
package util {
import com.jirbo.airadc.AirAdColony;

import flash.events.StatusEvent;
import flash.events.TimerEvent;
import flash.system.Capabilities;
import flash.utils.Timer;

public class AdColonyAdManager {
    private var _model:Model;
    private static var instance:AdColonyAdManager = new AdColonyAdManager();
    private var _adColony:AirAdColony;

    private var _androidAppColonyId:String = "app06da6d5ce56241b6a1";
    private var _androidAppColonyZone:String = "vz481b369f0ca1475b98";

    private var _iosAppColonyId:String = "app09b47d0fd9194542bf";
    private var _iosAppColonyZone:String = "vzc8a1e868ae404cada5";
    private var adColonySearchTimer:Timer = new Timer(1000, 30);;

    public function AdColonyAdManager() {

        _model = Model.getInstance();
        if (instance) {
            throw new Error("We cannot create a new instance.Please use AdColonyAdManager.getInstance()");
        }

    }

    public static function getInstance():AdColonyAdManager {

        return instance;
    }


    public function showAd():void {

        trace("Ding nothing!");
//        _model.game.activateCurrentCharsSpecial();

        if (_adColony)
        {
            checkPlayformAndPlayVideo();
        }
        else
        {
            initAirColony();
        }


        startTimeoutTimer();


    }

    private function startTimeoutTimer():void {

        adColonySearchTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onAdColonyTimeout)
        adColonySearchTimer.start();
        trace("Ad colony timeout timer started.");
    }

    private function onAdColonyTimeout(event:TimerEvent):void {
        adColonySearchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onAdColonyTimeout)
        Util.comebackFromWatchingAd();
    }

    private function initAirColony():void {



        _adColony = new AirAdColony();
        trace("Init adcolony. Supported: " + _adColony.isSupported());


        if (_adColony.isSupported()) {
            _adColony.adcContext.addEventListener(StatusEvent.STATUS, handleAdColonyEvent);


            if (Capabilities.version.toLowerCase().indexOf("ios") > -1) {
                trace("configuring for ios");
                _adColony.configure(
                        "1.0",              // client_options on Android, app version number on iOS
                        _iosAppColonyId, // Replace with your App ID from adcolony.com
                        _iosAppColonyZone   // Video Zone ID #1 from adcolony.com
//                    "z4daf3029bdd8a"    // Zone #2 - you can have any number of zones
                );
            }
            else if (Capabilities.version.toLowerCase().indexOf("and") > -1) {
                trace("configuring for android");
                _adColony.configure(
                        "1.0",              // client_options on Android, app version number on iOS
                        _androidAppColonyId, // Replace with your App ID from adcolony.com
                        _androidAppColonyZone   // Video Zone ID #1 from adcolony.com
//                    "z4daf3029bdd8a"    // Zone #2 - you can have any number of zones
                );
            }

        }
    }

    private function handleAdColonyEvent(event:StatusEvent):void {
        trace("On ad colony event");
        trace("level: " + event.level);
        trace("event.code: " + event.code);

        if (event.code.indexOf("AdFinished|true") != -1)
        {
            trace("THE VIDEO AD HAS ENDED");
            _model.game.activateCurrentCharsSpecial();

            if (adColonySearchTimer.running)
            {
                adColonySearchTimer.stop();
            }

            Util.comebackFromWatchingAd();
        }

        if (event.code.indexOf("AdAvailabilityChange|false") != -1)
        {
            trace("AdAvailabilityChange was false");
        }
        else if (event.code.indexOf("AdAvailabilityChange|true") != -1)
        {
            trace("AdAvailabilityChange was true");

           checkPlayformAndPlayVideo();

        }

    }

    private function checkPlayformAndPlayVideo():void {
        if(Capabilities.version.toLowerCase().indexOf("ios") > -1)
        {
            playVideo(_iosAppColonyZone);
        }
        else if(Capabilities.version.toLowerCase().indexOf("and") > -1)
        {

            playVideo(_androidAppColonyZone)
        }
    }

    public function playVideo(zoneID:String):void {

        trace("playing video");
        if(_adColony.isVideoAvailable(zoneID))
        {
            trace("showing ad");
            _adColony.showVideoAd(zoneID);
        }
        else
        {
            trace("Video not available");
        }
    }



}

}