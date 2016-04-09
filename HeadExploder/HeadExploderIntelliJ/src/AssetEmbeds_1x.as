package
{
import flash.text.FontType;

import starling.text.BitmapFont;
import starling.textures.Texture;

public class AssetEmbeds_1x
{
 
 		/**		Fonts bitmaps		 ... */
		[Embed(source="media/fonts/font___0.fnt", mimeType="application/octet-stream")]
		public static const FontXML:Class;		
		
		[Embed(source="media/fonts/ubuntu.fnt", mimeType="application/octet-stream")]
		public static const FontXML1:Class;

	[Embed(source="media/glyphD fonts new/Cooper.xml", mimeType="application/octet-stream")]
	public static const CooperXml:Class;

	[Embed(source="media/glyphD fonts new/Cooper.png")]
	public static const CooperTexture:Class;

	[Embed(source="media/glyphD fonts new/Tropical-no-shadow.xml", mimeType="application/octet-stream")]
	public static const tropicalNoShadowXml:Class;

	[Embed(source="media/glyphD fonts new/Tropical-no-shadow.png")]
	public static const tropicalNoShadowTexture:Class;


	[Embed(source="media/fonts/HoboStdMedium.ttf", fontName="HoboTtfName", fontFamily="HoboTtf",mimeType="application/x-font",embedAsCFF="false")]
	public static const HoboTtf:Class;

	[Embed(source="media/sound/BombSound.mp3")]
	public static var ExplosionSound:Class;

	[Embed(source="media/sound/Ta-da-sound.mp3")]
	public static var TaDaSound:Class;

	[Embed(source="media/sound/secret-sound.mp3")]
	public static var SecretSound:Class;

		
	}
}





