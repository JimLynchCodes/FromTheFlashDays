package com.gamebook.reversi.ui 
{
	import com.electrotank.electroserver5.api.EsObject;
	import com.gamebook.reversi.Reversi;
	import com.gamebook.reversi.GameConstants;
	import com.gamebook.reversi.elements.*;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class Tile extends Sprite {
		
		private var _controller:Reversi;
		private var _color:int;
		private var _id:int;
		private var _image:Bitmap;
		
		public function Tile(id:int, color:int, controller:Reversi) 
		{
			_id = id;
			_color = color;
			updateImage();
			_controller = controller;
			addEventListener(MouseEvent.CLICK, onClickHandler);

		}
		
		private function onClickHandler (event : MouseEvent) : void {
			_controller.onTileClicked(this);
		}
		
		
		public function get image():Bitmap { return _image; }
		
		public function set image(value:Bitmap):void {
			_image = value;
		}
		
		public function get id():int { return _id; }
		public function get color():int { return _color; }
		public function updateImage():void {
			if (_image) {
				removeChild(_image);
			}
			switch (_color) {
				case GameConstants.BLACK:
					_image =  new BlackPNG();
					break;
				case GameConstants.WHITE:
					_image =  new WhitePNG();
					break;
				case GameConstants.LEGAL:
					_image =  new LegalPNG();
					break;
				default:
					_image =  new EmptyPNG();
					break;
			}
			addChild(_image);
		}
		
		public function set color(value:int):void {
			_color = value;
			updateImage();
		}
		
		public function isColorBlack():Boolean {
			return _color == GameConstants.BLACK;
		}
		
		public function toEsObject():EsObject {
			var obj:EsObject = new EsObject();
			obj.setInteger(GameConstants.ID, _id);
			obj.setBoolean(GameConstants.COLOR_IS_BLACK, isColorBlack());
			return obj;
		}
	}
	
}