package com.helpers
{
	import com.assets.Assets;
	import com.models.CellDataObj;
	import com.views.screens.GameScreen;
	
	import flash.display.Bitmap;
	
	import feathers.controls.Button;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class GameSetupManager extends Sprite
	{
		private var _gameScreen:GameScreen;
		private var _model:Object;
		private var _stage:Object;
		private var _cellUpTexture:Texture;
		private var _cellDownTexture:Texture;
		private var cellDataSprite:Sprite;
		private var cellUpBtn:Button;
		private var cellDownImage:Image;
		private var _easyGameScreenImage:Image;
		private var _easyGameScreenTexture:Texture;
		private var _easyGameSprite:Sprite;
		private var _idCounter:int;
		private var txt_Score:TextField;
		private var _bombTexture:Texture;
		private var rowsChosen:uint;
		private var columnsChosen:uint;
		private var _numberOfBombs:uint;
	
		
		public function GameSetupManager(model:Object, stage:Object, gameScreen:GameScreen)
		{
			_model = model;
			_stage = stage;
			_gameScreen = gameScreen;
			
			init();
		}
		
		
		private function init():void
		{
			assignVars();
			
			buildEasyGrid();
			

			_stage.addChild(_easyGameSprite);
			_easyGameSprite.visible = false;
		}
		
		
		private function assignVars():void
		{
			
			_bombTexture = _model.fpMinesweeperTextureAtlas.getTexture("Bomb");
			
			_easyGameScreenTexture = _model.fpMinesweeperTextureAtlas.getTexture("EasyGameScreen");
			_easyGameScreenImage = new Image(_easyGameScreenTexture);
			_easyGameSprite = new Sprite();
			_model.gameScreen = _easyGameSprite;
			_easyGameSprite.addChild(_easyGameScreenImage);
			
			_cellUpTexture = _model.fpMinesweeperTextureAtlas.getTexture("CellUp");
			_cellDownTexture = _model.fpMinesweeperTextureAtlas.getTexture("CellDown");
			
		}
		
		private function buildEasyGrid():void
		{
			
			_idCounter = 0;
			
			for (var i:uint = 0; i < _model.configu.HARD_COLUMNS; i++)
			{
				
				var easyRow:Array = [];
				
				for (var j:uint = 0; j < _model.configu.HARD_ROWS; j++)
				{
					
					var cellDataObj:CellDataObj = new CellDataObj(_model);
					cellDataObj.isRevealed = false;
					cellDataObj.isABomb = false;
					cellDataObj.isFlagged = false;
					cellDataObj.bombsNextTo = 0;
					cellDataSprite = new Sprite();
					var cellSprite:Sprite = new Sprite();
					cellUpBtn = new Button;
					var cellDownBtn:Button = new Button;
					
					cellDataObj.cellBtnDown = cellDownBtn;
					cellDataObj.cellBtnUp = cellUpBtn;
					cellUpBtn.defaultSkin = new Image(_cellUpTexture);
					cellUpBtn.downSkin = new Image(_cellUpTexture);
					cellUpBtn.useHandCursor = true;
					
					cellDownImage = new Image(_cellDownTexture);
					cellUpBtn.addChild(cellDownImage);
					
					var _fontBitmap:Bitmap = new Assets.DesyrelFont;
					var _fontTexture:Texture = Texture.fromBitmap(_fontBitmap);
					var _fontXml:XML = XML(new Assets.DesyrelXML);

					TextField.registerBitmapFont(new BitmapFont(_fontTexture, _fontXml));
					cellDownBtn.defaultLabelProperties.textFormat = new BitmapFontTextFormat("Desyrel");
					cellDownBtn.defaultSkin = new Image(_cellDownTexture);
					
					cellSprite.addChild(cellDownBtn);
					cellSprite.addChild(cellDataObj.cellBtnUp);
					
					cellDownBtn.label = "0";
					
			/**		see all the numbers in the grid at beginning
					cellUpBtn.visible = false;
//			**/		
					_easyGameSprite.addChild(cellSprite);
					cellSprite.x = 10 + 50 * i;
					cellSprite.y = 10 + 50 * j;
					
					cellDataObj.cellSprite = cellSprite;
					cellDataObj.cellBtnUp = cellUpBtn;
					cellDataObj.cellClickedSprite = cellDataSprite
//					
					_idCounter ++;
					cellDataObj.id = _idCounter;
					easyRow.push(cellDataObj);
					
				}
				
			_model.easyGrid.push(easyRow);
				
			}
			
			
		}
			
						
		public function placeBombs():void
		{
			
			switch(_model.difficultySelected)
			{
				case _model.configu.EASY:
					rowsChosen = _model.configu.EASY_ROWS
					columnsChosen = _model.configu.EASY_COLUMNS
					_numberOfBombs = _model.configu.BOMBS_EASY;
					break;
				
				case _model.configu.MEDIUM:
					rowsChosen = _model.configu.MEDIUM_ROWS
					columnsChosen = _model.configu.MEDIUM_COLUMNS
					_numberOfBombs = _model.configu.BOMBS_MEDIUM;
					break;
				
				case _model.configu.HARD:
					rowsChosen = _model.configu.HARD_ROWS
					columnsChosen = _model.configu.HARD_COLUMNS
					_numberOfBombs = _model.configu.BOMBS_HARD;
					break;
				
			}
			
			var q:uint = 0;
			
			trace("number of bombs this level: " + _numberOfBombs);
			while (q < _numberOfBombs)
			{
					//randomly choose row and column
				var randomColumn:uint = uint(Math.random()*(columnsChosen));
				var randomRow:uint = uint(Math.random()*(rowsChosen));
				
				trace("rand col and row " + randomColumn + ", " +  randomRow);
					// check that cell isn't already a bomb
				if (_model.easyGrid[randomColumn][randomRow].isABomb == false)
				{
					
					_model.easyGrid[randomColumn][randomRow].cellBtnDown.upIcon = new Image(_bombTexture);
					_model.easyGrid[randomColumn][randomRow].cellBtnDown.hoverIcon = new Image(_bombTexture);
					_model.easyGrid[randomColumn][randomRow].cellBtnDown.downIcon = new Image(_bombTexture);
					_model.easyGrid[randomColumn][randomRow].cellBtnDown.label = "";
					
						// tell chosen cell it's a bomb
					_model.easyGrid[randomColumn][randomRow].isABomb = true;
					trace("I am a bomb i: " + randomColumn + " , j: " + randomRow);
					q++;
					
					 alertNeighbors(randomColumn, randomRow);
					
				}
				
			}
			
			hideNumberOnZeroCells();
			
				
		}			
		
		
		private function hideNumberOnZeroCells():void
		{
			for (var i:uint = 0; i < columnsChosen; i++)
			{
				for (var j:uint = 0; j < rowsChosen; j++)
				{
					if (_model.easyGrid[i][j].bombsNextTo == false)
					{
						_model.easyGrid[i][j].cellBtnDown.label = "";
						
					}
				}
				
			}
		}
		
		
		private function alertNeighbors(randomColumn:uint, randomRow:uint):void
		{

					// top left
			if (randomRow > 0 && randomColumn > 0)
			{
				if (_model.easyGrid[(randomColumn-1)][(randomRow-1)].isABomb == false)
				{
					_model.easyGrid[(randomColumn-1)][(randomRow-1)].bombsNextTo += 1;
					_model.easyGrid[(randomColumn-1)][(randomRow-1)].cellBtnDown.label = 
						_model.easyGrid[(randomColumn-1)][(randomRow-1)].bombsNextTo;
					
				}
			}
			
				// top center
			if (randomRow > 0)
			{
				if (_model.easyGrid[(randomColumn)][(randomRow-1)].isABomb == false)
				{
					_model.easyGrid[(randomColumn)][(randomRow-1)].bombsNextTo += 1;
					_model.easyGrid[(randomColumn)][(randomRow-1)].cellBtnDown.label = 
					_model.easyGrid[(randomColumn)][(randomRow-1)].bombsNextTo;
					
				}
			}
			
			// top right
			if (randomRow > 0 && randomColumn < (columnsChosen -1))
			{
				if (_model.easyGrid[(randomColumn+1)][(randomRow-1)].isABomb == false)
				{
					_model.easyGrid[(randomColumn+1)][(randomRow-1)].bombsNextTo += 1;
					_model.easyGrid[(randomColumn+1)][(randomRow-1)].cellBtnDown.label = 
						_model.easyGrid[(randomColumn+1)][(randomRow-1)].bombsNextTo;
					
				}
			}

			// right center
			if (randomColumn < (columnsChosen -1))
			{
				if (_model.easyGrid[(randomColumn+1)][(randomRow)].isABomb == false)
				{
					_model.easyGrid[(randomColumn+1)][(randomRow)].bombsNextTo += 1;
					_model.easyGrid[(randomColumn+1)][(randomRow)].cellBtnDown.label = 
						_model.easyGrid[(randomColumn+1)][(randomRow)].bombsNextTo;
					
				}
			}
			
			
			// bottom right
			if (randomColumn < (columnsChosen -1) &&
				randomRow < (rowsChosen -1))
			{
				if (_model.easyGrid[(randomColumn+1)][(randomRow+1)].isABomb == false)
				{
					_model.easyGrid[(randomColumn+1)][(randomRow+1)].bombsNextTo += 1;
					_model.easyGrid[(randomColumn+1)][(randomRow+1)].cellBtnDown.label = 
						_model.easyGrid[(randomColumn+1)][(randomRow+1)].bombsNextTo;
					
				}
			}
			
			// bottom center
			if (randomRow < (rowsChosen -1))
			{
				if (_model.easyGrid[(randomColumn)][(randomRow+1)].isABomb == false)
				{
					_model.easyGrid[(randomColumn)][(randomRow+1)].bombsNextTo += 1;
					_model.easyGrid[(randomColumn)][(randomRow+1)].cellBtnDown.label = 
						_model.easyGrid[(randomColumn)][(randomRow+1)].bombsNextTo;
					
				}
			}
			
			// bottom left
			if (randomColumn > 0 &&
				randomRow < (rowsChosen -1))
			{
				if (_model.easyGrid[(randomColumn-1)][(randomRow+1)].isABomb == false)
				{
					_model.easyGrid[(randomColumn-1)][(randomRow+1)].bombsNextTo += 1;
					_model.easyGrid[(randomColumn-1)][(randomRow+1)].cellBtnDown.label = 
						_model.easyGrid[(randomColumn-1)][(randomRow+1)].bombsNextTo;
					
				}
			}
			
			// left center
			if (randomColumn >0)
			{
				if (_model.easyGrid[(randomColumn-1)][(randomRow)].isABomb == false)
				{
					_model.easyGrid[(randomColumn-1)][(randomRow)].bombsNextTo += 1;
					_model.easyGrid[(randomColumn-1)][(randomRow)].cellBtnDown.label = 
						_model.easyGrid[(randomColumn-1)][(randomRow)].bombsNextTo;
					
				}
			}
			

		}
		
		
		public function showGameScreen():void
		{
			trace("setting up");
			
			_easyGameSprite.visible = true;
			trace(_easyGameSprite.visible);
			
			switch(_model.difficultySelected)
			{
				case _model.configu.EASY:
					rowsChosen = _model.configu.EASY_ROWS;
					columnsChosen = _model.configu.EASY_COLUMNS;
					trace("found easy");
					break;
				
				case _model.configu.MEDIUM:
					rowsChosen = _model.configu.MEDIUM_ROWS;
					columnsChosen = _model.configu.MEDIUM_COLUMNS;
					trace("found medium");
					break;
				
				case _model.configu.HARD:
					rowsChosen = _model.configu.HARD_ROWS;
					columnsChosen = _model.configu.HARD_COLUMNS;
					trace("found hard");
					break;
				
			}
			
			hideAllCellSprites();
			
			for (var i:uint = 0; i < columnsChosen; i++)
			{
				for (var j:uint = 0; j < rowsChosen; j++)
				{
					_model.easyGrid[i][j].cellSprite.visible = true;
				}
			
			}
			
			
		}
		
		
		private function hideAllCellSprites():void
		{
			for (var i:uint = 0; i < _model.configu.HARD_COLUMNS; i++)
			{
				for (var j:uint = 0; j < _model.configu.HARD_ROWS; j++)
				{
					_model.easyGrid[i][j].cellSprite.visible = false;
				}
			}
		}
		
		
	}
}