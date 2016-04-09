package pre_game.src {
	
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	
	
	public class PreGameInteractive extends MovieClip {
		
		private var _preGameScreen:MovieClip;
		private var _imReadyBtn:MovieClip;
		private var _startBtn:MovieClip;
		private var _quitBtn:MovieClip;
		private var _fader:MovieClip;
//		private var _classBtn6:MovieClip;
		private var _classBtn5:MovieClip;
		private var _classBtn4:MovieClip;
		private var _classBtn3:MovieClip;
		private var _classBtn2:MovieClip;
		private var _classBtn1:MovieClip;
		public var readySignal:Signal = new Signal();
		private var _preGameModel:preGameModel;
		public var classChangeSignal:Signal = new Signal();
		
		
		public function PreGameInteractive() {
			// constructor code
			init();
			
		}
		
		private function init():void
		{
		trace("cheese")	
			
			assignVars();
			addListeners();
			
			_preGameModel = preGameModel.getInstance();
			_preGameModel.preGameMainClass = this;

			beginPlayerIoLogin();
		}

		private function beginPlayerIoLogin():void
		{
			client.multiplayer.developmentServer = "127.0.0.1:8184";


			PlayerIO.Authenticate(
    "mjack-dev-jxmuuaa4j0ofwnvniaq",            //Your game id
    "public",                               //Your connection id
    new Dictionary<string, string> {        //Authentication arguments
        {"username", "todd"},         //Username - either this or email, or both
        {"email", "jim@fuck.com"},               //Email - either this or username, or both
        {"password", "poopy"}          //Password - required
    },
    null,                                   //PlayerInsight segments
    delegate(Client client) {
        //Success!
    },
    delegate(PlayerIOError error) {
        //Error authenticating.
    }
);
		}
		
		private function assignVars():void
		{
			_preGameScreen = this["preGameScreen"];
			trace(_preGameScreen);
			
			
			_quitBtn = _preGameScreen["quitBtn"];
			_imReadyBtn = _preGameScreen["imReadyBtn"];
			_startBtn = _preGameScreen["startBtn"];
			_fader = _preGameScreen["fader"];

			_classBtn1 = _preGameScreen["classBtn1"];
			_classBtn2 = _preGameScreen["classBtn2"];
			_classBtn3 = _preGameScreen["classBtn3"];
			_classBtn4 = _preGameScreen["classBtn4"];
			_classBtn5 = _preGameScreen["classBtn5"];
//			_classBtn6 = _preGameScreen["classBtn6"];
			
			_fader.alpha = 0;
			
			_classBtn1.buttonMode = true;
			_classBtn2.buttonMode = true;
			_classBtn3.buttonMode = true;
			_classBtn4.buttonMode = true;
			_classBtn5.buttonMode = true;
//			_classBtn6.buttonMode = true;
			_imReadyBtn.visible = false;
			
			_startBtn.buttonMode = true;
			_quitBtn.buttonMode = true;
			_imReadyBtn.buttonMode = true;
			
//			classButtonClicked
			
			
		}
		
		private function onReady(passed:String):void
		{
			// TODO Auto Generated method stub
			trace("IIIIIIIIIm ready" + passed);
			
			
			
			
		}		
		
		
		private function addListeners():void
		{
			// TODO Auto Generated method stub
			_quitBtn.addEventListener(MouseEvent.CLICK, onQuitBtnClick);
			_imReadyBtn.addEventListener(MouseEvent.CLICK, onImReadyBtnlick);
			_startBtn.addEventListener(MouseEvent.CLICK, onStartBtnClick);
//			_fader.addEventListener(MouseEvent.CLICK, onStartBtnClick);
			_fader.mouseEnabled = false;
			
			_classBtn1.addEventListener(MouseEvent.CLICK, onClassBtnClick);
			_classBtn2.addEventListener(MouseEvent.CLICK, onClassBtnClick);
			_classBtn3.addEventListener(MouseEvent.CLICK, onClassBtnClick);
			_classBtn4.addEventListener(MouseEvent.CLICK, onClassBtnClick);
			_classBtn5.addEventListener(MouseEvent.CLICK, onClassBtnClick);
//			_classBtn6.addEventListener(MouseEvent.CLICK, onClassBtnClick);

			readySignal.add(onReady);
			classChangeSignal.add(onClassChange);
		}
		
		private function onClassChange(newClass:String):void
		{
			// TODO Auto Generated method stub
			trace("new class " + newClass);
			
			switch(newClass)
			{
				case "classBtn1":
					_imReadyBtn.visible = true;
					break;
			}
		}
		
		protected function onClassBtnClick(event:MouseEvent):void
		{
			trace("class btn clicked " + event.target.name);
			_preGameModel.myClassChosen = event.target.name;
			
		}
		
		protected function onStartBtnClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("start clicked");
			
			TweenLite.to(_fader, 2, {alpha:1});
			
			
		}
		
		protected function onImReadyBtnlick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function onQuitBtnClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
	}
	
}
