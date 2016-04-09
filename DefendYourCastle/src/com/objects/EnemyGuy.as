package com.objects
{
	import com.assets.Assets;
	import com.characters.Robot;
	import com.leebrimelow.starling.StarlingPool;
	import com.models.GameModel;
	import com.models.SaveModel;
	import com.utils.GuyMover;
	import com.utils.RungeKuttaMover;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import dragonBones.Armature;
	import dragonBones.events.AnimationEvent;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class EnemyGuy extends Sprite
	{
		private var guyMc:Robot;
		private var _isFlying:Boolean = false;
		private var _isAttacking:Boolean = false;
		private var _isHeld:Boolean = false;
		private var _highestY:int = 1000;
		private var _floorY:Number = 0;
		private var _speed:Number;
		private var _health:Number = 0;
		private var _damage:Number = 0;
		private var _stopX:Number = 0;
		private var _posAry:Array;
		private var _offsetX:Number;
		private var _offsetY:Number;
		private var _positionAry:Array;
		private var _fingerDownPosition:Point = new Point;
		private var _currentTime:int;
		private var _oldTime:int;
		private var _fingerUpPosition:Point = new Point(0,0);;
		private var _throwVelocity:Point = new Point(0,0);
		private var _guyMover:GuyMover;
		private var _throwVelocity2:Point = new Point(0,0);
		private var _position:Point = new Point(0,0);
		private var _accel1:Point = new Point(0,0);
		private var _accel2:Point = new Point(0,0);
		public var isRecovering:Boolean = false;
		public var myPool:StarlingPool;
		public var type:String;
		
		public function EnemyGuy()
		{
//			guyMc = new MovieClip(Assets.guyFrames, 3);
//			pivotX = guyMc.width * 0.5;
//			pivotY = guyMc.height;
//			this.addChild(guyMc);
			
			guyMc = new Robot();
			addChild(guyMc);
			
			type = GameModel.poolCreationEnemy;
			_guyMover = GuyMover.getInstance();
			
//			var additionalRandomY:Number = Math.random() * 250;
//			guyMc.y = additionalRandomY;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
			guyMc.armCreatedSignal.add(onArmCreated)
			
		}
		
		private function onArmCreated():void
		{
			guyMc.armature.addEventListener(dragonBones.events.AnimationEvent.COMPLETE, aramtureAnimCompleteHandler);
		}		

		public function get stopX():Number
		{
			return _stopX;
		}

		public function set stopX(value:Number):void
		{
			_stopX = value;
		}

		public function get damage():Number
		{
			return _damage;
		}

		public function set damage(value:Number):void
		{
			_damage = value;
		}

		public function get health():Number
		{
			return _health;
		}

		public function set health(value:Number):void
		{
			_health = value;
		}

		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

		public function get isAttacking():Boolean
		{
			return _isAttacking;
		}

		public function set isAttacking(value:Boolean):void
		{
			_isAttacking = value;
		}

		public function get throwVelocity2():Point
		{
			return _throwVelocity2;
		}

		public function set throwVelocity2(value:Point):void
		{
			_throwVelocity2 = value;
		}

		public function get throwVelocity():Point
		{
			return _throwVelocity;
		}

		public function set throwVelocity(value:Point):void
		{
			_throwVelocity = value;
		}

		public function get accel2():Point
		{
			return _accel2;
		}

		public function set accel2(value:Point):void
		{
			_accel2 = value;
		}

		public function get accel1():Point
		{
			return _accel1;
		}

		public function set accel1(value:Point):void
		{
			_accel1 = value;
		}

		public function get position():Point
		{
			return _position;
		}

		public function set position(value:Point):void
		{
			_position = value;
		}

		public function get posAry():Array
		{
			return _posAry;
		}

		public function set posAry(value:Array):void
		{
			_posAry = value;
		}

		public function get highestY():int
		{
			return _highestY;
		}

		public function set highestY(value:int):void
		{
			_highestY = value;
			trace("new highest Y : " + _highestY);
		}

		public function get floorY():Number
		{
			return _floorY;
		}

		public function set floorY(value:Number):void
		{
			_floorY = value;
		}

		public function get isHeld():Boolean
		{
			return _isHeld;
		}

		public function set isHeld(value:Boolean):void
		{
			_isHeld = value;
		}

		public function get isFlying():Boolean
		{
			return _isFlying;
		}

		public function set isFlying(value:Boolean):void
		{
			_isFlying = value;
		}

		private function onAddedToStage():void
		{
			trace("guy added to stage!");
//			Starling.juggler.add(guyMc);,
//			guyMc.play();
			
			
			this.addEventListener(TouchEvent.TOUCH, onTouchEvent);
			
		}
		
		private function onTouchEvent(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.target as DisplayObject);
			var guyMc:EnemyGuy = e.currentTarget as EnemyGuy;
//			trace("guyMC: " + guyMc);
			
//			trace(guyMc);
			if (touch && guyMc)
			{
				
//				_isHeld = true;
				var _fingerPos:Point = touch.getLocation(stage as DisplayObject) as Point;
				
				switch(touch.phase){
					
					case "began":
//						trace("_offsetX " + _offsetX);
//						trace("_fingerPos.x " + _fingerPos.x);
//						trace("this.x " + this.x);
						
						trace("touching guy");

						
						_offsetX = (_fingerPos.x - guyMc.x);
						_offsetY = (_fingerPos.y - guyMc.y);
						
						_currentTime = getTimer();
						_oldTime = _currentTime;
						
						_positionAry = [];
						
						_isHeld = true;
						break;
					
					case "moved":
						
						if (_isHeld == true)
						{
							trace("moving guy");
							_fingerDownPosition.x = _fingerPos.x;
							_fingerDownPosition.y = _fingerPos.y;
							
							guyMc.x = _fingerPos.x - _offsetX;
							guyMc.y = _fingerPos.y - _offsetY;
							
							
							//						trace("touch beganX: finger x: " + _fingerPos.x + " _guy: " + this.x + " offset: " + _offsetX);
							//						trace("touch beganX: finger y: " + _fingerPos.y + " _guy: " + this.y + " offset: " + _offsetY);
							//						trace("guyrealx " + this.x + "y: " + this.y);
							_currentTime = getTimer();
							
							if (_currentTime - _oldTime > 3)
							{
								var _guyPos:Point = new Point(this.x, this.y);
								_positionAry.push(_guyPos)
								_oldTime = _currentTime;
							}
							
						}
						break;
					
					case "ended":
						trace("end position" + this);
						
						_isHeld = false;
						_isFlying = true;
						_fingerUpPosition.x = _fingerPos.x 
						_fingerUpPosition.y = _fingerPos.y
						
//						trace("_throwVelocity.x  " + _throwVelocity.x );
//						trace("_positionAry.length  " + _positionAry.length );
//						trace("guyMc.x  " + guyMc.x );
						if (_positionAry[(_positionAry.length -2)])
						{
							
							_throwVelocity.x = Math.abs(_positionAry[(_positionAry.length -2)].x - guyMc.x)*SaveModel.currentVelocityNum;
							_throwVelocity.y = (_positionAry[(_positionAry.length - 2)].y - guyMc.y)*SaveModel.currentVelocityNum;
							
							if (guyMc.x < _positionAry[(_positionAry.length - 2)].x)
							{
								_throwVelocity.x = -1 * _throwVelocity.x
							}
							
							if (guyMc.y < _positionAry[(_positionAry.length - 2)].y)
							{
								_throwVelocity.y = -1 * _throwVelocity.y
							}
						}
						
						guyMc.throwVelocity.x = _throwVelocity.x
						guyMc.throwVelocity.y = _throwVelocity.y
						
						trace("guyMc.throwVelocity.x: " + guyMc.throwVelocity.x + " guyMc.throwVelocity.y " + guyMc.throwVelocity.y);
//						_guyMover.beginMovingGuy(guyMc, _throwVelocity);
						GameModel.guysMovingAry.push(guyMc);
						guyMc.playThrownAnimation();
						
						
//						trace("_fingerDownPosition.x " + this.posAry[(this.posAry.length -1)].x + " _fingerUpPosition.x " + this.x )
//						trace("_fingerDownPosition.y " + this.posAry[(this.posAry.length - 1)].y + " _fingerUpPosition.y " + this.y )
//						trace("_throwVelocity: " + _throwVelocity.x + " " + _throwVelocity.y)
						
						
//						var runge:RungeKuttaMover = _rungePool.getSprite()
						
//						runge.init(this, _throwVelocity);
//						GameModel.rungeMoverAry.unshift(runge)
//						
//						trace(GameModel.rungeMoverAry.length);
						
						//						_rungeKuttaMover.init(this, _throwVelocity);
						
						
//						for (var j:uint = 0; j < _guyPosAry.length; j++)
//						{
//							trace("ary element x: " + j + " is " + _guyPosAry[(j)].x)
//							
//						}
						break;
					
					default:
						break;		
				}
			}
			
		}
		
		
		public function playAttackingAnimation():void
		{
			guyMc.playThrownAnimation();
			trace("playing thrown animation");
		}
		
		
		public function playRunningAnimation():void
		{
			guyMc.playRunningAnimation();
			
		}
		
		
		public function playHitGroundRecoverAnimation():void
		{
			guyMc.platHitGroundRecoverAnimation();
			
//			guyMc.armature.addEventListener(dragonBones.events.AnimationEvent.COMPLETE, aramtureAnimCompleteHandler);
			
		}
		
		private function aramtureAnimCompleteHandler(e:AnimationEvent):void
		{
			
			var animStateString:String = e.animationState.name as String;
			
			//			trace(animStateString)
			//			trace("e.target " + e.target);		
			trace("e.currentTarget " + e.currentTarget);		
			
			
			
			if ( animStateString == "hitGroundRecover")
			{
				trace("hit ground animation complete" + e.animationState + " " + e.armature + " " )
				
				var arm:Armature = e.currentTarget as Armature;
				arm.animation.gotoAndPlay("run");
				
				_isFlying = false;
			}
			
			if ( animStateString == "hitGroundDead")
			{
				trace("hit grounddead animation complete" + e.animationState + " " + e.armature + " " )
				
				var arm:Armature = e.currentTarget as Armature;
				arm.animation.gotoAndPlay("run");
//				x = 0;
				visible = false;
			
				_isFlying = false;
			}
			
			
			
		}
		
		public function playDieingAnimation():void
		{
			guyMc.playDieingAnimation();
			
		}
		
		
		public function playThrownAnimation():void
		{
			guyMc.playThrownAnimation();
			
		}
	}
}