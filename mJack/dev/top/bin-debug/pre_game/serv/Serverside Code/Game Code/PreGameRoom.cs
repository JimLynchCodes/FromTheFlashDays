using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PlayerIO.GameLibrary;

namespace FridgeMagnets
{

	public class Player : BasePlayer {
		public int X;
		public int Y;
		public Player() 
		{
			X = 0; //Player mouseX
			Y = 0; //Player mouseY
			Console.WriteLine ("hello there world");
		}
	}

	[RoomType("PreGameRoom")]
	public class PreGameRoom : Game<Player> 
	{

    }

		// This method is called when the last player leaves the room, and it's closed down.
	public override void GameClosed() {
		Console.WriteLine("Room has been closed: " + RoomId);

		//Broadcast("closed");
	}

	// This method is called whenever a player joins the game
	public override void UserJoined(Player player) {
		// Create init message for the joining player

		if (players == 2)
		{
			broadcast("Game can begin now");
			beginGame();
		}

		Console.WriteLine ("Player has joined the room: " + player.Id);
	}


	private void beginGame()
	{
		// during in-game send the 
		// "allow players to see each other, click their start buttons and begin game"

		// for pre-game
		// sendTheOkToBeginMessage
	}

	// This method is called when a player leaves the game
	public override void UserLeft(Player player) {
		Console.WriteLine("Player " + player.Id + " left the room");

		//Inform all other players that user left.
		player.Send("player has left");
	}

	// This method is called when a player sends a message into the server code
	public override void GotMessage(Player player, Message message) {

		//player.Send ("HelloWorld");
		Switch on message type
					switch(message.Type) {
		case "move": {
		//						//Move letter in internal representation
		//
		//
		//						//inform all players that the letter have been moved
		//
				break;
					}

		case "userChoseClass":{
				otherPlayer.send("opponentChoseClass", "class")
			}

		case "userReady":{
				otherPlayer.send("opponentReady")
			}

		case "userWantsToStart":{
				otherPlayer.send("opponentWantsToStart")
			}

		case "userCancelsReady":{
				otherPlayer.send("opponentCancelsReady")
			}

		case "userCancelsWantToStart":{
				otherPlayer.send("opponentCancelsWantToStart")
			}
		
					
					}
	}
}
