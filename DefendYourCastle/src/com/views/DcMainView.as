package com.views
{
	import com.assets.Assets;
	import com.controllers.DCController;
	import com.managers.SharedObjectManager;
	import com.models.GameModel;
	import com.states.AchievementRewardsState;
	import com.states.AchievementsState;
	import com.states.BuyCurrencyState;
	import com.states.CreditsState;
	import com.states.ExchangeCurrencyState;
	import com.states.GameLostState;
	import com.states.HowToPlayState;
	import com.states.IDCState;
	import com.states.LevelSelectState;
	import com.states.LoadGameState;
	import com.states.MainMenuState;
	import com.states.PlayState;
	import com.states.SetPowerupState;
	import com.states.ShopState;
	import com.states.TestState;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class DcMainView extends Sprite
	{
		private var _model:Object;
		private var _controller:DCController;
		private var _configu:Object;
		
		
		public static const MAIN_MENU_STATE		: int = 3;
		public static const HOW_TO_PLAY_STATE		: int = 13;
		public static const CREDITS_STATE	: int = 2;
		public static const PLAY_STATE		: int = 17
		public static const SHOP_STATE	: int = 15;
		public static const GAME_OVER_STATE : int = -1;
		public static const LEVEL_SELECT_STATE : int = 35;
		public static const ACHIEVEMENTS_STATE : int = 34
		public static const ACHIEVEMENT_REWARDS_STATE : int = 33
		public static const SET_POWERUP_STATE : int = 32
		public static const BUY_CURRENCY_STATE : int = 31
		public static const EXCHANGE_CURRENCY_STATE : int = 30
		public static const VIDEO_AD_STATE : int = 29
		
		public static const TEST_STATE : int = 99;
		
		
		public static var so:SharedObjectManager = SharedObjectManager.getInstance();
		public var currentState:IDCState;
		public static var LOAD_GAME_STATE:int = 24;
		
		public function DcMainView()
		{
			trace('dc view created');
			
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			init();
		}
		
		private function onGameOverEvent():void
		{
			trace("NewIosView heard the game over event!");
			changeState(-1);
		}
		
		private function init():void
		{
			Assets.createAssets();
			
			/** change this to the state currently being tested **/
			
			changeState(MAIN_MENU_STATE);
			_addUpdateListener();
			
		}		
		
		
			/**
			 * Updates the current state  */
		private function update():void {
			
//			trace("upadte from " + currentState);
			currentState.update();
		}
		
			/**
			 * Adds update listener */
		private function _addUpdateListener():void {
			addEventListener(Event.ENTER_FRAME, update);
		}
		
			/**
			 * Removes update listener
			 */
		private function _removeUpdateListener():void {
			removeEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * Changes state to the new state specified by state param
		 * @param int state the state constant to change to
		 */
		public function changeState(state:int):void {
//			Config.log('Game', 'changeState', 'Changing state to ' + state);
			trace("changing game state to: " + state);
			var removed:Boolean = false;
			
			if(currentState != null) {
				_removeUpdateListener();
				currentState.destroy();
				removeChild(Sprite(currentState));
				currentState = null;
				removed = true;	
			}
			
			switch(state) {
//				case GAME_LOAD_STATE:
//					currentState = new GameLoad(this);
//					break;
				
				case MAIN_MENU_STATE:
					currentState = new MainMenuState(this, _model);
					break;
				
				case HOW_TO_PLAY_STATE:
					currentState = new HowToPlayState(this, _model);
					break;
				
				
				case LOAD_GAME_STATE:
					currentState = new LoadGameState(this, _model);
					break;
				
				case LEVEL_SELECT_STATE:
					currentState = new LevelSelectState(this, _model);
					break;
				
				case CREDITS_STATE:
					currentState = new CreditsState(this, _model);
					break;
				
				case ACHIEVEMENTS_STATE:
					currentState = new AchievementsState(this, _model);
					break;
				
				case ACHIEVEMENT_REWARDS_STATE:
					currentState = new AchievementRewardsState(this, _model);
					break;
				
				case SET_POWERUP_STATE:
					currentState = new 	SetPowerupState(this, _model);
					break;
				
				case BUY_CURRENCY_STATE:
					currentState = new BuyCurrencyState(this, _model);
					break;
				
				case EXCHANGE_CURRENCY_STATE:
					currentState = new 	ExchangeCurrencyState(this, _model);
					break;
				
				case VIDEO_AD_STATE:
					currentState = new 	VideoAdState(this);
					break;
				
				
//				case MAP_SELECT_STATE:
//					currentState = new MapSelect(this);
//					break;
				
//				case MAP_LOAD_STATE:
//					currentState = new MapLoad(this);
//					break;
				
				case PLAY_STATE:
					currentState = new PlayState(this, _model);
					trace("changing to play");
					break;
				
				case GAME_OVER_STATE:
					currentState = new GameLostState(this, _model);
					break;
				
				case SHOP_STATE:
					currentState = new ShopState(this, _model);
					break;
				
				case TEST_STATE:
					currentState = new TestState(this, _model);
					break;
			}
			
			stage.addChild(Sprite(currentState));
			
			trace("state is now " + currentState);
			if(removed) {
				// Add update listeners back
				_addUpdateListener();
				removed = false;
			}
		}
	}
}