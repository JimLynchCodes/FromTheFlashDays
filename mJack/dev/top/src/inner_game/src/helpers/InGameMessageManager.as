package inner_game.src.helpers
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import inner_game.src.controllers.ButtonController;
	import inner_game.src.model.InnerGameModel;
	
	import playerio.Connection;
	import playerio.Message;
	
	public class InGameMessageManager
	{
		
		private static var instance:InGameMessageManager;
		private static var allowInstantiation:Boolean;
		private var _inGameModel:InnerGameModel;
		private static var _connection:Connection;
		private var _btnController:ButtonController;
		private var _decorator:InGameDecorator;
		private var _readySetGoMc:MovieClip;
		private var _myCard1Mc:Cards;
		private var _myCard2Mc:Cards;
		private const HAND1_INITIAL_Y:Number = 323.3;
		
		
		private var _dealerCard1Mc:Cards;
		private var _dealerCard2Mc:Cards;
		
		
		public function InGameMessageManager()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
			
		}
		
		public static function getInstance(connection: Connection):InGameMessageManager {
			if (instance == null) {
				allowInstantiation = true;
				_connection = connection;
				instance = new InGameMessageManager();
				
				allowInstantiation = false;
				trace("in pre game model");
			}
			return instance;
		}
		
		private function init():void
		{
			assignVars();
			addListeners();
		}
		
		private function addListeners():void
		{
			_connection.addMessageHandler("BOTH_PLAYERS_JOINED", onMessageReceived);
			_connection.addMessageHandler("OPPONENT_READY", onMessageReceived);
			
			_connection.addMessageHandler("BOTH_PLAYERS_READY", onMessageReceived);
			_connection.addMessageHandler("NEW_HAND", onMessageReceived);
			_connection.addMessageHandler("DEALER_BREAK", onMessageReceived);
			_connection.addMessageHandler("SHOWDOWN", onMessageReceived);
			_connection.addMessageHandler("TIMER_TICK", onMessageReceived);
			_connection.addMessageHandler("TIMER_UP", onMessageReceived);
			_connection.addMessageHandler("I_BUSTED", onMessageReceived);
			
			_connection.addMessageHandler("NEW_HIT_CARD", onMessageReceived);
			_connection.addMessageHandler("OP_NEW_HIT_CARD", onMessageReceived);
			
			_connection.addMessageHandler("NEW_DOUBLE_CARD", onMessageReceived);
			_connection.addMessageHandler("OP_NEW_DOUBLE_CARD", onMessageReceived);
			
			_connection.addMessageHandler("MY_NEXT_BET_SUBMITTED", onMessageReceived);
			_connection.addMessageHandler("OP_NEXT_BET_SUBMITTED", onMessageReceived);
			
			
			_connection.addMessageHandler("DEALER_PULLS_ANOTHER_CARD", onMessageReceived);
			_connection.addMessageHandler("OP_DEALER_PULLS_ANOTHER_CARD", onMessageReceived);
			_connection.addMessageHandler("DEALER_PULLS_LAST_CARD", onMessageReceived);
			_connection.addMessageHandler("OP_DEALER_PULLS_LAST_CARD", onMessageReceived);

			_connection.addMessageHandler("REVEAL_DEALER_DOWN_CARD", onMessageReceived);
			
			_connection.addMessageHandler("USER_JOINED", onMessageReceived);
			_connection.addMessageHandler("TWO_PLAYERS_JOINED", onMessageReceived);
			_connection.addMessageHandler("PLAYER_WANTS_TO_START", onMessageReceived);
			_connection.addMessageHandler("BOTH_WANT_TO_START", onMessageReceived);
			
			_readySetGoMc.addEventListener("READY_SET_GO_ANIM_OVER", onReadySetGoAnimDone);
			
		}
		
		protected function onReadySetGoAnimDone(event:Event):void
		{
			trace("ready set go animation finished");
			_connection.send("NEW_HAND");
			_connection.send("START_TIMER");
		}
		
		private function onMessageReceived(m:Message):void
		{
			
//			trace("message received: " + m.type);
			switch(m.type)
			{
				case "BOTH_PLAYERS_JOINED":
//					_inGameDecorator.show(m.type);
					break;
				
				case "OPPONENT_READY":
					
					break;
				
				case "BOTH_PLAYERS_READY":
					
					break;
				
				case "DEALER_BREAK":
					
					break;
				
				case "SHOWDOWN":
					var outcome:String = m.getString(0);
					var amountWon:int = m.getInt(1);
					var currentBet:int = m.getInt(2);
					var currentChipstack:int = m.getInt(3);
					var dealerBust:Boolean = m.getBoolean(4);
					
					trace("showdown with dealer: ", outcome,amountWon ,currentBet ,currentChipstack );
					
					_inGameModel.myChipstackBet = currentChipstack;
					_btnController.showNextHandBtn();
										
					switch(outcome) 
					{
						case "LOSE":
							trace("Stand came back, displaying LOSE effects");
							_decorator.displayLosingHandEffects(false);
							break;
						case "PUSH":
							trace("Stand came back, displaying PUSH effects");
							_decorator.displayPushEffects();
							break;
						case "WIN":
							trace("Stand came back, displaying WIN effects");
							_decorator.displayWinEffects(amountWon, currentBet);
							break;
											
						
					}
					
					
					break;
				
				case "TIMER_TICK":
					var newTime:int = m.getInt(0);
					_decorator.displayTime(newTime);
					break;
				
				case "TIMER_UP":
					trace("timer up!");
					break;
				
				case "MY_POTENTIAL_BET_UPDATE":
					var potBet:int = m.getInt(0);
					trace("my potential bet update " + potBet);
					_decorator.updateOpPotentialtBet(potBet);
					break;
				
				case "OP_POTENTIAL_BET_UPDATE":
					var potBet:int = m.getInt(0);
					_decorator.updatePotentialtBet(potBet);
					break;
				
				case "OP_NEXT_BET_SUBMITTED":
					var nextBet:int = m.getInt(0);
					_decorator.updateOpNextBet(nextBet);
					break;
				
				case "MY_NEXT_BET_SUBMITTED":
					var nextBet:int = m.getInt(0);
					_decorator.updateMyNextBet(nextBet);
					trace("got new submitted bet: " + nextBet);
					break;
				
				case "TWO_PLAYERS_JOINED":
					_btnController.twoPlayersJoined();
					break;
				
				case "USER_JOINED":
					var nameOfJoiner:String = m.getString(0);
					_decorator.userJoined(nameOfJoiner);
					break;
				
				case "PLAYER_WANTS_TO_START":
					
					_decorator.opponentWantsToStart();
					break;
				
				case "BOTH_WANT_TO_START":
					_decorator.bothWantToStart();
					break;
				
				case "NEW_HAND":
					trace("I just got a new hand! " + m.getString(0), m.getString(1), m.getString(2));
					trace("rest of hand: " + m.getInt(3), m.getInt(4), m.getInt(5));
					
					
					_btnController.showButtons();
					// get card values from message object
					var myCard1:String = m.getString(0);
					var dealerCard1:String =  m.getString(1);
					var myCard2:String = m.getString(2);
					
					// get my hand value and dealer hand and my current bet value from message object
					var myHandValue:int = m.getInt(3);
					var myCurrentBet:int = m.getInt(4);
					var myCurrentChipStack:int = m.getInt(5);
					//var myDealerHandValue:int = m.getInt(5);
					
					trace("placing new bet with bet: " + myCurrentBet+ " and stack " + myCurrentChipStack);
					
					// create card MovieClips and display on the screen
					// player
					_myCard1Mc = new Cards();
					_myCard2Mc = new Cards();
					_myCard1Mc.gotoAndPlay(myCard1);
					_myCard2Mc.gotoAndPlay(myCard2);
					
					
					// my cards
					_inGameModel.myHandStrings.push(myCard1);
					_inGameModel.myHandStrings.push(myCard2);
					_inGameModel.myHandMcs.push(_myCard1Mc);
					_inGameModel.myHandMcs.push(_myCard2Mc);
					_inGameModel.inGameScreen["cardBoard"].addChild(_myCard1Mc);
					_inGameModel.inGameScreen["cardBoard"].addChild(_myCard2Mc);
										
					_inGameModel.myHandValue = myHandValue;
				//	_inGameModel.myDealerHandValue = myDealerHandValue;
					_inGameModel.myCurrentBet = myCurrentBet;
					_inGameModel.myChipstackBet = myCurrentChipStack;
					
					trace("decorating that shit");
					// _decorator.updateMyCurrentBetDisplay();
					_decorator.makeMyCurrentBetReadyForNewHand(myCurrentBet);
					
					
					// dealer cards
					_dealerCard1Mc = new Cards();
					_dealerCard2Mc = new Cards();
					_dealerCard1Mc.gotoAndPlay("back");
					_dealerCard2Mc.gotoAndPlay(dealerCard1);
					_inGameModel.dealerHandMcs.push(_dealerCard1Mc);
					_inGameModel.dealerHandMcs.push(_dealerCard2Mc);
					_inGameModel.dealerHandStrings.push(dealerCard1);
//					_inGameModel.dealerHandStrings.push(dealerCard2);
					_inGameModel.inGameScreen["cardBoard"].addChild(_dealerCard1Mc);
					_inGameModel.inGameScreen["cardBoard"].addChild(_dealerCard2Mc);
					_dealerCard1Mc.x = 250;
					_dealerCard1Mc.y = 100;
					_dealerCard2Mc.x = 250 + _inGameModel.HORIZONTAL_SPACER;
					_dealerCard2Mc.y = 100 + _inGameModel.VERTICAL_CARD_SPACER;
					
					
					
					_decorator.updateMyHandDisplay();
					_decorator.placeNewBet();
				//	_decorator.updateMyDealerDisplay();
					
					updateCardPositions();	
					updateDealerCardPositions();
					
					break;
				
				case "NEW_HIT_CARD":
					trace("Got new_ hit card: " +  m.getString(0), "My new hand value: " + myNewHandValue);
					
					// get card values from message object
					var myHitCard:String = m.getString(0);
					var myNewHandValue:int = m.getInt(1);
									
					// create card MovieClips andd add to the screen
					var myHitCardMc:Cards = new Cards();
					
					_inGameModel.myHandMcs.push(myHitCardMc);
					_inGameModel.myHandStrings.push(myHitCard);
					
					trace("dealing card: " + myHitCard);
					myHitCardMc.gotoAndStop(myHitCard);
					_inGameModel.inGameScreen["cardBoard"].addChild(myHitCardMc);
					
					
					myHitCardMc.x = _inGameModel.HAND1_INITIAL_X + _inGameModel.HORIZONTAL_CARD_SPACER * (_inGameModel.myHandMcs.length -1);
					myHitCardMc.y = _inGameModel.HAND1_INITIAL_Y - _inGameModel.VERTICAL_CARD_SPACER * (_inGameModel.myHandMcs.length - 1);
					
					trace("placing new card at: ( " + myHitCardMc.x + ", " + myHitCardMc.y + " for mcArray length: " + _inGameModel.myHandMcs.length);
					// add to model arrays
					trace("just added hit card " + _inGameModel.myHandMcs.length, _inGameModel.myHandStrings.length);
//					updateCardPositions();	
//					_inGameModel.myHandValue = myNewHandValue;
//					
//					_decorator.updateMyHandDisplay();
//					trace("got new hit card");
//					
					break;
				
				case "OP_NEW_HIT_CARD":	
					trace("opponent just drew a card");
					break;
				
				case "I_BUSTED":	
					var newCard:String = m.getString(0);
					var whichHand:int = m.getInt(1);
					var handValue:int = m.getInt(2);
					var dealerDownCard:String = m.getString(3);
					var currentBet:int = m.getInt(4);
					var chipstack:int = m.getInt(5);
					
					_inGameModel.dealerHandStrings.push(dealerDownCard);
					
					trace("uh oh! I_BUSTED, displaying card: " + newCard);
					
				//	var myBustCardMc:Cards = new Cards();
				//	myBustCardMc.gotoAndPlay(newCard);
				//	_inGameModel.inGameScreen["cardBoard"].addChild(myBustCardMc);
					//myBustCardMc.x = _inGameModel.HAND1_INITIAL_X + _inGameModel.HORIZONTAL_CARD_SPACER * (_inGameModel.myHandMcs.length);
				//	myBustCardMc.y = _inGameModel.HAND1_INITIAL_Y - _inGameModel.VERTICAL_CARD_SPACER * (_inGameModel.myHandMcs.length);
					
					// add to model arrays
				//	_inGameModel.myHandMcs.push(myBustCardMc);
				//	_inGameModel.myHandStrings.push(newCard);
					
					_decorator.displayBustEffects(dealerDownCard);
					_decorator.currentBetToDealer();
					
					_btnController.waitForUserToGoToNextHand();
					
				//	_decorator.displayMeBusting(newCard, whichHand, handValue, dealerDownCard,currentBet,chipstack);
									
					break;
				
				case "OP_BUSTED":
					var opDealerDownCard:String = m.getString(0);
					var opCurrentBet:int = m.getInt(1);
					var opChipstack:int = m.getInt(2);
					
					break;
			
				case "DEALER_PULLS_ANOTHER_CARD":
					var newDealerCard:String = m.getString(0);
					trace("dealer got a new card!: " + newDealerCard);
					
					_inGameModel.dealerHandStrings.push(newDealerCard);

					var rawCardMc:Cards = _decorator.createNewDealerCard();
					_inGameModel.dealerHandMcs.push(rawCardMc);
					_inGameModel.inGameScreen["cardBoard"].addChild(rawCardMc);
					rawCardMc.x = _inGameModel.DEALER_CARD_X + 20 * _inGameModel.dealerHandMcs.length;
					rawCardMc.y = _inGameModel.DEALER_CARD_Y + 15 * _inGameModel.dealerHandMcs.length;
					rawCardMc.gotoAndPlay(newDealerCard);
					
					break;
				
				case "OP_DEALER_PULLS_ANOTHER_CARD":
					
					trace("op dealer got a new card!: ");
					break;
				
				case "DEALER_PULLS_LAST_CARD":
					
					var lastDealerCard:String = m.getString(0);
					var dealerBusted:Boolean = m.getBoolean(1);
					var amountWon:int = m.getInt(2);
					var newCurrentBet:int = m.getInt(3);
					var newChipstack:int = m.getInt(4);

					var rawLastCardMc:Cards = _decorator.createNewDealerCard();
					_inGameModel.dealerHandMcs.push(rawLastCardMc);
					_inGameModel.inGameScreen["cardBoard"].addChild(rawLastCardMc);
					rawLastCardMc.x = _inGameModel.DEALER_CARD_X + 20 * _inGameModel.dealerHandMcs.length;
					rawLastCardMc.y = _inGameModel.DEALER_CARD_Y + 15 * _inGameModel.dealerHandMcs.length;
					rawLastCardMc.gotoAndPlay(lastDealerCard);
					
					trace("dealer got a LAST card!: " + lastDealerCard,dealerBusted ,amountWon,
						newCurrentBet ,newChipstack );
					
					if (amountWon == 0 && newCurrentBet == 0)
					{
						// I lost the hand.
						_decorator.displayLosingHandEffects(false);
						
					}
					
					_btnController.showNextHandBtn();
					
				break;			
				case "OP_DEALER_PULLS_LAST_CARD":
					trace("op dealer got last card!: ");
					break;
				
				case "NEW_DOUBLE_CARD":
					var newDubCard:String = m.getString(0);
					var dubHandValue:int = m.getInt(1);
					var betAfterDub:int = m.getInt(2);
					var chipstackAfterDub:int = m.getInt(3);
					
					trace("Got a new double card: " + newDubCard + " hand value: " + dubHandValue + " new current bet: " + betAfterDub + " new chipstack: " + chipstackAfterDub);
					_inGameModel.myCurrentBet = betAfterDub;
					_inGameModel.myChipstackBet = chipstackAfterDub;
					
					if (dubHandValue <= 21) {
						_connection.send("PLAYER_STANDS");
					}
					else
					{
						// TODO should be busting now
						trace("PLAYER BUSTED ON DOUBLE DOWN");

					}
					
					// display movieclip of new card
					var myHitCard:String = m.getString(0);
					var myNewHandValue:int = m.getInt(1);
					
					// create card MovieClips andd add to the screen
					var myHitCardMc:Cards = new Cards();
					
					_inGameModel.myHandMcs.push(myHitCardMc);
					_inGameModel.myHandStrings.push(myHitCard);
					
					trace("dealing card: " + myHitCard);
					myHitCardMc.gotoAndStop(myHitCard);
					_inGameModel.inGameScreen["cardBoard"].addChild(myHitCardMc);
					
					
					_decorator.updateMyCurrentBetDisplay();
					myHitCardMc.x = _inGameModel.HAND1_INITIAL_X + _inGameModel.HORIZONTAL_CARD_SPACER * (_inGameModel.myHandMcs.length -1);
					myHitCardMc.y = _inGameModel.HAND1_INITIAL_Y - _inGameModel.VERTICAL_CARD_SPACER * (_inGameModel.myHandMcs.length - 1);
					TweenLite.to(myHitCardMc, 1, {x:_inGameModel.HAND1_INITIAL_X, y:_inGameModel.HAND1_INITIAL_Y, rotation:90});
					
					trace("placing new card at: ( " + myHitCardMc.x + ", " + myHitCardMc.y + " for mcArray length: " + _inGameModel.myHandMcs.length);
					// add to model arrays
					trace("just added hit card " + _inGameModel.myHandMcs.length, _inGameModel.myHandStrings.length);
					//					updateCardPositions();	
					
					trace("new double card!: " + newDubCard);
					break;
				
				case "REVEAL_DEALER_DOWN_CARD":
					var dealersDownCard:String = m.getString(0);
					trace("revealing dealer down card: " + dealersDownCard);
	
					_inGameModel.dealerHandStrings.push(dealersDownCard);
					_decorator.revealDealerDownCard(dealersDownCard);
					break;
				
				
			}
			
		}
		
		private function updateDealerCardPositions():void
		{
			for (var h:int = 0; h < _inGameModel.dealerHandMcs.length; h++)
			{
				_inGameModel.myHandMcs[h].x = _inGameModel.CARD_ORIGIN_X;
				_inGameModel.myHandMcs[h].y = _inGameModel.CARD_ORIGIN_Y;
				
				var xVal:int = _inGameModel.DEALER_CARD_X + (h) * _inGameModel.HORIZONTAL_CARD_SPACER;
				var yVal = _inGameModel.DEALER_CARD_Y +  (h) * _inGameModel.VERTICAL_CARD_SPACER;
				var moveCardParams:Array = [_inGameModel.dealerHandMcs[h], xVal, yVal];
				TweenLite.delayedCall(2*h + 1, moveCardFromShoe, moveCardParams);
				//	_inGameModel.myHandMcs[h].x = _inGameModel.HAND1_INITIAL_X + (h) * _inGameModel.HORIZONTAL_CARD_SPACER;
				//	_inGameModel.myHandMcs[h].y = _inGameModel.HAND1_INITIAL_Y -  (h) * _inGameModel.VERTICAL_CARD_SPACER;
				trace("updating card at position: " + h, _inGameModel.myHandMcs[h], _inGameModel.myHandStrings[h],  _inGameModel.myHandMcs.length, _inGameModel.myHandStrings.length);
				
				//				_inGameModel.myHandMcs[h].gotoAndPlay(_inGameModel.myHandStrings[h]);
			}
		}
		
		private function updateCardPositions():void
		{
			for (var h:int = 0; h < _inGameModel.myHandMcs.length; h++)
			{
				_inGameModel.myHandMcs[h].x = _inGameModel.CARD_ORIGIN_X;
				_inGameModel.myHandMcs[h].y = _inGameModel.CARD_ORIGIN_Y;
				
				var xVal:int = _inGameModel.HAND1_INITIAL_X + (h) * _inGameModel.HORIZONTAL_CARD_SPACER;
				var yVal = _inGameModel.HAND1_INITIAL_Y -  (h) * _inGameModel.VERTICAL_CARD_SPACER;
				var moveCardParams:Array = [_inGameModel.myHandMcs[h], xVal, yVal];
				TweenLite.delayedCall(2*h, moveCardFromShoe, moveCardParams);
			//	_inGameModel.myHandMcs[h].x = _inGameModel.HAND1_INITIAL_X + (h) * _inGameModel.HORIZONTAL_CARD_SPACER;
			//	_inGameModel.myHandMcs[h].y = _inGameModel.HAND1_INITIAL_Y -  (h) * _inGameModel.VERTICAL_CARD_SPACER;
				trace("updating card at position: " + h, _inGameModel.myHandMcs[h], _inGameModel.myHandStrings[h],  _inGameModel.myHandMcs.length, _inGameModel.myHandStrings.length);
				
//				_inGameModel.myHandMcs[h].gotoAndPlay(_inGameModel.myHandStrings[h]);
			}
		}
		
		private function moveCardFromShoe(cardMc:MovieClip, xPos:int, yPos:int):void {
			TweenLite.to(cardMc, 1, {x:xPos, y:yPos});
		}
		
		private function assignVars():void
		{
			_inGameModel = InnerGameModel.getInstance();
			_btnController = ButtonController.getInstance();
			_decorator = InGameDecorator.getInstance(_connection);
			_readySetGoMc = _inGameModel.inGameScreen["readySetGoMc"];
		}		
		
	}
}

