package pre_game.src.helpers
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import org.osflash.signals.Signal;
	
	import playerio.DatabaseObject;
	
	import pre_game.src.model.PreGameModelo;
	
	
	public class TextDisplayer extends Sprite
	{
		private static var instance:TextDisplayer;
		private static var allowInstantiation:Boolean;
		
		
		public static var updateTextSig:Signal = new Signal();
		private var _opFavPowTxtTF:TextField;
		private var _opAvgLevelBeatenTF:TextField;
		private var _opLossesTF:TextField;
		private var _opWinsTF:TextField;
		private var _opTitleTF:TextField;
		private var _opLevelTF:TextField;
		private var _opRankTF:TextField;
		private var _opNameTF:TextField;
		private var _myFavPowTxtTF:TextField;
		private var _myAvgLevelBeatenTF:TextField;
		private var _myLossesTF:TextField;
		private var _myWinsTF:TextField;
		private var _myTitleTF:TextField;
		private var _myLevelTF:TextField;
		private var _myRankTF:TextField;
		private var _myNameTF:TextField;
		private var _preGameModel:PreGameModelo;
		private static var _preGameScreen:PreGameScreen;
		private var _waitingForOpponentToTxt:TextField;
		private var _WaitingForOpponentClassTxt:TextField;
		
		public function TextDisplayer()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
			
		}
		
		
		public static function getInstance(preGameScreen : PreGameScreen):TextDisplayer {
			if (instance == null) {
				_preGameScreen = preGameScreen;
				trace("start dat " + preGameScreen + " fuck " +  _preGameScreen);
				
				allowInstantiation = true;
				trace("text displayer" + preGameScreen);
				instance = new TextDisplayer();
				
				
				allowInstantiation = false;
			}
			return instance;
		}

		
		private function init():void
		{
			trace("Helper Class Initialized.");
			assignVars();
			addListeners();
		}
		
			// encapsulate logic / calculations for other classes in public functions
		public static function helpOut():void
		{
//			Model.someInteger = 5;
		}
		
		
		private function assignVars():void
		{
			
			_preGameModel = PreGameModelo.getInstance();
			
			trace("pre game Screen " + _preGameScreen);
			
			_myNameTF = _preGameScreen["myNameTxt"];
			_myRankTF = _preGameScreen["myRankTxt"];
			_myLevelTF = _preGameScreen["myLevelTxt"];
			_myTitleTF = _preGameScreen["myTitleTxt"];
			_myWinsTF = _preGameScreen["myWinsTxt"];
			_myLossesTF = _preGameScreen["myLossesTxt"];
			_myAvgLevelBeatenTF = _preGameScreen["myAvgLevelBeatenTxt"];
			_myFavPowTxtTF = _preGameScreen["myFavPowTxt"];
			
			_waitingForOpponentToTxt = _preGameScreen["waitingForOpponentToTxt"];
			_waitingForOpponentToTxt.visible = false;

			_WaitingForOpponentClassTxt = _preGameScreen["WaitingForOpponentClassTxt"];
//			_WaitingForOpponentClassTxt.visible = false;
		
		
			_opNameTF = _preGameScreen["opNameTxt"];
			_opRankTF = _preGameScreen["opRankTxt"];
			_opLevelTF = _preGameScreen["opLevelTxt"];
			_opTitleTF = _preGameScreen["opTitleTxt"];
			_opWinsTF = _preGameScreen["opWinsTxt"];
			_opLossesTF = _preGameScreen["opLossesTxt"];
			_opAvgLevelBeatenTF = _preGameScreen["opAvgLevelBeatenTxt"];
			_opFavPowTxtTF = _preGameScreen["opFavPowTxt"];
		
		
		
		}
		
		public function flushMyText():void
		{
			_myNameTF.text = _preGameModel.myName;
			
		}
//		private function onUpdateSigFired():void
//		{
//			// TODO Auto Generated method stub
//			
//		}		
		
		private function addListeners():void
		{
//			updateTextSig.add(onUpdateSigFired);
			
			
		}
		
		
		public function displayInfoFromDbObject(o:DatabaseObject):void
		{
			//	trace("nameo " + o.something);
			//trace("woAH " + o.coolGuyOb["obString"]);
			//			trace("woAH " + o.coolGuyOb["innerOb"]["loopa"]);
			trace("o ob@@ name" + o.name);
			trace("o.key: @ "+o.key);
			
			switch(o.key)
			{
				case _preGameModel.myName:
					
					_myNameTF.text = o.key;
					trace("_myRank " + _myRankTF);
					trace('o.general["rank"] ' + o.general["rank"]);
					_myRankTF.text = "Rank: " + o.general["rank"];
					_myLevelTF.text = "Level: " + o.general["level"];
					_myTitleTF.text = o.general["title"];
//					
					_myWinsTF.text = "Wins: " + o.stats["wins"];
					_myLossesTF.text = "Losses: " + o.stats["losses"];
					_myAvgLevelBeatenTF.text = "Average Level Beaten: " + o.stats["avgLevelBeaten"];
					_myFavPowTxtTF.text = "Favorite Powerup: " + o.stats["favPow"];
					
					break;
				
				case _preGameModel.opponentName:
//					_opNameTF.text = o.key;
					_opRankTF.text = "Rank: " + o.general["rank"];
					_opLevelTF.text = "Level: " + o.general["level"];
					_opTitleTF.text = o.general["title"];
					//					
					_opWinsTF.text = "Wins: " + o.stats["wins"];
					_opLossesTF.text = "Losses: " + o.stats["losses"];
					_opAvgLevelBeatenTF.text = "Average Level Beaten: " + o.stats["avgLevelBeaten"];
					_opFavPowTxtTF.text = "Favorite Powerup: " + o.stats["favPow"];
					
					break;
				
				default:
					trace("ERROR: trying to display dbobject for unknown player: " + o.key);
					break;
				
			}
			
			
		}
	}	
}