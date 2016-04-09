package com.helpers
{
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class RungeKuttaMover extends Sprite
	{
		
				private var _ball:starling.display.MovieClip;
				private var _velocity:Point;
				private var _position:Point;
				private var _pixelsPerFoot:Number = 1;
				private var _oldTime:int;
				private var _bounce:Number = -.6;
				private var _gravity:Number = 260;
				private var _guy:starling.display.MovieClip;
				private var _stage:Object;
				private var _view:*;
				
				public function RungeKuttaMover(stage:Object, view:*)
				{
					_stage = stage;
					_view = view;
					init();
				}
				
				private function init():void
				{
					assignVars();
					addListeners();
					buildScreen();
					
					
					
				}
				
				private function buildScreen():void
				{
					// TODO Auto Generated method stub
					
				}
				
				private function addListeners():void
				{
					// TODO Auto Generated method stub
					
				}
				
				private function assignVars():void
				{
//					_ball.graphics.beginFill(0xff0000);
//					_ball.graphics.drawCircle(0,0,20);
//					_ball.graphics.endFill();
//					_ball.x = 50;
//					_ball.y = 50;
//					addChild(_ball);
					
//					_velocity = new Point(20,-20);
//					_position = new Point(_ball.x / _pixelsPerFoot,
//						_ball.y / _pixelsPerFoot);
//					
//					
//					_oldTime = getTimer();
//					addEventListener(Event.ENTER_FRAME, onEnterFrame);
					
				}	
				
				
				public function moveGuy(guy:starling.display.MovieClip, velocity:Point):void
				{
					trace("runge kutta moving guy");
					
					_guy = guy;
					_velocity = velocity;
					_position = new Point(guy.x / _pixelsPerFoot,
						guy.y / _pixelsPerFoot);
					
					_oldTime = getTimer();
					_stage.addEventListener(Event.ENTER_FRAME, onTheEnterFrame);
				}
				
				protected function onTheEnterFrame(event:Event):void
				{
//					trace("doing enter frame");
					var time:int = getTimer();
					var elapsed:Number = (time - _oldTime) / 1000
					_oldTime = time;
					
					var accel1:Point = acceleration(_position, _velocity);
					
					var position2:Point = new Point();
					position2.x = _position.x + _velocity.x * elapsed;
					position2.y = _position.y + _velocity.y * elapsed
					
					var velocity2:Point = new Point();
					velocity2.x = _velocity.x + accel1.x * elapsed;
					velocity2.y = _velocity.y + accel1.y * elapsed;
					
					var accel2:Point = acceleration(position2, velocity2);
					
//					trace("_position: " + _position)
//					trace("_velocity.x: " + _velocity.x)
//					trace("_velocity2.x: " + velocity2.x)
//					trace("elapsed: " + elapsed)
					
					_position.x += (_velocity.x + velocity2.x) / 2 * elapsed;
					_position.y += (_velocity.y + velocity2.y) / 2 * elapsed;
					
					_velocity.x += (accel1.x + accel2.x) / 2 * elapsed;
					_velocity.y += (accel1.y + accel2.y) / 2 * elapsed;
					
					if (_position.y > (640 - 20) / _pixelsPerFoot)
					{
						_position.y = (640 - 20) / _pixelsPerFoot;
						_velocity.y *= _bounce;
						
						_stage.removeEventListener(Event.ENTER_FRAME, onTheEnterFrame);
						_view.putInListener();
					}
					
//					if (_position.y < 0 / _pixelsPerFoot)
//					{
//						_position.y = 0 / _pixelsPerFoot
//						_velocity.y *= _bounce;
//					}
					
					if (_position.x > (960) / _pixelsPerFoot)
					{
						_position.x = (960) / _pixelsPerFoot;
						_velocity.x *= _bounce;
					}
						
					else if (_position.x < 0 / _pixelsPerFoot)
					{
						_position.x = 0 / _pixelsPerFoot
						_velocity.x *= _bounce;
					}
					
					_guy.x = _position.x * _pixelsPerFoot;
					_guy.y = _position.y * _pixelsPerFoot;
					
//					trace("position.x : " + _position.x + " position.y : " + _position.y);
//					trace("_guy.x : " + _guy.x + " _guy.y : " + _guy.y);
					
				}	
				
				
				private function acceleration(p:Point, v:Point):Point
				{
					return new Point(0, _gravity);
				}
				
				
		
		
		
	}
}