package pre_game.src.model
{


	public class PreGameModelo
	{
		
		private var _inFlashBuilder:Boolean = true;
//		private var _inFlashBuilder:Boolean = false;
		
	//	private var _readyChosen:Boolean = false;
		private static var instance:PreGameModelo;
		private static var allowInstantiation:Boolean;
		//---------
		private var _imReady:Boolean = false;
		private var _opponentIsReady:Boolean = false;
		private var _myClassChosen:String = "none";
		private var _opponentPowerups:Array = [];
		private var _iWantToStart:Boolean = false;
		private var _opponentWantsToStart:Boolean = false;
	//	private var _preGameMainClass:PreGameMainNew;
		private var _opponentName:String;
		private var _myName:String;
		private var _myPass:String;
		
		public function PreGameModelo()
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharedObjectManager.getInstance() instead of new.");
			} else {
				init();
			}
		}

//		public function get readyChosen():Boolean
//		{
//			return _readyChosen;
//		}
//
//		public function set readyChosen(value:Boolean):void
//		{
//			_readyChosen = value;
//		}

		public function get myPass():String
		{
			return _myPass;
		}

		public function set myPass(value:String):void
		{
			_myPass = value;
		}

		public function get opponentName():String
		{
			return _opponentName;
		}

		public function set opponentName(value:String):void
		{
			_opponentName = value;
		}

		public function get myName():String
		{
			return _myName;
		}

		public function set myName(value:String):void
		{
			_myName = value;
		}

		public static function getInstance():PreGameModelo {
			if (instance == null) {
				allowInstantiation = true;
				
				instance = new PreGameModelo();
				
				allowInstantiation = false;
				trace("in pre game model");
			}
			return instance;
		}
		
		private function init():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get inFlashBuilder():Boolean
		{
			return _inFlashBuilder;
		}

		public function set inFlashBuilder(value:Boolean):void
		{
			_inFlashBuilder = value;
		}

//		public function get preGameMainClass():PreGameMainNew
//		{
//			return _preGameMainClass;
//		}
//
//		public function set preGameMainClass(value:PreGameMainNew):void
//		{
//			_preGameMainClass = value;
//			_preGameMainClass.readySignal.dispatch("shit");
//			
//			_preGameMainClass = value;
//		}

		public function get imReady():Boolean
		{
			return _imReady;
		}

		public function set imReady(value:Boolean):void
		{
			_imReady = value;
		}

		public function get opponentIsReady():Boolean
		{
			return _opponentIsReady;
		}

		public function set opponentIsReady(value:Boolean):void
		{
			_opponentIsReady = value;
		}

		public function get myClassChosen():String
		{
			return _myClassChosen;
		}

		public function set myClassChosen(value:String):void
		{
//			_preGameMainClass.classChangeSignal.dispatch(value);
			_myClassChosen = value;
			trace("changed my class");
		}

		public function get opponentPowerups():Array
		{
			return _opponentPowerups;
		}

		public function set opponentPowerups(value:Array):void
		{
			_opponentPowerups = value;
		}

		public function get iWantToStart():Boolean
		{
			return _iWantToStart;
		}

		public function set iWantToStart(value:Boolean):void
		{
			_iWantToStart = value;
		}

		public function get opponentWantsToStart():Boolean
		{
			return _opponentWantsToStart;
		}

		public function set opponentWantsToStart(value:Boolean):void
		{
			_opponentWantsToStart = value;
		}

	}
}