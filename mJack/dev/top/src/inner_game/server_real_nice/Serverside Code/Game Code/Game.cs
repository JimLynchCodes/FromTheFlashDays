using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using PlayerIO.GameLibrary;
using System.Drawing;

namespace TicTacToe {
	//Player class. each player that join the game will have these attributes.
	
	public class Tile {
		public String Type;
	}

    [RoomType("InGameYo")]
	public class GameCode : Game<Player> {

        private int _globalTime = 120;
        private const int NUMBER_OF_SHOES = 8;
		private Player player1;
		private Player player2;
		private List<Player> _playerList = new List<Player>();
        private List<String> _startDeck = new List<String> {
            "2h", "3h", "4h", "5h", "6h", "7h", "8h", "9h", "th", "jh", "qh", "kh", "ah",
            "2s", "3s", "4s", "5s", "6s", "7s", "8s", "9s", "ts", "js", "qs", "ks", "as",
            "2c", "3c", "4c", "5c", "6c", "7c", "8c", "9c", "tc", "jc", "qc", "kc", "ac",
            "2d", "3d", "4d", "5d", "6d", "7d", "8d", "9d", "td", "jd", "qd", "kd", "ad"
        };

		
		// This method is called when an instance of your the game is created
		public override void GameStarted() {
			// anything you write to the Console will show up in the 
			// output window of the development server
			Console.WriteLine("Game is started");
		}

		// This method is called when the last player leaves the room, and it's closed down.
		public override void GameClosed() {
			Console.WriteLine("RoomId: " + RoomId);
		}

		// This method is called whenever a player joins the game
		public override void UserJoined(Player player) {


            Boolean newGuyFlag = true;
            for (int i = 0; i < _playerList.Count; i++)
            {
                if (_playerList[i].ConnectUserId == player.ConnectUserId)
                {
                    Console.WriteLine("user is in the list already");
                    newGuyFlag = false;
                }      
            }

            if (newGuyFlag)
            {
                _playerList.Add(player);

                // send message to other user
                 for (int i = 0; i < _playerList.Count; i++)
                 {
                     if (_playerList[i].ConnectUserId == player.ConnectUserId)
                     {
                         
                     } 
                     else
                     {
                         _playerList[i].Send("USER_JOINED", player.ConnectUserId);
                     }
                 }

                if (_playerList.Count == 2)
                {
                    Console.WriteLine("two players joined!");
                    Broadcast("TWO_PLAYERS_JOINED");
                    buildDecks();
                }
            
            }

		}

		// This method is called when a player leaves the game
		public override void UserLeft(Player player) {
            for (int i = 0; i < _playerList.Count; i++)
            {
                if (_playerList[i].ConnectUserId == player.ConnectUserId)
                {
                    _playerList.RemoveAt(i);
                }
                else
                {
                    
                }
            }
		}

