package inner_game.src.controllers
{
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import inner_game.src.helpers.InGameDecorator;
	import inner_game.src.model.InnerGameModel;
	import inner_game.src.views.QuitPopup;
	
	
	public class ButtonController extends Sprite
	{
		private static var instance:ButtonController;
		private static var allowInstantiation:Boolean;
		private static  var _inGameModel:InnerGameModel;
		private static  var _startBtn:Sprite;
		private static  var _fiftyChipBtn:Sprite;
		private static  var _twentyFiveChipBtn:Sprite;
		private static  var _tenChipBtn:Sprite;
		private static  var _fiveChipBtn:Sprite;
		private static  var _potentialNextBetTF:TextField;
		private static  var _submitNextBetBtn:Sprite;
		private static  var _decrementBetBtn:Sprite;
		private static  var _incrementBetBtn:Sprite;
		private static  var _myPowerup3:Sprite;
		private static  var _myPowerup2:Sprite;
		private static  var _myPowerup1:Sprite;
		private static  var _surrenderBtn:Sprite;
		private static  var _splitBtn:Sprite;
		private static  var _doubleBtn:Sprite;
		private static  var _standBtn:Sprite;
		private static  var _hitBtn:Sprite;
		private static  var _quitBtn:Sprite;
		private static  var _musicBtn:Sprite;
		private static  var _sfxBtn:Sprite;
		private static  var quitPopup:Object;
		private static  var _decorator:InGameDecorator;
		private static  var _nextHandBtn:Sprite;
		
		public function ButtonController()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				
			}
			
		}
		
		
		public static function getInstance():ButtonController {
			if (instance == null) {
				allowInstantiation = true;
				
				instance = new ButtonController();
				init();
				allowInstantiation = false;
			}
			return instance;
		}

		
		private static function init():void
		{
			trace("Helper Class Initialized.");
			assignVars();
			addListeners();
		}
		
			// encapsulate logic / calculations for other classes in public functions
		public static function helpOut():void
		{
//			Model.someInteger = 5;
		}

		public function handleclick(m:MouseEvent):void
		{
			trace("handling message")

		}
		
		
		private static function assignVars():void
		{
			_inGameModel = InnerGameModel.getInstance();
			var inGameScreen:Sprite = _inGameModel.inGameScreen;
			trace("inGameScreen in BC " + inGameScreen);		
			_decorator = InGameDecorator.getInstance(_inGameModel.connection);
			
			_startBtn = inGameScreen["startBtn"];
			_startBtn.visible = false;
			_startBtn.buttonMode = true;
			// next bet panel
			_incrementBetBtn = inGameScreen["nextBetPanel"]["incrementBetBtn"];
			_decrementBetBtn = inGameScreen["nextBetPanel"]["decrementBetBtn"];
			_submitNextBetBtn = _inGameModel.inGameScreen["nextBetPanel"]["submitNextBetBtn"];
			_potentialNextBetTF = inGameScreen["nextBetPanel"]["potentialNextBetTF"];
			_fiveChipBtn = inGameScreen["nextBetPanel"]["fiveChipBtn"];
			_tenChipBtn = inGameScreen["nextBetPanel"]["tenChipBtn"];
			_twentyFiveChipBtn = inGameScreen["nextBetPanel"]["twentyFiveChipBtn"];
			_fiftyChipBtn= inGameScreen["nextBetPanel"] ["fiftyChipBtn"];
			
			_myPowerup1 = inGameScreen["myPowerup1"];
			_myPowerup2 = inGameScreen["myPowerup2"];
			_myPowerup3 = inGameScreen["myPowerup3"];
			
			
			_hitBtn = inGameScreen["hitBtn"];
			_standBtn = inGameScreen["standBtn"];
			_doubleBtn = inGameScreen["doubleBtn"];
			_splitBtn= inGameScreen["splitBtn"];
			_surrenderBtn = inGameScreen["surrenderBtn"];
			
			_hitBtn.visible = false;
			_standBtn.visible = false;
			_doubleBtn.visible = false;
			_splitBtn.visible = false;
			_surrenderBtn.visible = false;
			
			_nextHandBtn = inGameScreen["nextHandBtn"];
			_nextHandBtn.visible = false;
			
			_sfxBtn = inGameScreen["sfxBtn"];
			_musicBtn = inGameScreen["musicBtn"];
			_quitBtn = inGameScreen["pauseBtn"];
			
			
			
			
		}
		
		
		private static function addListeners():void
		{
			_startBtn.addEventListener(MouseEvent.CLICK, onStartBtnClick);
			
			_hitBtn.addEventListener(MouseEvent.CLICK, onDecisionBtnClick);
			_standBtn.addEventListener(MouseEvent.CLICK, onDecisionBtnClick);
			_doubleBtn.addEventListener(MouseEvent.CLICK, onDecisionBtnClick);
			_splitBtn.addEventListener(MouseEvent.CLICK, onDecisionBtnClick);
			_surrenderBtn.addEventListener(MouseEvent.CLICK, onDecisionBtnClick);
			
			_sfxBtn.addEventListener(MouseEvent.CLICK, onSfxBtnClick);
			_musicBtn.addEventListener(MouseEvent.CLICK, onMusicBtnClick);
			_quitBtn.addEventListener(MouseEvent.CLICK, onQuitBtnClick);
			
			_incrementBetBtn.addEventListener(MouseEvent.CLICK, betAmountChangeClick);
			_decrementBetBtn.addEventListener(MouseEvent.CLICK, betAmountChangeClick);
			_submitNextBetBtn.addEventListener(MouseEvent.CLICK, betSubmitBtnClick);
			_fiveChipBtn.addEventListener(MouseEvent.CLICK, betAmountChangeClick);
			_tenChipBtn.addEventListener(MouseEvent.CLICK, betAmountChangeClick);
			_twentyFiveChipBtn.addEventListener(MouseEvent.CLICK, betAmountChangeClick);
			_fiftyChipBtn.addEventListener(MouseEvent.CLICK, betAmountChangeClick);
			_nextHandBtn.addEventListener(MouseEvent.CLICK, onNextHandBtnClick);
			
			_inGameModel.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyPress);
		}
		
		protected function onStartBtnClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected static function onKeyPress(event:KeyboardEvent):void
		{
			trace("key pressed " + event.charCode, event.keyCode);
			switch(event.keyCode) 
			{
				case 32:
					trace("Space key pressed!");
					break;
				
				case 13:
					trace("Enter key pressed!");
					break;
				
				case 90:
					trace("z key pressed!");
					break;
				
				case 88:
					trace("x key pressed!");
					break;
				
				case 67:
					trace("c key pressed!");
					break;
				
				case 86:
					trace("v key pressed!");
					break;
				
				case 65:
					trace("a key pressed!");
					break;
				
				case 83:
					trace("s key pressed!");
					break;
				
				case 68:
					trace("d key pressed!");
					break;
				
				case 38:
					trace("up arrow key pressed!");
					break;
				
				case 40:
					trace("down arrow key pressed!");
					break;
				
				case 81:
					trace("q key pressed!");
					break;
				
				case 87:
					trace("w key pressed!");
					break;
				
				case 69:
					trace("e key pressed!");
					break;
				
				case 82:
					trace("r key pressed!");
					break;
				
				
			}
			
		}
		
		protected static function onNextHandBtnClick(event:MouseEvent):void
		{
			
			//moveCardsToDiscardTray
			_decorator.moveMyCardsToDiscardTray();
			_decorator.moveDealerCardsToDiscardTray();
			
			_nextHandBtn.visible = false;
			_inGameModel.connection.send("NEW_HAND");
			
		}
		
		protected static function betSubmitBtnClick(event:MouseEvent):void
		{
			_inGameModel.connection.send("NEXT_BET_SUBMIT");
			trace("clicked next bet submit button");
		}
		
		protected static function betAmountChangeClick(event:MouseEvent):void
		{
			trace("pressed: " + event.currentTarget.name);
			switch(event.currentTarget.name)
			{
				case "incrementBetBtn":
					if (_inGameModel.myPotentialNextBet <= 100) {
					_inGameModel.myPotentialNextBet += 5;
					_inGameModel.connection.send("POT_BET_CHANGE", "up", 5);
					
					trace("sent bet change, POT_BET_CHANGE");
					}
					break;
				case "decrementBetBtn":
					if (_inGameModel.myPotentialNextBet >= 5) {
					_inGameModel.myPotentialNextBet -= 5;
					_inGameModel.connection.send("POT_BET_CHANGE", "down", 5);
						
					trace("sent bet change, POT_BET_CHANGE");
					}
					break;
				case "fiveChipBtn":
					if (_inGameModel.myPotentialNextBet <= 100) {
						_inGameModel.myPotentialNextBet += 5;
						_inGameModel.connection.send("POT_BET_CHANGE", "up", 5);
					}
					break;
				case "tenChipBtn":
					if (_inGameModel.myPotentialNextBet <= 100) {
						_inGameModel.myPotentialNextBet += 10;
						_inGameModel.connection.send("POT_BET_CHANGE", "up", 10);
					}
					break;
				case "twentyFiveChipBtn":
					if (_inGameModel.myPotentialNextBet <= 100) {
						_inGameModel.myPotentialNextBet += 25;
						_inGameModel.connection.send("POT_BET_CHANGE", "up", 25);
					}
					break;
				case "fiftyChipBtn":
					if (_inGameModel.myPotentialNextBet <= 100) {
						_inGameModel.myPotentialNextBet += 50;
						_inGameModel.connection.send("POT_BET_CHANGE", "up", 50);
					}
					break;
			}
			
			_decorator.updatePotentialNextBetTF();
			
			
		}
		
		protected static function onSfxBtnClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected static function onMusicBtnClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected static function onQuitBtnClick(event:MouseEvent):void
		{
			trace("quit btn clicked");
			quitPopup = QuitPopup.getInstance();
			
		}
		
		protected static function onDecisionBtnClick(event:MouseEvent):void
		{
			switch(event.currentTarget.name)
			{
				case "hitBtn":
					_inGameModel.connection.send("PLAYER_HITS");
					trace("sending PLAYER_HITS");
					break;
				case "standBtn":
					_inGameModel.connection.send("PLAYER_STANDS");
					trace("sending PLAYER_STANDS");
					break;
				case "doubleBtn":
					_inGameModel.connection.send("PLAYER_DOUBLES");
					trace("sending PLAYER_DOUBLES");
					break;
				case "splitBtn":
					_inGameModel.connection.send("PLAYER_SPLITS");
					
					trace("sending PLAYER_SPLITS");
					break;
				case "surrenderBtn":
					_inGameModel.connection.send("PLAYER_SURRENDERS");
					trace("sending PLAYER_SURRENDERS");
					break;
				
			}
			
		}
		
		protected static function onStartBtnClick(event:MouseEvent):void
		{
			_inGameModel.connection.send("PLAYER_WANTS_TO_START");
			_startBtn.visible = false;
			
		}		
		
		public function twoPlayersJoined():void
		{
		_startBtn.visible = true;
			
		}
		
		public function waitForUserToGoToNextHand():void
		{
			_hitBtn.visible = false;
			_standBtn.visible = false;
			_doubleBtn.visible = false;
			_splitBtn.visible = false;
			_surrenderBtn.visible = false;
				
			_nextHandBtn.visible = true;
		}
		
		public function showButtons():void
		{
			_hitBtn.visible = true;
			_standBtn.visible = true;
			_doubleBtn.visible = true;
		}
		
		public function showNextHandBtn():void
		{
			_nextHandBtn.visible = true;
			
			_hitBtn.visible = false;
			_standBtn.visible = false;
			_doubleBtn.visible = false;
			_splitBtn.visible = false;
			_surrenderBtn.visible = false;
			
		}
	}	
}