package com.assets
{
	import flash.display.Bitmap;
	
	import starling.display.Sprite;
	import starling.extensions.Particle;
	import starling.extensions.ParticleDesignerPS;
	import starling.extensions.ParticleSystem;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets extends Sprite
	{
		
		
		
		
		
		public function Assets()
		{
			
		}
		
		
		[Embed(source = "/tp/tpOutput/FpMinesweeperAtlas_1.png")]
		public static const FpMineSweeperAtlas_1SS:Class;
		
		[Embed(source = "/tp/tpOutput/FpMinesweeperAtlas_1.xml", mimeType="application/octet-stream")]
		public static const FpMineSweeperAtlas_1Xml:Class;
		
		[Embed(source = "/tp/tpOutput2/FpMineSweeperAtlas_2.png")]
		public static const FpMineSweeperAtlas_2SS:Class;
		
		[Embed(source = "/tp/tpOutput2/FpMineSweeperAtlas_2.xml", mimeType="application/octet-stream")]
		public static const FpMineSweeperAtlas_2Xml:Class;
		
		[Embed(source = "/tp/tpOutput3/output3.png")]
		public static const Atlas3SS:Class;
		
		[Embed(source = "/tp/tpOutput3/output3.xml", mimeType="application/octet-stream")]
		public static const Atlas3Xml:Class;
		
		[Embed(source = "/tp/tpOutput3/DefendCastleAtlas2.png")]
		public static const DefendCastleAtlasPng:Class;
		
		[Embed(source = "/tp/tpOutput3/DefendCastleAtlas2.xml", mimeType="application/octet-stream")]
		public static const DefendCastleAtlasXml:Class;
		
		
		[Embed(source = "/font/desyrel.png")]
		public static const DesyrelFont:Class;
		
		[Embed(source = "/font/desyrel.fnt", mimeType="application/octet-stream")]
		public static const DesyrelXML:Class;
		
		[Embed(source = "/dragon_bones/RobotMerged.png")]
		public static const RobotResource:Class;
		
		[Embed(source = "/particles/smoke.pex", mimeType="application/octet-stream")]
		public static var smokeXml:Class;
		
		[Embed(source = "/particles/explosion.pex", mimeType="application/octet-stream")]
		public static var explosionXml:Class;
		
		[Embed(source = "/font/komika.png")]
		public static var komika:Class;
		
		[Embed(source = "/font/komika.fnt", mimeType="application/octet-stream")]
		public static var komikaXml:Class;
		
		
		[Embed(source = "/font/BasicWhite.png")]
		public static var basicWhiteFont:Class;
		
		[Embed(source = "/font/BasicWhite.fnt", mimeType="application/octet-stream")]
		public static var basicWhiteFontXml:Class;
		
		[Embed(source = "/particles/particle.pex", mimeType="application/octet-stream")]
		public static var FireParticle:Class;
		
		[Embed(source = "/particles/texture.png")]
		public static var FireParticleImage:Class;
		
		
		private static var _fpAtlas1Bitmap:Bitmap;
		private static var _fpAtlasTexture:starling.textures.Texture;
		private static var _fpAtlas1Xml:XML;
		
		public static var fpMinesweeperTextureAtlas:TextureAtlas = new TextureAtlas(_fpAtlasTexture, _fpAtlas1Xml);
		
		//		public static var bkgdT		     : Texture = fpMinesweeperTextureAtlas.getTexture("bkgd/bkgd");
		public static var logoT	 : Texture;
		public static var newGameBtnT:Texture;
		
		private static var _number:Number = 6;
		private static var _DefendCastleAtlasBitmap:Bitmap;
		private static var _DefendCastleAtlasTexture:Texture;
		private static var _DefendCastleAtlasXml:XML;
		public static var _defendCastleTextureAtlas:TextureAtlas;
		public static var gameBgT:Texture;
		public static var bombT:Texture;
		public static var genericPopup:Texture;
		public static var greenBtnT:Texture;
		public static var greenBtnDownT:Texture;
		public static var redBtnT:Texture;
		public static var redBtnDownT:Texture;
		public static var fpMinesweeper2TextureAtlas:TextureAtlas;
		public static var guyFrames:Vector.<Texture>;
		public static var fireParticles:ParticleDesignerPS;
		public static var fullPopupTest:Texture;
		public static var smallPopupTest:Texture;
		public static var slotBgTest:Texture;
		public static var palaX:Texture;
		public static var moneyBox:Texture;
		public static var addMoneyBtn:Texture;
		public static var santa:Texture;
		public static var openSlot:Texture;
		public static var slotty:Texture;
		public static var slottySelect:Texture;
		public static var elfGuy:Texture;
		public static var scroller:Texture;
		public static var levelBox:Texture;
		public static var heartLevelBox:Texture;
		public static var throwOnlyBox:Texture;
		public static var magicOnlyBox:Texture;
		public static var impossibleModeBox:Texture;
		public static var coinShop:Texture;
		public static var gamePowUpBtn:Texture;
		public static var shopPreviewArea:Texture;
		public static var shopUpgradeArea:Texture;
		
		trace("logoT");
		
		//		public static var gameStateBkgdT : Texture;
		
		
		// mp3 sounds here
		//
		//	[Embed(source = "/folder/the_sound.mp3")]
		//  public static const TheSound:Class;
		//
		
		public static function get number():Number
		{
			return _number;
		}

		public static function set number(value:Number):void
		{
			_number = value;
		}

		public static function createAssets():void
		{
			// atlas 1
			_fpAtlas1Bitmap = new Assets.Atlas3SS;
			_fpAtlasTexture = Texture.fromBitmap(_fpAtlas1Bitmap);
			_fpAtlas1Xml = XML(new Assets.Atlas3Xml);
			
			fpMinesweeperTextureAtlas = new TextureAtlas(_fpAtlasTexture, _fpAtlas1Xml);

			// atlas 2
			var _fpAtlas2Bitmap:Bitmap = new Assets.FpMineSweeperAtlas_2SS;
			var _fpAtlas2Texture:Texture = Texture.fromBitmap(_fpAtlas2Bitmap);
			var _fpAtlas2Xml:XML = XML(new Assets.FpMineSweeperAtlas_2Xml);
			
			fpMinesweeper2TextureAtlas = new TextureAtlas(_fpAtlas2Texture, _fpAtlas2Xml);
			
			// defend atlas
			_DefendCastleAtlasBitmap = new Assets.DefendCastleAtlasPng;
			_DefendCastleAtlasTexture = Texture.fromBitmap(_DefendCastleAtlasBitmap);
			_DefendCastleAtlasXml = XML(new Assets.DefendCastleAtlasXml);
			
			_defendCastleTextureAtlas = new TextureAtlas(_DefendCastleAtlasTexture, _DefendCastleAtlasXml);
			
			guyFrames = fpMinesweeper2TextureAtlas.getTextures("guy_walking_brime/GuyWalking");
			
			
			gameBgT = _defendCastleTextureAtlas.getTexture("GameBg");
			bombT = _defendCastleTextureAtlas.getTexture("Bomb");
			genericPopup = _defendCastleTextureAtlas.getTexture("GenericPopup");
			greenBtnT = _defendCastleTextureAtlas.getTexture("GreenBtn");
			greenBtnDownT = _defendCastleTextureAtlas.getTexture("GreenBtnDown");
			redBtnT = _defendCastleTextureAtlas.getTexture("RedBtn");
			redBtnDownT = _defendCastleTextureAtlas.getTexture("RedBtnDown");
			fullPopupTest = _defendCastleTextureAtlas.getTexture("FullPopupBg");
			smallPopupTest = _defendCastleTextureAtlas.getTexture("SmallPopupBgTest");
			slotBgTest = _defendCastleTextureAtlas.getTexture("SlotTest");
			palaX = _defendCastleTextureAtlas.getTexture("palaX");
			moneyBox = _defendCastleTextureAtlas.getTexture("MoneyBox");
			addMoneyBtn = _defendCastleTextureAtlas.getTexture("addMoneyBtn");
			santa = _defendCastleTextureAtlas.getTexture("Santa");
			openSlot = _defendCastleTextureAtlas.getTexture("OpenSlot");
			slotty = _defendCastleTextureAtlas.getTexture("slotty");
			slottySelect = _defendCastleTextureAtlas.getTexture("slottySelect");
			elfGuy = _defendCastleTextureAtlas.getTexture("elfGuy");
			scroller = _defendCastleTextureAtlas.getTexture("Scroller");
			levelBox = _defendCastleTextureAtlas.getTexture("LevelBox");
			heartLevelBox = _defendCastleTextureAtlas.getTexture("HeartLevelBox");
			throwOnlyBox = _defendCastleTextureAtlas.getTexture("throwOnlyBox");
			magicOnlyBox = _defendCastleTextureAtlas.getTexture("magicOnlyBox");
			impossibleModeBox = _defendCastleTextureAtlas.getTexture("impossibleModeBox");
			coinShop = _defendCastleTextureAtlas.getTexture("coinShop");
			gamePowUpBtn = _defendCastleTextureAtlas.getTexture("gamePowUpBtn");
			shopPreviewArea = _defendCastleTextureAtlas.getTexture("ShopPreviewArea");
			shopUpgradeArea = _defendCastleTextureAtlas.getTexture("ShopUpgradeArea");
			
			createTextures(fpMinesweeperTextureAtlas);

			// text fonts
			TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new komika), XML(new komikaXml)));
			TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new basicWhiteFont), XML(new basicWhiteFontXml)), "BasicWhiteFont");
		
		
				
//			fireParticles = new ParticleDesignerPS(new XML(new FireParticle()),
//				Texture.fromBitmap(new FireParticleImage));
			
		
		
		}
		
		private static function createTextures(atlas:TextureAtlas):void
		{
			logoT = atlas.getTexture("logo");
			trace("logoT " + logoT);
			
			newGameBtnT = atlas.getTexture("buttons/newGameBtn");
			
			
		}
	}
}