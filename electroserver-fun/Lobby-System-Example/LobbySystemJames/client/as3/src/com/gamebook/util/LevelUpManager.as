package com.gamebook.util
{
	import com.gamebook.model.StorageModel;

	public class LevelUpManager
	{
		public function LevelUpManager()
		{
		}
		
		public static function getExpForNexTLevel():int
		{
			var exp:int;
			
			exp = 200 + StorageModel.myLevel * 20;
			StorageModel.expToNextLevel = exp;
			
			return exp;
		}
		
	}
}