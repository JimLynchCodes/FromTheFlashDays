using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using PlayerIO.GameLibrary;
using System.Drawing;

namespace PreGameReals
{
    //Player class. each player that join the game will have these attributes.
    public class Player : BasePlayer
    {
        public Boolean IsReady = false;
        public Player()
        {
            Console.WriteLine("hello there world");
        }
    }

    [RoomType("InGameYo")]
    public class GameCode : Game<Player>
    {
        private List<Player> _playerList = new List<Player> { };

        // This method is called when an instance of your the game is created
        public override void GameStarted()
        {
            // anything you write to the Console will show up in the 
            // output window of the development server
            Console.WriteLine("Game is started");
        }

        // This method is called when the last player leaves the room, and it's closed down.
        public override void GameClosed()
        {
            Console.WriteLine("Game Room has been closed: " + RoomId);
        }

        // This method is called whenever a player joins the game
        public override void UserJoined(Player player)
        {
            bool notYetJoined = true;
            // check if player is in list already
            for (int i = 0; i < _playerList.Count; i++) {
                if (_playerList[i] == player) {
                    notYetJoined = false;
                }
            }
            if (notYetJoined) {
                _playerList.Add(player);
            }

            Console.WriteLine("User Joined, player list is now: " + _playerList);

            if (_playerList.Count == 2)
            {
                Console.WriteLine("two players " + _playerList);
                Console.WriteLine("player1: " + _playerList[0].ConnectUserId + " and two " + _playerList[1].ConnectUserId);
              
                // TODO:
                // do db calls here and broadcast stats to display
                //
                // PlayerioDB.get(...);
                // Broadcast("TWO_PLAYERS_JOINED", db args...);

            }

        }

        // This method is called when a player leaves the game
        public override void UserLeft(Player player)
        {
            Console.WriteLine("User left the chat " + player.Id);
        }

        // This method is called when a player sends a message into the server code
        public override void GotMessage(Player player, Message message)
        {

            Console.WriteLine("got message of type: " + message.Type + " from player: " + player.ConnectUserId);
            switch (message.Type)
            {
                case "USER_CLASS_CHOSEN":
                    Console.WriteLine("player.ConnectUserId: " + player.ConnectUserId + " _playerList[0].ConnectUserId " + _playerList[0].ConnectUserId);
                        if (player.ConnectUserId == _playerList[0].ConnectUserId)
                        {
                            Console.WriteLine("Sending OPPONENT_CLASS_CHOSEN from" + player.ConnectUserId + " to " + _playerList[1].ConnectUserId);
                            _playerList[1].Send("OPPONENT_CLASS_CHOSEN", player.ConnectUserId, message.GetString(0));
                        }
                        else
                        {
                            _playerList[0].Send("OPPONENT_CLASS_CHOSEN", player.ConnectUserId, message.GetString(0));
                        }
                        
                    break;

                case "USER_READY_CHOSEN":
             
                        Console.WriteLine("Sending OPPONENT_READY_CHOSEN from" + player.ConnectUserId + " to " + _playerList[1].ConnectUserId);
                         if (player.ConnectUserId == _playerList[0].ConnectUserId)
                         {
                             Console.WriteLine("Sending OPPONENT_READY_CHOSEN from" + player.ConnectUserId + " to " + _playerList[1].ConnectUserId);
                         _playerList[1].Send("OPPONENT_READY_CHOSEN", player.ConnectUserId);
                        }
                        else
                        {
                            _playerList[0].Send("OPPONENT_READY_CHOSEN", player.ConnectUserId);
                         }
                      
//                        Broadcast("OPPONENT_READY_CHOSEN", player.ConnectUserId);
                    break;

                case "USER_WANTS_TO_START_CHOSEN":
                    if (player.ConnectUserId == _playerList[0].ConnectUserId)
                    {
                        Console.WriteLine("Sending OPPONENT_CLASS_CHOSEN from" + player.ConnectUserId + " to " + _playerList[1].ConnectUserId);
                        _playerList[1].Send("OPPONENT_WANTS_TO_START_CHOSEN", player.ConnectUserId);
                    }
                    else
                    {
                        _playerList[0].Send("OPPONENT_WANTS_TO_START_CHOSEN", player.ConnectUserId);
                    }

                    break;

                case "USER_READY_CANCEL_CHOSEN":
                    if (player.ConnectUserId == _playerList[0].ConnectUserId)
                    {
                        Console.WriteLine("Sending OPPONENT_CLASS_CHOSEN from" + player.ConnectUserId + " to " + _playerList[1].ConnectUserId);
                        _playerList[1].Send("OPPONENT_READY_CANCEL_CHOSEN", player.ConnectUserId);
                    }
                    else
                    {
                        _playerList[0].Send("OPPONENT_READY_CANCEL_CHOSEN", player.ConnectUserId);
                    }
              
                    break;

            }
        }

    }
}