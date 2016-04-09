package inner_game.src.model
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import playerio.Connection;

	public class InnerGameModel
	{
		
		private static var instance:InnerGameModel;
		private static var allowInstantiation:Boolean;


//		private var _imReady:Boolean = false;
//		private var _opponentIsReady:Boolean = false;
//		private var _myClassChosen:String = "none";
//		private var _opponentPowerups:Array = [];
//		private var _iWantToStart:Boolean = false;
//		private var _opponentWantsToStart:Boolean = false;
//		private var _innerGameMainClass:InnerGameModel;
//		
		private var _stage:Object;
		private var _myName:String;
		private var _opponentName:String;
		private var _myPass:String;
		private var _inGameScreen:Sprite;
		private var _connection:Connection;

		private var _myPotentialNextBet:int = 5;
		private var _myNextBet:int;
		private var _myCurrentBet:int;
		private var _myChipstackBet:int;
		private var _myHandValue:int;
		private var _myDealerHandValue:int;
		
		private var _opPotentialNextBet:int;
		private var _opNextBet:int;
		private var _opCurrentBet:int;
		private var _opChipstackBet:int;
		private var _opHandValue:int;
		private var _opDealerHandValue:int;
		private var _handPosAry:Array = [new Point(303,323)];
		public var myHandStrings:Array = [];
		public var myHandMcs:Array = [];
		public var cardMcsToBeCleanedUp:Array = [];
		
		public var dealerHandStrings:Array = [];
		public var dealerHandMcs:Array = [];
		public var HAND1_INITIAL_Y:Number = 303;
		public var HAND1_INITIAL_X:Number = 314;
		public var VERTICAL_CARD_SPACER:Number = 15;
		public var HORIZONTAL_CARD_SPACER:Number = 20;
		public var HORIZONTAL_SPACER:int = 20;
		public var MY_EXPLOSION_X:Number = 1080;
		public var MY_EXPLOSION_Y:Number = 979;
		public var DEALER_EXPLOSION_X:Number = 1033.25;
		public var DEALER_EXPLOSION_Y:Number = 713.1;
		public var CURRENT_BET_CHIP_X_1:Number = 321;
		public var CURRENT_BET_CHIP_Y_1:Number = 429;
		public var DEALER_CARD_X:int = 191;
		public var DEALER_CARD_Y:int = 119;
		public var CARD_ORIGIN_X:int = 365;
		public var CARD_ORIGIN_Y:int = 135;
		
		public function InnerGameModel()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
			
		}
		
		public function get stage():Object
		{
			return _stage;
		}

		public function set stage(value:Object):void
		{
			_stage = value;
		}

		public function get myNextBet():int
		{
			return _myNextBet;
		}

		public function set myNextBet(value:int):void
		{
			_myNextBet = value;
		}

		public function get handPosAry():Array
		{
			return _handPosAry;
		}

		public function set handPosAry(value:Array):void
		{
			_handPosAry = value;
		}

		public function get myPotentialNextBet():int
		{
			return _myPotentialNextBet;
		}

		public function set myPotentialNextBet(value:int):void
		{
			_myPotentialNextBet = value;
		}

		public function get myCurrentBet():int
		{
			return _myCurrentBet;
		}

		public function set myCurrentBet(value:int):void
		{
			_myCurrentBet = value;
		}

		public function get myChipstackBet():int
		{
			return _myChipstackBet;
		}

		public function set myChipstackBet(value:int):void
		{
			_myChipstackBet = value;
		}

		public function get myHandValue():int
		{
			return _myHandValue;
		}

		public function set myHandValue(value:int):void
		{
			_myHandValue = value;
		}

		public function get myDealerHandValue():int
		{
			return _myDealerHandValue;
		}

		public function set myDealerHandValue(value:int):void
		{
			_myDealerHandValue = value;
		}

		public function get opPotentialNextBet():int
		{
			return _opPotentialNextBet;
		}

		public function set opPotentialNextBet(value:int):void
		{
			_opPotentialNextBet = value;
		}

		public function get opNextBet():int
		{
			return _opNextBet;
		}

		public function set opNextBet(value:int):void
		{
			_opNextBet = value;
		}

		public function get opCurrentBet():int
		{
			return _opCurrentBet;
		}

		public function set opCurrentBet(value:int):void
		{
			_opCurrentBet = value;
		}

		public function get opChipstackBet():int
		{
			return _opChipstackBet;
		}

		public function set opChipstackBet(value:int):void
		{
			_opChipstackBet = value;
		}

		public function get opHandValue():int
		{
			return _opHandValue;
		}

		public function set opHandValue(value:int):void
		{
			_opHandValue = value;
		}

		public function get opDealerHandValue():int
		{
			return _opDealerHandValue;
		}

		public function set opDealerHandValue(value:int):void
		{
			_opDealerHandValue = value;
		}

		public function get connection():Connection
		{
			return _connection;
		}

		public function set connection(value:Connection):void
		{
			_connection = value;
		}

		public function get inGameScreen():Sprite
		{
			return _inGameScreen;
		}

		public function set inGameScreen(value:Sprite):void
		{
			_inGameScreen = value;
		}

		public function get myPass():String
		{
			return _myPass;
		}

		public function set myPass(value:String):void
		{
			_myPass = value;
		}

		public function get opponentName():String
		{
			return _opponentName;
		}

		public function set opponentName(value:String):void
		{
			_opponentName = value;
		}

		public function get myName():String
		{
			return _myName;
		}

		public function set myName(value:String):void
		{
			_myName = value;
		}

		public static function getInstance():InnerGameModel {
			if (instance == null) {
				allowInstantiation = true;
				
				instance = new InnerGameModel();
				
				allowInstantiation = false;
				trace("in pre game model");
			}
			return instance;
		}
		
		private function init():void
		{
			// TODO Auto Generated method stub
			
		}
//		
//		public function get innerGameMainClass():InnerGameModel
//		{
//			return _innerGameMainClass;
//		}
//


	}
}