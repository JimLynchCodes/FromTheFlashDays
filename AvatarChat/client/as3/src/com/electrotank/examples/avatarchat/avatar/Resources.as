package com.electrotank.examples.avatarchat.avatar {


import flash.text.Font;
import flash.filters.GlowFilter;    
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;

import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.geom.Rectangle;

import flash.filters.BevelFilter;
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterQuality;
import flash.filters.BitmapFilterType;

import com.electrotank.examples.avatarchat.ui.MyFont;

public class Resources {

    // RESOURCE ACCESSORS

    // FORMATS

    /** Returns a new instance of text style */
    public static function makeFormatColor (size : int, color : uint) : TextFormat
    {
        var format : TextFormat = new TextFormat();
		var font : MyFont ;

        format.font = "Verdana";
        format.color = color;
        format.size = size;

        return format;
    }

    
    // FILTERS

    /** Returns a new instance of a filter for a Bevel */
    public static function makeBitmapFilter(highlightColor : int, 
			shadowColor : int) : BitmapFilter 
    {
            var distance:Number       = 3;
            var angleInDegrees:Number = 45;
            var highlightAlpha:Number = 0.8;
            var shadowAlpha:Number    = 0.8;
            var blurX:Number          = 2;
            var blurY:Number          = 2;
            var strength:Number       = 3;
            var quality:Number        = BitmapFilterQuality.HIGH;
            var type:String           = BitmapFilterType.INNER;
            var knockout:Boolean      = false;

            return new BevelFilter(distance,
                                   angleInDegrees,
                                   highlightColor,
                                   highlightAlpha,
                                   shadowColor,
                                   shadowAlpha,
                                   blurX,
                                   blurY,
                                   strength,
                                   quality,
                                   type,
                                   knockout);
    }

 
}


} // package


