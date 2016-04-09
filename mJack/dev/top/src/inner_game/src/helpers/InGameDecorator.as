	package inner_game.src.helpers
	{
		import com.greensock.TweenLite;
		
		import flash.display.MovieClip;
		import flash.display.Sprite;
		import flash.text.TextField;
		
		import inner_game.src.model.InnerGameModel;
		
		import playerio.Connection;
		
		public class InGameDecorator
		{
			
			private static var instance:InGameDecorator;
			private static var allowInstantiation:Boolean;
		//	private var _model:InnerGameModel;
			private static var _connection:Connection;
			private static var _model:InnerGameModel;
			private static var _inGameScreen:Sprite;
			private static var _myUsernameTF:TextField;
			private static var _myTitleTF:TextField;
			private static var _myLvlTF:TextField;
			private static var _myRankTF:TextField;
			private static var _timeCountTF:TextField;
			private static var _timeBar:Sprite;
			private static var _timeMc:Sprite;
			private static var _opRankTF:TextField;
			private static var _opLvlTF:TextField;
			private static var _opTitleTF:TextField;
			private static var _opUsernameTF:TextField;
			private static var _playerWantsToStartMc:Sprite;
			private static var _readySetGoMc:MovieClip;
			private static var _myPotentialNextBetTF:TextField;
			private static var _opPotentialNextBetTF:TextField;
			private static var _myNextBetTF:TextField;
			private static var _opNextBetTF:TextField;
			private static var _initialTimeBarWidth:Number;
			private static var _myCurrentBetTF:TextField;
			private static var _myChipStackTF:TextField;
			private static var _myCurrentBetMc:MovieClip;
			private static var _myNewCardMc:MovieClip;
			private static var _explosionMC:MovieClip;
			private static var _myWinningsMc:MovieClip;
			private static var _nextHandBtn:Sprite;
			private static var _opponentReadyToStartMc:MovieClip;
			
			
			public function InGameDecorator()
			{
				if (!allowInstantiation) {
					throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
				} else {
					//init();
				}
				
			}
			
			public static function getInstance(connection: Connection):InGameDecorator {
				if (instance == null) {
					allowInstantiation = true;
					_connection = connection;
					instance = new InGameDecorator();
					init();
					allowInstantiation = false;
					trace("in pre game model");
				}
				return instance;
			}
			
			private static function init():void
			{
				assignVars();
				addListeners();
			}
			
			private static function addListeners():void
			{
				
			}
			

			
			private static function assignVars():void
			{
				_model = InnerGameModel.getInstance();
//				_inGameScreen = _model.inGame
				_inGameScreen = _model.inGameScreen;
				
				
				_myUsernameTF = _model.inGameScreen["myTitleTF"];
				_myTitleTF = _model.inGameScreen["myUsernameTF"];
				_myLvlTF = _model.inGameScreen["myLvlTF"];
				_myRankTF = _model.inGameScreen["myRankTF"];
				_myWinningsMc = _model.inGameScreen["myWinningsMc"];
				_myWinningsMc.alpha = 0;
				
				_explosionMC = _model.inGameScreen["explosionMC"];
				
				_opUsernameTF = _model.inGameScreen["opUsernameTF"];
				_opTitleTF = _model.inGameScreen["opTitleTF"];
				_opLvlTF = _model.inGameScreen["opLvlTF"];
				_opRankTF = _model.inGameScreen["opRankTF"];
				
				_timeMc = _model.inGameScreen["timeMc"];
				_timeBar = _model.inGameScreen["timeMc"]["timeBar"];
				_initialTimeBarWidth = _timeBar.width;
				_timeCountTF = _model.inGameScreen["timeMc"]["timeCountTF"];
				_playerWantsToStartMc = _model.inGameScreen["opponentReadyToStartMc"];
				_playerWantsToStartMc.visible = false;	
				_readySetGoMc = _model.inGameScreen["readySetGoMc"];
				
				_myNextBetTF =  _model.inGameScreen["nextBetPanel"]["nextBetTF"];
				_myPotentialNextBetTF =  _model.inGameScreen["nextBetPanel"]["potentialNextBetTF"];
				_opNextBetTF =  _model.inGameScreen["opNextBetPanel"]["nextBetTF"];
				_opPotentialNextBetTF =  _model.inGameScreen["opNextBetPanel"]["potentialNextBetTF"];
			
				_myCurrentBetTF = _model.inGameScreen["myCurrentBetTF"];
				_myChipStackTF = _model.inGameScreen["myChipStackTF"];
				
				_myCurrentBetMc = _model.inGameScreen["myCurrentBetMc"];
			//	_nextHandBtn = _model.inGameScreen["nextHandBtn"];
				_nextHandBtn = _model.inGameScreen["nextHandBtn"];
				_opponentReadyToStartMc = _model.inGameScreen["opponentReadyToStartMc"];
				_opponentReadyToStartMc.visible = false;
				
				_nextHandBtn.buttonMode = true;
				_nextHandBtn.visible = false;
			
			}		 
			
			public function userJoined(nameOfJoiner:String):void
			{
				_opUsernameTF.text = "" + nameOfJoiner;
				
			}
			
			public function opponentWantsToStart():void
			{
				_playerWantsToStartMc.visible = true;
				
			}
			
			public function bothWantToStart():void
			{
				_playerWantsToStartMc.visible = false;
				_readySetGoMc.gotoAndPlay("go");
				
			}
			
			public function updatePotentialNextBetTF():void
			{
				_myPotentialNextBetTF.text = "" + _model.myPotentialNextBet;
				
			}
			
			public function updateOpPotentialtBet(potBet:int):void
			{
				_myPotentialNextBetTF.text = "" + potBet;
			}
			
			public function updatePotentialtBet(potBet:int):void
			{
				_myPotentialNextBetTF.text = "" + potBet;
			}
			
			public function updateOpNextBet(nextBet:int):void
			{
				_myPotentialNextBetTF.text = "" + nextBet;
			}
			
			public function updateMyNextBet(nextBet:int):void
			{
				_myNextBetTF.text = "" + nextBet;
			}
			
			public function displayTime(newTime:int):void
			{
//				trace("new time: " + newTime);
				var minutes:int = Math.floor(newTime / 60);
				var seconds:int = newTime % 60;
				var secondsString:String;
				
				_timeBar.width = _initialTimeBarWidth * newTime / 120;
				
				switch(seconds)
				{
					case 0:
						secondsString = "00";
					case 1:
						secondsString = "01";
						break;
					case 2:
						secondsString = "02";
						break;
					case 3:
						secondsString = "03";
						break;
					case 4:
						secondsString = "04";
						break;
					case 5:
						secondsString = "05";
						break;
					case 6:
						secondsString = "06";
						break;
					case 7:
						secondsString = "07";
						break;
					case 8:
						secondsString = "08";
						break;
					case 9:
						secondsString = "09";
						break;
					default:
						secondsString = seconds.toString();
						break;
				}
				
				_timeCountTF.text = "" + minutes + ":" + secondsString;
				
			}
			
			public function updateMyHandDisplay():void
			{
				for (var i:int = 0; i < _model.myHandStrings.length; i++)
				{
					trace("trying to gotoAndPlay(" + _model.myHandStrings[i] + ")");
					_model.myHandMcs[i].gotoAndStop(_model.myHandStrings[i]);	
				}
			}
			
			public function updateMyDealerDisplay():void
			{
				// TODO Auto Generated method stub
				
			}
			
			public function updateMyCurrentBetDisplay():void
			{

				trace("displaying my new bet: " +  _model.myCurrentBet,  _model.myChipstackBet);
				
				_myCurrentBetTF.text = "" + _model.myCurrentBet;
				_myCurrentBetMc.gotoAndStop(_model.myCurrentBet.toString());
				
				_myChipStackTF.text = "" + _model.myChipstackBet;
				// _myChipstackMc.gotoAndPlay(_model.myChipstackMc.toString());
			}
			
			
			
		
//			public function displayMeBusting(newCard:String, whichHand:int, handValue:int,dealerDownCard:String,currentBet:int,chipstack:int):void
//			{
//				
//				_model.myHandStrings.push(newCard);
//				_model.myHandValue = handValue;
//				
//				// my cards
//				_myNewCardMc = new Cards();
//				_myNewCardMc.gotoAndPlay(newCard);
//				_model.inGameScreen.addChild(_myNewCardMc);
//				
//				
//				_model.dealerHandMcs[1].goToAndPlay(dealerDownCard);
//	
//				  
//				 
//				TweenLite.to(_myCurrentBetMc, 1, {y:(_myCurrentBetMc.y - 100), alpha:0});
			//	_myCurrentBetMc.y += 100;
			//	_myCurrentBetMc.gotoAndPlay(currentBet);
				
			//	updateCardPositions();					
				
			//	_model.myDealerHandValue = myDealerHandValue;
			//	_model.myCurrentBet = myCurrentBet;
				
//				trace("I am busting!");
//			}
//			
			
			
			public function displayBustEffects(dealerDownCard:String):void
			{
				// show bust explostion
				_explosionMC.visible = true;
				_explosionMC.x = _model.MY_EXPLOSION_X;
				_explosionMC.y = _model.MY_EXPLOSION_Y;
				_explosionMC.gotoAndPlay("explode");
				
				trace("Mc length  " + _model.myHandMcs.length, _model.myHandStrings.length);
				trace(_model.myHandMcs);
				
				trace("moving cards to discard tray");
				
				//TweenLite.delayedCall(2, moveCardsToDiscardTray);
				
				var newY:int = _myCurrentBetMc.y -100;
				TweenLite.to(_myCurrentBetMc, 1, {y:newY, alpha:0, onComplete:onCurrentChipsMovedToDealer});
				
				var paramArray:Array = [dealerDownCard];
				TweenLite.delayedCall(2, showDealerCard, paramArray);
				
				// move my cards to discard tray
//				for (var i:int = 0; i < _model.myHandStrings.length; i++)
//				{
//					TweenLite.to(_model.myHandMcs[i+1], 1, {x:83, y:164});
//					
//					//gotoAndPlay(_model.myHandStrings[i]);	
//				}
				
				
				// move my chips away from my spot
				
				// move show dealer down card, move dealer cards to tray
				
				
			}
			
			private function onCurrentChipsMovedToDealer():void
			{
				_myCurrentBetTF.text = "0";
			}
			
			private function moveCardsToDiscardTray():void
			{
				
				trace("moving card to discard tray @!@", _model.myHandStrings.length, _model.myHandMcs.length);
				for (var i:int = (_model.myHandMcs.length-1); i >= 0; i--)
				{
					var myCard:MovieClip = _model.myHandMcs[i];
					trace("tweening card " +  myCard, i + " of " + _model.myHandMcs.length);
					var param:Array = [myCard];
					TweenLite.to(myCard, 1, {x:83, y:164, onComplete:onCardAtDiscardTray, onCompleteParams:param});
					//gotoAndPlay(_model.myHandStrings[i]);	
					_model.myHandMcs.splice(i, 1);
					_model.myHandStrings.splice(i, 1);
				
				}
				
//				_model.myHandMcs = [ ];
//				_model.myHandStrings = [ ];
//				
			}
			
			private function onCardAtDiscardTray(card:MovieClip):void
			{
				
//				var indexOfCard:int = _model.myHandMcs.indexOf(card);
//				trace("index is " + indexOfCard);
			
				// contains
//				if (_model.inGameScreen["cardBoard"].contains(card)) {
//					_model.inGameScreen["cardBoard"].removeChild(card);
//					
//				}
				
				// child.parent.removeChil
				card.parent.removeChild(card);
				
				
//				_model.myHandMcs.splice(indexOfCard, 1);
//				_model.myHandStrings.splice(indexOfCard, 1);
				
//				if (_model.myHandMcs.length == 0) {
//					_model.myHandStrings = [ ];
//					
//				//	TweenLite.delayedCall(3, showDealerCard);
//				}
			}
			
			private function showDealerCard(card:String):void {
				trace("showDealerCard " + _model.dealerHandMcs.length);
				_model.dealerHandMcs[0].gotoAndPlay(card);
				
				TweenLite.to(_model.dealerHandMcs[0], 1, {x:129 , y:94, onComplete:onDealerCardRepositioned, onCompleteParams:[_model.dealerHandMcs[0]]});
				TweenLite.to(_model.dealerHandMcs[1], 1, {x:232 , y:94, onComplete:onDealerCardRepositioned, onCompleteParams:[_model.dealerHandMcs[1]]});
				
			}
			
//			private function onDealerHandsRepositionedAfterPause():void
//			{
//				trace("	onDealerHandsRepositionedAfterPause ");
//				for (var h:int = 0; h < _model.dealerHandMcs.length; h++) {
//					TweenLite.to(_model.dealerHandMcs[h], 2, {x:83, y:164, onComplete:onDealerCardMovedToDiscard});
//				}
//				
//				
//				trace("deleting MC's: " + _model.dealerHandMcs.length + " and string: " + _model.dealerHandStrings.length);
//				for (var i:int = 0; i < _model.dealerHandMcs.length; i++) {
//					
//					var indexOfMc:int = _model.dealerHandMcs.indexOf(_model.dealerHandMcs[i]);
//					trace("index of Mc being removed: " + indexOfMc);
//					_model.inGameScreen["cardBoard"].removeChild(_model.dealerHandMcs[i]);
//					_model.myHandMcs.splice(indexOfMc, 1);
//					
//				}
//					
//					
//			}
			
			private function onDealerCardMovedToDiscard(card:MovieClip):void {
			//	trace("deleting MC's: " + _model.dealerHandMcs.length + " and string: " + _model.dealerHandStrings.length);
//					var indexOfMc:int = _model.cardMcsToBeCleanedUp.indexOf(card);
//					trace("index of shit " + _model.cardMcsToBeCleanedUp.indexOf("shit"));
//					trace("index of Mc being removed: " + indexOfMc);
					
					trace("CARD before removed: " + card);
					// using contains
//					if (_model.inGameScreen["cardBoard"].contains(card)) {
//						_model.inGameScreen["cardBoard"].removeChild(card);
//					}
//					else
//					{
//						trace("cardBoard doesn't contain " + card);
//					}
					
					// using child.parent.removeChild
					card.parent.removeChild(card);
					
					
					//_model.myHandMcs.splice(indexOfMc, 1);
					//_model.myHandStrings.splice(indexOfMc, 1);
//					_model.cardMcsToBeCleanedUp.splice(indexOfMc, 1);
			}
			
			private function onDealerCardRepositioned(card:MovieClip):void
			{
				trace("onDealerHandsRepositionedAfterPause: " + card);
				var paramArray:Array = [];
				paramArray.push(card);
				TweenLite.delayedCall(1, onDealerCardRepositionedAfterPause, paramArray);
				//TweenLite.to(card, 2, {x:232 , y:94, omComplete:onDealerCardRepositioned, onCompleteParams:[_model.dealerHandMcs[1]]});
			}
			
			private function onDealerCardRepositionedAfterPause(card:MovieClip):void
			{
				trace("onDealerCardRepositionedAfterPause");
			//	var params:Array = [card];
			//	TweenLite.to(card, 2, {x:83, y:164, onComplete:onDealerCardMovedToDiscard, onCompleteParams:params});
				
			}			
			
			public function placeNewBet():void
			{
				trace("placing new bet with bet: " + _model.myCurrentBet + " poo5 and stack " + _model.myChipstackBet);
				
				_myCurrentBetTF.text = "" + _model.myCurrentBet;
				_myChipStackTF.text = "" +_model.myChipstackBet;
				
			//	_myCurrentBetMc.gotoAndPlay(_model.myCurrentBet.toString());
				// play sound of putting chips out
				
			}
			
			public function revealDealerDownCard(dealersDownCard:String):void
			{
				showDealerCard(dealersDownCard);
				
			}
			
			public function moveDealerCardsToDiscardTray():void
			{
				
				trace("moving dealer cards to discard tray: " + _model.dealerHandMcs.length);
				if (_model.dealerHandMcs.length > 0)
				{
					for (var f:int = (_model.dealerHandMcs.length-1); f >= 0; f--)
					{	
						var card:MovieClip = _model.dealerHandMcs[f];
//						TweenLite.to(_model.dealerHandMcs[f], 2, {x:83, y:164, onComplete:onDealerCardMovedToDiscard, onCompleteParams:params});	
//						_model.cardMcsToBeCleanedUp.push(_model.dealerHandMcs.splice(0,1));
						_model.dealerHandStrings.splice(f,1);
						_model.dealerHandMcs.splice(f,1);
						
						var params:Array = [card];
						TweenLite.to(card, 2, {x:83, y:164, onComplete:onDealerCardMovedToDiscard, onCompleteParams:params});	
			
						
					}
					//	var params:Array = [card];
					//	TweenLite.to(card, 2, {x:83, y:164, onComplete:onDealerCardMovedToDiscard, onCompleteParams:params});
					
				}
				
			}
			
			public function createNewDealerCard():Cards
			{
				var newCardMc:Cards = new Cards;
				return newCardMc;
			}
			
			public function currentBetToDealer():void
			{	
				TweenLite.to(_myCurrentBetMc, 1, {y:_myCurrentBetMc.y - 100, alpha:0});
				_model.myCurrentBet = 0;
				_myCurrentBetTF.text = "" + _model.myCurrentBet;
				
			}
			
			public function displayLosingHandEffects(busted:Boolean):void
			{
				_myCurrentBetTF.text = "0";
				_model.myCurrentBet = 0;
				
				TweenLite.to(_myCurrentBetMc, 1, {y:_myCurrentBetMc.y - 100, alpha:0});
				trace("displaying Lose effectx: " + busted, _model.myCurrentBet);
				
				
				if (busted) {
					_explosionMC.x = _model.MY_EXPLOSION_X;
					_explosionMC.y = _model.MY_EXPLOSION_Y;
					_explosionMC.gotoAndPlay("explode");
				}
				
			}
			
			public function displayPushEffects():void
			{
				trace("should be displaying push effects, if any");
				
			}
			

			public function displayWinEffects(amountWon:int, currentBet:int):void
			{
				trace("displaying win effectx: " + amountWon, currentBet);
				
				_myWinningsMc.x = _myCurrentBetMc.x + 40;
				_myWinningsMc.y = _myCurrentBetMc.y - 150;
				_myWinningsMc.visible = true;
				TweenLite.to(_myWinningsMc, 1, {alpha:1, y:_myCurrentBetMc.y});
				
				_model.myCurrentBet += amountWon;
				_myCurrentBetTF.text = "" + _model.myCurrentBet;

				
				
			}
			
			public function makeMyCurrentBetReadyForNewHand(myCurrentBet:int):void
			{
				trace("making them chips ready!");
				// show my current bet
				_myCurrentBetMc.alpha = 1;
				_myCurrentBetMc.visible = true;
				_myCurrentBetMc.x = _model.CURRENT_BET_CHIP_X_1;
				_myCurrentBetMc.y = _model.CURRENT_BET_CHIP_Y_1;
				var currentBetString:String = myCurrentBet.toString();
				
				trace("_myCurrentBetMc bet playing: " + currentBetString);
				_myCurrentBetMc.gotoAndStop("c"+currentBetString);
				
				// hide my winnings mc
				_myWinningsMc.visible = false;
			}
			
			public function moveMyCardsToDiscardTray():void
			{
				moveCardsToDiscardTray();
				
			}
		}
	}

	
