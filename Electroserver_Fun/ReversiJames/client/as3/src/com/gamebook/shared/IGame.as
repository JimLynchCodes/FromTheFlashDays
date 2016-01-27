package com.gamebook.shared 
{
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.zone.Room;
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	/**
	 * Have each game that your lobby will load as a separate swf implement IGame.
	 * If there is other information that the lobby needs to pass to the IGame, 
	 * add another function to the interface or another parameter to initialize.
	 * 
	 */
	
	public interface IGame extends IEventDispatcher
	{
		
		function IGame();
		
		/**
		 * The display object that allows you to see the game.
		 */
		function get display():DisplayObject;
		
		
		/**
		 * Lobby calls this after a successful CreateOrJoinGameEvent and JoinRoomEvent, to pass any 
		 * variables that the game will need.
		 */
		function initialize (es:ElectroServer, gameRoom:Room, gameDetails:EsObject) : void;
		
		/**
		 * Called by the lobby when the game is destroyed, such as when the player returns to the lobby.
		 * Use this function to clean up details, such as removing event listeners.
		 * 
		 */
		function destroy () : void;
		
	}
	
}