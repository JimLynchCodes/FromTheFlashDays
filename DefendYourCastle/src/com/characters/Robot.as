package com.characters
{
	
	import com.assets.CharacterAssets;
	import com.models.GameModel;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import dragonBones.Armature;
	import dragonBones.animation.WorldClock;
	import dragonBones.events.AnimationEvent;
	import dragonBones.events.ArmatureEvent;
	import dragonBones.factorys.StarlingFactory;
	
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;

	public class Robot extends Sprite
	{
		
		
		private var factory:StarlingFactory;
		public var armature:Armature;
		private var armatureClip:Sprite;
		public static var anCompleteSig:Signal = new Signal;
		public var armCreatedSignal:Signal = new Signal;
		
		public function Robot()
		{
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:starling.events.Event):void
		{
			trace("added to stage robot");
			factory = new StarlingFactory();
			factory.addEventListener(flash.events.Event.COMPLETE, textureCompleteHandler);
			
			/** !!!!! **/
			
			
			
			switch (GameModel.poolCreationEnemy)
			{
				case "Peasant":
					factory.parseData(new CharacterAssets.ArcherResource);	
					break;
				
				case "Archer":
					factory.parseData(new CharacterAssets.ArcherResource2);	
					break;
				
				case "Turtle":
					factory.parseData(new CharacterAssets.RobotResource1());	
					break;
				
				case "Wizard":
					factory.parseData(new CharacterAssets.RobotResource1());	
					break;
				
				case "Bird":
					factory.parseData(new CharacterAssets.RobotResource1());	
					break;
				
				case "Frog":
					factory.parseData(new CharacterAssets.RobotResource1());	
					break;
				
				case "Penguin":
					factory.parseData(new CharacterAssets.RobotResource1());	
					break;
				
				case "Dragon":
					factory.parseData(new CharacterAssets.RobotResource1());	
					break;
				
			}
			
		}		
		
		protected function textureCompleteHandler(event:flash.events.Event):void
		{
			trace("texture done");
			
//			var enemyType:String = "Peasant";
			switch (GameModel.poolCreationEnemy)
			{
				case "Peasant":
					armature = factory.buildArmature("knight");	
					break;
				
				case "Archer":
					armature = factory.buildArmature("knight");
					break;
				
				case "Turtle":
					armature = factory.buildArmature("robot");					
					break;
				
				case "Wizard":
					armature = factory.buildArmature("robot");					
					break;
				
				case "Bird":
					armature = factory.buildArmature("robot");					
					break;
				
				case "Frog":
					armature = factory.buildArmature("robot");					
					break;
				
				case "Penguin":
					armature = factory.buildArmature("robot");					
					break;
				
				case "Dragon":
					armature = factory.buildArmature("robot");					
					break;
				
			}
			
			armatureClip = armature.display as Sprite
//			armature.addEventListener(dragonBones.events.AnimationEvent.COMPLETE, aramtureAnimCompleteHandler);
//			armature.addEventListener(dragonBones.events.AnimationEvent.LOOP_COMPLE/TE, aramtureLoopCompleteHandler);
//			armature.addEventListener(dragonBones.events.AnimationEvent.START, aramtureAnimStartHandler);
			addChild(armatureClip);
			WorldClock.clock.add(armature);
			armature.animation.gotoAndPlay("run");
			armatureClip.scaleX = 1.5;
			armatureClip.scaleY = 1.5;
			
				
//				Event.COMPLETE, aramtureEventHandler);
//			armatureClip.x = 100;
//			armatureClip.y = 100;
			
			armatureClip.addEventListener(TouchEvent.TOUCH, onRobotTouch);
			
			armCreatedSignal.dispatch();
		}
		
		private function aramtureAnimStartHandler(e:AnimationEvent):void
		{
			trace("start complete" + e.animationState.name + " " + e.armature + " " )
			
		}
		
		private function aramtureLoopCompleteHandler(e:AnimationEvent):void
		{
			trace("loop complete" + e.animationState + " " + e.armature + " " )
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
			
			}
		}
		
		private function onRobotTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.target as DisplayObject);
			
			if (touch)
			{
				switch(touch.phase)
				{
					case "began":
						armature.animation.gotoAndPlay("grabbed");
//					case "ended":
//						armature.animation.gotoAndPlay("grabbed");
				}
			}
			
		}
		
		
		public function playRunningAnimation():void
		{
			armature.animation.gotoAndPlay("run");
		}
		
		public function playAttackingAnimation():void
		{
			armature.animation.gotoAndPlay("attack");
		}
		
		
		
		public function playDieingAnimation():void
		{
			armature.animation.gotoAndPlay("hitGroundDead");
		}
		
		
		
		public function playThrownAnimation():void
		{
			armature.animation.gotoAndPlay("thrown");
			
		}
		
		public function platHitGroundRecoverAnimation():void
		{
			armature.animation.gotoAndPlay("hitGroundRecover");
			
		}
	}
}