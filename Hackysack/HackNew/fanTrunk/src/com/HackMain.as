package com
{
	
	import com.configu.HackConfig;
	import com.controllers.HackController;
	import com.models.HackModel;
	import com.views.HackView;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;

	public class HackMain extends Sprite
	{
		
		private var _controller:HackController;
		private var _model:HackModel;
		private var _config:HackConfig;
		private var _stage:Object;
		private var _kicksTF:TextField;
		private var _guy:MovieClip;
		private var _mainView:HackView;
		private var _rect_1:Sprite;
		
		
		
		
		public function HackMain()
		{
			init();
		}
		
		
		private function init():void
		{
			
			trace("Document Class Initialized.");
			
			_guy = getChildByName("guy") as MovieClip;
			
			trace("guy width 1: " + _guy.width);
			
			_rect_1 = getChildByName("rect_1") as Sprite;
			
			_config = new HackConfig();
			_model = new HackModel(_config);
			_controller = new HackController(_model, _config);
			_mainView = new HackView(_model, _controller, _config, stage, _guy, _rect_1);
			
			addChild(_mainView);
			
//			Mouse.hide();
			_model.addEventListener(_model.config.KICKS_CHANGE, onKicksChange);
			
	
			_kicksTF = this.getChildByName("kicksTxt") as TextField;
			
			_stage = stage;
			
//			_stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			
			stage.addEventListener(MouseEvent.RIGHT_CLICK, doNothing);
			
			trace(_stage);
			
			_stage.scaleMode = StageScaleMode.NO_SCALE
		}
		
		protected function doNothing(event:MouseEvent):void
		{
			trace("nothing");
			
			
			
		}
		
		protected function onRightClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("right click");
		}		
		
		private function onKicksChange(e:Event):void
		{
			_kicksTF.text = "Kicks: " + _model.kicks;
			
		}
		
	}
}