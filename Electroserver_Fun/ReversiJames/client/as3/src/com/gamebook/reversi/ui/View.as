package com.gamebook.reversi.ui 
{
	import com.gamebook.lobby.ui.TextLabel;
	import com.gamebook.reversi.Reversi;
	import com.gamebook.reversi.GameConstants;
	import com.gamebook.shared.SharedConstants;
	import fl.controls.Button;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;

	public class View extends Sprite  {
		
		private static const TIMER_X:int = 400;
		private static const TIMER_Y:int = 50;
		private var _controller: Reversi;
		private var _background : Bitmap;
		private var _counter: Counter;
		private var _waitingMessage: TextField;
		private var _errorMessage: TextField;
		private var _lobbyButton: Button;
		
		public function View(controller: Reversi) {
			_controller = controller;
			
			initGrid();
			makeCounter();
			makeLobbyButton()
			makeLabels();
		}
		
		public function destroy():void {
			if (_counter) {
				_counter.stopCountdown();
			}
		}
		
		private function initGrid():void {
			var id:int = 0;
			var x:int = 100;
			var y:int = 100;
			
			for (var ii:int = 0; ii < GameConstants.BOARD_SIZE; ii++) {
				for (var jj:int = 0; jj < GameConstants.BOARD_SIZE; jj++) {
					var tile:Tile = _controller.tiles[id];
					tile.x = x;
					tile.y = y;
					tile.visible = true;
					addChild(tile);
					//trace("tile " + id + " added to view");
					id++;
					y = y + GameConstants.TILE_SIZE;
				}
				y = 100;
				x = x + GameConstants.TILE_SIZE;
			}
			
		}
		
		private function makeLabels():void {
			_waitingMessage = makeOneLabel();

			_waitingMessage.x = 100;
			_waitingMessage.y = 50;
		
			_waitingMessage.text = "Waiting for opponent";
			addChild(_waitingMessage);
			
			_errorMessage = makeOneLabel();
			_errorMessage.x = 100;
			_errorMessage.y = 70;
		
			_errorMessage.text = "";
			addChild(_errorMessage);
			
		}
		
		public function updateWaitingMessage(value:String):void {
			_waitingMessage.text = value;
		}
		
		public function updateErrorMessage(value:String):void {
			_errorMessage.text = value;
		}
		
		public function startTimer(value:int):void {
			// TODO: stop any timer that is running
			
			setCounter(value);
			showCounter();
			
			// TODO: start a new ticker
		}
		
		private function makeOneLabel():TextField {
			var label:TextField = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.selectable = false;
			var format : TextFormat = new TextFormat();
			//var font : MyFont ;
			//format.font = MyFont.FONT_NAME;
			format.color = 0x333333;
			format.size = 20;	
			format.bold = true;
		
			label.defaultTextFormat = format;
			return label;
		}
		
		private function makeLobbyButton():void {
			_lobbyButton = new Button();
			_lobbyButton.label = "Back to Lobby";
			_lobbyButton.width = 150;
			_lobbyButton.x = 150;
			_lobbyButton.y = 400;
			_lobbyButton.addEventListener(MouseEvent.CLICK, onLobbyClick);
			addChild(_lobbyButton);
		}
		
		public function hideLobbyButton():void {
			_lobbyButton.visible = false;
		}
		
		public function showLobbyButton():void {
			_lobbyButton.visible = true;
		}
		
		private function onLobbyClick(e:MouseEvent):void {
			_controller.onLobbyClick();
		}
		
		private function makeCounter():void {
			if (!_counter) {
				_counter = new Counter(0xB0171F);
				_counter.x = TIMER_X;
				_counter.y = TIMER_Y;
				addChild(_counter);
			}
			hideCounter();
		}
		
		public function setCounter(value:int):void {
			_counter.setValue(value);
		}
		
		public function showCounter():void {
			_counter.visible = true;
		}
		
		public function hideCounter():void {
			_counter.stopCountdown();
			_counter.visible = false;
		}
		
		
	}
	
}