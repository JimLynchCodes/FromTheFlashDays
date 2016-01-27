package com.gamebook.reversi.ui 
{
	//import com.electrotank.toyrepairshop.assembly.elements.MyFont;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.DisplayObject;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;

	public class Counter extends Sprite {
		
		private var _label:TextField;
		private var _value:int;
		private var _countdownTimer:Timer;
		
		public function Counter(color:uint) 
		{
        _label = new TextField();
        _label.autoSize = TextFieldAutoSize.CENTER;
        _label.selectable = false;
        var format : TextFormat = new TextFormat();
		//var font : MyFont ;
		//format.font = MyFont.FONT_NAME;
        format.color = color;
        format.size = 28;	
        format.bold = true;
		
        _label.defaultTextFormat = format;

        addChild(_label);

		_label.x = 0;
		_label.y = 0;
		
		_value = 0;
		_label.text = ":" + _value;
		}
		
		private function setLabelText():void {
			if (_value < 10) {
				_label.text = ":0" + _value;
			} else {
				_label.text = ":" + _value;
			}
		}
		
		public function increment():void {
			_value++;
			setLabelText();
		}
		
		public function decrement():void {
			_value--;
			if (_value < 0) {
				_value = 0;
				visible = false;
				stopCountdown();
			}
			setLabelText();
		}
		
		public function setValue(value:int):void {
			_value = value;
			setLabelText();
			visible = true;
			if (_value > 0) {
				startCountdown();
			}
		}
		
		private function onCountdownTimer(e:TimerEvent):void {
			decrement();
		}

		public function stopCountdown():void {
			if (_countdownTimer != null ) {
				_countdownTimer.stop();
				_countdownTimer.removeEventListener(TimerEvent.TIMER, onCountdownTimer);
			}
			visible = false;
		}
		
		private function startCountdown():void {
			if (null == _countdownTimer) {
				_countdownTimer = new Timer(1000);
			} else if (_countdownTimer.running) {
				stopCountdown();
			}
			_countdownTimer.start();
			_countdownTimer.addEventListener(TimerEvent.TIMER, onCountdownTimer);
			visible = true;
		}
	}
	
}