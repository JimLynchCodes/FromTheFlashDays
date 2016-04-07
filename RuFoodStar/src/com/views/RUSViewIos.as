package com.views
{
	import com.assets.Assets;
	
	import flash.display.Bitmap;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	
	public class RUSViewIos extends Sprite
	{
		private var _stage:Object;
		private var _model:Object;
		private var _controller:Object;
		private var _configu:Object;
		private var _fpMinesweeperTextureAtlas:TextureAtlas;
		private var _fpMinesweeperTextureAtlas2:TextureAtlas;
		private var _yellowFireworkMc:MovieClip;
		private var _redFireworkMc:MovieClip;
		
		
		public function RUSViewIos()
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
			addListeners();
			
			trace("Main View Initialized.");
			
			startFireworks();
		}
		
		private function startFireworks():void
		{
			// get the textures frames
			var yellowFireworkFrames:Vector.<Texture> = _fpMinesweeperTextureAtlas.getTextures("yellow_firework");
			
			
			_yellowFireworkMc = new MovieClip(yellowFireworkFrames, 20);
			_redFireworkMc = new MovieClip(yellowFireworkFrames, 20);
			
			_redFireworkMc.x = 440;
			_redFireworkMc.y = 500;
			
			_yellowFireworkMc.x = 0;
			_yellowFireworkMc.y = 300;
			
			Starling.juggler.add(_redFireworkMc);
			
			_redFireworkMc.play();
			
		}		
		
		private function assignVars():void
		{
			_configu = _model.configu;
			
			
			// create the texture atlas(es) and save into a model variable			
			var fpAtlas1Bitmap:Bitmap = new Assets.FpMineSweeperAtlas_1SS;
			var fpAtlasTexture:starling.textures.Texture = Texture.fromBitmap(fpAtlas1Bitmap);
			var fpAtlas1Xml:XML = XML(new Assets.FpMineSweeperAtlas_1Xml);
			
			_fpMinesweeperTextureAtlas = new TextureAtlas(fpAtlasTexture, fpAtlas1Xml);
//			_model.fpMinesweeperTextureAtlas = _fpMinesweeperTextureAtlas;
			
			var fpAtlas2Bitmap:Bitmap = new Assets.FpMineSweeperAtlas_2SS;
			var fpAtlas2Texture:starling.textures.Texture = Texture.fromBitmap(fpAtlas2Bitmap);
			var fpAtlas2Xml:XML = XML(new Assets.FpMineSweeperAtlas_2Xml);
			
			_fpMinesweeperTextureAtlas2 = new TextureAtlas(fpAtlas2Texture, fpAtlas2Xml);
//			_model.fpMinesweeperTextureAtlas2 = _fpMinesweeperTextureAtlas2;
			
		}
		
		
		private function addListeners():void
		{
			
		}
		
		
		private function addedToStageHandler(event:Event):void
		{
			trace("Main view added to stage.");
		}
		
		
		
		
		
	}
}