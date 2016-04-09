package com.objects
{
	public class LevelDataObj extends Object
	{
		
		private var _type:String;
		private var _speed:Number;
		private var _goldRewardOnDeath:int;
		private var _floorY:Number;
		private var _timeSent:Number;
		private var _health:Number;
		private var _damage:Number;
		private var _weight:Number;
		private var _stopX:Number;
		
		public function LevelDataObj()
		{
			super();
		}


		public function get stopX():Number
		{
			return _stopX;
		}

		public function set stopX(value:Number):void
		{
			_stopX = value;
		}

		public function get weight():Number
		{
			return _weight;
		}

		public function set weight(value:Number):void
		{
			_weight = value;
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

		public function get timeSent():Number
		{
			return _timeSent;
		}

		public function set timeSent(value:Number):void
		{
			_timeSent = value;
		}

		public function get floorY():Number
		{
			return _floorY;
		}

		public function set floorY(value:Number):void
		{
			_floorY = value;
		}

		public function get goldRewardOnDeath():int
		{
			return _goldRewardOnDeath;
		}

		public function set goldRewardOnDeath(value:int):void
		{
			_goldRewardOnDeath = value;
		}

		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

	}
}