package com.electrotank.examples.avatarchat.avatar {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getTimer; // function import
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import com.electrotank.logging.adapter.ILogger;
	import com.electrotank.logging.adapter.Log;
	import com.electrotank.utils.LogUtil;
	
	public class SpeechBubble extends Sprite {
		
		private static const log:ILogger = Log.getLogger(LogUtil.categoryFor(prototype));		
		private var _words:TextField;
		private var _timer : Timer;
		public static const FONT_SIZE:int = 16;
		public static const FONT_COLOR:uint = 0x333333;
		public static const FONT_BG_COLOR:uint = 0xffffff;
		public static const TIME_TO_LIVE:int = 5000;  // milliseconds
		
		public function SpeechBubble() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			log.debug("SpeechBubble initialized");
		}
		
		protected function onAddedToStage(e:Event):void {
			log.debug("SpeechBubble added to stage!");
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initBubble();
			visible = false;
		}
		
		public function setText(txt:String):void {
			log.debug("SpeechBubble setting text: " + txt);
			if (_timer != null && _timer.running) {
				_timer.stop();
			}
			_words.text = txt.substring(0,99);
			_timer = new Timer (TIME_TO_LIVE, 1);
			_timer.addEventListener (TimerEvent.TIMER, removeText);
			_words.x = - _words.width / 2;
			visible = true;
			_timer.start();
		}
		
		protected function removeText(e:Event):void {
			_words.text = "";
			visible = false;
		}

		protected function initBubble() : void {
			_words = new TextField();
			_words.border = false;
			_words.multiline = true;
			//_words.borderColor = FONT_BG_COLOR;
			_words.background = true;
			_words.backgroundColor = FONT_BG_COLOR;
			_words.selectable = false;
			_words.embedFonts = true;

			var format:TextFormat = Resources.makeFormatColor(FONT_SIZE, FONT_COLOR);
			_words.defaultTextFormat = format;
			_words.setTextFormat(format);
			_words.autoSize = TextFieldAutoSize.LEFT;
			_words.wordWrap = true;
			_words.text = "";
			addChild(_words);
			_words.x = - _words.width / 2;
			
		}
	}
	
}