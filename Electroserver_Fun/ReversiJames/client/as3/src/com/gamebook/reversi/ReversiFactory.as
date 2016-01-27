package com.gamebook.reversi 
{
	import com.gamebook.shared.IGame;
	import com.gamebook.shared.IGameFactory;
	import flash.display.Sprite;
	
	public class ReversiFactory extends Sprite implements IGameFactory {

		public function ReversiFactory() {
			super();
		}
		
		public function getNewGame():IGame {
			var game:IGame = new Reversi();
			return game;
		}
	}
	
}