package pre_game.src
{
//	import com.models.Model;
//	import com.utils.LoadingSprite;
	
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import pre_game.src.model.PreGameModelo;
	
	
	public class PowerupDisplayController extends Sprite
	{
		private static var instance:PowerupDisplayController;
		private static var allowInstantiation:Boolean;
		private static var _opp3:MovieClip;
		private static var _opp2:MovieClip;
		private static var _opp1:MovieClip;
		private static var _myp3:MovieClip;
		private static var _myp2:MovieClip;
		private static var _myp1:MovieClip;
		private var _preGameScreen:MovieClip;
		private var _opClassBtn5:MovieClip;
		private var _opClassBtn4:MovieClip;
		private var _opClassBtn3:MovieClip;
		private var _opClassBtn2:MovieClip;
		private var _opClassBtn1:MovieClip;
		private var _waitingForOpponentToChooseClassTF:TextField;
		private var _preGameModel:PreGameModelo;
		private var _opponentIsReadyTF:TextField;
		private var _startBtn:MovieClip;
		private var _waitingForOpponentToTF:TextField;
		private var _fader:MovieClip;
		private var _opponentIWantsToStartTF:TextField;
		private var _waitingForOpponentToStartTF:TextField;
		private var _readyBtn:MovieClip;
		private var _cancelBtn:MovieClip;
		private var _opponentReturnedToClassSelectTF:Object;
		
		public function PowerupDisplayController()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
			
		}
		
		
		public static function getInstance():PowerupDisplayController {
			if (instance == null) {
				allowInstantiation = true;
				
				instance = new PowerupDisplayController();
				
				allowInstantiation = false;
				
				
				
				
			}
			return instance;
		}
		
		
		private function init():void
		{
			trace("Helper Class Initialized.");
			assignVars();
			addListeners();
		}
		
		public function setPowMovieClips(preGameScreen:MovieClip, myp1:MovieClip, myp2:MovieClip, myp3:MovieClip, opp1:MovieClip, opp2:MovieClip, opp3:MovieClip):void
		{
			
			_preGameScreen = preGameScreen;
			_waitingForOpponentToChooseClassTF = _preGameScreen["WaitingForOpponentClassTxt"];
			_opponentIsReadyTF = _preGameScreen["opponentIsReadyTF"];
			_startBtn = _preGameScreen["startBtn"];
			_waitingForOpponentToTF = _preGameScreen["waitingForOpponentToTxt"];
			_fader = _preGameScreen["fader"];
			_opponentIWantsToStartTF = _preGameScreen["opponentIWantsToStartTF"];
			_opponentIWantsToStartTF.visible = false;
			
			_waitingForOpponentToStartTF = _preGameScreen["waitingForOpponentToStartTF"];
			
			_opClassBtn1 = _preGameScreen["opClassBtn1"];
			_opClassBtn2 = _preGameScreen["opClassBtn2"];
			_opClassBtn3 = _preGameScreen["opClassBtn3"];
			_opClassBtn4 = _preGameScreen["opClassBtn4"];
			_opClassBtn5 = _preGameScreen["opClassBtn5"];
			_opponentReturnedToClassSelectTF = _preGameScreen["opponentReturnedToClassSelectTF"];
			_opponentReturnedToClassSelectTF.visible = false;
			
			_readyBtn = _preGameScreen["readyBtn"];
			_cancelBtn = _preGameScreen["cancelBtn"];
			
			_myp1 = myp1;
			_myp2 = myp2;
			_myp3 = myp3;
			
			_opp1 = opp1;
			_opp2 = opp2;
			_opp3 = opp3;
		}
		
		// encapsulate logic / calculations for other classes in public functions
		public static function helpOut():void
		{
			//Model.someInteger = 5;
		}
		
		
		private function assignVars():void
		{
			_preGameModel = PreGameModelo.getInstance();
			
		}
		
		
		private function addListeners():void
		{
			
			
		}
		
		
		
//		public function ():void
//		{
//			
//		}
		
		public function displayPowerups(whosePowerups):void
		{
			trace("displaying powerups");
			var pow1:MovieClip;
			var pow2:MovieClip;
			var pow3:MovieClip;
			
			
			if (whosePowerups == "mine") {
				pow1 = _myp1;
				pow2 = _myp2;
				pow3 = _myp3;
			}
			
			if (whosePowerups == "opponent") {
				pow1 = _opp1;
				pow2 = _opp2;
				pow3 = _opp3;
			}
			
			pow1.alpha = 0;
			pow2.alpha = 0;
			pow3.alpha = 0;
			
			
			trace("doing first");
			
			var powAry:Array = [pow2, pow3];
			TweenLite.to(pow1, 1, {alpha:1, onComplete:DoneFirst, onCompleteParams:powAry})
			pow1.gotoAndPlay("on");
		}
//		
		private function DoneFirst(pow2: MovieClip, pow3:MovieClip):void	
		{
			trace("done first");
			var secPowAry:Array = [pow3] 
			TweenLite.to(pow2, 1, {alpha:1, delay: 0.5, onComplete:DoneSecond, onCompleteParams:secPowAry})
		}
		
		private function DoneSecond(pow3:MovieClip):void	
		{
			TweenLite.to(pow3, 1, {alpha:1, delay: 0.5, onComplete:DoneThird})
		}
		
		private function DoneThird():void
		{
			trace("done third");
		}
		
		
		public function selectOpponentClassBtn(whichBtn:int):void
		{
			hideAllOpponentBtns();
			
			_waitingForOpponentToChooseClassTF.visible = false;
			
			switch(whichBtn)
			{
				case 1:
					_opClassBtn1.gotoAndPlay("select");
					break;
			
				case 2:
					_opClassBtn2.gotoAndPlay("select");
					break;
			
				case 3:
					_opClassBtn3.gotoAndPlay("select");
					break;
			
				case 4:
					_opClassBtn4.gotoAndPlay("select");
					break;
			
				case 5:
					_opClassBtn5.gotoAndPlay("select");
					break;
			
			
			}
			
		}
		
		private function hideAllOpponentBtns():void
		{
			_opClassBtn1.gotoAndPlay("nan");
			_opClassBtn2.gotoAndPlay("nan");
			_opClassBtn3.gotoAndPlay("nan");
			_opClassBtn4.gotoAndPlay("nan");
			_opClassBtn5.gotoAndPlay("nan");
			
		}
		
		public function handleOpponentReady():void
		{
			_opponentReturnedToClassSelectTF.visible = false;
			
			trace("handling opponent ready, me: " + _preGameModel.imReady);
			if (_preGameModel.imReady)
			{
				_opponentIsReadyTF.visible = true;
				_startBtn.visible = true;
				_startBtn.alpha = 1;
				_waitingForOpponentToTF.visible = false;
				_opponentIsReadyTF.visible = false;
				
				trace("I'm ready and my opponent is ready!");
			}
			else
			{
				_opponentIsReadyTF.visible = true;
				//_waitingForOpponentToTF.visible = false;
				
				
			}
			
			
		}
		
		public function handleOpponentCancelled():void
		{
			_opponentIWantsToStartTF.visible = false;
			_waitingForOpponentToStartTF.visible = false;
			_startBtn.visible = false;
				_readyBtn.visible = true;
				_readyBtn.alpha = 1;
				_preGameModel.imReady = false;
				_preGameModel.iWantToStart = false;
				_opponentIsReadyTF.visible = false;
				_waitingForOpponentToTF.visible = false;
				_opponentIsReadyTF.visible = false;
				_waitingForOpponentToTF.visible = false;
				_cancelBtn.visible = false;
				_opponentReturnedToClassSelectTF.visible = true;
			
			trace("opponent cancelled ready! " );
			
			if (_preGameModel.iWantToStart) {
			
			}
			
			if (_preGameModel.imReady && !_preGameModel.iWantToStart)
			{
			}
			else
			{
				
			}
			// TODO Auto Generated method stub
			
		}
		
		public function handleOpponentWantsToStart():void
		{
			_preGameModel.opponentWantsToStart = true;
			if (_preGameModel.iWantToStart)
			{
				TweenLite.to(_fader, 2, {alpha:1});
				_opponentIWantsToStartTF.visible = false;
			}	
			else if (_preGameModel.imReady) {
				
				_opponentIWantsToStartTF.visible = true;
			}
			else
			{
				_opponentIWantsToStartTF.visible = false;
				
			}
			
			
		}
	}	
}


