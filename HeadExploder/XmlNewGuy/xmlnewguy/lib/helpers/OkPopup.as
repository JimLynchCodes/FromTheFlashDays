package helpers
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import externaltween.FGtween;
	import externaltween.easing.Back;
	
	public class OkPopup extends MovieClip
	{
		private var _model:Object;
		private var _okBtn:SimpleButton;
		private var _stage:Object;
		private var _stageHeight:uint;
		
		
		
		
		public function OkPopup(model:Object = null, stage:Object = null)
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
			_okBtn = this["okBtn"];
			
		}
		
		private function addListeners():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK, onOkBtnClick);
			
		}		
		
		protected function onOkBtnClick(event:Event):void
		{
			FGtween.to(this, 0.8, {y:(-1 * (this.height + 50)), ease:Back.easeIn, onComplete:onCompleteTweeningOut});
			trace("_stageHeight " + _stageHeight);
		}		
		
		protected function onCompleteTweeningOut():void
		{
			
		}		
		
		
	}
}