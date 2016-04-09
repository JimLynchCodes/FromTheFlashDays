package objects
{
	import flash.geom.Rectangle;
	
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.VAlign;
	
	public final class MButton extends Button
	{
		public function MButton(text:String="", upState:Texture=null,  downState:Texture=null, _fontSize:Number=0)
		{
			if(!upState){				
				upState=Assets.getTextureAtlas().getTexture("mainMenuBtn00");
  			}
 
  			super(upState, text, downState);		
 			textVAlign=VAlign.CENTER;			
			fontName="EMBFonts";		
			fontSize=(_fontSize>0)?_fontSize:11;			
			fontColor=	 0x50e415						//	0xf2c835;				   
		}
	}
}


