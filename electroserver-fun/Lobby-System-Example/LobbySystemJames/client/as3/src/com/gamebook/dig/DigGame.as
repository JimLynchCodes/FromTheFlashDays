package com.gamebook.dig {
	import com.electrotank.electroserver5.ElectroServer;
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.LeaveRoomRequest;
	import com.electrotank.electroserver5.api.MessageType;
	import com.electrotank.electroserver5.api.PluginMessageEvent;
	import com.electrotank.electroserver5.api.PluginRequest;
	import com.electrotank.electroserver5.api.PrivateMessageRequest;
	import com.electrotank.electroserver5.api.PublicMessageEvent;
	import com.electrotank.electroserver5.api.PublicMessageRequest;
	import com.electrotank.electroserver5.user.User;
	import com.electrotank.electroserver5.zone.Room;
	import com.gamebook.dig.elements.Background;
	import com.gamebook.dig.elements.Item;
	import com.gamebook.dig.elements.Trowel;
	import com.gamebook.dig.player.Player;
	import com.gamebook.dig.player.PlayerManager;
	import com.gamebook.lobby.LobbyFlow;
	import com.gamebook.lobby.states.IState;
	import com.gamebook.model.StorageModel;
	import com.gamebook.util.LevelUpManager;
	import com.gamebook.util.PhpManager;
	import com.gamebook.util.TransitionManager;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import mochi.as3.MochiAd;
	
	import org.osflash.signals.Signal;
	
	import playerio.Client;
	import playerio.PlayerIOError;
	
	/**
	 * ...
	 * @author Jobe Makar - jobe@electrotank.com
	 */
	public dynamic class DigGame extends MovieClip implements IState{
		
		public static const BACK_TO_LOBBY:String = "backToLobby";
		public static const SEACH_CANCELED:String = "saerchCanceled";
		
		public var _es:ElectroServer;
		public var _room:Room;
		private var _playerManager:PlayerManager;
//		private var _playerListUI:List;
		
		private var _itemsHolder:MovieClip;
		private var _trowel:Trowel;
		
		private var _myUsername:String;
		
//		[Embed(source='../../../assets/dig.swf', symbol='DigSound')]
//		private var DIG_SOUND:Class;
//		
//		[Embed(source='../../../assets/dig.swf', symbol='FoundSound')]
//		private var FOUND_SOUND:Class;
//		
//		[Embed(source='../../../assets/dig.swf', symbol='NothingSound')]
//		private var NOTHING_SOUND:Class;
		
		private var _countdownField:TextField;
		private var _countdownTimer:Timer;
		private var _secondsLeft:int;
		private var _gameStarted:Boolean;
		
		private var _lastTimeSent:int;
		
		private var _okToSendMousePosition:Boolean;
		
		private var _waitingField:TextField;
		private var quitButton:SimpleButton;
//		private var questionRequested:Boolean = false;
		private var _alreadyAswered:Boolean;
		public var gameRoomEnteredSig:Signal = new Signal();
		private var vsScreen:VsScreenAsset;
		private var player2vsTF:TextField;
		private var player1vsTF:TextField;
		private var _roundTF:TextField;
		private var _aBtn:MovieClip;
		private var _bBtn:MovieClip;
		private var _cBtn:MovieClip;
		private var _dBtn:MovieClip;
		private var _dTF:TextField;
		private var _cTF:TextField;
		private var _bTF:TextField;
		private var _aTF:TextField;
		private var _questionTxt:TextField;
		private var _questionBox:MovieClip;
		private var _p1ScoreTF:TextField;
		private var _p1WinsTF:TextField;
		private var _p1LevelTF:TextField;
		private var _p1NameTF:TextField;
		private var _p2ScoreTF:TextField;
		private var _p2WinsTF:TextField;
		private var _p2LevelTF:TextField;
		private var _p2NameTF:TextField;
		private var p1Box:Sprite;
		private var p2Box:Sprite;
		private var player2Name:String;
		private var _correctAnswer:String;
		private var _timeTF:TextField;
		private var _questionCount:int = 0;
		private var roundTime:int;
		private var _questionTimer:Timer;
		private var _p1Score:int = 0;
		private var _p2Score:int = 0;
		private var _iWasCorrect:Boolean = false;
		private var player2vsExpTF:TextField;
		private var player2vsLevelTF:TextField;
		private var player2vsWinsTF:TextField;
		private var player1vsExpTF:TextField;
		private var player1vsLevelTF:TextField;
		private var player1vsWinsTF:TextField;
		private var phpManager:PhpManager;
		private var p2Trowel:Trowel;
		private var _gameOverPopup:Sprite;
		private var gameObackBtn:SimpleButton;
		private var gameOwinsTxt:TextField;
		private var gameOcoinsTxt:TextField;
		private var gameOexpTxt:TextField;
		private var gameOlevelTxt:TextField;
		private var gameOyouWinSprite:Sprite;
		private var _gameOyouLoseSprite:Sprite;
		private var winnerHandled:Boolean = false;
		
//		private var coinAdded:Boolean = false
//		private var winAdded:Boolean = false
//		private var levelAdded:Boolean = false
//		private var expAdded:Boolean = false
		private var gameOotherPlayerTxt:TextField;
		private var gameEndedFairly:Boolean;
		private var gameEndedLeaver:Boolean;
		private var gameOwatchBtn:SimpleButton;
		private var _chatInputBg:Sprite;
		private var _chatInputTF:TextField;
		private var _lobbyFlow:LobbyFlow;
		private var _cursorClass:Class;
		private var p2displayCursor:Trowel;
		private var mydisplayCursor:Trowel;
//		private var inGameRoom:Boolean = false;
		private var addToCoinsTimer:Timer;
		private var expToAdd:int;
		private var addToExpTimer:Timer;
		private var guestSprite:Sprite;
		private var dontWorryTF:TextField;
		private var coinsToAdd:int;
		private var shouldaWouldaTF:TextField;
		private var gameOloggedInTxtSprite:Sprite;
		private var vsWinsTF:TextField;
		private var vsExpTF:TextField;
		private var vsLevelTF:TextField;
		private var vsDiamondsTF:TextField;
		private var vsCoinsTF:TextField;
		private var hWinsTF:TextField;
		private var hExpTF:TextField;
		private var hLevelTF:TextField;
		private var hDiamondsTF:TextField;
		private var hCoinsTF:TextField;
		private var expNeedsReset:Boolean = false;
		private var c:Client;
		private var _diamondTimer:Timer;
		private var gameScreen:GameScreenAsset;
		
		public function DigGame(lobbyFlow:LobbyFlow) {
			_lobbyFlow = lobbyFlow;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void {
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyPress);
//			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}
		
				
		public function initialize():void {
			
			_gameStarted = false;
			
			_lastTimeSent = -1;
			
			_es.engine.addEventListener(MessageType.PluginMessageEvent.name, onPluginMessageEvent);
			
			_es.engine.addEventListener(MessageType.PublicMessageEvent.name, onPublicMessageEvent);
//			_es.engine.addEventListener(MessageType.PrivateMessageEvent.name, onPrivateMessageEvent);
			
			
			_myUsername = _es.managerHelper.userManager.me.userName;
			
			_playerManager = new PlayerManager();
			
			
			sendInitializeMe();
			
//			sendCursorBroadcast();
		}
		
		protected function onKeyPress(event:KeyboardEvent):void
		{
//			if (inGameRoom)
//			{
				
				
				trace("event code" + event.charCode);
				
				/**
				 *    ENTER is charCode 13
				 */
				
				if (event.charCode == 13)
				{
					trace("enter pressed");
					
					var InputTxtLength:int = _chatInputTF.text.length;	
					
					//				if (stage.focus == _chatInputTF)
					if (InputTxtLength  > 0)
					{
						trace("in enter sending message");
						sendChatMessage();
					}
					else
					{
						_chatInputBg.visible = true;
						_chatInputTF.visible = true;
						
						_chatInputTF.text = "";
						stage.focus = _chatInputTF;
						
						stage.focus = _chatInputTF;
						
						
					}
					
				}
//			}
		}
		
		protected function onMouseLeave(event:Event):void
		{
			if (_trowel)
			{
				_trowel.visible = false;
				
			}
			
		}
		
		private function sendChatMessage():void
		{
			
			//send 
			_chatInputBg.visible = false;
			_chatInputTF.visible = false;
			
			//if there is text to send, then proceed
			if (_chatInputTF.text.length > 0) {
				
				//get the message to send
				var msg:String = _chatInputTF.text;
				
				//check to see if it is a public or private message
				if (msg.charAt(0) == "/" && msg.indexOf(":") != -1) {
					//private message
					
					//parse the message to get who it is meant to go to
//					var to:String = msg.substr(1, msg.indexOf(":") - 1);
//					
//					//parse the message to get the message content and strip out the 'to' value
//					msg = msg.substr(msg.indexOf(":")+2);
//					
//					//create the request object
//					var prmr:PrivateMessageRequest = new PrivateMessageRequest();
//					prmr.userNames = [to];
//					prmr.message = msg;
//					
//					//send it
//					_es.engine.send(prmr);
					
				} else {
					//public message
					
					//create the request object
					var pmr:PublicMessageRequest = new PublicMessageRequest();
					pmr.message = _chatInputTF.text;
					pmr.roomId = StorageModel.gameRoom.id;
					pmr.zoneId = StorageModel.gameRoom.zoneId;
					
					//send it
					_es.engine.send(pmr);
					trace("sending public message request pmr " +  pmr.message);
				}
				
//				TransitionManager.fadeOut(bubble);
				//clear the message input field
				_chatInputTF.text = "";
				
				//give the message field focus
				//				stage.focus = _message;
			}
		}
		
		protected function onPublicMessageEvent(event:PublicMessageEvent):void
		{
//			if (inGameRoom)
//			{
				var playersInRoomAry:Array = _playerManager.players;
				
				trace("public message event name: "+ event.userName);
				for (var i:int = 0; i < playersInRoomAry.length; i++)
				{
					
					trace("pplayer in room: "+ i + playersInRoomAry[i].name);
					if (playersInRoomAry[i].name == event.userName && event.userName != _myUsername)
					{
						trace("Message received from " + event.userName);
						trace("playersInRoomAry[i]" + playersInRoomAry[i]);
						trace("playersInRoomAry[i].trowel" + playersInRoomAry[i].trowel);
						trace("playersInRoomAry[i].trowel.bubble" + playersInRoomAry[i].trowel.bubble);
						playersInRoomAry[i].trowel.bubble.visible = true;
						playersInRoomAry[i].trowel.bubble.alpha = 1;
						playersInRoomAry[i].trowel.bubbleTF.text = event.message;
						trace("new message " + event.message);
						//					TransitionManager.fadeOut(playersInRoomAry[i].trowel.bubble);
						
						TweenLite.to(playersInRoomAry[i].trowel.bubble, 10, {alpha:0});
					}
					
					if (event.userName == _myUsername)
					{
						_trowel.bubble.visible = true;
						_trowel.bubble.alpha = 1;
						//					TransitionManager.fadeOut(_trowel.bubble);
						TweenLite.to(_trowel.bubble, 10, {alpha:0});
						_trowel.bubbleTF.text = event.message;
					}
				}
//			}
		}		
		
		protected function onQuitBtnClick(event:MouseEvent):void
		{
//			trace("event dispatched");
			
			shutDownGame();
		}
		
		public function shutDownGame():void
		{
			_gameStarted = false;
			_okToSendMousePosition = false;
			
				
				if (_countdownTimer != null ) {
					_countdownTimer.stop();
					_countdownTimer.removeEventListener(TimerEvent.TIMER, onCountdownTimer);
					_countdownTimer = null;
					
					removeChild(_countdownField);
					_countdownField = null;
					
//					if (_playerManager.players.length == 1) {
//						createWaitingField();
//					}
					
					
				}
			
				destroy();
			dispatchEvent(new Event(BACK_TO_LOBBY));	
//				_lobbyFlow.changeState(LobbyFlow.LOBBY_STATE);
		}
		
		private function createGameScreen():void {
//			var tf:TextFormat = new TextFormat();
//			tf.size = 30;
//			tf.bold = true;
//			tf.font = "Arial";
//			tf.color = 0xFFFFFF;
//			
//			var field:TextField = new TextField();
//			field.x = 320;
//			field.y = 150;
//			field.autoSize = TextFieldAutoSize.CENTER;
//			field.defaultTextFormat = tf;
//			
//			field.text = "Waiting for players...";
//			
//			_waitingField = field;
//			
//			addChild(field);
			
//			quitButton = new QuitBtn as SimpleButton;
//			addChild(quitButton);
//			quitButton.y = 300;
//			trace("quit " + quitButton);
			
			gameScreen = new GameScreenAsset();
			
//			gameScreen["bg"].visible = false;
			
			_roundTF = gameScreen["roundTxt"] as TextField;
			
			_questionBox = gameScreen["questionBox"] as MovieClip;
			_questionTxt = gameScreen["questionBox"]["questionTxt"] as TextField;
			
			quitButton = gameScreen["quitBtn"] as SimpleButton;			
			quitButton.addEventListener(MouseEvent.CLICK, onQuitBtnClick);
			
			_aBtn = gameScreen["aBtn"] as MovieClip;
			_bBtn = gameScreen["bBtn"] as MovieClip;
			_cBtn = gameScreen["cBtn"] as MovieClip;
			_dBtn = gameScreen["dBtn"] as MovieClip;
			
			
			_aTF= gameScreen["aBtn"]["answerTxt"] as TextField;
			_bTF= gameScreen["bBtn"]["answerTxt"] as TextField;
			_cTF= gameScreen["cBtn"]["answerTxt"] as TextField;
			_dTF= gameScreen["dBtn"]["answerTxt"] as TextField;
			
			_aBtn.addEventListener(MouseEvent.CLICK, onAnswerButtonClick);
			_bBtn.addEventListener(MouseEvent.CLICK, onAnswerButtonClick);
			_cBtn.addEventListener(MouseEvent.CLICK, onAnswerButtonClick);
			_dBtn.addEventListener(MouseEvent.CLICK, onAnswerButtonClick);
			
			p2Box = gameScreen["p2Box"] as Sprite;
			p1Box = gameScreen["p1Box"] as Sprite;
			
			_p2NameTF = gameScreen["p2Box"]["nameTxt"] as TextField;
			_p2LevelTF = gameScreen["p2Box"]["levelTxt"] as TextField;
			_p2WinsTF = gameScreen["p2Box"]["winsTxt"] as TextField;
			_p2ScoreTF = gameScreen["p2Box"]["scoreTxt"] as TextField;
			
			_p1NameTF = gameScreen["p1Box"]["nameTxt"] as TextField;
			_p1LevelTF = gameScreen["p1Box"]["levelTxt"] as TextField;
			_p1WinsTF = gameScreen["p1Box"]["winsTxt"] as TextField;
			_p1ScoreTF = gameScreen["p1Box"]["scoreTxt"] as TextField;
			
			_timeTF = gameScreen["timeTF"] as TextField;
			
			_gameOverPopup = Sprite(gameScreen["gameOverPopup"]);
			_gameOverPopup.visible = false;			
			_gameOyouLoseSprite = Sprite(gameScreen["gameOverPopup"]["youLoseSprite"]);
			gameOyouWinSprite = Sprite(gameScreen["gameOverPopup"]["youWinSprite"]);

			gameOlevelTxt = TextField(gameScreen["gameOverPopup"]["loggedInUserSprite"]["levelTxt"]);
			gameOexpTxt = TextField(gameScreen["gameOverPopup"]["loggedInUserSprite"]["expTxt"]);
			gameOcoinsTxt = TextField(gameScreen["gameOverPopup"]["loggedInUserSprite"]["coinsTxt"]);
			gameOwinsTxt = TextField(gameScreen["gameOverPopup"]["loggedInUserSprite"]["winsTxt"]);
			gameOloggedInTxtSprite = Sprite(gameScreen["gameOverPopup"]["loggedInUserSprite"]);
			gameOotherPlayerTxt = TextField(gameScreen["gameOverPopup"]["loggedInUserSprite"]["otherPlayerxt"]);
			gameOotherPlayerTxt.visible = false;
			gameOwatchBtn = SimpleButton(gameScreen["gameOverPopup"]["youWinSprite"]["watchBtn"]);
			gameOwatchBtn.addEventListener(MouseEvent.CLICK, onWatchBtnClick);
			dontWorryTF = TextField(gameScreen["gameOverPopup"]["dontWorryTxt"]);
			guestSprite = Sprite(gameScreen["gameOverPopup"]["guestSprite"]);
			shouldaWouldaTF = TextField(gameScreen["gameOverPopup"]["guestSprite"]["shouldaWouldaTxt"]);
				
			dontWorryTF = TextField(gameScreen["gameOverPopup"]["dontWorryTxt"]);
				
			
			gameObackBtn = SimpleButton(gameScreen["gameOverPopup"]["backBtn"]);
			gameObackBtn.addEventListener(MouseEvent.CLICK, onLobbyClick);
			
			_chatInputTF = TextField(gameScreen["chatInput"]);
			_chatInputBg = Sprite(gameScreen["chatInputBg"]);
			_chatInputBg.visible = false;
			_chatInputTF.visible = false;
			
			hCoinsTF = TextField(gameScreen["header"]["coinsTxt"]);
			hDiamondsTF = TextField(gameScreen["header"]["diamondsTxt"]);
			hLevelTF = TextField(gameScreen["header"]["levelTxt"]);
			hExpTF = TextField(gameScreen["header"]["expTxt"]);
			hWinsTF = TextField(gameScreen["header"]["winsTxt"]);
			
			hCoinsTF.text = "" + StorageModel.myCoins
			//			hDiamondsTF.text = StorageModel.my
			hLevelTF.text = "Lvl: " + StorageModel.myLevel
			hExpTF.text = "Exp: " + StorageModel.myExp
			hWinsTF.text = "Wins: " + StorageModel.myWins
				
			if (!StorageModel.iAmGuest)
			{
				// display diamonds
				c = StorageModel.playerIOClient;
				
				c.payVault.refresh(onRefreshedOk, onRefreshFail);
				function onRefreshedOk():void
				{
					trace(" I have " + c.payVault.coins);
					hDiamondsTF.text = "" + c.payVault.coins;
				}
				function onRefreshFail():void
				{
					trace("refresh diamonds failed");
				}
			}
		
		}
		
		protected function onWatchBtnClick(event:MouseEvent):void
		{
			
			if (!StorageModel.iAmGuest)
			{
				// add them shizznits
				c = StorageModel.playerIOClient;
				
				c.payVault.refresh(onRefreshedOk, onRefreshFail);
				function onRefreshedOk():void
				{
//					trace(" I have " + c.payVault.coins);
//					hDiamondsTF.text = "" + c.payVault.coins;
					c.payVault.credit(10, "watching..", onCredited, onCreditFail);
					function onCredited():void
					{
						trace(" I now have " + c.payVault.coins);
						
						gameOwatchBtn.visible = false;
						
						_diamondTimer = new Timer(100, 10)
						_diamondTimer.addEventListener(TimerEvent.TIMER, onDiamondTimeTick);
						_diamondTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDiamondTimerComplete);
						_diamondTimer.start();
						
					}
					function onCreditFail(e:PlayerIOError):void
					{
						trace("playerio credit failed", e);
					}
					
					
				}
				function onRefreshFail():void
				{
					trace("refresh diamonds failed");
				}
			}
			
			
		}
		
		protected function onDiamondTimeTick(event:TimerEvent):void
		{
			var diamondInt:int = int( hDiamondsTF.text );
			trace("diamondInt " + diamondInt);
			hDiamondsTF.text = "" + (diamondInt + 1);
			// play adding diamond sound
			
		}
		
		protected function onDiamondTimerComplete(event:TimerEvent):void
		{
			_diamondTimer.removeEventListener(TimerEvent.TIMER, onDiamondTimeTick);
			_diamondTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDiamondTimerComplete);
			_diamondTimer = null
			
			MochiAd.showInterLevelAd({clip:this, id:"970db54f9a0b450c", res:"600x480"});
		}
		
		
		protected function onGameOverBackClicked(event:MouseEvent):void
		{
			trace("clicked");
		}		
		
		private function fillGameScreenData():void
		{
			
			trace("filling game screen data");
			_p2NameTF.text = "" + player2Name;
			
			_p1NameTF.text = "" + _myUsername;
			_p1ScoreTF.text = "Score: " + _p1Score;
			_p2ScoreTF.text = "Score: " + _p2Score;
			
			_p2LevelTF.text = "Level: " + StorageModel.p2Level;
			_p2WinsTF.text = "Wins: " + StorageModel.p2Wins;
			
			_p1LevelTF.text = "Level: " + StorageModel.myLevel;
			_p1WinsTF.text = "Wins: " + StorageModel.myWins;
			
			
			_timeTF.text = "Time: ";
//			_p2Level = phpManager.getVarFromUsername("level", _myUsername) 	
//			_p2Wins = phpManager.getVarFromUsername("wins", _myUsername) 	
//			_p2Score = 
			
				
//			_p2Level = phpManager.getVarFromUsername("level", _myUsername) 	
//			_p2Wins = phpManager.getVarFromUsername("wins", _myUsername) 
//			_p2Score = 
			
				
				
		}		
		
		
		
		
		private function run(e:Event):void {
			if (getTimer()-_lastTimeSent > 500 && _okToSendMousePosition) {
				sendMousePosition();
			}
			
			for (var i:int = 0; i < _playerManager.players.length;++i) {
				var p:Player = _playerManager.players[i];
				if (!p.isMe) {
					p.trowel.run();
				}
			}
		}
		
//		private function sendAnsweredQuestion():void{
////	_lastTimeSent = getTimer();
//
////			var answerTime = 100;
//						
//			var esob:EsObject = new EsObject();
//			esob.setString(PluginConstants.ACTION, PluginConstants.ANSWER_HAS_BEEN_CHOSEN);
////			esob.setInteger(PluginConstants.ANSWER_TIME, answerTime);
//						
//			sendToPlugin(esob);
//		}

		private function sendQuestionOver():void{
			//astTimeSent = getTimer();
			
			var esob:EsObject = new EsObject();
			esob.setString(PluginConstants.ACTION, PluginConstants.POSITION_UPDATE);
			esob.setInteger(PluginConstants.X, _trowel.x);
			esob.setInteger(PluginConstants.Y, _trowel.y);
			
			sendToPlugin(esob);
		}

		private function sendMousePosition():void{
			
//			trace("sending mouse position");
			_lastTimeSent = getTimer();
			
			var esob:EsObject = new EsObject();
			esob.setString(PluginConstants.ACTION, PluginConstants.POSITION_UPDATE);
			esob.setInteger(PluginConstants.X, _trowel.x);
			esob.setInteger(PluginConstants.Y, _trowel.y);
			
			sendToPlugin(esob);
		}
		
		private function playSound(snd:Sound):void {
			snd.play();
		}
		
		private function sendInitializeMe():void {
			//tell the plugin that you're ready
			var esob:EsObject = new EsObject();
			esob.setString(PluginConstants.ACTION, PluginConstants.INIT_ME);
//			esob.setString(PluginConstants.CURSOR, StorageModel.currentCursorClassName);
			
			//send to the plugin
			sendToPlugin(esob);
		}
		
//		private function sendCursorBroadcast():void {
//			//tell the plugin that you're ready
//			var esob:EsObject = new EsObject();
//			esob.setString(PluginConstants.ACTION, PluginConstants.CURSOR_BROADCAST);
//			esob.setString(PluginConstants.CURSOR_NAME, StorageModel.currentCursorClassName);
//			
//			//send to the plugin
//			sendToPlugin(esob);
//			trace(_myUsername + " sending cursor broadcast");
//		}
		
		/**
		 * Sends formatted EsObjects to the DigGame plugin
		 */
		private function sendToPlugin(esob:EsObject):void {
			//build the request
			
			if (esob.getString(PluginConstants.ACTION) == PluginConstants.QUESTION_REQUEST)
			{
				trace("sending question request to plugin");
				trace("sending to plugin, room: " + _room.id, "zone " + _room.zoneId);
			}
			
			var pr:PluginRequest = new PluginRequest();
			pr.parameters = esob;
			pr.roomId = StorageModel.gameRoom.id;
			pr.zoneId = StorageModel.gameRoom.zoneId;
			pr.pluginName = PluginConstants.PLUGIN_NAME;
			
			//send it
			_es.engine.send(pr);
		}
		
		/**
		 * Called when a message is received from a plugin
		 */
		public function onPluginMessageEvent(e:PluginMessageEvent):void {
			var esob:EsObject = e.parameters;
			
			//get the action which determines what we do next
			var action:String = esob.getString(PluginConstants.ACTION);
			switch (action) {
//				case PluginConstants.AI_CHECK:
//					handleAiCheck(esob);
//					break;
				case PluginConstants.POSITION_UPDATE:
					handlePositionUpdate(esob);
					break;
				case PluginConstants.DONE_DIGGING:
					handleDoneDigging(esob);
					break;
				case PluginConstants.DIG_HERE:
					handleDigHere(esob);
					break;
				case PluginConstants.PLAYER_LIST:
					handlePlayerList(esob);
					break;
				case PluginConstants.START_COUNTDOWN:
					handleStartCountdown(esob);
					break;
				case PluginConstants.STOP_COUNTDOWN:
					handleStopCountdown(esob);
					break;
				case PluginConstants.START_GAME:
					handleStartGame(esob);
					break;
				case PluginConstants.GAME_OVER:
					handleGameOver(esob);
					break;
				case PluginConstants.ADD_PLAYER:
					handleAddPlayer(esob);
					break; 
				case PluginConstants.REMOVE_PLAYER:
					handleRemovePlayer(esob);
					break;
				case PluginConstants.ERROR:
					handleError(esob);
					break;
				case PluginConstants.QUESTION_OVER:
					handleQuestionOver(esob);
					break;
				case PluginConstants.QUESTION_REQUEST:
					handleQuestionRequestResponse(esob);
					trace("well hot dog!");
					break;

				case PluginConstants.ANSWER_HAS_BEEN_CHOSEN:
					handleAnswerHasBeenChosenRequestResponse(esob);
					trace("well hotter dog!");
					break;
				case PluginConstants.ROUND_OVER:
					handleRoundOverCallback(esob);
					trace("well hotty tot dog!");
					break;

				default:
					trace("Action not handled: " + action);
			}
		}
		
//		private function handleCursor(esob:EsObject):void
//		{
//			var name:String = esob.getString(PluginConstants.NAME);
//			var cursor:String = esob.getString(PluginConstants.CURSOR_NAME);
//			trace(_myUsername + "init handled for: " + name + " " + cursor); 
//			
//			_p2CursorClassName = cursor;
//			
//			if (name != _myUsername)
//			{
//				trace(_myUsername + " sees + " + name + " equipping " + cursor);
//				var p2:Player = _playerManager.playerByName(name)
//				p2.trowel.equipNewCursor(cursor);
//			}
//		}
		
//		private function handleInit(esob:EsObject):void
////		{
////			
////		}
		
		private function handleRoundOverCallback(esob:EsObject):void
		{
			trace("the round has ended");
		}
		
		private function handleAnswerHasBeenChosenRequestResponse(esob:EsObject):void
		{
			
			var name:String = esob.getString(PluginConstants.NAME);
			var ans:String = esob.getString(PluginConstants.ANSWER_CHOSEN);
			var time:int = esob.getInteger(PluginConstants.TIME_TO_ANSWER);
			var scoreDelta:int = esob.getInteger(PluginConstants.SCORE);
			trace("score delta " + scoreDelta);
//			
//			trace("server says " + name + " chose " + ans + "with time: " + time + "!");
			trace("answer question response from : " + name + " chose " + ans + "time: " + time);
			
			var winnerChosen:String = esob.getString(PluginConstants.WINNER_CHOSEN);
			
			if (winnerChosen == "true")
			{
				var winnerName:String = esob.getString(PluginConstants.WINNER_NAME);
				trace("the round winner was " + winnerName);			
			}
//			_p2ScoreTF
			
			if(name == _myUsername)
			{
				
				var newPoints:int= scoreDelta;
				_p1Score = _p1Score + newPoints;
				trace("i get this much score for answer " + _p1Score);
				_p1ScoreTF.text = "Score: " + _p1Score;
				
				var player:Player = _playerManager.playerByName(_myUsername);
//				player.score = player.score + _p1Score;
			
				
			}
			else
			{
				
				var newPoints2:int= scoreDelta;
				_p2Score = _p2Score + newPoints2;
				trace("i get this much score for answer " + _p2Score);
				_p2ScoreTF.text = "Score: " + _p2Score;
				
				var player2:Player = _playerManager.playerByName(name);
//				player.score = player.score + _p2Score;
				
			}
			
			
			
		}
		
		private function handleQuestionRequestResponse(esob:EsObject):void
		{
			if (p2Trowel)
			{
				p2Trowel.visible = false;
				
			}
			
			trace("got a new question");
			var question:String = esob.getString(PluginConstants.QUESTION_TEXT);
			var a_ans:String = esob.getString(PluginConstants.A_TEXT);
			var b_ans:String = esob.getString(PluginConstants.B_TEXT);
			var c_ans:String = esob.getString(PluginConstants.C_TEXT);
			var d_ans:String = esob.getString(PluginConstants.D_TEXT);
			var correctAnswer:String = esob.getString(PluginConstants.ANSWER_VALUE);
			roundTime = esob.getInteger(PluginConstants.ROUND_TIME);
			
			trace("a btn " + _aBtn);
			_aBtn.visible = true;
			_bBtn.visible = true;
			_cBtn.visible = true;
			_dBtn.visible = true;
			
			trace("round will be " + roundTime + " seconds");
			_questionTxt.text = question;
			
			_timeTF.text = "Time: " + (roundTime - 5);
//			
			_aTF.text = a_ans;
			_bTF.text = b_ans;
			_cTF.text = c_ans;
			_dTF.text = d_ans;
//			
			_correctAnswer = correctAnswer;
			trace("_correct" + _correctAnswer);
			
			trace("Question: " + question + " | a."+a_ans+ " | b."+b_ans+ " | c."+c_ans+ " | d."+d_ans);
			
			if (_questionTimer == null)
			{
			_questionTimer = new Timer(1000, roundTime)
				
			}
			_questionTimer.addEventListener(TimerEvent.TIMER, onQuestionTimeTick);
			_questionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onQuestionTimerComplete);
			_questionTimer.start();
			
		}
		
		protected function onQuestionTimeTick(event:TimerEvent):void
		{
			roundTime--;
			
			if (roundTime > 5)
			{
				_timeTF.text = "Time: " + (roundTime - 5);			
			}
			else if(roundTime == 5)
			{
				
				p2Trowel.visible = true;
				
				_timeTF.text = "Time: " + roundTime;
				_aBtn.visible = false;
				_bBtn.visible = false;
				_cBtn.visible = false;
				_dBtn.visible = false;
				
				_aBtn.gotoAndPlay("regular");
				_bBtn.gotoAndPlay("regular");
				_cBtn.gotoAndPlay("regular");
				_dBtn.gotoAndPlay("regular");
				
				_questionBox.gotoAndPlay("regular");
				
				if (_iWasCorrect)
				{
					_iWasCorrect = false;
					_questionTxt.text = "You're good. Keep it up!";
					
				}
				else
				{
					_questionTxt.text = "It's alright, you'll get this next one!";
				}
					
				
				
			}
			else
			{
				_timeTF.text = "Time: " + roundTime;	
			}
			
			if (roundTime == 0)
			{
				trace("time is at zero");
				sendQuestionRequest();
			}
			
			
		}
		
		protected function onQuestionTimerComplete(event:TimerEvent):void
		{
			if (_questionTimer)
			{
				_questionTimer.removeEventListener(TimerEvent.TIMER, onQuestionTimeTick);
				_questionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onQuestionTimerComplete);
				_questionTimer = null;
				
				poop();
				trace("question timer expired");
				
			}
			
		}
		
		private function poop():void
		{
			trace("pooping");
		}
		
		private function handleDigHere(esob:EsObject):void{
			var name:String = esob.getString(PluginConstants.NAME);
			var player:Player = _playerManager.playerByName(name);
			if (!player.isMe) {
				player.trowel.dig();
			}
		}

		private function handleQuestionOver(esob:EsObject):void{
			//var name:String = esob.getString(PluginConstants.NAME);

			var questionDataAry:Array = esob.getEsObjectArray(PluginConstants.ANSWER_DATA_ARY);
			for (var i:int = 0; i < questionDataAry.length;++i) {
				var ob:EsObject = questionDataAry[i];
				var name:String = ob.getString(PluginConstants.NAME);
				var answerTime:int = ob.getInteger(PluginConstants.ANSWER_TIME);
				var winnerName:String = ob.getString(PluginConstants.WINNER_NAME);

				var player:Player = _playerManager.playerByName(name);
				// add value of points player gets to his score tF
				// addToScore(player, answerTime)
				var player:Player = _playerManager.playerByName(name);
				
				
				if (!player.isMe) {
					// displayWinnerSparkles(player)
					
				}
				
				
				
				
				
			}


		}
		
		private function handlePositionUpdate(esob:EsObject):void{
			
			
			var name:String = esob.getString(PluginConstants.NAME);
			var tx:int = esob.getInteger(PluginConstants.X);
			var ty:int = esob.getInteger(PluginConstants.Y);
			
			var player:Player = _playerManager.playerByName(name);
			
//			trace("position update received." + name + " " + tx + " " + ty + " " + player);
			
			if (!player.isMe) {
				player.trowel.moveTo(tx, ty);
			}
		}
		
		private function handleGameOver(esob:EsObject):void {
			if (!gameEndedFairly && !gameEndedLeaver)
			{
				if(_playerManager.players.length == 1)
				{
					gameEndedLeaver = true;
					trace("herr gameEndedLeaver");
				}
				else
				{
					gameEndedFairly = true;
					trace("herr gameEndedFairly");
				}
			
			
			_gameStarted = false;
			_okToSendMousePosition = false;
			trace("handling the shiznit");
			var str:String = "Game Over \n";
			
//			var success:Boolean = esob.getBoolean(PluginConstants.SUCCESS);
//				var success:Boolean = false;
			var topUser:String = "";
			var topScore:int = 0;
				
				
			var list:Array = esob.getEsObjectArray(PluginConstants.PLAYER_LIST);
			for (var i:int = 0; i < list.length;++i) {
				var ob:EsObject = list[i];
				var name:String = ob.getString(PluginConstants.NAME);
				var score:int = ob.getInteger(PluginConstants.SCORE);
				
				if (i==0)
				{
					topScore = score;
					topUser = name;
				}
				else
				{
					if (score > topScore)
					{
						topScore = score;
						topUser = name;
					}
				}
//				topUser = name;
				
//				var success:Boolean = ob.getBoolean(PluginConstants.SUCCESS);
				str += name + " - " + score.toString()+"\n";
				
//				trace("And the success is: " + success);
			}
			
			if (_gameOverPopup)
			{
				TweenLite.to(_gameOverPopup, 1, {y:24});
				_gameOverPopup.visible = true;			
				
			}
			
//				phpManager.updateSig.add(onUpdateResponse);
//			var winnerName:String = _myUsername;
			
			trace("Length of player list ");
			if (topUser == _myUsername || _playerManager.players.length == 1)
			{
				if (!winnerHandled)
				{
					
						coinsToAdd = (30 + 4 * p2Level);
						expToAdd = (10 + 3* p2Level);
					
					if (StorageModel.iAmGuest)
					{
						shouldaWouldaTF.text = "You may have lost this round, but you would have still gotten " + coinsToAdd + " the coins and " + expToAdd + " experience points!";
						guestSprite.visible = true;
						gameOloggedInTxtSprite.visible = false;
						gameOyouWinSprite.visible = true;
						gameOwatchBtn.visible = false;
						_gameOyouLoseSprite.visible = false;
						dontWorryTF.visible = true;
						dontWorryTF.text = "Too bad your on a guest account.";
					}
					
					else
					{
						gameOloggedInTxtSprite.visible = false;
						gameOotherPlayerTxt.visible = false;
						winnerHandled = true;	
						guestSprite.visible = false;
						gameOwatchBtn.visible = true;
						//			
						trace("I Won!!!");
						_gameOyouLoseSprite.visible = false;
						gameOyouWinSprite.visible = true;
						
						gameOloggedInTxtSprite.visible = true;
						dontWorryTF.visible = true; 
						dontWorryTF.text = "Nice job! You earned " + coinsToAdd + " and " + expToAdd + " experience points.";
						
						gameOwinsTxt.text = "Wins: " + StorageModel.myWins;
						gameOlevelTxt.text = "Level: " +StorageModel.myLevel;
						gameOexpTxt.text = "Exp: " +StorageModel.myExp;
						gameOcoinsTxt.text = "Coins: " +StorageModel.myCoins;
						
						phpManager.updateSig.add(onUpdateResponse);
						phpManager.addOneWin(_myUsername);
						
						var p2Level:int = int(_p2LevelTF.text);
						
						phpManager.addToExp(_myUsername, expToAdd);
						phpManager.addToCoins(_myUsername, coinsToAdd);
						
						
					}
					
					// you won by default, other players left
					if (_playerManager.players.length == 1)
					{
						gameOotherPlayerTxt.visible = true;
					}
					
				}
				
			}
			
			else
			{
				trace("I lost");

				
				if (StorageModel.iAmGuest)
				{
					guestSprite.visible = true;
					gameOloggedInTxtSprite.visible = false;
					gameOyouWinSprite.visible = false;
					_gameOyouLoseSprite.visible = true;
					dontWorryTF.visible = true;
					dontWorryTF.text = "Keep playing to learn more words!";
					
				}
				else
				{
					dontWorryTF.visible = true;
					
					gameOloggedInTxtSprite.visible = true;
					gameOotherPlayerTxt.visible = false;
//					phpManager.addToCoins(_myUsername, 5);
//					phpManager.addToExp(_myUsername, 5);
					guestSprite.visible = false;
					
					
					_gameOyouLoseSprite.visible = true;
					
					gameOyouWinSprite.visible = false;
					
					gameOexpTxt.text = "Exp :" + StorageModel.myExp;
					gameOcoinsTxt.text = "Coins :" + StorageModel.myCoins;
					gameOwinsTxt.text = "Wins :" + StorageModel.myWins;
					gameOlevelTxt.text = "Level: " + StorageModel.myLevel;
					//				gameOwinsTxt.visible = false;
					
					phpManager.updateSig.add(onUpdateResponse);
					
					coinsToAdd = 15 + 2 * p2Level;
					expToAdd = (5 + 2* p2Level);
					dontWorryTF.text = "You earned " + coinsToAdd + " coins and " + expToAdd + " experience points.";
					phpManager.updateSig.add(onUpdateResponse);
					
					phpManager.addToExp(_myUsername, expToAdd);
					phpManager.addToCoins(_myUsername, coinsToAdd);
				}
				
				
			}
			
			
			
//			var lobby:Button = new Button();
//			lobby.label = "Back to Lobby";
//			lobby.width = 150;
//			lobby.x = 300;
//			lobby.y = 540;
//			lobby.addEventListener(MouseEvent.CLICK, onLobbyClick);
//			addChild(lobby);
			
			}
			
		}
		
		protected function onCoinsTimerComplete(event:TimerEvent):void
		{
			trace("coin adding timer complete, now expToAdd " + expToAdd);
			addToCoinsTimer.removeEventListener(TimerEvent.TIMER, onCoinsTimer);
			addToCoinsTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCoinsTimerComplete);
			addToCoinsTimer = null;
			
			addToExpTimer = new Timer(200, expToAdd);
			addToExpTimer.addEventListener(TimerEvent.TIMER, onExpTimer);
			addToExpTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onExpTimerComplete);
			addToExpTimer.start();	
			
		}
		
		protected function onExpTimerComplete(event:TimerEvent):void
		{
			
			if (expNeedsReset)
			{
				phpManager.setExpSig.add(onExpSet);
				phpManager.setExp(_myUsername, StorageModel.myExp);
				
				expNeedsReset = false;
			}
			
			
			addToExpTimer.removeEventListener(TimerEvent.TIMER, onExpTimer);
			addToExpTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onExpTimerComplete);
			addToExpTimer = null;
			
		}
		
		protected function onExpTimer(event:TimerEvent):void
		{
			StorageModel.myExp = StorageModel.myExp + 1;
			gameOexpTxt.text = "Exp: " + StorageModel.myExp;
			hExpTF.text = "Exp: " + StorageModel.myExp;
			
			if (StorageModel.myExp == StorageModel.expToNextLevel)
			{
				trace("level up!");
				// play level up sound
				
				StorageModel.myExp = 0;
				
				StorageModel.myLevel ++;
				
				LevelUpManager.getExpForNexTLevel();
				
				expNeedsReset = true;
				
				phpManager.addOneLevel(_myUsername);
				
			}
			
			
		}
		
		protected function onCoinsTimer(event:TimerEvent):void
		{
			trace("on coins timer");
			StorageModel.myCoins = StorageModel.myCoins + 1;
			gameOcoinsTxt.text = "Coins: " + StorageModel.myCoins;
			hCoinsTF.text = "" + StorageModel.myCoins;
		}
		
		private function onUpdateResponse(response:String, type:String, amount:int):void
		{
			trace("update responded! " + response);
			if (type == "coin" )
			{
				trace("updated coins !!");
//				StorageModel.myCoins = StorageModel.myCoins + amount;
//				gameOcoinsTxt.text = "Coins: " + StorageModel.myCoins;
//				trace("coin added! " + gameOcoinsTxt.text);
				
				TweenLite.delayedCall(5, beginIncrementing)
				
					trace("called on it!");
			}
			
			
			if (type == "level" )
			{
//				StorageModel.myLevel = StorageModel.myLevel + amount;
//				gameOlevelTxt.text = "levels: " + StorageModel.myLevel;
//				trace("level added! " + gameOlevelTxt.text);
			}
			
			
			if (type == "exp" )
			{
//				StorageModel.myExp = StorageModel.myExp + amount;
				gameOexpTxt.text = "exp: " + StorageModel.myExp + " / " + StorageModel.expToNextLevel;;
//				trace("coin added! " + gameOexpTxt.text);

					// enough experience to level up?
//				if (StorageModel.myExp > 200 + StorageModel.myLevel * 20)
//				{
//					StorageModel.myExp = StorageModel.myExp - (200 + StorageModel.myLevel * 20);
//					StorageModel.myLevel = StorageModel.myLevel + 1;
//					
//					phpManager.addOneLevel(_myUsername);
////					phpManager.setExpSig.add(onExpSigSet);
//					phpManager.setExpSig.add(onExpSet);
//					phpManager.setExp(_myUsername, StorageModel.myExp);
//
//				}
				
				
				
				/**
				 * 	DONT FORGET LEVEL UP CHECK
				 * 
				 */
				
			}
			
			
			if (type == "wins" )
			{
				StorageModel.myWins = StorageModel.myWins + amount;
				gameOwinsTxt.text = "Wins: " + StorageModel.myWins;
				hWinsTF.text = "Wins: " + StorageModel.myWins;
				trace("coin added! " + gameOwinsTxt.text);
			}
			
			
			
			
			
		}
		
		private function beginIncrementing():void
		{
			trace("$$ beginning the incrementing to " + coinsToAdd);
			addToCoinsTimer = new Timer(100, coinsToAdd);
			addToCoinsTimer.addEventListener(TimerEvent.TIMER, onCoinsTimer);
			addToCoinsTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCoinsTimerComplete);
			addToCoinsTimer.start();	
		}
		
		private function onExpSet(newExp:int):void
		{
			trace("new exp " + newExp + " and Strorage model exp " + StorageModel.myExp);
//			gameOexpTxt.text = "Exp: " + StorageModel.myExp + " / " + StorageModel.expToNextLevel;;
//			gameOlevelTxt.text = "Level: " + StorageModel.myLevel;
		}
		
		private function onLobbyClick(e:MouseEvent):void {
			trace("TO LOBBY CLICKEDF");
			destroy();
			dispatchEvent(new Event(BACK_TO_LOBBY));
			_lobbyFlow.changeState(LobbyFlow.LOBBY_STATE);
		}
		
		public function destroy():void {
			//- new format is _es.engine.addEventListener(MessageType.LoginResponse.name, onLoginResponse);
			_es.engine.removeEventListener(MessageType.PluginMessageEvent.name, onPluginMessageEvent);
			//
			Mouse.show();
			removeEventListener(Event.ENTER_FRAME, run);
			
//			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
//			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
			
			var lrr:LeaveRoomRequest = new LeaveRoomRequest();
			lrr.roomId = room.id;
			lrr.zoneId = room.zoneId;
			
			_es.engine.send(lrr);
//			inGameRoom = false;
			
			this.parent.removeChild(this);
			
			trace("destroying game");
		}
		
		private function handleStartGame(esob:EsObject):void{
			_gameStarted = true;
		}
		
		private function handleStopCountdown(esob:EsObject):void {
			if (_countdownTimer.running) {
				_countdownTimer.stop();
			}
				_countdownTimer.removeEventListener(TimerEvent.TIMER, onCountdownTimer);
				
				if (_countdownTimer != null)
				{
					_countdownTimer = null;
				}
				
				if (_countdownField && _countdownField.parent)
				{
					removeChild(_countdownField);
					_countdownField = null;
				}
				
				if (_playerManager.players.length == 1) {
					trace("final seconds");
//					createGameScreen();
//					fillGameScreenData();
				}
				
				
			
		}
		
		
		private function handleStartCountdown(esob:EsObject):void {
			
			trace("RECEIVED START COUNTDOWN");
			
			trace("dispatching");
			gameRoomEnteredSig.dispatch();
//			inGameRoom = true;
			
				// create and fill in vs screen
			vsScreen = new VsScreenAsset;
			player1vsTF = vsScreen["player1vsTxt"] as TextField;
			player1vsWinsTF = vsScreen["player1vsWinsTxt"] as TextField;
			player1vsLevelTF = vsScreen["player1vsLevelTxt"] as TextField;
			player1vsExpTF = vsScreen["player1vsExpTxt"] as TextField;

			player2vsTF = vsScreen["player2vsTxt"] as TextField;
			player2vsWinsTF = vsScreen["player2vsWinsTxt"] as TextField;
			player2vsLevelTF = vsScreen["player2vsLevelTxt"] as TextField;
			player2vsExpTF = vsScreen["player2vsExpTxt"] as TextField;

			vsCoinsTF = TextField(vsScreen["header"]["coinsTxt"]);
			vsDiamondsTF = TextField(vsScreen["header"]["diamondsTxt"]);
			vsLevelTF = TextField(vsScreen["header"]["levelTxt"]);
			vsExpTF = TextField(vsScreen["header"]["expTxt"]);
			vsWinsTF = TextField(vsScreen["header"]["winsTxt"]);
			
			vsCoinsTF.text = "" + StorageModel.myCoins
			//			hDiamondsTF.text = StorageModel.my
			vsLevelTF.text = "" + StorageModel.myLevel
			vsExpTF.text = "" + StorageModel.myExp
			vsWinsTF.text = "" + StorageModel.myWins
				
			if (!StorageModel.iAmGuest)
			{
				// display diamonds
				c = StorageModel.playerIOClient;
				
				c.payVault.refresh(onRefreshedOk, onRefreshFail);
				function onRefreshedOk():void
				{
					trace(" I have " + c.payVault.coins);
					vsDiamondsTF.text = "" + c.payVault.coins;
				}
				function onRefreshFail():void
				{
					trace("refresh diamonds failed");
				}
			}
//			_room.users = _es.managerHelper.userManager.users					
//			trace("_es.managerHelper.userManager.users " + _playerManager.players);
			
			var players:Array = _playerManager.players;
			
//			trace("users" + _room.users + " and length: " + _room.users.length);
			
			for (var i:int = 0; i < players.length; i++)
			{
				if (players[i].name == _myUsername)
				{
					trace("it's me!");
					player1vsTF.text = players[i].name;
					player1vsWinsTF.text = "Wins: " + StorageModel.myWins;
					player1vsLevelTF.text = "Level: " +StorageModel.myLevel;
					player1vsExpTF.text = "Exp: " +StorageModel.myExp + " / " + StorageModel.expToNextLevel;;
				}
				else
				{
					player2vsTF.text = players[i].name;
					player2Name = players[i].name;
					
					phpManager = PhpManager.getInstance();
					phpManager.getLevel2(player2Name);
					phpManager.levelSig.add(onP2LevelReceived);
					phpManager.getWins(player2Name);
					phpManager.winsSig.add(onP2WinsReceived);
					phpManager.getExp(player2Name);
					phpManager.expSig.add(onP2ExpReceived);
					phpManager.getCurrentCursorClass(player2Name);
					phpManager.cursorCheckSig.add(onP2CursorChecked);
					phpManager.getCursorOffset(player2Name);
					phpManager.offsetCheckSig.add(onp2OffsetGot);
					phpManager.getCursorOffset(_myUsername);
					phpManager.offsetCheckSig.add(onMyOffsetGot);
					
				}
			}
			
			addChild(vsScreen);
			
			if (_waitingField != null) {
				removeChild(_waitingField);
				_waitingField = null;
			}
			
			
			
//			sendCursorBroadcast();
			
			_secondsLeft = esob.getInteger(PluginConstants.COUNTDOWN_LEFT);
			trace("secondsLeft: " + _secondsLeft.toString());
			
			_countdownField = new TextField();
//			addChild(_countdownField);
			
//			_countdownField.x = 320;
//			_countdownField.y = 200;
//			_countdownField.selectable = false;
//			
//			_countdownField.autoSize = TextFieldAutoSize.CENTER;
//			
//			var tf:TextFormat = new TextFormat();
//			tf.size = 80;
//			tf.bold = true;
//			tf.font = "Arial";
//			tf.color = 0xFFFFFF;
			
			
//			_countdownField.defaultTextFormat = tf;
//			_countdownField.text = _secondsLeft.toString();
//			
//			_countdownField.filters = [new GlowFilter(0x009900), new DropShadowFilter()];
			
			_countdownTimer = new Timer(1000);
			_countdownTimer.start();
			_countdownTimer.addEventListener(TimerEvent.TIMER, onCountdownTimer);
//			_countdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCountdownTimerComplete);
			createGameScreen();
			
		}
		
		private function onp2OffsetGot(offsets:Array):void
		{
			phpManager.offsetCheckSig.remove(onp2OffsetGot);
			trace("got the offsets " + offsets);
			if (offsets == null)
			{
				trace("offsets is null");	
			}
			else
			{
				
			var offsetX:Number = offsets[0];
			var offsetY:Number = offsets[1];
		
			p2displayCursor.x += offsetX;
			p2displayCursor.y += offsetY;
			p2displayCursor.visible = true;
			}
		
		
		}
		
		private function onMyOffsetGot(offsets:Array):void
		{
			phpManager.offsetCheckSig.remove(onMyOffsetGot);
			trace("got the offsets " + offsets);
			if (offsets == null)
			{
				trace("offsets is null");	
			}
			else
			{
				
			var offsetX:Number = offsets[0];
			var offsetY:Number = offsets[1];
		
			mydisplayCursor = new Trowel(StorageModel.currentCursorClassName) as Trowel;
			addChild(mydisplayCursor);
			mydisplayCursor.x =  (152 + offsetX)
			mydisplayCursor.y =  (130 + offsetY);
//			trace("calculating $$ " + xPos, yPos, StorageModel.myCurrentOffsetX, StorageModel.myCurrentOffsetY);
			
//			mydisplayCursor.x = (152 + StorageModel.myCurrentOffsetX);
//			mydisplayCursor.y = (130 + StorageModel.myCurrentOffsetY);
			trace("mydisplayCursor " + mydisplayCursor.x + " " + mydisplayCursor.y); 
			}
		
		
		}
		
		private function onP2CursorChecked(cursorClassName:String):void
		{
			phpManager.cursorCheckSig.remove(onP2CursorChecked);
			
			p2displayCursor = new Trowel(cursorClassName) as Trowel;
			addChild(p2displayCursor);
			p2displayCursor.x = 378;
			p2displayCursor.y = 130;
			p2displayCursor.visible = false;
			trace("in p2 cursor check " + _myUsername + " sees + " + player2Name + "getting " + cursorClassName);
			
			
			StorageModel.p2CursorClassName = cursorClassName
			
//			trace(_myUsername + " sees + " + player2Name + " equipping " + cursorClassName);
//							var p2:Player = _playerManager.playerByName(player2Name)
//							p2.trowel.equipNewCursor(cursorClassName);
			
		}
		
		private function onP2WinsReceived(wins:int):void
		{
			trace("my wins:" + wins);
			player2vsWinsTF.text = "Wins: " + wins;
			phpManager.winsSig.remove(onP2WinsReceived);
			StorageModel.p2Wins = wins;
		}
		
		private function onP2LevelReceived(level:int):void
		{
			trace("my level is " + level);
			player2vsLevelTF.text = "Level: " + level;
			phpManager.levelSig.remove(onP2LevelReceived);
			StorageModel.p2Level = level;
		}
		
		private function onP2ExpReceived(exp:int):void
		{
			trace("my exp is " + exp);
			player2vsExpTF.text = "Exp: " + exp;
			phpManager.expSig.remove(onP2ExpReceived);
			StorageModel.p2Exp = exp;
		}
		
