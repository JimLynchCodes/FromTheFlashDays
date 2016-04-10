package com.electrotank.examples.avatarchat.avatar {


import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import flash.events.KeyboardEvent;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.ui.Keyboard;

import flash.filters.GlowFilter;

import flash.utils.getTimer; // function import
import flash.utils.Timer;
import com.electrotank.examples.avatarchat.player.Player;

import com.electrotank.logging.adapter.ILogger;
import com.electrotank.logging.adapter.Log;
import com.electrotank.utils.LogUtil;

public class GenericAvatar extends Sprite
{
	private static const log:ILogger = Log.getLogger(LogUtil.categoryFor(prototype));		

	public function GenericAvatar (player:Player)
    {
        _control = new AvatarControl(player, this);
		player.avatar = this;

        addEventListener(Event.ENTER_FRAME, handleEnterFrame);

		initState();
		initButton();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		log.debug("GenericAvatar initialized");
    }
	
	public function updateSpeechBubble(txt:String):void {
		if (_bubble != null) {
			_bubble.setText(txt);
		}
	}
	
	protected function onAddedToStage(e:Event):void {
		log.debug("GenericAvatar added to stage!");
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		initButton();
		visible = true;
		width = AVATAR_WIDTH;
		height = AVATAR_HEIGHT;
		_bubble = new SpeechBubble();
		addChild(_bubble);
	}

    protected function initButton() : void {
	  if (_button != null && this.contains(_button))
		removeChild(_button);
        _button  = new Sprite();
        var g :Graphics = _button.graphics;
		var highlight :uint = 0xffffff | _buttonColor;
		var shadow :uint = 0x000000;
        g.beginFill(_buttonColor);
        g.drawCircle(0, 0, AVATAR_WIDTH - AVATAR_PADDING);
        g.endFill();
		_button.filters = [ Resources.makeBitmapFilter(highlight, shadow) ];
		_button.x = 5;
		_button.y = 5;
		_button.rotation = 0;
	  
		addChild(_button);
		initText();
    }
	
	protected function changeButtonColor(color : uint) : void {
		if (_button ==  null) return;
		_buttonColor = color;
        var g :Graphics = _button.graphics;
		var highlight :uint = 0xffffff | color;
		var shadow :uint = 0x000000;
        g.beginFill(color);
        g.drawCircle(0, 0, AVATAR_WIDTH - AVATAR_PADDING);
        g.endFill();
		_button.filters = [ Resources.makeBitmapFilter(highlight, shadow) ];
	}

    protected function updatePosition(dy : int) : void {
			var k:Number = .15;
			var xm:Number = (_targetX - x) * k;
			var ym:Number = (_targetY - y) * k;
			x += xm;
			y += ym;
		
			_button.y = 150 + dy;
    }

    protected function updateText(txt : String) : void {
	  _text = txt;

	  var size : int = getFontSize(_text);
	  _words.defaultTextFormat = makeFormatColor(size);
	  _words.text = _text.substring(0,11);
	  updatePosition(0);
    }	
	
	protected function changeTextColor(color : uint) : void {
		if (_words == null) return;
		_textColor = color;
		var size : int = getFontSize(_text);
		var newFormat:TextFormat = makeFormatColor(size);
		_words.defaultTextFormat = newFormat;
		_words.setTextFormat(newFormat);
	}
	
	protected function makeFormatColor(size:int):TextFormat {
	  //var newFormat:TextFormat = new TextFormat();
	  //newFormat.size = size;
	  //newFormat.color = _textColor;
	  //newFormat.font = "Verdana"; // FONT_VERDANA;
	//
	  //return newFormat;
	  
	  var newFormat:TextFormat = Resources.makeFormatColor(size, _textColor);
	  log.debug("makeFormatColor: " + newFormat.size + "," + newFormat.font);
	  
	  return newFormat;
	}
	
	private function getFontSize(text:String):int {
	  var size : int;
	  if (text.length < 7)
		size = 36;
	  else if (text.length < 12)
		size = 24;
	  else size = 20;
		
	  return size;
	}

    protected function initText() : void {
	  var size : int = getFontSize(_text);
	  
	  if (_words != null && this.contains(_words)) {
		  removeChild(_words);
	  }
	  _words = new TextField();
      _words.selectable = false;
	  _words.embedFonts = true;

	  var format:TextFormat = makeFormatColor(size);
	  _words.defaultTextFormat = format;
	  _words.setTextFormat(format);
      _words.border = false;
	  _words.autoSize = TextFieldAutoSize.CENTER;
	  _words.text = _text.substring(0,11);
	  _button.addChild(_words);
	  _words.y = -20;
	  _words.x = -40;
	  _words.width = AVATAR_WIDTH - 20;
	  _words.visible = true;
	  
	  log.debug("words dimen: " + _words.width + "," + _words.height);
    }

    /**
     * This is called when your avatar is unloaded.
     */
    public function handleUnload (event :Event) :void
    {
        // stop any sounds, clean up any resources that need it.  This specifically includes 
        // unregistering listeners to any events - especially Event.ENTER_FRAME
        removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
    }

    protected function handleEnterFrame (evt :Event = null) :void
    {
        var now :Number = getTimer();
        var elapsed :Number = getTimer() - _bounceStamp;
		var delta : Number;

        // compute our bounce
        var dy : int = _bounce_amplitude *
            Math.sin(elapsed * (Math.PI * 2) / _bounce_period);	

		updatePosition(dy);
    }
	
	private function initState() : void {
		_text = _control.name;
		_name = _control.name;
		_buttonColor = 0x008800;
		_textColor = 0xffffff;
		_bounce_amplitude = 10;
		_bounce_period = 1500;
		
		// TODO: randomize the initial position
		_targetX = x;
		_targetY = y;
		width = 400;
		height = 300;
	}
	
	/**
	 * Called when a plugin event triggers a position update
	 */
	public function handlePositionUpdate(toX:Number, toY:Number):void {
		_targetX = toX;
		_targetY = toY;
	}

	/**
	 * Called when a plugin event triggers a change of emotional state
	 */
	public function handleEmotionStateChange(emo:EmotionState):void {
		switch (emo) {
			case EmotionState.HAPPY:
			    _button.rotation = 90;
			    updateText( ":-)");
				changeButtonColor(0xffcc00);
				break;
			case EmotionState.SAD:
			    _button.rotation = 90;
			    updateText(  ":(");
				changeButtonColor(0x0033ff);
				break;
			case EmotionState.SURPRISED:
			    _button.rotation = 90;
			    updateText( ":O");
				changeButtonColor(0xff0099);
				break;
			case EmotionState.CONFUSED:
			    _button.rotation = 0;
			    updateText(  "O.o");
				changeButtonColor(0xf999999);
				break;
			default:
			    _button.rotation = 0;
				changeButtonColor(0x008800);
			    updateText( _name);
			    _bounce_amplitude = 10;
			    _bounce_period = 1500;
		}
	}
	
    protected var _control :AvatarControl;
    protected var _button : Sprite;
    protected var _words : TextField;
    protected var _text  : String;
	protected var _name : String;
	protected var _buttonColor : uint;
	protected var _textColor : uint;
	private var _targetX:Number;
	private var _targetY:Number;
	public static const AVATAR_WIDTH:int = 100;
	public static const AVATAR_HEIGHT:int = 100;
	public static const AVATAR_PADDING:int = 25;
	
	protected var _bubble:SpeechBubble;
	
    /** Are we moving? */ 
    protected var _moving :Boolean = false;

    /** The timestamp at which we started bouncing. */
    protected var _bounceStamp :Number = getTimer();

    /** The amplitude of our bounce, in pixels. */ 
    protected var _bounce_amplitude :int;

    /** The period of our bounce: we do one bounce every 1500 milliseconds. */
    protected var _bounce_period :int;

}
}