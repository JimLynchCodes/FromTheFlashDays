package com.utils
{
	import com.managers.EnemyManager;
	import com.models.GameModel;
	import com.objects.EnemyGuy;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.display.MovieClip;

	public class GuyMover
	{
		
		private static var instance:GuyMover;
		private static var allowInstantiation:Boolean;
		private var _oldTime:Number = 0;
		private var _gravity:Number = 200;
		private var elapsed:Number;
		private var _bounce:Number = -.75;
		
		public function GuyMover()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
		
		}
		
		private function init():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public static function getInstance():GuyMover 
		{
			if (instance == null)
			{
				allowInstantiation = true;
				
				instance = new GuyMover();
				
				allowInstantiation = false;
			}
			return instance;
		}
		
		
		public function beginMovingGuy(guy:EnemyGuy, throwVelocity:Point):void
		{
			GameModel.guysMovingAry.push(guy)
				
//			trace("beginning to move guy: " + guy + " with throw velocity " + throwVelocity);	
//			trace("guysMovingAry.length " + GameModel.guysMovingAry.length);
				
//			guy.isHeld = false;
			
		}
		
		public function update():void
		{
			var time:int = getTimer();
			elapsed = (time - _oldTime) / 1000
			_oldTime = time;
			
//			trace("updateing guy mover ary l;ength: " + GameModel.guysMovingAry.length);
			for (var r:int = 0; r < GameModel.guysMovingAry.length; r++)
			{
				if (GameModel.guysMovingAry[r].isHeld == false)
					{
				move(GameModel.guysMovingAry[r]);
						
					}
				
			}
		}
		
		private function move(guy:EnemyGuy):void
		{
//			guy.isHeld = true;
			guy.position.x = guy.x;
			guy.position.y = guy.y;
			
			
			
			
//			trace("moving the guy!");
			var accel1:Point = acceleration(guy.position, guy.throwVelocity);
			
//			trace("accel1" + accel1)
			
			var position2:Point = new Point();
			position2.x = guy.position.x + guy.throwVelocity.x * elapsed;
			position2.y = guy.position.y + guy.throwVelocity.y * elapsed
			
			guy.throwVelocity2 = new Point();
			guy.throwVelocity2.x = guy.throwVelocity.x + accel1.x * elapsed;
			guy.throwVelocity2.y = guy.throwVelocity.y + accel1.y * elapsed;
			
			var accel2:Point = acceleration(position2, guy.throwVelocity2);
			
			guy.position.x += (guy.throwVelocity.x + guy.throwVelocity2.x) / 2 * elapsed;
			guy.position.y += (guy.throwVelocity.y + guy.throwVelocity2.y) / 2 * elapsed;
			
//			trace("NEW-> guy.position.y " + guy.position.y + " guy.throwVelocity.y " + guy.throwVelocity.y + " guy.throwVelocity2.y " + guy.throwVelocity2.y + "elapsed" + elapsed);
			
			guy.throwVelocity.x += (accel1.x + accel2.x) / 2 * elapsed;
			guy.throwVelocity.y += (accel1.y + accel2.y) / 2 * elapsed;
			
//			trace("begin guy pos x: " + guy.position.x + "y: " + guy.position.y);
//			trace("end guy pos x: " + guy.x + "y: " + guy.y);
			
//			guy.x = 0;
//			guy.y = 0;
			
			// if the guy hit the floor
			
			if (guy.position.y > guy.floorY)
			{
				guy.position.y = guy.floorY;
				guy.throwVelocity.y = 0;
				guy.isHeld = false;
//				guy.isFlying = false;
				
				checkForDeath(guy);
				
				for (var j:int = GameModel.guysMovingAry.length; j >= 0; j--)
				{
					if (guy == GameModel.guysMovingAry[j])
					{
//						checkForDeath(GameModel.guysMovingAry[j]);
						
						// removes guy from array of flying guys
						GameModel.guysMovingAry.splice(j,1);
						trace("splicing guy out of moving (flying) array!");
						
					}
				}

//				guy.removeFromParent(true);
//				pool.returnSprite(guy);
				
			}
			
			
			// bounce off of left and right walls
			if (guy.position.x > (960) )
			{
				guy.position.x = (960);
				guy.throwVelocity.x *= _bounce;
			}
				
			else if (guy.position.x < 0)
			{
				guy.position.x = 0
				guy.throwVelocity.x *= _bounce;
			}
			
			guy.x = guy.position.x;
			guy.y = guy.position.y;
			
			if (guy.y < guy.highestY)
			{
				guy.highestY = guy.y;
			}
			
		}
		
		private function checkForDeath(guy:EnemyGuy):void
		{
			trace("guy's highest Y " + guy.highestY);
			trace("guy's floorY " + guy.floorY);
			
			var heightTraveled:Number = 0;
			
			if (guy.highestY > 0)
			{
				heightTraveled = guy.floorY - guy.highestY;
			}
			else
			{
				heightTraveled = (guy.floorY) + (guy.highestY * -1);
//				guy.playHitGroundRecoverAnimation();
			}
			
			trace("guy's height traveled " + heightTraveled);
			
			guy.health -= heightTraveled;
			trace("guy's new health: " + guy.health);
			
				
			if ( guy.health <= 0)
//			if ( heightTraveled > GameModel.HEIGHT_TO_KILL)
			{
				//guy has died!
				
				guy.highestY = 1000;
				guy.throwVelocity.x = 0;
				guy.throwVelocity.y = 0;
				EnemyManager.returnGuy(guy);
//				guy.removeFromParent;
				trace("killed");
				GameModel.kills ++;
				guy.playDieingAnimation();
			}
			
			else
			{
				if (guy)
				{
					// really should play guy falling animation
					guy.playHitGroundRecoverAnimation();
					guy.isRecovering = true;
					
					
				}
			}
			
		}
		
		
		// listen for event for when guy is done recovering
		
		
		
		private function acceleration(p:Point, v:Point):Point
		{
			return new Point(0, _gravity);
		}
		
		
		public function destroy():void
		{
			
		}
		
		
	}
}