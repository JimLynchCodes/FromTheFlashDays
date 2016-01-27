package com.views
{
	import com.assets.Assets;
	import com.controllers.FPMController;
	import com.views.screens.DifficultyPopup;
	import com.views.screens.GameOverPopup;
	import com.views.screens.GameScreen;
	import com.views.screens.HowToPlayPopup;
	import com.views.screens.StartScreen;
	import com.views.screens.YouWinPopup;
	
	import flash.display.Bitmap;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	
	public class FPMView extends Sprite
	{
		private var _stage:Object;
		private var _model:Object;
		private var _controller:Object;
		private var _configu:Object;
		private var _fpMinesweeperTextureAtlas:TextureAtlas;
		private var _startScreenTexture:Texture;
		private var _startScreen:Image;
		private var _startScreenC:StartScreen;
		private var _gameScreen:GameScreen;
		private var _howToPlayPopup:HowToPlayPopup;
		private var _gameOverPopup:GameOverPopup;
		private var _youWinPopup:YouWinPopup;
		private var _difficultyPopup:DifficultyPopup;
		private var _startBtnUpTexture:Texture;
		private var _startBtnImage:Image;
		private var _fpMinesweeperTextureAtlas2:TextureAtlas;
		private var _startSound:Chime;
		
		
		public function FPMView()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		private function onAddedToStage():void
		{
			_stage = stage;
			
		}		
		
		
		private function init():void
		{
			assignVars();
			
			_startSound = new Chime;
			_startSound.play();

			trace("Main View Initialized.");
		}
		
		
		private function assignVars():void
		{
			
				// create the texture atlas(es) and save into a model variable			
			var fpAtlas1Bitmap:Bitmap = new Assets.FpMineSweeperAtlas_1SS;
			var fpAtlasTexture:starling.textures.Texture = Texture.fromBitmap(fpAtlas1Bitmap);
			var fpAtlas1Xml:XML = XML(new Assets.FpMineSweeperAtlas_1Xml);
			
			_fpMinesweeperTextureAtlas = new TextureAtlas(fpAtlasTexture, fpAtlas1Xml);
			_model.fpMinesweeperTextureAtlas = _fpMinesweeperTextureAtlas;
			
			var fpAtlas2Bitmap:Bitmap = new Assets.FpMineSweeperAtlas_2SS;
			var fpAtlas2Texture:starling.textures.Texture = Texture.fromBitmap(fpAtlas2Bitmap);
			var fpAtlas2Xml:XML = XML(new Assets.FpMineSweeperAtlas_2Xml);
			
			_fpMinesweeperTextureAtlas2 = new TextureAtlas(fpAtlas2Texture, fpAtlas2Xml);
			_model.fpMinesweeperTextureAtlas2 = _fpMinesweeperTextureAtlas2;
			
			
			_gameScreen = new GameScreen(_model, _stage);
			_howToPlayPopup = new HowToPlayPopup(_model, _stage);
			_difficultyPopup = new DifficultyPopup(_model, _stage, _gameScreen);
			_startScreenC = new StartScreen(_model, _stage, _howToPlayPopup, _difficultyPopup);
			_gameOverPopup = new GameOverPopup(_model, _stage, _startScreenC, _gameScreen);
			_youWinPopup = new YouWinPopup(_model, _stage, _startScreenC, _gameScreen);
			
			
		}
		
		private function addListeners():void
		{
			// just in case you want to add some listeners here.	
		}
		
			// how I am passing variables from Main class to a new Starling
		public function passVars(model:Object, controller:FPMController):void
		{
			_model = model;
			_controller = controller;
			_configu = _model.configu;
			
			init();
		}
		
		
	}
}