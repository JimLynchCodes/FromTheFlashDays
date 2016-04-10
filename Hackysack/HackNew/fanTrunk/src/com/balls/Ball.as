package com.balls
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Ball extends Sprite
	{
		private var _model:Object;
		private var _yPower:Number = 1;
		private var _xPower:Number;
		private var _guy:Sprite;
		
		
		public function Ball(model:Object)
		{
			_model= model;			
			init();
		}
		
		public function get xPower():Number
		{
			return _xPower;
		}

		public function set xPower(value:Number):void
		{
			_xPower = value;
		}

		private function init():void
		{
			assignVars();
			addListeners();
		}
		
		private function assignVars():void
		{
			
			
		}
		
		private function addListeners():void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		protected function onAddedToStage(event:Event):void
		{
			turnOnDrop();
			_guy = _model.guy;
			
		}
		
		private function turnOnDrop():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame)
		}
		
		protected function onEnterFrame(event:Event):void
		{
			
			_yPower++;
			
			if (_yPower > 1)
			{
				_yPower = 1;
			}
			
			if (	this.hitTestObject(_model.rightFoot)  && _model.rightFoot.visible == true )
			{
				
				determineBallXPowerKickByMyLeft();
				determineBallYPowerKickByMyLeft();
				
				_model.kicks += 1;
				
				
				
			}
			
			
			else if (this.hitTestObject(_model.leftFoot) && _model.leftFoot.visible == true)
			{
				determineBallXPowerKickByMyRight();
				determineBallYPowerKickByMyRight();
				_model.kicks += 1;
				
				
				trace("collision!")
				trace("_model.rightFoot.y" +  this.y)
			}
			
			
			else
			{
				this.y = this.y + 10;
				this.x = this.x + _model.xDirection;
			}
			
			
			this.y = this.y + _yPower;
			this.x = this.x + _xPower;

			
		}		
		
		private function determineBallYPowerKickByMyRight():void
		{
			_yPower = -1 * (this.y - 100 )/ 7
		}
		
		private function determineBallYPowerKickByMyLeft():void
		{
			_yPower = -1 * (this.y - 100 )/ 7
		}
		
		private function determineBallXPowerKickByMyRight():void
		{
			var diff:Number = _guy.x - this.x
			
			trace("diff " + diff);	
				
				
			switch (true)
			{
				
				
				
				
					// determine x power
				
				case diff < -15:
					xPower = 5;
					break;
				//				
				case diff >= -15 && diff < -10:
					xPower = 3;
					break;
				
				case diff >= -10 && diff < -5:
					xPower = 1;
					break;
				
				case diff >= -5 && diff < 0:
					xPower = -1;
					break;
				
				case diff >= 0 && diff < 5:
					xPower = -3;
					break;
				
				case diff >= 5 && diff < 10:
					xPower = -5;
					break;
				
				//				case diff >= 25 && diff < 40:
				//					xPower = 5;
				//					break;
			}	
			
		}
		
		private function determineBallXPowerKickByMyLeft():void
		{
			
			var diff:Number = _guy.x - this.x
			
			
			
			
					// determine x power
			switch (true)
			{
				case diff < 10:
					xPower = 5;
					break;
				//				
				case diff >= 10 && diff < 15:
					xPower = 3;
					break;
				
				case diff >= 20 && diff < 25:
					xPower = 1;
					break;
				
				case diff >= 25 && diff < 30:
					xPower = -1;
					break;
				
				case diff >= 30 && diff < 35:
					xPower = -3;
					break;
				
				case diff >= 35 && diff < 50:
					xPower = -5;
					break;
				
				//				case diff >= 25 && diff < 40:
				//					xPower = 5;
				//					break;
				
				
			}
			
			
			trace("diff " + diff);
			
		}
		
		private function determineBallXPower():void
		{
		
			
		}		
		
		private function atTop():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame)
			
			
			
		}
			
			
			
		
	}
}