		// This method is called when a player sends a message into the server code
		public override void GotMessage(Player player, Message message) {
            switch (message.Type)
            {
                case "PLAYER_WANTS_TO_START":
                    player.wantsToStart = true;

                    if (_playerList[0].wantsToStart && _playerList[1].wantsToStart)
                    {
                        Console.WriteLine("both players want to start");
                        Broadcast("BOTH_WANT_TO_START");

                        //buildDecks();
                    }
                    else
                    {
                        for (int i = 0; i < _playerList.Count; i++)
                        {
                            if (_playerList[i].ConnectUserId == player.ConnectUserId)
                            {
                                //_playerList[i]
                            }
                            else
                            {
                                _playerList[i].Send("PLAYER_WANTS_TO_START", player.ConnectUserId);
                            }
                        }
                    }

                    break;

                case "NEW_HAND":
                    Console.WriteLine("dealing new hand to: " + player.ConnectUserId);

                    Console.WriteLine("beginning current bet & chipstack: " + player.currentBet + " " + player.chipStack + " " + player.nextBet);
                    String playerCard1 = PopAt(player.shoe, 0);
                    String dealerCard1 = PopAt(player.shoe, 0);
                    String playerCard2 = PopAt(player.shoe, 0);
                    String dealerCard2 = PopAt(player.shoe, 0);

                    player.hand1Cards.Add(playerCard1);
                    player.hand1Cards.Add(playerCard2);

                    player.dealerCards.Add(dealerCard1);
                    player.dealerCards.Add(dealerCard2);
                    player.dealerDownCard = dealerCard2;

                    

                    int handValue = getCardValueFromCardString(playerCard1, player.hand1Value) + getCardValueFromCardString(playerCard2, player.hand1Value);
                    Console.WriteLine("hand value is " + handValue);
                    player.hand1Value = handValue;
  
                    player.dealerHandValue = getCardValueFromCardString(dealerCard1, player.dealerHandValue) + getCardValueFromCardString(dealerCard2, player.dealerHandValue);
                   
                    if (player.currentBet > player.nextBet)
                    {
                        
                        player.chipStack += (player.currentBet - player.nextBet);
                        Console.WriteLine("adding " + (player.currentBet - player.nextBet) + " to chipstack, now: " + player.chipStack);
                    }
                    else
                    {
                        
                        player.chipStack -= (player.nextBet - player.currentBet);
                        Console.WriteLine("current bet: " + player.currentBet + " not greater than next bet: " + player.nextBet + " new chipstack: " + player.chipStack);
                    }

                    Console.WriteLine("new currentbet & chipstack: " + player.currentBet + " " + player.chipStack);
                    player.currentBet = player.nextBet;
                    Console.WriteLine("Dealer initial value for hand: " + player.dealerHandValue + " with cards: " + dealerCard1 + ", " + dealerCard2);


                    for (int i = 0; i < _playerList.Count; i++)
                    {
                        if (_playerList[i].ConnectUserId == player.ConnectUserId)
                        {
                            Console.WriteLine("sending new hand with bet: " + player.currentBet + " and chipstack: " + player.chipStack);
                            player.Send("NEW_HAND", playerCard1, dealerCard1, playerCard2, player.hand1Value, player.currentBet, player.chipStack);
                        }
                        else
                        {
                            _playerList[i].Send("OP_NEW_HAND", playerCard1, playerCard2, dealerCard1);
                        }
                    }
                    
                    Console.WriteLine("Sending: " + playerCard1 + " " + playerCard2 + " " + dealerCard1 + " to " + player.ConnectUserId);

                    break;

                case "START_TIMER":
                    for (int i = 0; i < _playerList.Count; i++)
                    {
                        if (_playerList[i].ConnectUserId == player.ConnectUserId)
                        {
                            player.startTimer = true;
                        }

                    }
                    if (_playerList[0].startTimer && _playerList[1].startTimer)
                    {
                        AddTimer(onTimerTick, 1000);
                    }
                    break;

                case "POT_BET_CHANGE":
                    String direction = message.GetString(0);
                    int magnitude = message.GetInt(1);

                    if (direction == "up")
                    {
                        player.potentialNextBet += magnitude;
                    }
                    else
                    {
                        player.potentialNextBet -= magnitude;
                    }

                    // SEND the message!
                    for (int i = 0; i < _playerList.Count; i++)
                    {
                        if (_playerList[i].ConnectUserId == player.ConnectUserId)
                        {
                            player.Send("MY_POTENTIAL_BET_UPDATE", player.potentialNextBet);
                        }
                        else
                        {
                            _playerList[i].Send("OP_POTENTIAL_BET_UPDATE", player.potentialNextBet);
                        }
                    }
                    break;


                case "NEXT_BET_SUBMIT":

                    player.nextBet = player.potentialNextBet;
                    
                    for (int i = 0; i < _playerList.Count; i++)
                    {
                        if (_playerList[i].ConnectUserId == player.ConnectUserId)
                        {
                            player.Send("MY_NEXT_BET_SUBMITTED", player.nextBet);
                        }
                        else
                        {
                            _playerList[i].Send("OP_NEXT_BET_SUBMITTED", player.nextBet);
                        }
                    }
                    break;

                case "PLAYER_HITS":
                    
                    String newCard = PopAt(player.shoe, 0);
                    player.hand1Cards.Add(newCard);
                    String newCardString = newCard.Substring(0, 1);
                    int newCardInt = 0;

                    newCardInt = getCardValueFromCardString(newCardString, player.hand1Value);

                    player.hand1Value += newCardInt;

                    Console.WriteLine(player + " is hitting, now has had value: " + player.hand1Value);
                    int whichHand = 1;

                        //player busted!
                    if (player.hand1Value > 21)
                    {
                        for (int i = 0; i < _playerList.Count; i++)
                        {
                            if (_playerList[i].ConnectUserId == player.ConnectUserId)
                            {

                                int winnings = 0;
                                player.currentBet = 0;

                                Console.WriteLine("player  is busting " + player.Id + " with card: " + newCard);
                                player.Send("NEW_HIT_CARD", newCard, player.hand1Value);
                                player.Send("I_BUSTED", newCard, whichHand, player.hand1Value, player.dealerDownCard, player.currentBet, player.chipStack);
                                  
                            }
                            else
                            {
                                _playerList[i].Send("OP_BUSTED", newCard, whichHand, player.hand1Value, player.dealerDownCard, player.currentBet, player.chipStack);
                            }
                        }


                    }
                    else
                    {
                        Console.WriteLine(player.Id + "is ready to continue hand, send new card: " + newCard, player.hand1Value, whichHand);

                        for (int i = 0; i < _playerList.Count; i++)
                        {
                            if (_playerList[i].ConnectUserId == player.ConnectUserId)
                            {

                                player.Send("NEW_HIT_CARD", newCard, player.hand1Value);

                            }
                            else
                            {
                                _playerList[i].Send("OP_NEW_HIT_CARD", newCard, player.hand1Value);
                            }
                        }
                    }

                  //  _playerList[i].hand1Cards.
                        
                    break;
                     
                case "PLAYER_STANDS":
                    player.Send("REVEAL_DEALER_DOWN_CARD", player.dealerDownCard);
                    Console.WriteLine("player standing: " + player.ConnectUserId + " dealer hand value: " + player.dealerHandValue);
                    String outcome = "";

                    if (player.dealerHandValue >= 17)
                    {
                        Console.WriteLine("dealer didnt need to draw any cards: " + player.dealerHandValue);
                        if (player.hand1Value > player.dealerHandValue)
                        {
                            // player wins
                            player.amountWon = player.currentBet;
                            player.currentBet += player.amountWon;
                            // outcome = "WIN";
                            player.Send("SHOWDOWN", "WIN", player.amountWon, player.currentBet, player.chipStack, false);
                        }
                        else if (player.hand1Value == player.dealerHandValue)
                        {
                            // push
                            player.amountWon = 0;
                            player.currentBet = player.currentBet;
                            // outcome = "PUSH";
                            player.Send("SHOWDOWN", "PUSH", player.amountWon, player.currentBet, player.chipStack, false);
                        }
                        else
                        {
                            // player loses in showdown
                            player.amountWon = 0;
                            player.currentBet = 0;
                            // outcome = "LOSE";
                            player.Send("SHOWDOWN", "LOSE", player.amountWon, player.currentBet, player.chipStack, false);
                        }

                    }


                    while (player.dealerHandValue < 17)
                    {
                        String drawnCard = PopAt(player.shoe, 0);
                        int drawnCardValue = getCardValueFromCardString(drawnCard, player.hand1Value);
                        player.dealerHandValue += drawnCardValue;
                        player.dealerCards.Add(drawnCard);
                        Console.WriteLine("Dealer taking card : " + drawnCard + " and new hand total " + player.dealerHandValue);
                        
                        //if (player.dealerHandValue < 17)
                        //{
                            for (int i = 0; i < _playerList.Count; i++)
                            {
                                if (_playerList[i].ConnectUserId == player.ConnectUserId)
                                {
                                    _playerList[i].Send("DEALER_PULLS_ANOTHER_CARD", drawnCard);
                                    Console.WriteLine("Dealer pulling another card: ", player.hand1Value + " " + player.dealerHandValue);

                                }
                                else
                                {
                                    _playerList[i].Send("OP_DEALER_PULLS_ANOTHER_CARD");
                                }
                            }
                        //}
                        //else // 1
                        //{
                                // dealer busted
                            if (player.dealerHandValue > 21)
                            {
                                player.dealerBusted = true;
                                player.amountWon = player.currentBet;
                                player.currentBet += player.amountWon;

                                player.Send("SHOWDOWN", "WIN", player.amountWon, player.currentBet, player.chipStack, true);
                                Console.WriteLine("Dealer busting, sending SHOWDOWN WIN ", player.hand1Value + " " + player.dealerHandValue);

                            }
                            else if (player.dealerHandValue <= 21 && player.dealerHandValue >= 17)
                            {
                                // dealer hand between 21 and 17. 
                                // compare to see who won 
                                player.dealerBusted = false;
                                if (player.hand1Value > player.dealerHandValue)
                                {
                                    // player wins
                                    player.amountWon = player.currentBet;
                                    player.currentBet += player.amountWon;
                                    // outcome = "WIN";
                                    player.Send("SHOWDOWN", "WIN", player.amountWon, player.currentBet, player.chipStack, false);
                                    Console.WriteLine("sending SHOWDOWN WIN straight up ", player.hand1Value + " " + player.dealerHandValue);
                                }
                                else if (player.hand1Value == player.dealerHandValue)
                                {
                                    // push
                                    player.amountWon = 0;
                                    player.currentBet = player.currentBet;
                                    // outcome = "PUSH";
                                    player.Send("SHOWDOWN", "PUSH", player.amountWon, player.currentBet, player.chipStack, false);
                                    Console.WriteLine("sending SHOWDOWN PUSH ", player.hand1Value + " " + player.dealerHandValue);
                                }
                                else
                                {
                                    // player loses in showdown
                                    player.amountWon = 0;
                                    player.currentBet = 0;
                                    // outcome = "LOSE";
                                    player.Send("SHOWDOWN", "LOSE", player.amountWon, player.currentBet, player.chipStack, false);
                                    Console.WriteLine("Dealer win straight up sending SHOWDOWN LOSE ", player.hand1Value + " " + player.dealerHandValue);
                                }

                            //} // 2

                       } // 1

                    } // while

                    Console.WriteLine("All done dealer getting cards hand val: " + player.dealerHandValue + " # dealer cards: " + player.dealerCards.Count + "player hand val: " + player.hand1Value);
                    for (int k = 0; k < player.dealerCards.Count; k++ )
                    {
                        Console.WriteLine("Dealer's card at index " + k + " is " + player.dealerCards[k]);
                    }

                    Console.WriteLine("stand hand over: " + player.currentBet + " " + player.chipStack);
                        break;
                case "PLAYER_DOUBLES":

                    String newDubCard = PopAt(player.shoe, 0);
                    player.hand1Cards.Add(newDubCard);
                    String newDubCardString = newDubCard.Substring(0, 1);
                    int newDubCardInt = 0;
                    newDubCardInt = getCardValueFromCardString(newDubCardString, player.hand1Value);

                    player.hand1Value += newDubCardInt;

                    // put more chips out for doubling down;
                    player.chipStack -= player.currentBet;
                    player.currentBet *= 2;


                    Console.WriteLine(player + " is doubling, now has hand value: " + player.hand1Value);
                    int whichDubHand = 1;

                   for (int i = 0; i < _playerList.Count; i++)
                        {
                            if (_playerList[i].ConnectUserId == player.ConnectUserId)
                            {
                                player.currentBet = 0;

                                Console.WriteLine("player  is busting " + player.Id + " with card: " + newDubCard);
                                player.Send("NEW_DOUBLE_CARD", newDubCard, player.hand1Value, player.currentBet, player.chipStack);
                               // player.Send("I_BUSTED", newDubCard, whichDubHand, player.hand1Value, player.dealerDownCard, player.currentBet, player.chipStack);
                                  
                            }
                            else
                            {
                                _playerList[i].Send("OP_BUSTED", newDubCard, whichDubHand, player.hand1Value, player.dealerDownCard, player.currentBet, player.chipStack);
                            }
                        }
                    break;



            }
		}

