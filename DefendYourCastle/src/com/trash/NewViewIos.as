package com.trash
{
	import com.assets.Assets;
	import com.controllers.DCController;
	import com.managers.SharedObjectManager;
	import com.models.GameModel;
	import com.states.GameLostState;
	import com.states.IDCState;
	import com.states.MainMenuState;
	import com.states.PlayState;
	import com.states.ShopState;
	import com.states.TestState;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class NewViewIos extends Sprite
	{
		private var _model:Object;
		private var _controller:DCController;
		private var _configu:Object;
		
		
//		public static const MAIN_MENU_STATE		: int = 3;
		
		
//		public static const GAME_LOAD_STATE	: int = 0;
		public static const MAIN_MENU_STATE		: int = 3;
//		public static const MAP_LOAD_STATE	: int = 6;
//		public static const MAP_SELECT_STATE: int = 9;
		public static const PLAY_STATE		: int = 12;
		public static const SHOP_STATE	: int = 15;
		public static const GAME_OVER_STATE : int = -1;
		
		public static const TEST_STATE : int = 99;
		
		public static var so:SharedObjectManager = SharedObjectManager.getInstance();
		public var currentState:IDCState;
		
		public function NewViewIos()
		{
			trace('new view ios created');
		}
		
		public function passVars(model:Object, controller:DCController):void
		{
			_model = model;
			_controller = controller;
			_configu = _model.configu;
			
			GameModel.gameOverSig.add(onGameOverEvent);
			
//			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			init();
		}
		
		private function onGameOverEvent():void
		{
			trace("NewIosView heard the game over event!");
			changeState(-1);
		}
		
//		private function onAddedToStage():void
//		{
//			trace("newIos been added");
//			init();
//			
//		}
		
		private function init():void
		{
			Assets.createAssets();
			changeState(PLAY_STATE);
//			changeState(MAIN_MENU_STATE);
			_addUpdateListener();
		}		
		
		
			/**
			 * Updates the current state  */
		private function update():void {
			
			trace("upadte from " + currentState);
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
//					currentState = new MainMenuState(this, _model);
					break;
				
//				case MAP_SELECT_STATE:
//					currentState = new MapSelect(this);
//					break;
				
//				case MAP_LOAD_STATE:
//					currentState = new MapLoad(this);
//					break;
				
				case PLAY_STATE:
//					currentState = new ShopState(this, _model);
					break;
				
				case GAME_OVER_STATE:
//					currentState = new GameOverState(this, _model);
					break;
				
				case SHOP_STATE:
//					currentState = new Shop(this, _model);
					break;
				
				case TEST_STATE:
//					currentState = new TestState(this, _model);
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