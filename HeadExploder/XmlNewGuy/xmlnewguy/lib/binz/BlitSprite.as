package com.fs.edu.explosion_guy.blit_specific
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BlitSprite extends EventDispatcher
	{
		
		private var _fullSpriteSheet:BitmapData;
		private var _rects:Array;
		private var _bitmapDataStage:BitmapData;
		
		private var pos:Point = new Point ();
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		private var _animIndex:int = 0;
		private var _loop:Boolean = false;
		private var _count:int = 0;
		
		public var animate:Boolean = false;
		private var _whiteTransparent:BitmapData;
		private var _envelopeAnimAry:Array;
		private var _model:Object;
		private var _stageHeight:uint;
		private var _stageWidth:uint;
		private var _givenName:String = null;
		
		
		
		public function BlitSprite(fullSpriteSheet:BitmapData, envelopeAnimAry:Array, bitmapDataStage:BitmapData, stageWidth:uint = 500, stageHeight:uint = 500, model:Object = null) 
		{
			_fullSpriteSheet = fullSpriteSheet;
			_envelopeAnimAry = envelopeAnimAry;
			_bitmapDataStage = bitmapDataStage;
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			_model= model;
			
			init();
		}
		
		

		public function get givenName():String
		{
			return _givenName;
		}

		public function set givenName(value:String):void
		{
			_givenName = value;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function stop():void
		{
			this.animate = false;
		}
		
		public function start():void
		{
			this.animate = true;
		}
		
		public function stopAndShutdown():void
		{
			this.animate = false;
			this.removeEventListener("ENV_ANIM_DONE", onEvnAnimDone);
			_bitmapDataStage.fillRect(new Rectangle(0,0,_stageWidth,_stageHeight), 0x0000CC);
		}
		
		
		
		private function init():void
		{
//			_whiteTransparent = new BitmapData(100, 100, true, 0x80FFffFF);
		}		
		
		protected function onEvnAnimDone(event:Event):void
		{
			
		}		
		
		public function render():void
		{
			_count++;		


				
			if (_count % 1 == 0 && animate == true)
			{
				
				
				if (_animIndex == (_envelopeAnimAry.length - 1) )
				{
					_animIndex = 0;
					
					
					if (this.givenName == "johnny")
					{
						dispatchEvent(new Event("ENV_ANIM_DONE", true));
						_bitmapDataStage.fillRect(new Rectangle(0,0,_stageWidth,_stageHeight), 0x0000CC);
					}
					
					
					
					
						/** uncomment if you want animation to only play once **/
					if (_loop == false)
					{
						animate = false;
					}
				}
					
				else 
				{
					_animIndex++;
				
//					pos.x = x - _rects[_animIndex].width*.5;
//					pos.y = y - _rects[_animIndex].width*.5;
					
					pos.x = _x; 
					pos.y = _y; 
					
					
					_bitmapDataStage.copyPixels(_fullSpriteSheet, _envelopeAnimAry[_animIndex][0], pos, null, null, true);
				
				}
			}
				
		}
		
		
		public function get animIndex():int
		{
			return _animIndex;
		}
		
		public function set animIndex(value:int):void
		{
			_animIndex = value;
		}
		
		public function get loop():Boolean
		{
			return _loop;
		}
		
		public function set loop(value:Boolean):void
		{
			_loop = value;
		}
		
		
	}
}