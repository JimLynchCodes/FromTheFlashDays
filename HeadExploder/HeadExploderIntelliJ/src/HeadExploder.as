package {
import com.ma.extensions.NativeLogger.NativeLoggerANE;
import com.testfairy.AirTestFairy;

import flash.desktop.NativeApplication;
import flash.display.Loader;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage3D;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.events.Event;

import flash.geom.Rectangle;
import flash.media.Sound;
import flash.media.SoundChannel;

import flash.system.Capabilities;
import flash.system.System;

import org.gestouch.core.Gestouch;
import org.gestouch.extensions.native.NativeDisplayListAdapter;
import org.gestouch.extensions.native.NativeTouchHitTester;
import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
import org.gestouch.extensions.starling.StarlingTouchHitTester;
import org.gestouch.input.NativeInputAdapter;

import starling.core.Starling;


import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.textures.RenderTexture;
import starling.utils.RectangleUtil;
import starling.utils.ScaleMode;
import starling.utils.SystemUtil;


//[SWF(width="300", height="400", frameRate="60", backgroundColor="#000000")]
//[SWF(height="2048", width="1536", frameRate="60", backgroundColor="0x000000")]//ipad 3rd generation Retina
//[SWF(height="568", width="320", frameRate="60", backgroundColor="0x000000")] //iphone 5th generation		1136	640
//[SWF(height="1024", width="768", frameRate="24", backgroundColor="#999999")]    //iPad2 generation  512   384      1024     768
//[SWF(height="960", width="640", frameRate="24", backgroundColor="#222222")]  //Half of IPhone size for testing.   480  320           960 640
//[SWF(height="320", width="480", frameRate="24", backgroundColor="#222222")]  //  IPhone original size.
//[SWF(width="550", height="400", frameRate="30", backgroundColor="#1199EF")]
//[SWF(width="320", height="480", frameRate="30", backgroundColor="#000000")]


public class HeadExploder extends Sprite
{
//	private var mStarling:Starling;

//	private const StageWidthIos:int  = 320;
//	private const StageWidthAnd:int  = 270;
//	private const StageHeight:int = 480;

	private var mStarling:Starling;
	private var mBackground:Loader;
	private var stageVideoAvail:Boolean;
	private var _model:Model;
	private var trueSplash:StartupSplashScreen;

	public function HeadExploder()
	{
        if(stage) initializeMainApp();
        else
        addEventListener(flash.events.Event.ADDED_TO_STAGE, initializeMainApp);
    }

    private function initializeMainApp(e:flash.events.Event=null):void {
		stage.stage3Ds[0].addEventListener(flash.events.Event.CONTEXT3D_CREATE, onContext3DCreate);

		trace("startin up hmmm");
		NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onAppActivate);
		NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, onAppDeactivate);


		AirTestFairy.begin("ff2f3a7f767103a893225ebf30206274475d8641");
		var bool:Boolean = NativeLoggerANE.getInstance().isSupported();
		NativeLoggerANE.getInstance().init(false,"AIR");

		NativeLoggerANE.getInstance().debug("Started!");
		NativeLoggerANE.getInstance().error("Started!");
		NativeLoggerANE.getInstance().warn("Started!");


		if(Capabilities.version.toLowerCase().indexOf("ios") > -1)
		{
//			Main.GAME_W= 320;
//			Main.GAME_H= 480;

			Main.GAME_H= 480;
			Main.GAME_W= 480 / stage.fullScreenHeight * stage.fullScreenWidth;
		}
		else if(Capabilities.version.toLowerCase().indexOf("and") > -1)
		{

			Main.GAME_H= 480;
			Main.GAME_W= 480 / stage.fullScreenHeight * stage.fullScreenWidth;

//			Main.GAME_W = stage.fullScreenWidth / 2;
//			Main.GAME_H = stage.fullScreenHeight / 2 ;
		}

		var model:Model = Model.getInstance();
		model.flashStage = stage;

		trace("Flash stage: " + model.flashStage.fullScreenWidth + ", " + model.flashStage.fullScreenHeight)
		var rectangle:Shape = new Shape; // initializing the variable named rectangle
		rectangle.graphics.beginFill(0x000000); // choosing the colour for the fill, here it is red
		rectangle.graphics.drawRect(0, 0, model.flashStage.fullScreenWidth,model.flashStage.fullScreenHeight); // (x spacing, y spacing, width, height)
		rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
		model.flashStage.addChild(rectangle);
		model.splashScreen = rectangle;

		trueSplash = new StartupSplashScreen();
		trueSplash.width = model.flashStage.fullScreenWidth;
		trueSplash.height = model.flashStage.fullScreenHeight;
		model.flashStage.addChild(trueSplash);


		model.platform = Capabilities.version.toLowerCase();

//		var :Boolean = SystemUtil.platform == "IOS";
		var stageSize:Rectangle  = new Rectangle(0, 0, Main.GAME_W, Main.GAME_H);
		var screenSize:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
		var viewPort:Rectangle = RectangleUtil.fit(stageSize, screenSize, ScaleMode.SHOW_ALL);
		var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640

		Starling.multitouchEnabled = true; // useful on mobile devices
//		Starling.handleLostContext = true; // recommended everywhere when using AssetManager
//		RenderTexture.optimizePersistentBuffers = iOS; // safe on iOS, dangerous on Android


		mStarling = new Starling(Main, stage, viewPort, null, "auto", "auto");
		mStarling.stage.stageWidth    = Main.GAME_W;  // <- same size on all devices!
		mStarling.stage.stageHeight   = Main.GAME_H; // <- same size on all devices!
		mStarling.enableErrorChecking = Capabilities.isDebugger;
		_model = Model.getInstance();
		_model.mStarling = mStarling;


		Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		//setup gestouch
		//
		if (SystemUtil.platform == "IOS")
		{
//			trace("setting up ios gestouch");
//			Gestouch.addDisplayListAdapter(flash.display.DisplayObject, new NativeDisplayListAdapter());
//			Gestouch.addTouchHitTester(new NativeTouchHitTester(stage));
			trace("setting up non-ios gestouch");
			Gestouch.inputAdapter ||= new NativeInputAdapter(_model.flashStage);
			Gestouch.addDisplayListAdapter(DisplayObject, new StarlingDisplayListAdapter());
			Gestouch.addTouchHitTester(new StarlingTouchHitTester(mStarling), -1);
		}
		else
		{
			trace("setting up non-ios gestouch");
			Gestouch.inputAdapter ||= new NativeInputAdapter(_model.flashStage);
			Gestouch.addDisplayListAdapter(DisplayObject, new StarlingDisplayListAdapter());
			Gestouch.addTouchHitTester(new StarlingTouchHitTester(mStarling), -1);
		}

		mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
		{
			trueSplash.visible = false;

//			loadAssets(scaleFactor, startGame);
			mStarling.start();

		});
	}

	private function onAppDeactivate(event:flash.events.Event):void {
		Starling.current.stop(true);
		trace("onAppDeactivate called");

		if (_model.game)
		{
			_model.game.appDeactivated();
		}

	}

	private function onAppActivate(event:flash.events.Event):void {
		Starling.current.start();
		trace("onAppActivate called");
		if (_model.game) {
			_model.game.appActivated();
		}

	}

	private function onContext3DCreate(event:flash.events.Event):void {

		trace("On new context!");
		var my_stage3D:Stage3D = (event.target as Stage3D);
		my_stage3D.context3D.clear();
		my_stage3D.context3D.present();
	}
}
}

