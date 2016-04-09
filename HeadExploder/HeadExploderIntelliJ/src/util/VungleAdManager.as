/**
 * Created by Jim on 8/25/2015.
 */
package util {
import com.distriqt.extension.application.Application;

import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.NetStatusEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.filesystem.File;
import flash.geom.Rectangle;
import flash.media.Video;
import flash.media.VideoStatus;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.sendToURL;
import flash.utils.Timer;

import starling.core.Starling;

import starling.display.Sprite;

public class VungleAdManager extends Sprite {

    private var _model:Model;
    private var testUrl:String = "http://cdn.liverail.com/adasset4/1331/229/7969/lo.flv";
    private var _vid:Video;
    private var adWidth:int;
    private var adHeight:int;
    private var _videoContainer:Sprite;
    private var _ns:NetStream;
    private var urlLoader:URLLoader;
    private var DISTRIQT_APPLICATION_KEY:String = "896e7e4d879898d576a78deb3bade9aa6cbae1e6RVD/2JLKammsJ2RRWMctHiq5b4Fq6yVSTBZkm733C74vcVBmSUKrINLhDMrztDaCLWOWZQJZp/GTF1UVKDY+2cnz4PmPAP/SjBflIlQ870msq5XCrL++XKdYTqXTIrprOgefTuuhBBruG5MCb45+9t6eH34E6TaDju8sRxaoRUvmj9E9AcWFd3gZePpuYtiwmkhkOlXcsktOPGx9pwFmu8KSZafYNu833le7reJntgV7gBThsD3BjwGWq7nR3wl7+Ku1WvCvcEBB6/ncnM3ERqzBA1pcYFuTekHlQtHARxhtLlLSAB0DEA4yBeyMYOQuHn6RrzhRsn8P0QbOz7v2kw==";
    private var adDuration:int;
    private var videoAdTimer:Timer;
    private var completeTrackingUri:String;
    private var thirdQaurtTrackingUri:String;
    private var midpointTrackingUri:String;
    private var firstQuartTrackingUri:String;
    private var startTrackingUri:String;
    private var secondsElapsed:int;
    private var _firstQuartileSeconds:int;
    private var _midpointSeconds:int;
    private var _thirdQuartileSeconds:int;
    private var _completeSeconds:int;
    private var _impressionsArray:Array = [];



    public function VungleAdManager() {

        _model = Model.getInstance();
    }



    public function beginAd():void
    {
        trace("beginning ad.");
        callForXml();
    }

    private function callForXml():void {
        var width = 200;
        var height = 200;
        var doNotTrack = 0;
        var LocationLat = 100;
        var LocationLong = 100;
        var IDFA = 17;
        var advertisingId = "";

        Application.init( DISTRIQT_APPLICATION_KEY );
        if (Application.isSupported)
        {

            trace("distriqt Application is supported!");
            var uniqueId:String = Application.service.device.uniqueId();
            trace("## got unique id: " + uniqueId);
            advertisingId = Application.service.device.uniqueId();
        }
        else
        {
            trace("distriqt Application is not supported.");
        }

        var rnd = Math.random() * 9000;

        urlLoader = new URLLoader();
        var request:URLRequest = new URLRequest();

        var urlString:String = "http://ssp.lkqd.net/ad?pid=119&sid=6571&env=2&format=2&width="+ width + "&height=" + height + "&dnt="+ doNotTrack + "&output=vast" + "&ua="+ escape(request.userAgent) + "&rnd=" + rnd + " &loclat=" + LocationLat +"&loclong=" + LocationLong + "&aid=" + advertisingId;
        trace("urlString: " + urlString);
        request.url = urlString;

        urlLoader.addEventListener(Event.COMPLETE, completeHandler);
        urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

        urlLoader.load(request);
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
        trace("io error handler" + event.toString());
        trace("io error handler" + event.errorID);
        trace("io error handler" + event.text);

        if (event.errorID.toString() == "2032")
        {
            trace("Io event 2032!!")
            _model.adDidntFillPopupSprite.visible = true;


        }

    }

    private function httpStatusHandler(event:HTTPStatusEvent):void {
        trace("http status handler");
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
        trace("security error handler");
    }

    private function progressHandler(event:ProgressEvent):void {
        trace("progress handler");
    }

    private function completeHandler(event:Event):void {
        trace("complete handler");
        trace("completed: " + urlLoader.data);
        var xml:XML = XML(urlLoader.data);

        trace("value of : " + xml.valueOf() + " ");
        trace("value of error:: " + xml.Extensions.valueOf() + " ");
        trace("code " + xml.Extensions.Extension.Error.@code);

        if (int(xml.Extensions.Extension.Error.@code) != 2 && int(xml.Extensions.Extension.Error.@code) != 1 ) {
            var videoUrl:String = xml.Ad.InLine.Creatives.Creative.Linear.MediaFiles.MediaFile.valueOf();

            var adDurationString = xml.Ad.InLine.Creatives.Creative.Linear.Duration.valueOf();
            adDuration = int(adDurationString.substr(6, 2))
            trace("duration: " + adDuration);

            var trackingEventsXml:XMLList = xml.Ad.InLine.Creatives.Creative.Linear.TrackingEvents.Tracking
            for each (var trackingNode:XML in trackingEventsXml) {
                trace("$ getting tracking track: " + trackingNode);

                if (trackingNode.@event == "start") {
                    trace("Start node!")
                }
                else if (trackingNode.@event == "firstQuartile") {
                    firstQuartTrackingUri = trackingNode.valueOf();
                    trace("saving firstQuartile uri: " + trackingNode.valueOf());


                }
                else if (trackingNode.@event == "midpoint") {
                    midpointTrackingUri = trackingNode.valueOf();
                    trace("saving midpointTrackingUri uri: " + trackingNode.valueOf());

                }
                else if (trackingNode.@event == "thirdQuartile") {
                    thirdQaurtTrackingUri = trackingNode.valueOf();
                    trace("saving thirdQuartile uri: " + trackingNode.valueOf());

                }
                else if (trackingNode.@event == "complete") {
                    completeTrackingUri = trackingNode.valueOf();
                    trace("saving complete uri: " + trackingNode.valueOf());

                }
                else {
                    trace("not valid tarcking: " + trackingNode.@event);
                }
            }
            var trackingEventsXml:XMLList = XMLList(xml.Ad.InLine.Creatives.Creative.Linear.TrackingEvents.Tracking);
            trackingEventsXml.length();

            var impressionTrackingXml:XMLList = XMLList(xml.Ad.InLine.Impression);
            for each (var impressionNode:XML in impressionTrackingXml) {
                var impressionUri:String = impressionNode.valueOf();
                _impressionsArray.push(impressionUri);
            }


            trace("in line: " + videoUrl);

            loadVideo(videoUrl);

        }
        else if (int(xml.Extensions.Extension.Error.@code) == 2 )
        {
            trace("Error occurred with ad, Error Code 2");
            _model.adDidntFillPopupSprite.visible = true;
        }
        else if (int(xml.Extensions.Extension.Error.@code) == 1 )
        {
            trace("Error occurred with ad, Error Code 1");
            _model.adDidntFillPopupSprite.visible = true;
        }



    }

    private function loadVideo(testUrl:String):void {

        var nc:NetConnection = new NetConnection();
        nc.connect(null);
        _ns = new NetStream(nc);
        var netClient:Object = new Object();

        netClient.onMetaData = function(meta:Object):void
        {


        };
        _ns.client = netClient;

            _vid = new Video(_model.flashStage.stageWidth, _model.flashStage.stageHeight);
            _model.flashStage.addChild(_vid);
            _vid.attachNetStream(_ns);

        _ns.play(testUrl);
        secondsElapsed = 0;
    _firstQuartileSeconds = Math.floor(adDuration * 1 / 4)
    _midpointSeconds = Math.floor(adDuration * 0.5)
    _thirdQuartileSeconds = Math.floor(adDuration * 3 / 4)
    _completeSeconds = adDuration;

        videoAdTimer = new Timer(1000, adDuration);
        videoAdTimer.addEventListener(TimerEvent.TIMER, onAdTimerTick);
        videoAdTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onAdTimerComplete);
        videoAdTimer.start();
        trace("video playing?");

        _ns.addEventListener(NetStatusEvent.NET_STATUS, netstat);

        function netstat(stats:NetStatusEvent):void
        {

            trace("netstat thrown: " + stats.info.code);
            switch (stats.info.code)
            {

                case "NetStream.Play.Start":
                    break;

                case "NetStream.Pause.Notify":
                    break;

                case "NetStream.Play.StreamNotFound":
                    trace("%$ !!!! Stream was not found!");
                    break;

                case "NetStream.Play.Stop":

                        trace("Handling video over")

                        if (Main.stageVideoAvailable)
                        {
                            // dispose StageVideo
                            trace("disposing stagevideo?");
                            _model.mStarling.stage3D.visible = true;
                            _model.mStarling.stage.touchable = true;
                        }
                        else
                        {
                            trace("destroying video");
                            trace(_model.flashStage);
                            trace(_model.flashStage.getChildAt(0));
                            trace(_vid);


                            _model.flashStage.removeChild(_vid);
                            _model.mStarling.stage3D.visible = true;
                            _model.mStarling.stage.touchable = true;
                            _vid = null;

                            _model.game.activateCurrentCharsSpecial();
                        }

                    break;

                default:
                    trace("unrecognised code: " + stats.info.code);
                break;

            }

        }
    }

    private function onAdTimerTick(event:TimerEvent):void {
        trace("onAdTimerTick");

        secondsElapsed++;
        trace("New seconds Elapsed: " + secondsElapsed);
        var request:URLRequest = new URLRequest();

        switch (secondsElapsed)
        {
            case 1:
                trace("%$ Pinging Impression event., looping...");

                for (var i:int = 0; i < _impressionsArray.length; i++)
                {
                    trace("%$ Pinging Impression event url, " + _impressionsArray[i]);
                    request.url = _impressionsArray[i];
                    request.method = "GET";
                    ping(request);
                }

                break;

            case _firstQuartileSeconds:
                trace("%$ Pinging event: " + "_firstQuartile" + " at URL: " + firstQuartTrackingUri);
                request.url = firstQuartTrackingUri;
                request.method = "GET";
                ping(request);
                break;
            case _midpointSeconds:
                trace("%$ Pinging event: " + "_midpoint" + " at URL: " + midpointTrackingUri);
                request.url = midpointTrackingUri;
                request.method = "GET";
                ping(request);
                break;

            case _thirdQuartileSeconds:
                trace("%$ Pinging event: " + "_thirdQuartileSeconds" + " at URL: " + thirdQaurtTrackingUri);
                request.url = thirdQaurtTrackingUri;
                request.method = "GET";
                ping(request);
                break;

            case _completeSeconds:
                trace("%$ Pinging event: " + "_completeSeconds" + " at URL: " + completeTrackingUri);
                request.url = completeTrackingUri;
                request.method = "GET";
                ping(request);
                break;

            default:


                break;
        }

    }

    private function ping(request:URLRequest):void {
        if (request.url != null)
        {
            sendToURL(request);
        }
        else
        {
            trace("The PING REQUEST WAS NULL!!")
        }
    }

    private function onAdTimerComplete(event:TimerEvent):void {
        trace("onAdTimerComplete");
    }

    private function onVideoComplete(event:Event):void {
        trace("Video completed!");
    }


    public function onMetaData(e:Object):void
    {

    }

    public function onXMPData(e:Object):void
    {

    }


    private function onVideoClicked(event:MouseEvent):void {
        trace("video clicked");
    }
}
}
