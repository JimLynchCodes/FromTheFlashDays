package com.models
{
	
		import starling.display.Image;
		import starling.display.Quad;
		import starling.display.Sprite;
		import starling.events.Event;
		import starling.events.EventDispatcher;
		import starling.textures.TextureAtlas;
		
		
		public class FPMModel extends EventDispatcher
		{
			private var _configu:Object;
			private var _clicks:int = 0;
			private var _keyDirection:String;
			private var _difficultySelected:String;
			private var _overlay:Image;
			
			private var _easyGrid:Array = [];
			private var _mediumGrid:Array = [];
			private var _hardGrid:Array = [];
			private var _startScreenClose:Boolean; 
			private var _goingBackToStart:Boolean; 
			private var _gameJustWon:Boolean; 
			private var _gameLost:Boolean; 
			private var _resetGame:Boolean; 
			private var _gameScreen:Sprite; 
			private var _lightOverlaySprite:Sprite; 
			private var _lightOverlay:Quad; 
			
			private var _fpMinesweeperTextureAtlas:TextureAtlas;
			private var _fpMinesweeperTextureAtlas2:TextureAtlas;
			
			
			public function FPMModel(config:Object)
			{
				_configu = config;
				
				init();
			}
			
			private function init():void
			{
				trace("Model Initialized");
				
			}
			
			public function get resetGame():Boolean
			{
				return _resetGame;
			}

			public function set resetGame(value:Boolean):void
			{
				_resetGame = value;
				dispatchEvent(new Event(_configu.RESET_GAME, true));
			}

			public function get goingBackToStart():Boolean
			{
				return _goingBackToStart;
			}

			public function set goingBackToStart(value:Boolean):void
			{
				_goingBackToStart = value;
				
				dispatchEvent(new Event(configu.BACK_TO_START, true));
			}

			
			public function get difficultySelected():String
			{
				return _difficultySelected;
			}

			public function set difficultySelected(value:String):void
			{
				_difficultySelected = value;
			}
			
			public function get configu():Object
			{
				return _configu;
			}

			public function set configu(value:Object):void
			{
				_configu = value;
			}

			
			
			public function get keyDirection():String
			{
				return _keyDirection;
			}
			
			public function set keyDirection(value:String):void
			{
				_keyDirection = value;
				dispatchEvent(new Event(_configu.KEYBOARD_CHANGE));
				trace("dispatched keyaboard change");
			}
			
			public function get clicks():int
			{
				return _clicks;
			}
			
			public function set clicks(value:int):void
			{
				_clicks = value;
				dispatchEvent(new Event(_configu.MOUSE_CLICK_CHANGE));
				trace("dispatched mouse click change");
				
			}

			public function get overlay():Image
			{
				return _overlay;
			}

			public function set overlay(value:Image):void
			{
				_overlay = value;
			}

			public function get fpMinesweeperTextureAtlas():TextureAtlas
			{
				return _fpMinesweeperTextureAtlas;
			}

			public function set fpMinesweeperTextureAtlas(value:TextureAtlas):void
			{
				_fpMinesweeperTextureAtlas = value;
			}

			public function get easyGrid():Array
			{
				return _easyGrid;
			}

			public function set easyGrid(value:Array):void
			{
				_easyGrid = value;
			}

			public function get mediumGrid():Array
			{
				return _mediumGrid;
			}

			public function set mediumGrid(value:Array):void
			{
				_mediumGrid = value;
			}

			public function get hardGrid():Array
			{
				return _hardGrid;
			}

			public function set hardGrid(value:Array):void
			{
				_hardGrid = value;
			}

			public function get startScreenClose():Boolean
			{
				return _startScreenClose;
			}

			public function set startScreenClose(value:Boolean):void
			{
				_startScreenClose = value;
				
				dispatchEvent(new Event(_configu.START_SCREEN_CLOSE, true));
			}

			public function get gameJustWon():Boolean
			{
				return _gameJustWon;
			}

			public function set gameJustWon(value:Boolean):void
			{
				_gameJustWon = value;
				dispatchEvent(new Event(configu.GAME_WON, true));
			}

			public function get gameLost():Boolean
			{
				return _gameLost;
			}

			public function set gameLost(value:Boolean):void
			{
				_gameLost = value;
				dispatchEvent(new Event(configu.GAME_LOST, true));
			}

			public function get fpMinesweeperTextureAtlas2():TextureAtlas
			{
				return _fpMinesweeperTextureAtlas2;
			}

			public function set fpMinesweeperTextureAtlas2(value:TextureAtlas):void
			{
				_fpMinesweeperTextureAtlas2 = value;
			}

			public function get lightOverlay():Quad
			{
				return _lightOverlay;
			}

			public function set lightOverlay(value:Quad):void
			{
				_lightOverlay = value;
			}

			public function get gameScreen():Sprite
			{
				return _gameScreen;
			}

			public function set gameScreen(value:Sprite):void
			{
				_gameScreen = value;
			}

			public function get lightOverlaySprite():Sprite
			{
				return _lightOverlaySprite;
			}

			public function set lightOverlaySprite(value:Sprite):void
			{
				_lightOverlaySprite = value;
			}

			
			
			
		}
}