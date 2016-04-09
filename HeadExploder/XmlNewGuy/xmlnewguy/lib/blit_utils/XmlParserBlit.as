package blit_utils
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class XmlParserBlit
	{
		private var _xmlDataAry:Array = [];
		private var _xmlPath:String;
		private var _testXml:XML;
		private var _testXmlRequest:URLRequest;
		private var _testXmlLoader:URLLoader;
		
		private var _endNameValueIndex:int;
		private var _spriteNameValue:String;
		private var _begXValueIndex:int;
		private var _endXValueIndex:int;
		private var _begYValueIndex:int;
		private var _endYValueIndex:int;
		private var _begWidthValueIndex:int;
		private var _endWidthValueIndex:int;
		private var _begHeightValueIndex:int;
		private var _endHeightValueIndex:int;
		private var _begXOffsetValueIndex:int;
		private var _endXOffsetValueIndex:int;
		private var _begYOffsetValueIndex:int;
		private var _endYOffsetValueIndex:int;
		private var _nameValue:Number;
		private var _xValue:Number;
		private var _yValue:Number;
		private var _widthValue:Number;
		private var _heightValue:Number;
		private var _xOffsetValue:Number;
		private var _yOffsetValue:Number;
		private var _begNameValueIndexD:int;
		private var _yOffsetValueD:String;
		private var _endYOffsetValueIndexD:int;
		private var _begYOffsetValueIndexD:int;
		private var _xOffsetValueD:String;
		private var _endXOffsetValueIndexD:int;
		private var _begXOffsetValueIndexD:int;
		private var _heightValueD:String;
		private var _endHeightValueIndexD:int;
		private var _begHeightValueIndexD:int;
		private var _widthValueD:String;
		private var _endWidthValueIndexD:int;
		private var _begWidthValueIndexD:int;
		private var _yValueD:String;
		private var _endYValueIndexD:int;
		private var _begYValueIndexD:int;
		private var _xValueD:String;
		private var _endXValueIndexD:int;
		private var _begXValueIndexD:int;
		private var _nameValueD:String;
		private var _endNameValueIndexD:int;
		private var _begNameValueIndex:int;
		private var _xmlLineString:Object;
		private var _loadedXML:XML;
		private var _model:Object;
		
		public function XmlParserBlit()
		{
		}
		
		
		
		public function getArrayFromLoadedXml(loadedXml:XML):Array
		{
			_loadedXML = loadedXml;
			
			var theSprites:XMLList = _loadedXML..sprite
			
			//--------------------------------------
			//	create the rectangles
			//--------------------------------------
			
			for each ( var _rectSprite:XML in theSprites)
			{
				
				_xmlLineString = _rectSprite.toXMLString();
				
				_begNameValueIndex = _xmlLineString.indexOf('\"') + 1;
				_endNameValueIndex = _xmlLineString.indexOf('\"', ( _begNameValueIndex + 1)) -4;
				_nameValue = _xmlLineString.substring(_begNameValueIndex, _endNameValueIndex);
				
				_begXValueIndex = _xmlLineString.indexOf('\"', (_endNameValueIndex + 1) ) + 5;
				_endXValueIndex = _xmlLineString.indexOf('\"', ( _begXValueIndex + 1));
				_xValue = _xmlLineString.substring(_begXValueIndex, _endXValueIndex);
				
				_begYValueIndex = _xmlLineString.indexOf('\"', (_endXValueIndex + 1)) + 1;
				_endYValueIndex = _xmlLineString.indexOf('\"', ( _begYValueIndex + 1));
				_yValue = _xmlLineString.substring(_begYValueIndex, _endYValueIndex);
				
				_begWidthValueIndex = _xmlLineString.indexOf('\"', (_endYValueIndex + 1)) + 1;
				_endWidthValueIndex = _xmlLineString.indexOf('\"', ( _begWidthValueIndex + 1));
				_widthValue = _xmlLineString.substring(_begWidthValueIndex, _endWidthValueIndex);
				
				_begHeightValueIndex = _xmlLineString.indexOf('\"', (_endWidthValueIndex + 1)) + 1;
				_endHeightValueIndex = _xmlLineString.indexOf('\"', ( _begHeightValueIndex + 1));
				_heightValue = _xmlLineString.substring(_begHeightValueIndex, _endHeightValueIndex);
				
				_begXOffsetValueIndex = _xmlLineString.indexOf('\"', (_endHeightValueIndex + 1)) + 1;
				_endXOffsetValueIndex = _xmlLineString.indexOf('\"', ( _begXOffsetValueIndex + 1));
				_xOffsetValue = _xmlLineString.substring(_begXOffsetValueIndex, _endXOffsetValueIndex);
				
				_begYOffsetValueIndex = _xmlLineString.indexOf('\"',(_endXOffsetValueIndex + 1)) + 1;
				_endYOffsetValueIndex = _xmlLineString.indexOf('\"', ( _begYOffsetValueIndex + 1));
				_yOffsetValue = _xmlLineString.substring(_begYOffsetValueIndex, _endYOffsetValueIndex);
				
				
			
				var _rectangle:Rectangle = new Rectangle(_xValue, _yValue, _widthValue, _heightValue);
				
				var miniAry:Array = [_rectangle, _xOffsetValue, _yOffsetValue]
				
				_xmlDataAry.push(miniAry);
				
				
				
			}
			
			return _xmlDataAry;
			
		}
		
		
	}
}