        private int getCardValueFromCardString(string newCardString, int totalHandValue)
        {

            int cardValue = 0;
           

            String firstChar = newCardString.Substring(0, 1);
            Console.WriteLine("checking new card stting: " + newCardString + " " + firstChar);

            switch (firstChar)
            {
                case "1":
                case "2":
                case "3":
                case "4":
                case "5":
                case "6":
                case "7":
                case "8":
                case "9":
                    cardValue = Convert.ToInt32(firstChar);
                    break;
                case "t":
                case "j":
                case "q":
                case "k":
                    cardValue = 10;
                    break;
                case "a":
                    if (totalHandValue + 11 > 21)
                    {
                        cardValue = 1;
                    }
                    else
                    {
                        cardValue = 11;
                    }
                    break;
                default:
                    cardValue = 0;
                    Console.WriteLine("SHIT AINT GOOD CARD" + newCardString + " NOT FOUND");
                    break;

            }

            return cardValue;

        }

        private void buildDecks()
        {
            for (int i = 0; i < NUMBER_OF_SHOES; i++)
            {
                for (int h = 0; h < 51; h++)
                {
                    _playerList[0].shoe.Add(_startDeck[h]);
                    _playerList[1].shoe.Add(_startDeck[h]);
                    Console.WriteLine("adding card" + _startDeck[h]);

                }
            }

            Console.WriteLine("decks built : " + _playerList[1].shoe.Count);
        }

        private String PopAt(List<String> list, int index)
        {
            String r = list[index];
            list.RemoveAt(index);
            return r;
        }

        private void onTimerTick()
        {
             for (int i = 0; i < _playerList.Count; i++)
                {
                    _playerList[i].Send("TIMER_TICK", _globalTime);
                }


            if (_globalTime == 1)
            {

                // TODO check for winners, etc
                Broadcast("TIMER_UP");
                for (int i = 0; i < _playerList.Count; i++)
                {
                    _playerList[i].Send("TIMER_UP");
                }
                
            }
            else
            {
                _globalTime--;
            }
        }

		
	}
}