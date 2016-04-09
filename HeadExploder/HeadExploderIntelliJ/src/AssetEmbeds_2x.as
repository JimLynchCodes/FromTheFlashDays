package
{
	public class AssetEmbeds_2x
	{			
		/**		Fonts bitmaps		 ... */
		[Embed(source="/media/fonts/Eras Demi White.fnt", mimeType="application/octet-stream")]
		public static const FontXML:Class;	
		
		[Embed(source="/media/fonts/Eras Demi White.png")]
		public static const FontTexture:Class;
		
 		
		
		
		/**			Sprite sheet 1 ... */
		[Embed(source="media/textures/2x/HeadExploder1.xml", mimeType="application/octet-stream")]
		public static const AtlasXml1:Class;
		
		[Embed(source="media/textures/2x/HeadExploder1.png" )]                  	 
		public static const AtlasTexture1:Class;
 	 	
		[Embed(source="media/textures/2x/HeadExploder2.xml", mimeType="application/octet-stream")]
		public static const AtlasXml2:Class;
		
		[Embed(source="media/textures/2x/HeadExploder2.png" )]                  	 
		public static const AtlasTexture2:Class;
		
		
		

		
	 	
		/**Getting assets from 1x folder for 2x. Though assets are not yet ready i have used 1x to code roughly.  */
 		[Embed(source="media/textures/1x/MenuItemsG.xml", mimeType="application/octet-stream")]
		public static const AtlasXml3:Class;

		[Embed(source="media/textures/1x/MenuItemsG.png" )]
		public static const AtlasTexture3:Class;
		
		[Embed(source="media/textures/1x/Popups.xml", mimeType="application/octet-stream")]
		public static const AtlasXml4:Class;
		
		[Embed(source="media/textures/1x/Popups.png" )]                  	 
		public static const AtlasTexture4:Class;
 		
		
	}
}





