package com.gamebook.shared 
{
	
	/**
	 * All game SWFs can be loaded and then cast to this interface. 
	 * They can then be used as factories to cough up new IGame instances.
	 */
	public interface IGameFactory 
	{
		function getNewGame():IGame;

	}
	
}