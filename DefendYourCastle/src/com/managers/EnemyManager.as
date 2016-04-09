package com.managers
{
	import com.assets.Assets;
	import com.leebrimelow.starling.StarlingPool;
	import com.models.GameModel;
	import com.objects.EnemyGuy;
	import com.objects.LevelDataObj;
	import com.states.PlayState;
	import com.utils.RungeKuttaMover;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.ParticleDesignerPS;
	import starling.textures.Texture;

	public class EnemyManager
	{
		private var _play:PlayState;
		private var bullets:Array;
		private static var pool:StarlingPool;
		public static var _guysOutAry:Array;
		private var count:int = 0;	
		private var _rungeKuttaMover:RungeKuttaMover;

		
		private var timeBetweenSending:int = 200;
		private var smoke:PDParticleSystem;
		private static var archerPool:StarlingPool;
		
		public function EnemyManager(play:PlayState)
		{
			_play = play
			_guysOutAry = new Array();
			GameModel.poolCreationEnemy = "Peasant"
			pool = new StarlingPool(EnemyGuy, 50)

				
			GameModel.poolCreationEnemy = "Archer"
			archerPool = new StarlingPool(EnemyGuy, 50)
			
			_rungeKuttaMover = new RungeKuttaMover(play)
				
			GameModel.gameOverSig.add(onGameLostEvent);
				
		}
		
		private function onGameLostEvent():void
		{
			trace("game lost heard by enemy manager");
		}		
		
		
		public function update():void
		{
				var g:EnemyGuy;
				var len:int = _guysOutAry.length ;
				
				if( len > 0)
				{
					for (var i:int = len - 1; i>= 0; i--)
					{
//						trace("!!" + i + " "+_guysOutAry[i].speed);
						//					
						if (_guysOutAry[i].x < 800 && _guysOutAry[i].isHeld == false && _guysOutAry[i].isFlying == false )
						{
							_guysOutAry[i].x += _guysOutAry[i].speed;
							
							
//							trace("moving guy " + _guysOutAry[i].speed);
							_guysOutAry[i].isAttacking = false;
						}
						if(_guysOutAry[i].x >= 800 && GameModel.castleHealth > 0 && GameModel.secondsLeft > 0 && _guysOutAry[i].isHeld == false)
						{
							GameModel.castleHealth -= _guysOutAry[i].damage;
							//						trace("from manager healthy " + GameModel.castleHealth);
							_guysOutAry[i].x = 800;
//							trace("at the wall x: " + _guysOutAry[i].x + "GameModel.castleHealth" + GameModel.castleHealth);
							
							
							if (!_guysOutAry[i].isAttacking)
							{
								_guysOutAry[i].isAttacking = true;
								_guysOutAry[i].playAttackingAnimation();
								
							}
							
						}
						
					}
				}
				if (count%10 == 0)
				{
					//do something six times per second
				}
		}
		
		public function fire(enemyDataObj:LevelDataObj):void
		{
			
			trace("in fire" + enemyDataObj.speed + "?" + enemyDataObj.health);
			switch(enemyDataObj.type)
			{
				case "Peasant":
					trace("enemy is a peasant");
					// pool = peasantPool
					var g:EnemyGuy = pool.getSprite() as EnemyGuy;
					
					break;
				case "Archer":
					trace("enemy is an archer");
					// pool = peasantPool
					var g:EnemyGuy = pool.getSprite() as EnemyGuy;
					
					break;
			}
			
			
			g.floorY = enemyDataObj.floorY;
			g.speed = enemyDataObj.speed;
			g.health = enemyDataObj.health;
			g.damage = enemyDataObj.damage;
			_play.addChild(g);
			_guysOutAry.unshift(g);
			
			
			trace("g.floorY" + g.floorY);
			trace("g" + g);
			trace("g.health" + g.health);
			trace("g.damage" + g.damage);
			trace("g.speed" + g.speed);
			trace("enemyDataObj" + enemyDataObj + " " + enemyDataObj.speed);
			
//			g.stopX = enemyDataObj.stopX;
//			g.floorY = 250 + Math.random() * 100;
//			g.y = g.floorY;
			g.visible = true;
			
//			g.playRunningAnimation()
			
			g.x = 0;
			g.y = g.floorY;
		}
		
		public static function destroyGuy(guy:EnemyGuy):void
		{
			trace("destory guy now! " + guy.highestY);
			
			var len:int = _guysOutAry.length;
			
			for (var j:int= len; j >=0; j--)
			{
				if (_guysOutAry[j] == guy){
					_guysOutAry.splice(j,1);
					guy.removeFromParent(true);
					
//					switch(guy
					
					returnToPool(guy)
				}
			}
			
		}
		
		private static function returnToPool(guy:EnemyGuy):void
		{
			switch(guy.type)
			{
				case "Peasant":
					pool.returnSprite(guy);
					break;
				
				case "Archer":
					archerPool.returnSprite(guy);
					break;
			}
		}
		
		public static function returnGuy(guy:EnemyGuy):void
		{
			returnToPool(guy)
			guy.removeFromParent;
			
			var len:int = _guysOutAry.length;
			
			for (var j:int= len; j >=0; j--)
			{
				if (_guysOutAry[j] == guy)
				{
					_guysOutAry.splice(j,1);
				}
			}
		}
		
		public function destroy():void
		{
			var len:int = _guysOutAry.length;
			
			// play particle effect
			
			
			
			for (var j:int= len-1; j >=0; j--)
			{
				
				if (GameModel.castleHealth > 0)
				{
					var fireParticles:ParticleDesignerPS = new ParticleDesignerPS(new XML(new Assets.FireParticle()),
						Texture.fromBitmap(new Assets.FireParticleImage));
					fireParticles.start();
					_play.addChild(fireParticles);
					fireParticles.x = _guysOutAry[j].x +  -30;
					fireParticles.start(0.2);
					fireParticles.y = _guysOutAry[j].y + 100;
					Starling.juggler.add(fireParticles);
					
				}
				
				
				_guysOutAry[j].removeFromParent(true);
//					_play.removeChil
//					_guysOutAry[j].y = 10;
					
			}
			
			
//			pool.destroy();
//			pool = null;
//			_guysOutAry = [];
		}
		
	}
}