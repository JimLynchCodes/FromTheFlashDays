package com.assets
{
	import starling.display.Sprite;
	
	public class Assets extends Sprite
	{
		public function Assets()
		{
			super();
		}
		
		
		[Embed(source = "/tp/tpOutput/FpMinesweeperAtlas_1.png")]
		public static const FpMineSweeperAtlas_1SS:Class;
		
		[Embed(source = "/tp/tpOutput/FpMinesweeperAtlas_1.xml", mimeType="application/octet-stream")]
		public static const FpMineSweeperAtlas_1Xml:Class;
		
		[Embed(source = "/tp/tpOutput2/FpMineSweeperAtlas_2.png")]
		public static const FpMineSweeperAtlas_2SS:Class;
		
		[Embed(source = "/tp/tpOutput2/FpMineSweeperAtlas_2.xml", mimeType="application/octet-stream")]
		public static const FpMineSweeperAtlas_2Xml:Class;
		
		
		[Embed(source = "/font/desyrel.png")]
		public static const DesyrelFont:Class;
		
		[Embed(source = "/font/desyrel.fnt", mimeType="application/octet-stream")]
		public static const DesyrelXML:Class;
		

		// mp3 sounds here
		//
		//	[Embed(source = "/folder/the_sound.mp3")]
		//  public static const TheSound:Class;
		//
		
	}
}