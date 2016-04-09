using PlayerIO.GameLibrary;
using System;
using System.Collections.Generic;

namespace TicTacToe
{
    /// <summary>
    /// Description of Singleton1
    /// </summary>
    public class Player : BasePlayer {
		public Boolean IsReady = true;
        public int currentBet;
        public int nextBet = 5;
        public int potentialNextBet = 5;
        public int chipStack = 1500;
        public String dealerDownCard;
        public Boolean wantsToStart = false;
        public Boolean startTimer = false;
        public Boolean dealerBusted = false;

        public List<String> hand1Cards = new List<String>();
        public List<String> hand2Cards = new List<String>();
        public List<String> hand3Cards = new List<String>();
        public List<String> hand4Cards = new List<String>();

        public List<String> dealerDrawnCards = new List<String>();

        public List<String> dealerCards = new List<String>();

        
        public int hand1Value = 0;
        public int hand2Value = 0;
        public int hand3Value = 0;
        public int hand4Value = 0;
        public int amountWon = 0;

        public int dealerHandValue = 0;

        public List<String> shoe = new List<String> { };
       }
}
