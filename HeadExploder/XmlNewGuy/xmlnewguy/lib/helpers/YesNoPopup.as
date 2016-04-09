package helpers
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import externaltween.FGtween;
	import externaltween.easing.Back;
	
	public class YesNoPopup extends MovieClip
	{
		private var _model:Object;
		private var _okBtn:SimpleButton;
		private var _stage:Object;
		private var _stageHeight:uint;
		private var _yesBtn:Object;
		private var _noBtn:Object;
		
		
		public function YesNoPopup(model:Object = null, stage:Object = null)
		{
			
			_model = model;
			_stage = stage;
			
			init();
		}
		
		
		private function init():void
		{
			assignVars();
			addListeners();
			
			if (_stage == null)
			{
				_stageHeight = 1000;
			}

			else
			{
				_stageHeight = _stage.stageHeight;
			}
			
		}		
		
		
		private function assignVars():void
		{
			_yesBtn = this["yesBtn"];
			_noBtn = this["noBtn"];
			
		}
		
		private function addListeners():void
		{
			_yesBtn.addEventListener(MouseEvent.CLICK, onYesBtnClick);
			_noBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
		}		
		
		
		protected function onYesBtnClick(e:MouseEvent):void
		{
//			FGtween.to(this, 0.8, {y:(-1 * (this.height + 50)), ease:Back.easeIn, onComplete:onCompleteTweeningOut});
//			if (_model != null)
//			{
//				_model.character = "girl";
//			}
			trace(this.name);
//			
		}		
		
		protected function onBtnClick(e:MouseEvent):void
		{
			FGtween.to(this, 0.8, {y:(-1 * (this.height + 50)), ease:Back.easeIn, onComplete:onCompleteTweeningOut});
		}	
		
		
		protected function onOkBtnClick(event:Event):void
		{
			
		}		
		
		protected function onCompleteTweeningOut():void
		{
			
		}		
		
			
		
		
	}
}