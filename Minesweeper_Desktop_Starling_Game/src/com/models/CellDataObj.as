package com.models
{
	import feathers.controls.Button;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EventDispatcher;

	
	
	
	public class CellDataObj extends EventDispatcher
	{

		private var _id:uint;
		private var _model:Object;
		private var _isRevealed:Boolean;
		private var _isABomb:Boolean = false;
		private var _isFlagged:Boolean;
		private var _flagItself:Image;
		private var _bombsNextTo:uint;
		private var _cellBtnUp:Button;
		private var _cellBtnDown:Button;
		private var _cellClickedSprite:Sprite;
		
		private var _cellSprite:Sprite;
		
		
		public function CellDataObj(model:Object)
		{
			_model = model;
		}
		
		
		public function get isRevealed():Boolean
		{
			return _isRevealed;
		}
		
		public function set isRevealed(value:Boolean):void
		{
			_isRevealed = value;
		}

		public function get isABomb():Boolean
		{
			return _isABomb;
		}

		public function set isABomb(value:Boolean):void
		{
			_isABomb = value;
		}

		public function get isFlagged():Boolean
		{
			return _isFlagged;
		}

		public function set isFlagged(value:Boolean):void
		{
			_isFlagged = value;
		}

		public function get bombsNextTo():uint
		{
			return _bombsNextTo;
		}

		public function set bombsNextTo(value:uint):void
		{
			_bombsNextTo = value;
		}

		public function get id():uint
		{
			return _id;
		}

		public function set id(value:uint):void
		{
			_id = value;
		}

		public function get cellBtnUp():Button
		{
			return _cellBtnUp;
		}

		public function set cellBtnUp(value:Button):void
		{
			_cellBtnUp = value;
		}

		public function get cellClickedSprite():Sprite
		{
			return _cellClickedSprite;
		}

		public function set cellClickedSprite(value:Sprite):void
		{
			_cellClickedSprite = value;
		}

		public function get cellSprite():Sprite
		{
			return _cellSprite;
		}

		public function set cellSprite(value:Sprite):void
		{
			_cellSprite = value;
		}

		public function get cellBtnDown():Button
		{
			return _cellBtnDown;
		}

		public function set cellBtnDown(value:Button):void
		{
			_cellBtnDown = value;
		}

		public function get flagItself():Image
		{
			return _flagItself;
		}

		public function set flagItself(value:Image):void
		{
			_flagItself = value;
		}


	}
}