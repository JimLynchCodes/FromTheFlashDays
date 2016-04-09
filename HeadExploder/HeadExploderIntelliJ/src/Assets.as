package {
import flash.display.Bitmap;
import flash.media.Sound;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

//	import starling.extensions.PDParticleSystem;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Assets {

    [Embed(source="media/fonts/Azkidenz white.fnt", mimeType="application/octet-stream")]
    public static const FontXml:Class;

    [Embed(source="media/fonts/Azkidenz white.png")]
    public static const FontTexture:Class;

    private static var sContentScaleFactor:int = 1;
    private static var sTextures:Dictionary = new Dictionary();
    private static var sSounds:Dictionary = new Dictionary();
    private static var sBitmapFontsLoaded:Boolean;
    private static var sEffect:Dictionary = new Dictionary();

    // New variables.
    private static var sTextureAtlas:Array = [];

    public static function getTexture(name:String):Texture {
        if (sTextures[name] == undefined) {
            var data:Object = create(name);

            if (data is Bitmap)
                sTextures[name] = Texture.fromBitmap(data as Bitmap, true, false, sContentScaleFactor);
            else if (data is ByteArray)
                sTextures[name] = Texture.fromAtfData(data as ByteArray, sContentScaleFactor);
        }

        return sTextures[name];
    }


    public static function getTextureAtlas(_index:uint = 1):TextureAtlas {
        if (sTextureAtlas[_index - 1] == null) {
            var texture:Texture = getTexture("AtlasTexture" + _index);
            var xml:XML = XML(create("AtlasXml" + _index));
            sTextureAtlas[_index - 1] = new TextureAtlas(texture, xml);
        }

        return sTextureAtlas[_index - 1];
    }

    public static function loadBitmapFonts():void {
        if (!sBitmapFontsLoaded) {
            var texture:Texture = Texture.fromEmbeddedAsset(FontTexture); // getTexture("FontTexture");
            var xml:XML = XML(new FontXml());
            TextField.registerBitmapFont(new BitmapFont(texture, xml), "AkzidenzGroteskBQ-BoldItalic");   // Eras Demi White

            sBitmapFontsLoaded = true;

            var tropicalNoShadowTexture:Texture = Texture.fromEmbeddedAsset(AssetEmbeds_1x.tropicalNoShadowTexture); // getTexture("FontTexture");
            var tropicalNoShadowXml:XML = XML(new AssetEmbeds_1x.tropicalNoShadowXml);
            TextField.registerBitmapFont(new BitmapFont(tropicalNoShadowTexture, tropicalNoShadowXml), "HoboStd");   // Eras Demi White

            var cooperTexture:Texture = Texture.fromEmbeddedAsset(AssetEmbeds_1x.CooperTexture); // getTexture("FontTexture");
            var cooperXml:XML = XML(new AssetEmbeds_1x.CooperXml);
            TextField.registerBitmapFont(new BitmapFont(cooperTexture, cooperXml), "BM-CooperBlackStd");   // Eras Demi White


        }
    }

    private static function create(name:String):Object {
        var textureClass:Class = AssetEmbeds_2x       // sContentScaleFactor == 1 ? AssetEmbeds_1x : AssetEmbeds_2x;
//			trace("sContentScaleFactor :: "+sContentScaleFactor)
        return new textureClass[name];
    }

    public static function get contentScaleFactor():Number {
        return sContentScaleFactor;
    }

    public static function set contentScaleFactor(value:Number):void {
        for each (var texture:Texture in sTextures)
            texture.dispose();

        sTextures = new Dictionary();
        sContentScaleFactor = 2    //  value < 2 ? 1 : 2;
    }

}
}





