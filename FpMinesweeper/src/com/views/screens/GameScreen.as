package com.views.screens
{
	import com.helpers.GameSetupManager;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class GameScreen extends Sprite
	{
		private var _model:Object;
		private var _gameSetupManager:GameSetupManager;
		private var _stage:Object;
		private var _easyGameScreenTexture:Texture;
		private var _bombTexture:Texture;
		private var _flagTexture:Texture;
		private var _easyGameSprite:Sprite;
		private var _easyGameScreenImage:Image;
		private var _flagImage:Image;
		private var _currentRows:Array = [];
		private var rowsChosen:uint;
		private var columnsChosen:uint;
		private var zeroClickSound:Boodaloop;
		private var _placeFlagSound:PlaceFlag;
		private var _removeFlagSound:RemoveFlag;
		private var _explodeSound:Explode;
		private var _lightOverlay:starling.display.Quad;
		
		
		public function GameScreen(model:Object, stage:Object)
		{
			_stage = stage;
			_model = model;
			init();
		}
		
		
		private function init():void
		{
			assignVars();		
			addListeners();
			buildScreen();
		}
		
		
		private function assignVars():void
		{
			_gameSetupManager = new GameSetupManager(_model, _stage, this);
			
			_flagTexture = _model.fpMinesweeperTextureAtlas.getTexture("Flag");
			_bombTexture = _model.fpMinesweeperTextureAtlas.getTexture("Bomb");
			_easyGameScreenTexture = _model.fpMinesweeperTextureAtlas.getTexture("EasyGameScreen");
			
			_lightOverlay = new starling.display.Quad(800, 600, 0);
			_lightOverlay.alpha = 0.5;
			var _lightOverLaySprite:Sprite = new Sprite();
			_model.lightOverlaySprite = _lightOverLaySprite;
			_model.lightOverlay = _lightOverlay;
			_lightOverLaySprite.addChild(_lightOverlay);
			
			zeroClickSound = new Boodaloop; 	
			_placeFlagSound = new PlaceFlag;
			_removeFlagSound = new RemoveFlag;
			_explodeSound = new Explode;
				
		}
		
		
		public function beginNewGame():void
		{
			/** toggle commenting this line to win as soon as you join a game
			_model.gameJustWon = true; 
//			**/
			
			switch(_model.difficultySelected)
			{
				case _model.configu.EASY:
					trace("beginning game");
					_gameSetupManager.showGameScreen();
					resetGame();
					_gameSetupManager.placeBombs();
					break;
				
				case _model.configu.MEDIUM:
					_gameSetupManager.showGameScreen();
					resetGame();
					_gameSetupManager.placeBombs();
					break;
				
				case _model.configu.HARD:
					_gameSetupManager.showGameScreen();
					resetGame();
					_gameSetupManager.placeBombs();
					break;
				
			}
			
		}
		
		
		private function addGridListeners():void
		{
			for (var i:uint = 0; i < _model.configu.HARD_COLUMNS; i++)
			{
				
				for (var j:uint = 0; j < _model.configu.HARD_ROWS; j++)
				{
					_model.easyGrid[i][j].cellBtnUp.addEventListener(TouchEvent.TOUCH, onCellTouched);
				
				}
				
			}
		}
		
		
		private function onCellTouched(e:TouchEvent):void
		{
			
			var click:Touch = e.getTouch((_stage as starling.display.DisplayObject), TouchPhase.ENDED);
			if (click)
			{
				
				for (var i:uint = 0; i < _model.configu.HARD_COLUMNS; i++)
				{
					
					for (var j:uint = 0; j < _model.configu.HARD_ROWS; j++)
					{
						
						if (_model.easyGrid[i][j].cellBtnUp == click.target)
						{
							trace("clicked i: " + i + " , j: " + j);
							
							if (e.ctrlKey)
							{
									//do flag placing actions
								if(_model.easyGrid[i][j].isFlagged)
								{
									_model.easyGrid[i][j].cellBtnUp.removeChild(_model.easyGrid[i][j].flagItself);
									_model.easyGrid[i][j].isFlagged = false;
									_model.easyGrid[i][j].flagItself.dispose();
									
									_removeFlagSound.play();
								}
								else
								{
									_flagImage = new Image(_flagTexture);
									_model.easyGrid[i][j].cellBtnUp.addChild(_flagImage);
									_flagImage.x = 15;
									_flagImage.y = 5;
									_model.easyGrid[i][j].flagItself = _flagImage;
									_model.easyGrid[i][j].isFlagged = true;
									
									_placeFlagSound.play();
								}
								
							}
								// bomb clicked
							else if (_model.easyGrid[i][j].isABomb)
							{
								trace("you just clicked a bomb!");
								_model.gameLost = true;
								click.target.visible = false;
								
								_explodeSound.play();
							}
								// zero clicked
							else if(_model.easyGrid[i][j].bombsNextTo == 0)
							{
								revealThisAndAroundIt(i, j);
							}
								
								// just a regular nonzero number cell
							else
							{
								click.target.visible = false;
								_placeFlagSound.play();
							}
							
							
						}
					}
				}
			}
			
			checkForWin();
		}
		
		
		private function checkForWin():void
		{
			var winChecker:Boolean = true;
			var columnsChosen:uint;
			var rowsChosen:uint;
			
			switch(_model.difficultySelected)
			{
				case _model.configu.EASY:
					 rowsChosen = _model.configu.EASY_ROWS;
					columnsChosen = _model.configu.EASY_COLUMNS;
					break;
				
				case _model.configu.MEDIUM:
					rowsChosen = _model.configu.MEDIUM_ROWS;
					columnsChosen = _model.configu.MEDIUM_COLUMNS;
					break;
				
				case _model.configu.HARD:
					rowsChosen = _model.configu.HARD_ROWS;
					columnsChosen = _model.configu.HARD_COLUMNS;
					break;
				
			}
			
			
			for (var i:uint = 0; i < columnsChosen; i++)
			{
				for (var j:uint = 0; j < rowsChosen; j++)
				{
			
					if (_model.easyGrid[i][j].cellBtnUp.visible == true &&
						_model.easyGrid[i][j].isABomb == false)
					{
						winChecker = false;
					}
					
				}
				
			}
			
			if (winChecker == true)
			{
				trace("YOU WIN!");
				_model.gameJustWon = true;
			}
			
			
		}
		
		
		private function revealThisAndAroundIt(col:uint, row:uint):void
		{
			_model.easyGrid[col][row].cellBtnUp.visible = false;
			
			zeroClickSound.play();
			
			// top left
			if (row > 0 && col > 0)
			{
				if (_model.easyGrid[(col-1)][(row-1)].cellBtnUp.visible == true)
				{
					_model.easyGrid[(col-1)][(row-1)].cellBtnUp.visible = false;
					
					if (_model.easyGrid[(col-1)][(row-1)].bombsNextTo == 0)
					{
						revealThisAndAroundIt((col-1),(row-1));
					}
					
				}
			}
			
			// top center
			if (row > 0)
			{
				if(	_model.easyGrid[(col)][(row-1)].cellBtnUp.visible == true)
				{
					_model.easyGrid[(col)][(row-1)].cellBtnUp.visible = false;
					if (_model.easyGrid[(col)][(row-1)].bombsNextTo == 0
					)
					{
						revealThisAndAroundIt((col),(row-1));
					}
					
				}
				
			}
			
			// top right
			if (row > 0 && col < (columnsChosen-1))
			{
				if (_model.easyGrid[(col+1)][(row-1)].cellBtnUp.visible == true)
				{
					_model.easyGrid[(col+1)][(row-1)].cellBtnUp.visible = false;
					if (_model.easyGrid[(col+1)][(row-1)].bombsNextTo == 0)
					{
						revealThisAndAroundIt((col+1),(row-1));
					}
					
				}
				
			}
			
			// right center
			if (col < (columnsChosen-1))
			{
				if (_model.easyGrid[(col+1)][(row)].cellBtnUp.visible == true)
				{
					
					_model.easyGrid[(col+1)][(row)].cellBtnUp.visible = false;
					if (_model.easyGrid[(col+1)][(row)].bombsNextTo == 0)
					{
						revealThisAndAroundIt((col+1),(row));
					}
				}
			}
			
			
			// bottom right
			if (col < (columnsChosen-1) &&
				row < (rowsChosen-1))
			{
				if (_model.easyGrid[(col+1)][(row+1)].cellBtnUp.visible == true)
				{
					
					_model.easyGrid[(col+1)][(row+1)].cellBtnUp.visible = false;
					if (_model.easyGrid[(col+1)][(row+1)].bombsNextTo == 0)
					{
						revealThisAndAroundIt((col+1),(row+1));
					}
				}
			}
			
			// bottom center
			if (row < (rowsChosen-1))
			{
				if(_model.easyGrid[(col)][(row+1)].cellBtnUp.visible == true)
				{
					
					_model.easyGrid[(col)][(row+1)].cellBtnUp.visible = false;
					if (_model.easyGrid[(col)][(row+1)].bombsNextTo == 0)
					{
						revealThisAndAroundIt((col),(row+1));
					}
				}
			}
			
			// bottom left
			if (col > 0 &&
				row < (rowsChosen-1))
			{
				if (_model.easyGrid[(col-1)][(row+1)].cellBtnUp.visible == true)
				{
					
					_model.easyGrid[(col-1)][(row+1)].cellBtnUp.visible = false;
					if (_model.easyGrid[(col-1)][(row+1)].bombsNextTo == 0)
					{
						revealThisAndAroundIt((col-1),(row+1));
					}
				}
			}
			
			// left center
			if (col > 0)
			{
				if (_model.easyGrid[(col-1)][(row)].cellBtnUp.visible == true)
				{
					
					_model.easyGrid[(col-1)][(row)].cellBtnUp.visible = false;
					if (_model.easyGrid[(col-1)][(row)].bombsNextTo == 0)
					{
						revealThisAndAroundIt((col-1),(row));
					}
				}
				
			}
			
		}
		
		
		private function addListeners():void
		{
			_model.addEventListener(_model.configu.RESET_GAME, onResetGameEvent);
			
			addGridListeners();
		}
		
		
		private function onResetGameEvent(e:Event):void
		{
			resetGame();
			_gameSetupManager.placeBombs();
		}
		
		
		private function resetGame():void
		{
			
			switch(_model.difficultySelected)
			{
				case _model.configu.EASY:
					rowsChosen = _model.configu.EASY_ROWS
					columnsChosen = _model.configu.EASY_COLUMNS
					
					break;
				
				case _model.configu.MEDIUM:
					rowsChosen = _model.configu.MEDIUM_ROWS
					columnsChosen = _model.configu.MEDIUM_COLUMNS
					break;
				
				case _model.configu.HARD:
					rowsChosen = _model.configu.HARD_ROWS
					columnsChosen = _model.configu.HARD_COLUMNS
					break;
				
			}
			
			
			for (var m:uint = 0; m < columnsChosen; m++)
			{
				
				for (var n:uint = 0; n < rowsChosen; n++)
				{
					
					
					if(_model.easyGrid[m][n].isFlagged)
					{
						_model.easyGrid[m][n].cellBtnUp.removeChild(_model.easyGrid[m][n].flagItself);
						_model.easyGrid[m][n].isFlagged = false;
						_model.easyGrid[m][n].flagItself.dispose();
						
						
					}
					
					_model.easyGrid[m][n].cellBtnUp.visible = true;
					
					_model.easyGrid[m][n].cellBtnDown.upIcon = null;
					_model.easyGrid[m][n].cellBtnDown.hoverIcon = null;
					_model.easyGrid[m][n].cellBtnDown.downIcon = null;
					_model.easyGrid[m][n].cellBtnDown.label = "0"
					
					_model.easyGrid[m][n].bombsNextTo = 0;
					
					_model.easyGrid[m][n].isABomb = false;
					_model.easyGrid[m][n].isRevealed = false;
					
				}
			}
		}
		
		private function buildScreen():void
		{
			_model.gameScreen.addChild(_lightOverlay);
			_lightOverlay.visible = false;
			
		}
		
		
	}
}