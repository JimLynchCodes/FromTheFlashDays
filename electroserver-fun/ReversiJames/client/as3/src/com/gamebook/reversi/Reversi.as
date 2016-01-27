package com.gamebook.reversi 
{
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.ConnectionClosedEvent;
	import com.electrotank.electroserver5.api.GenericErrorResponse;
	import com.electrotank.electroserver5.api.LeaveRoomRequest;
	import com.electrotank.electroserver5.api.PluginMessageEvent;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.PluginRequest;
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.zone.Room;
	import com.gamebook.reversi.elements.BellMP3;
	import com.gamebook.reversi.ui.Tile;
	import com.gamebook.reversi.ui.View;
	import flash.media.Sound;
	
	import com.gamebook.shared.IGame;
	import com.gamebook.shared.SharedConstants;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	
	public class Reversi extends MovieClip implements IGame
	{

		private var _es:ElectroServer;
		private var _gameRoom: Room;
		private var _gameDetails: EsObject;
		private var _gameStarted:Boolean = false;
		private var _tiles:Array;
		private var _view:View;

		private var me:String;
		private var inGame:Boolean = false;
		private var myColor:int = -1;
		private var canClick:Boolean = false;
		private var showReturnToLobbyButton:Boolean = true;
		private var audio:Sound;
		
		// constructor
		public function Reversi() {
			trace("Reversi game Created");
		}
		
		public function get display():DisplayObject {
			return display;
		}
		
		public function get tiles():Array {
			return _tiles;
		}
		
		/**
		 * Lobby calls this after a successful CreateOrJoinGameEvent and JoinRoomEvent, to pass any 
		 * variables that the game will need.
		 */
		public function initialize (es:ElectroServer, gameRoom:Room, gameDetails:EsObject) : void {
			_es = es;
			_gameRoom = gameRoom;
			_gameDetails = gameDetails;
			
			var id:int = 0;
			_tiles = new Array();
			for (var ii:int = 0; ii < GameConstants.BOARD_SIZE; ii++) {
				for (var jj:int = 0; jj < GameConstants.BOARD_SIZE; jj++) {
					_tiles[id] = new Tile(id, GameConstants.EMPTY, this);
					id++;
				}
			}
			
			_view = new View(this);
			addChild(_view);
			
			me = _es.managerHelper.userManager.me.userName;
			_es.engine.addEventListener(MessageType.ConnectionClosedEvent.name, onConnectionClosedEvent);
			_es.engine.addEventListener(MessageType.GenericErrorResponse.name, onGenericErrorResponse);
			_es.engine.addEventListener(MessageType.PluginMessageEvent.name, onPluginMessageEvent);
			
			trace("Reversi initialized");
			sendInitMeRequest();
			audio = new BellMP3();
			//testViewChanges();
		}
		
		private function testViewChanges():void {
			_view.updateWaitingMessage("Updated waiting");
			_view.updateErrorMessage("updated Error");
			_view.startTimer(30);
		}
		
		/**
		 * Called by the lobby when the game is destroyed, such as when the player returns to the lobby.
		 * Use this function to clean up details, such as removing event listeners.
		 * 
		 */
		public function destroy () : void {
			trace("Reversi destroy called");
			
			_view.destroy();
			_es.engine.removeEventListener(MessageType.ConnectionClosedEvent.name, onConnectionClosedEvent);
			_es.engine.removeEventListener(MessageType.GenericErrorResponse.name, onGenericErrorResponse);
			_es.engine.removeEventListener(MessageType.PluginMessageEvent.name, onPluginMessageEvent);
		}
		
		public function onTileClicked(tile:Tile):void {
			if (canClick) {
				trace("tile clicked: " + tile.id);
				var available:Boolean = (tile.color == GameConstants.LEGAL);
				if (available) {
					var obj : EsObject = tile.toEsObject();
					obj.setString(GameConstants.ACTION, GameConstants.MOVE_REQUEST);
					sendToPlugin(obj);
				}
			}
		}
		
		public function onLobbyClick():void {
			_view.updateWaitingMessage("Returning to Lobby");
			_view.updateErrorMessage("");
			_view.hideLobbyButton();
			_view.hideCounter();
			inGame = false;
			
			if (null != _gameRoom) {
				var lrr: LeaveRoomRequest = new LeaveRoomRequest();
				lrr.roomId = _gameRoom.id;
				lrr.zoneId = _gameRoom.zoneId;
				_es.engine.send(lrr);
				_gameRoom = null;
			}
			
			dispatchEvent(new Event(SharedConstants.BACK_TO_LOBBY));
		}
		
		public function onConnectionClosedEvent(evt:ConnectionClosedEvent ):void {
			_view.updateWaitingMessage("Connection to the server has been lost.");
			_view.updateErrorMessage("Refresh to continue.");
			inGame = false;
			_view.hideCounter();
			trace(ConnectionClosedEvent);
		}

		public function onGenericErrorResponse(evt:GenericErrorResponse ):void {
			_view.updateWaitingMessage(evt.errorType.name);
			_view.showLobbyButton();
			trace(evt.errorType.name);
		}
		
		public function onPluginMessageEvent(evt:PluginMessageEvent):void {
			if (evt.pluginName != GameConstants.PLUGIN_NAME) {
				// we aren't interested, don't know how to process it
				return;
			}

			var esob:EsObject = evt.parameters;
			//trace the EsObject payload; comment this out after debugging finishes!
			trace("Plugin event: " + esob.toString());

			//get the action which determines what we do next
			var action:String = esob.getString(GameConstants.ACTION);
			
			switch (action) {
				case GameConstants.START_GAME:
					handleStartGame(esob);
					break;
				case GameConstants.MOVE_RESPONSE:
					handleMoveResponse(esob);
					break;
				case GameConstants.MOVE_EVENT:
					handleMoveEvent(esob);
					break;
				case GameConstants.TURN_TIME_LIMIT:
					handleTurnAnnouncement(esob);
					break;
				case GameConstants.GAME_OVER:
					handleGameOver(esob);
					break;
				case GameConstants.INIT_ME:
					// for game restarts only
					handleGameRestart(esob);
					break;
				default:
					trace("Action not handled: " + action);
			}
		}
		
		private function sendInitMeRequest() : void {
			var obj:EsObject = new EsObject();
			obj.setString(GameConstants.ACTION, GameConstants.INIT_ME);
			sendToPlugin(obj);
		}
		
		
		public function handleGameRestart(obj: EsObject ):void {
			myColor = -1;

			var id:int = 0;
			_tiles = new Array();
			for (var ii:int = 0; ii < GameConstants.BOARD_SIZE; ii++) {
				for (var jj:int = 0; jj < GameConstants.BOARD_SIZE; jj++) {
					_tiles[id] = new Tile(id, GameConstants.EMPTY, this);
					id++;
				}
			}
			
			_view.hideCounter();
			removeChild(_view);
			
			_view = new View(this);
			addChild(_view);
			
			_view.updateWaitingMessage("Waiting for game to start");
			_view.updateErrorMessage("");
			inGame = false;  
			sendInitMeRequest();
		}

		public function handleGameOver(obj:EsObject ):void {
			audio.play();
			canClick = false;
			_view.showLobbyButton();
			_view.hideCounter();
			var winner:String = "";
			if (obj.doesPropertyExist(GameConstants.WINNER)) {
				winner = obj.getString(GameConstants.WINNER);
			}
			
        // If we want to display the individual scores, this 
        // unpacks the info and stores it in model for view to get. (JAVA version)
        //        HashMap scoresMap = new HashMap<String, Integer>();
        //        if (obj.variableExists(GameConstants.SCORE)) {
        //            EsObject[] scores = obj.getEsObjectArray(GameConstants.SCORE);
        //            for (EsObject playerObj : scores) {
        //                String name = playerObj.getString(GameConstants.PLAYER_NAME);
        //                int points = playerObj.getInteger(GameConstants.SCORE);
        //                scoresMap.put(name, points);
        //            }
        //            model.setScores(scoresMap);
        //        }

			_view.updateWaitingMessage("Game Over");
			_view.updateErrorMessage("Winner: " + winner);
		}


		public function handleStartGame(obj:EsObject ):void  {
			inGame = true;
			_view.hideLobbyButton();
			var chips:Array = obj.getEsObjectArray(GameConstants.CHANGED_CHIPS);
            //for (EsObject chipObj : chips) {
			for (var ii:int = 0; ii < chips.length; ii++) {
				addOrUpdateOneChip(chips[ii]);
			}
		}

		private function addOrUpdateOneChip(chipObj:EsObject ):void {
			var id:int = chipObj.getInteger(GameConstants.ID);
			var isBlack:Boolean = chipObj.getBoolean(GameConstants.COLOR_IS_BLACK);
			var color:int = GameConstants.BLACK;
			if (!isBlack) {
				color = GameConstants.WHITE;
			}
			
			var chip:Tile = _tiles[id];
			chip.color = color;
		}

		public function handleTurnAnnouncement(obj:EsObject ):void {
			audio.play();
			var playerName:String = obj.getString(GameConstants.PLAYER_NAME);
			var seconds : int = obj.getInteger(GameConstants.TURN_TIME_LIMIT);
			
			_view.startTimer(seconds);
			
			var isBlack:Boolean = obj.getBoolean(GameConstants.COLOR_IS_BLACK);
			var legalMoves : Array = obj.getIntegerArray(GameConstants.LEGAL_MOVES);

			clearLegalMoves();
			if (playerName == (me)) {
				// it's my turn!
				if (myColor < 0) {
					myColor = GameConstants.BLACK;
					if (!isBlack) {
						myColor = GameConstants.WHITE;
					}
				}
				setLegalMoves(legalMoves);
				canClick = true;
				_view.updateErrorMessage("");
			} else {
				canClick = false;
			}

			if (isBlack) {
				_view.updateWaitingMessage(playerName + "'s turn: Black");
			} else {
				_view.updateWaitingMessage(playerName + "'s turn: White");
			} 
		}

		private function clearLegalMoves():void {
			for (var ii:int = 0; ii < _tiles.length; ii++) {
				var chip:Tile = _tiles[ii];
				if (chip.color == GameConstants.LEGAL) {
					chip.color = (GameConstants.EMPTY);
				}
			}
		}

		private function setLegalMoves(legalMoves:Array):void {
			for (var ii:int = 0; ii < legalMoves.length; ii++) {
				var chip:Tile = _tiles[legalMoves[ii]];
				chip.color = GameConstants.LEGAL;
			}
		}

		public function handleMoveResponse(obj:EsObject ):void {
			// only happens if there's an error
			var error:String = obj.getString(GameConstants.ERROR_MESSAGE);
			trace("handleMoveResponse ERROR: " + error);
			_view.updateErrorMessage("ERROR: " + error);
		}

		public function handleMoveEvent(obj: EsObject ):void {
			// only happens if it's good
			if (!obj.doesPropertyExist(GameConstants.CHANGED_CHIPS)) {
				return;
			}
			var changedChips: Array = obj.getEsObjectArray(GameConstants.CHANGED_CHIPS);
			if (changedChips != null) {
				// update the board
				for (var ii :int = 0; ii < changedChips.length; ii++) {
					addOrUpdateOneChip(changedChips[ii]);
				}
			}
		}
		
		
		private function sendToPlugin(esob:EsObject):void {
	        if (_gameRoom != null && _es != null) {

				//build the request
				var pr:PluginRequest = new PluginRequest();
				pr.parameters = esob;
				pr.roomId = _gameRoom.id;
				pr.zoneId = _gameRoom.zoneId;
				pr.pluginName = GameConstants.PLUGIN_NAME;
			
				//send it
				_es.engine.send(pr);
			}
		}
		
	}
	
}