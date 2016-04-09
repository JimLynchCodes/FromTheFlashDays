package blit_utils
{
	import flash.system.System;
	import flash.utils.getTimer;

	public class PerformanceProfiler
	{
		private var _time:uint;
		private var _fps:uint;
		private var _previousTime:uint;
		private var _times:Array = [];
		private static var _instance:PerformanceProfiler;
		
		
		
		
		public function PerformanceProfiler()
		{
		}
		
		
		public static function get i():PerformanceProfiler
		{
			if (_instance == null)
			{
				_instance = new PerformanceProfiler();
			}
			
			return _instance;
		}
		
		public function get fps():uint
		{
			// Calculate the frame rate
			_time = getTimer();
				_fps = 1000 / (_time - _previousTime);
				_previousTime = getTimer();
				_times.push(_fps);
				
				var average:uint = 0;
				for (var i:int = 0; i < _times.length; i++)
				{
					average += _times[i];
					
					// Make sure that the array doesn't grow to more than 60 elements
					
					if (_times.length > 60)
					{
						// Remove the first element from the array if there are more than 60
						_times.shift();
					}
				}
		
				var averageFps:uint = uint(average/ _times.length)
				
				return averageFps;
		
		
		}
		
		public function get memory():Number
		{
			// Convert the bytes into megabytes
			var mb:Number = (System.totalMemory / 1024 / 1024) ;
			
			// Round to three decimal places
			var memory:Number = Math.round(mb*1000) / 1000;
			    memory = mb
			
			return memory
		}
		
	}
}