package com
{
////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////// import classes
////////////////////////////////////////////////////////////////////////////////////
	import com.doitflash.consts.Easing;
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.ScrollConst;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.utils.scroll.TouchScroll;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	/**
	 * How to use TouchScroll.
	 * @author Ali Tavakoli - 1/28/2013 3:56 PM
	 * 
	 */
	public class MainFla extends MovieClip 
	{
////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////// properties
////////////////////////////////////////////////////////////////////////////////////
		
		private var _scroller:TouchScroll;
		
		
//		[Embed (source = "assets/graphic.swf", symbol = "Content")]
//		private var Content:Class; // embed a class from external SWF >> "http://www.flashdevelop.org/community/viewtopic.php?t=1796"
//		private var _content:*;
		
		
		
		
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////// constructor function
////////////////////////////////////////////////////////////////////////////////////
		private var _rect:Sprite;
		private var _content:Sprite;
		/**
		 * constructor function.
		 */
		public function MainFla():void 
		{
			
			assignVars();
			
			// set the stage alighnment
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			this.stage.addEventListener(Event.RESIZE, onResize);
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, start, false, 0, true);
		}
		
		private function assignVars():void
		{
			var _rectClass:Class = getDefinitionByName("rectClass") as Class;
			_rect = new _rectClass() as Sprite;
			_content = _rect;
		}
		
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////// private function
////////////////////////////////////////////////////////////////////////////////////
		
		private function start(e:Event = null):void 
		{
			setScroller();
			onResize();
		}
		
		private function setScroller():void
		{
			if (!_scroller) 
			{
				_scroller =  new TouchScroll();
				
//				_content = new Content();
//				_content.txt.autoSize = TextFieldAutoSize.LEFT;
			}
			
			//------------------------------------------------------------------------------ set Scroller
			_scroller.maskContent = _content;
			_scroller.enableVirtualBg = true;
			_scroller.mouseWheelSpeed = 5;
			
			_scroller.orientation = Orientation.VERTICAL; // accepted values: Orientation.AUTO, Orientation.VERTICAL, Orientation.HORIZONTAL
			_scroller.easeType = Easing.Strong_easeOut;
			_scroller.scrollSpace = 0;
			_scroller.aniInterval = 1;
			_scroller.blurEffect = false;
			_scroller.lessBlurSpeed = 15;
			_scroller.yPerc = 25; // min value is 0, max value is 100
			_scroller.xPerc = 0; // min value is 0, max value is 100
			_scroller.mouseWheelSpeed = 2;
			_scroller.isMouseScroll = false;
			_scroller.isTouchScroll = true;
			_scroller.bitmapMode = ScrollConst.NORMAL; // use it for smoother scrolling, special when working on mobile devices, accepted values: "normal", "weak", "strong"
			_scroller.isStickTouch = false;
			_scroller.holdArea = 7;
			
			this.addChild(_scroller);
		}
		
		// ==================================================================================
		// ================================================================= main functions
		// ==================================================================================
		
		private function onResize(e:*=null):void 
		{
			if (_scroller)
			{
				_scroller.maskWidth = 285;
				_scroller.maskHeight = 383;
				
				_scroller.x = 100;
				_scroller.y = 64;
			}
		}
		
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
	}
}