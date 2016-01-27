package com.gamebook.dig.elements {
	import com.gamebook.util.PhpManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Jobe Makar - jobe@electrotank.com
	 */
	[Embed(source='../../../../assets/dig.swf', symbol='Trowel')]
	public class UserTrowel extends MovieClip{
		
		private var _digging:Boolean;
		
		private var _targetX:Number;
		private var _targetY:Number;
		public var bubble:Bubble;
		public var bubbleTF:TextField;
		private static var instance:UserTrowel;
		private static var allowInstantiation:Boolean;
		
		public function UserTrowel()
		{
		
			if (!allowInstantiation) {
			throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
		} else {
			
			
			init();
		}

	}
			
		
		public static function getInstance():UserTrowel {
			if (instance == null) {
				allowInstantiation = true;
				
				instance = new UserTrowel();
				
				allowInstantiation = false;
			}
			
			return instance;
		}
		
	private function init():void
	{
		stop();
		_targetX = 0;
		_targetY = 0;
		
		createTextBubble();
		
		this.mouseEnabled = false;
		this.mouseChildren = false;
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
	}
	
		
		protected function onAddedToStage(event:Event):void
		{
						stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
						stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
		}
		
		private function mouseMoved(e:MouseEvent):void {
			updateTrowelPosition();
			e.updateAfterEvent();
		}
		
		private function updateTrowelPosition():void{
			//			if (!_trowel.digging) {
			this.visible = true;
			this.x = mouseX;
			this.y = mouseY;
			//			}
		}
		
		protected function onMouseLeave(event:Event):void
		{
			this.visible = false;
		}
		
		private function createTextBubble():void
		{
			bubble = new Bubble();
			addChild(bubble);
			//			bubble.visible = false;
			bubble.alpha = .2;
			bubbleTF= TextField(bubble["bubbleText"]);
			bubble.y = -30;
			bubble.x = -20;
		}
		
		public function run():void {
			var k:Number = .15;
			var xm:Number = (_targetX - x) * k;
			var ym:Number = (_targetY - y) * k;
			x += xm;
			y += ym;
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
	}	
	
}

