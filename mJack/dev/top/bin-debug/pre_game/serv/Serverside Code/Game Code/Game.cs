using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using PlayerIO.GameLibrary;
using System.Drawing;

namespace FridgeMagnets2 {

	//Player class. each player that join the game will have these attributes.
	public class Player : BasePlayer {
		public int X;
		public int Y;
		public Player() {
			X = 0; //Player mouseX
			Y = 0; //Player mouseY
			Console.WriteLine ("hello there world");

		}
	}

	//Letter class. Each letter on the screen is represented by an instance of this class.
	public class Letter {
		public int X;
		public int Y;
		public Letter(int x, int y) {
			this.X = x;
			this.Y = y;
		}
	}

	[RoomType("Klondike")]
	public class GameCode : Game<Player> {

			// This method is called when an instance of your the game is created
		public override void GameStarted() {
		
			Console.WriteLine("Game is started");

//			
			Broadcast("start");

			Console.WriteLine ("yes sir we sendin the start");

		}

		// This method is called when the last player leaves the room, and it's closed down.
		public override void GameClosed() {
			Console.WriteLine("RoomId: " + RoomId);

			Broadcast("closed");
		}

		// This method is called whenever a player joins the game
		public override void UserJoined(Player player) {
			// Create init message for the joining player

			Console.WriteLine ("user joined " + player.Id);
//			
			Broadcast("userJoin");
		}

		// This method is called when a player leaves the game
		public override void UserLeft(Player player) {
			Console.WriteLine("Player " + player.Id + " left the room");

			//Inform all other players that user left.
			Broadcast("left", player.Id);
		}

		// This method is called when a player sends a message into the server code
		public override void GotMessage(Player player, Message message) {

			player.Send ("HelloWorld");
			//Switch on message type
//			switch(message.Type) {
//				case "move": {
//						//Move letter in internal representation
//
//
//						//inform all players that the letter have been moved
//
//						break;
//					}
//				case "mouse": {
//						//Set player mouse information
//						player.X = message.GetInteger(0);
//						player.Y = message.GetInteger(1);
//						break;
//					}
//				case "activate": {
//						Broadcast("activate", player.Id, message.GetInteger(0));
//						break;
//					}
//			case "crap":
//				{
//					Broadcast("holla");
//					break;
//				}
//
//			}
		}
	}
}
