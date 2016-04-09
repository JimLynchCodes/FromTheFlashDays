﻿package sample.ui{	import flash.display.Sprite	import flash.display.Stage	import flash.events.Event	import flash.text.TextFormatAlign		import flash.events.MouseEvent		import sample.ui.components.*	import sample.ui.components.scroll.*	import playerio.*;		public class Lobby extends Sprite{		private var _stage:Stage		private var _roomType:String		private var _handleJoin:Function		private var _handleJoinError:Function		private var _client:Client		private var base:Box 		private var createDialog:Box		private var loader:Box		private var roomContainer:Rows		private var cancel:TextButton		function Lobby(client:Client, roomType:String, handleJoin:Function, handleJoinError:Function = null){			_stage = client.stage;			_client = client			_roomType = roomType			_handleJoin = handleJoin			_handleJoinError = handleJoinError						roomContainer = new Rows().spacing(2);						base = new Box().fill(0xffffff,.8).margin(20,20,20,20).add(				new Box().fill(0x000000,.5,10).margin(10,10,10,10).add(					new Box().fill(0xffffff,1,5).margin(10,10,10,10).add(						new Label("Lobby", 20, TextFormatAlign.LEFT)					).add(						new Box().margin(35,0,35,0).add(							new Box().margin(0,0,0,0).fill(0x0,0,10).border(1,0x555555,1).add(								new ScrollBox().margin(3,1,3,3).add(roomContainer)							)						)					).add(						new Box().margin(NaN,0,0,0).add(							new Columns().spacing(10).add(								cancel = new TextButton("Cancel", hide),								new TextButton("Create new game!",showCreateRoom)							)										)					)				)			)			var gamename:Input;			createDialog = new Box().fill(0xffffff,.8).add(				new Box().fill(0x000000,.5,15).margin(10,10,10,10).minSize(300,0).add(					new Box().fill(0xffffff,1,5).margin(10,10,10,10).minSize(300,0).add(						new Rows(							new Label("Create new game", 20, TextFormatAlign.CENTER),							new Label("Game name"),							gamename = new Input("My Amazing game!", 12, TextFormatAlign.LEFT, false),							new Columns().spacing(10).margin(10).add(								new TextButton("Cancel", hideCreateRoom),								new TextButton("Create", function(){ 									createGame(gamename.text)								})							)										).spacing(3)					)				)			)						loader = new Box().fill(0xffffff,.8).add(				new Label("Joining game.", 20)			).add(				new Box().margin(20).add(new Label("Please wait while we connect to the server.", 12))			)						addChild(base)			realign();		}				public function showCreateRoom(e:Event = null){			addChild(createDialog)		}				public function hideCreateRoom(e:Event = null){			if(createDialog.parent) removeChild(createDialog)		}				public function show(modal:Boolean = false):void{			_stage.addChild(this);			_stage.addEventListener(Event.RESIZE, realign)			refresh();			realign()			cancel.visible = !modal			trace(cancel.visible)		}				public function hide():void{			hideCreateRoom()			hideLoader(); 			if(this.parent) _stage.removeChild(this);			_stage.removeEventListener(Event.RESIZE, realign)		}						private function showLoader():void{			addChild(loader)		}		private function hideLoader():void{			if(loader.parent)removeChild(loader)		}				private function refresh():void{			roomContainer.removeChildren();						_client.multiplayer.listRooms(_roomType, {}, 50, 0, function(rooms:Array){				//Trace out returned rooms				for( var a:int=0;a<rooms.length;a++){					roomContainer.addChild(new RoomEntry(rooms[a], joinRoom))					}								base.reset();			}, function(e:PlayerIOError){				trace("Unable to list rooms", e)			})											}		private function joinRoom(id:String):void{			showLoader()			_client.multiplayer.joinRoom(				id,									//Room id				{},									//User join data.				handleJoin,							//Join handler				_handleJoinError					//Error handler				)		}				private function createGame(name:String):void{			hideCreateRoom();			showLoader()			_client.multiplayer.createRoom(				null,								//Room id, null for auto generted				_roomType,							//RoomType to create, bounce is a simple bounce server				true,								//Hide room from userlist				{name:name},						//Room Join data, data is returned to lobby list. Variabels can be modifed on the server				joinRoom,							//Create handler				_handleJoinError					//Error handler										   			)					}				private function handleJoin(connection:Connection):void{			hide();			_handleJoin(connection)		}				private function realign(e:Event = null):void{						//base.reset();			base.width = _stage.stageWidth			base.height = _stage.stageHeight						createDialog.width = _stage.stageWidth			createDialog.height = _stage.stageHeight						loader.width = _stage.stageWidth			loader.height = _stage.stageHeight					}	}	}