//		protected function onCountdownTimerComplete(event:TimerEvent):void
//		{
//			trace("timer complete");
//			
//			
//		}
		
		private function displayGameAssets():void
		{
			

			//			_trowel.x = -40;
			//			_trowel.y = -40;
//			createGameScreen();
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
			
			_okToSendMousePosition = true;
			
			addEventListener(Event.ENTER_FRAME, run);
			
			addChild(_countdownField);
			
			
			//create a container for items that are added
			_itemsHolder = new MovieClip();
			addChild(_itemsHolder);
			

			//add a background
			
			//add the player list UI
			//			_playerListUI = new List();
			//			_playerListUI.x = 650;
			//			_playerListUI.y = 10;
			//			_playerListUI.width = 800 - _playerListUI.x - 10;
			//			addChild(_playerListUI);
			
			
			//hide the mouse
						Mouse.hide();
			fillGameScreenData();
			
			//add mouse follower
			
			_trowel = new Trowel(StorageModel.currentCursorClassName);
			addChild(_trowel);
			
//			if (name != _myUsername)
//			{
//				trace(_myUsername + " sees + " + name + " equipping " + cursor);
//				var p2:Player = _playerManager.playerByName(name)
//				p2.trowel.equipNewCursor(cursor);
//			}
			
			var player:Player = _playerManager.playerByName(player2Name);
			if (!player.isMe) {
				
				
				setChildIndex(player.trowel, numChildren - 1);
//				player.trowel.mouseEnabled = false;
//				player.trowel.mouseChildren = false;
				
				p2Trowel = player.trowel;
				
				trace("p2Trowel: " + p2Trowel);
				
				p2Trowel.equipNewCursor(StorageModel.p2CursorClassName);
				trace("p2CursorClassName " + StorageModel.p2CursorClassName);
			}
			
			var mePlayer:Player =  _playerManager.playerByName(_myUsername);
			
			mePlayer.trowel = _trowel;
			
			setChildIndex(_trowel, numChildren - 1);
			_trowel.mouseEnabled = false;
			_trowel.mouseChildren = false;
			
			
		}
		
		private function onCountdownTimer(e:TimerEvent):void {
			--_secondsLeft;
			if (_countdownField)
			{
				_countdownField.text = _secondsLeft.toString();
				
			}
			
			trace("showing vs page!!");
//			
			if (_secondsLeft == 5)
			{
				removeChild(vsScreen);
				displayGameAssets();
				addChild(gameScreen);
				
				moveCursorsToFront();
			
			}
			
			if(_secondsLeft == 1)
			{
				sendQuestionRequest();
			}
		}
		
		private function moveCursorsToFront():void
		{
			
			
			setChildIndex(_trowel, numChildren - 1);
			setChildIndex(p2Trowel, this.numChildren - 1);
		}		
		
		private function sendQuestionRequest():void
		{
			_questionCount++;
			
			_roundTF.text = "Question: " + _questionCount;
			var esob:EsObject = new EsObject();
			
			esob.setInteger(PluginConstants.QUESTION_COUNT, _questionCount);
			esob.setString(PluginConstants.ACTION, PluginConstants.QUESTION_REQUEST);
//			esob.setInteger(PluginConstants.X, _trowel.x);
//			esob.setInteger(PluginConstants.Y, _trowel.y);
			
			sendToPlugin(esob);
			trace("sending question request");
			trace("sending to plugin, room: " + _room.id, "zone " + _room.zoneId);
			
			_alreadyAswered = false;
		}
		
		private function mouseMoved(e:MouseEvent):void {
			updateTrowelPosition();
			e.updateAfterEvent();
		}
		
		private function updateTrowelPosition():void{
//			if (!_trowel.digging) {
				_trowel.visible = true;
				_trowel.x = mouseX;
				_trowel.y = mouseY;
//			}
		}
		
		private function onAnswerButtonClick(m:MouseEvent):void
		{
			trace("button name clicked: " + m.currentTarget.name + " correct ans " + esAnswer);
			
			if (_gameStarted && !_alreadyAswered && _room != null)
			{
				
				p2Trowel.visible = true;
				
				_alreadyAswered = true
				
				var esob:EsObject = new EsObject();
				esob.setString(PluginConstants.ACTION, PluginConstants.ANSWER_HAS_BEEN_CHOSEN);
				var esAnswer:String = new String;
				
				switch(m.currentTarget.name)
				{
					case "aBtn":
						esob.setString(PluginConstants.ANSWER_CHOSEN, "A");
						esAnswer = "A"			
						break;
					
					case "bBtn":
						esob.setString(PluginConstants.ANSWER_CHOSEN, "B");
						esAnswer = "B"			
						break;
					
					case "cBtn":
						esob.setString(PluginConstants.ANSWER_CHOSEN, "C");
						esAnswer = "C"			
						break;
					
					case "dBtn":
						esob.setString(PluginConstants.ANSWER_CHOSEN, "D");
						esAnswer = "D"			
						break;
					
				}
				
				
				// animate buttons and stuff
				if (esAnswer == _correctAnswer)
				{
					trace("CORRECT");
					changeColorsOnAnswer(_correctAnswer, true);
					_iWasCorrect = true;
					
				}
				else
				{
					trace("WRONG");
					changeColorsOnAnswer(_correctAnswer, false);
					_iWasCorrect = false;
				}
				
				
				//send
				sendToPlugin(esob);
				
				playAnswerEffects();
			}
		}
		
		private function changeColorsOnAnswer(correctAnswer:String, answeredCorrectly:Boolean):void
		{
			var frameLabel:String = new String; 
			
			if (answeredCorrectly)
			{
				frameLabel = "correct"
			}
			else
			{
				frameLabel = "wrong";
			}
			
			switch(correctAnswer)
			{
				case "A":
					_bBtn.gotoAndPlay(frameLabel);
					_cBtn.gotoAndPlay(frameLabel);
					_dBtn.gotoAndPlay(frameLabel);
					break;
				
				case "B":
					_aBtn.gotoAndPlay(frameLabel);
					_cBtn.gotoAndPlay(frameLabel);
					_dBtn.gotoAndPlay(frameLabel);
					break;
				
				case "C":
					_aBtn.gotoAndPlay(frameLabel);
					_bBtn.gotoAndPlay(frameLabel);
					_dBtn.gotoAndPlay(frameLabel);
					break;
				
				case "D":
					_aBtn.gotoAndPlay(frameLabel);
					_bBtn.gotoAndPlay(frameLabel);
					_cBtn.gotoAndPlay(frameLabel);
					break;
			}
			
			_questionBox.gotoAndPlay(frameLabel);
				
		}
		
		private function displayWrongScreen(esAnswer:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function playAnswerEffects():void
		{
			
		}
		
		private function mouseDown(e:MouseEvent):void {
//			if (_gameStarted && !_trowel.digging && _room != null) {
			
			
				//tell the plugin you want to dig here
//				var esob:EsObject = new EsObject();
//				esob.setString(PluginConstants.ACTION, PluginConstants.DIG_HERE);
//				esob.setInteger(PluginConstants.X, mouseX);
//				esob.setInteger(PluginConstants.Y, mouseY);
//				
//				//send
//				sendToPlugin(esob);
//				
//				//animate
//				_trowel.dig();
//				playSound(new DIG_SOUND());
			
		}
		
		private function refreshPlayerList():void {
//			var dp:DataProvider = new DataProvider();
			
			for (var i:int = 0; i < _playerManager.players.length;++i) {
				var p:Player = _playerManager.players[i];
//				dp.addItem( { label:p.name + ", score: " + p.score.toString(), data:p } );
			}
			
//			_playerListUI.dataProvider = dp;
		}
		
		/**
		 * Parse the player list
		 */
		private function handlePlayerList(esob:EsObject):void{
			var players:Array = esob.getEsObjectArray(PluginConstants.PLAYER_LIST);
			for (var i:int = 0; i < players.length;++i) {
				var player_esob:EsObject = players[i];
				
				
				
				
//				var p:Player = new Player(trowelType);
				var p:Player = new Player("GreenTrowel");
				p.name = player_esob.getString(PluginConstants.NAME);
				p.score = player_esob.getInteger(PluginConstants.SCORE);
				p.isMe = p.name == _myUsername;
				
				if (!p.isMe) {
					addChild(p.trowel);
				}
				
				_playerManager.addPlayer(p);
			}
			refreshPlayerList();
		}
		
		/**
		 * Remove a player
		 */
		private function handleRemovePlayer(esob:EsObject):void{
			var name:String = esob.getString(PluginConstants.NAME);
			var player:Player = _playerManager.playerByName(name);
			if (!player.isMe) {
				removeChild(player.trowel);
			}
			_playerManager.removePlayer(name);
			refreshPlayerList();
		}
		
		/**
		 * Add a player
		 */
		private function handleAddPlayer(esob:EsObject):void{
		
			
			var p:Player = new Player("GreenTrowel");
			p.name  = esob.getString(PluginConstants.NAME);
			p.score = 0;
			
			trace(_myUsername + " handling add player: " + p.name);
//			sendCursorBroadcast();
			
			p.isMe = p.name == _myUsername;
			if (!p.isMe) {
				addChild(p.trowel);
			}
			
			_playerManager.addPlayer(p);
			
			refreshPlayerList();
		}
		
		/**
		 * Called when the server tells the client something went wrong
		 */
		private function handleError(esob:EsObject):void{
			var error:String = esob.getString(PluginConstants.ERROR);
			switch (error) {
				case PluginConstants.SPOT_ALREADY_DUG:
					_trowel.stopDigging();
//					playSound(new NOTHING_SOUND());
					updateTrowelPosition();
					break;
				default:
					trace("Error not handled: " + error);
			}
		}
		
		/**
		 * Called when the server tells the client someone has finished digging
		 */
		private function handleDoneDigging(esob:EsObject):void {
			//grab some initial information off of the EsObject
			var name:String = esob.getString(PluginConstants.NAME);
			var score:int = esob.getInteger(PluginConstants.SCORE);
			
			//find the player and update the score property
			var player:Player = _playerManager.playerByName(name);
			player.score = score;
			
			player.trowel.stopDigging();
			
			//if this player is me, then process the EsObject further
			if (player.isMe) {
				//stop the digging animation
				_trowel.stopDigging();
				
				//If true an item was found
				var found:Boolean = esob.getBoolean(PluginConstants.ITEM_FOUND);
				if (found) {
					//get the id that says which of the 4 item types was found
					var itemId:int = esob.getInteger(PluginConstants.ITEM_ID);
					
					//create item, set its type, position it, and add to screen
					var item:Item = new Item();
					item.itemType = itemId;
					item.x = _trowel.x;
					item.y = _trowel.y;
					_itemsHolder.addChild(item);
					
					//play a positive sound since you found an item
//					playSound(new FOUND_SOUND());
				} else {
					//play a negative sound since you found nothing
//					playSound(new NOTHING_SOUND());
				}
				
				//move trowel to wherever the mouse now is
				updateTrowelPosition();
			}
			
			//rebuild the player list to show updated scores
			refreshPlayerList();
		}
		
		public function set es(value:ElectroServer):void {
			_es = value;
		}
		
		public function update():void
		{
			
		}
		
		public function get room():Room
		{
			return _room;	
		}
		
		public function set room(value:Room):void {
			_room = value;
		}
		
	}
	
}