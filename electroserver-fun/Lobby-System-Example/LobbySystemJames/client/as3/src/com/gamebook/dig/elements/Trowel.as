package com.gamebook.dig.elements {
	import com.gamebook.model.StorageModel;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
//	import mx.managers.CursorManager;
//	import mx.managers.ICursorManager;
	
	/**
	 * ...
	 * @author Jobe Makar - jobe@electrotank.com
	 */
//	[Embed(source='../../../../assets/dig.swf', symbol='Trowel')]
	public class Trowel extends MovieClip{
		
		private var _digging:Boolean;
		
		private var _targetX:Number;
		private var _targetY:Number;
		public var bubble:Bubble;
		public var bubbleTF:TextField;
		private var trowelClip:MovieClip;
		
//		[Embed(source="cursors/redTrowel.png")]
//		private var moveArrowIcon:Class;
//		private var cursorManager:ICursorManager;
		private var _cursorClass:Class;
		private var _cursorClassName:String;
		private var cursorClass:Object;
		
		public function Trowel(cursorClassName:String) {
			
			_cursorClassName = cursorClassName;
			
			stop();
			_targetX = 0;
			_targetY = 0;
			
			createTextBubble();
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
//			CursorManager.getInstance();
			
		}
		
		protected function onAddedToStage(event:Event):void
		{
//			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			trace("trying to instantiate " + _cursorClassName);
			
			if (_cursorClassName == "false" || _cursorClassName == null)
			{
				trace("making is a Trowel");
				_cursorClassName = "BaseTrowel";
			}
			
			_cursorClass = StorageModel.loadedCursors.getDefinition(_cursorClassName) as Class
			trowelClip = new _cursorClass as MovieClip;
			this.addChild(trowelClip);
			trowelClip.stop();
		}
		
		private function createTextBubble():void
		{
			bubble = new Bubble();
			addChild(bubble);
//			bubble.visible = false;
			bubble.alpha = 0;
			bubbleTF= TextField(bubble["bubbleText"]);
			bubble.y = 0;
			bubble.x = 0;
		}
		
		public function run():void {
			
			var k:Number = .15;
			
			if (x != _targetX)
			{
				var xm:Number = (_targetX - x) * k;
				x += xm;
				
			}
			if (y != _targetY)
			{
				var ym:Number = (_targetY - y) * k;
				y += ym;
				
			}
		}
		
		public function moveTo(tx:Number, ty:Number):void {
			_targetX = tx;
			_targetY = ty;
		}
		
		public function dig():void {
			gotoAndStop(2);
			_digging = true;
		}
		
		public function stopDigging():void {
			gotoAndStop(1);
			_digging = false;
		}
		
		

		
		public function get digging():Boolean { return _digging; }
		
		public function equipNewCursor(currentTrowelClassName:String):void
		{
			
//			trowelClip.stop();
//			this.removeChild(trowelClip);

//			trowelClip.addEventListener(Event.REMOVED, onRemoved);
			
			trace("equpping");
			trace("numchildren" + numChildren)
			
			while (this.numChildren > 1)
			{
				this.removeChild(this.getChildAt(1));
				
			}
						
			
//			this.removeChild(trowelClip);
//			trowelClip.visible = false;
//			CursorManager.setCursor(moveArrowIcon);
			
//			trowelClip = null;
			
			if (currentTrowelClassName == "false")
			{
				currentTrowelClassName = "BaseTrowel";
			}
			
			cursorClass = StorageModel.loadedCursors.getDefinition(currentTrowelClassName) as Class
			trowelClip = new cursorClass() as MovieClip;
			addChild(trowelClip);
		}
		
		protected function onRemoved(event:Event):void
		{
			trace("shit and been removed!");
		}
	}
	
}