package com.states
{
	import com.views.DcMainView;
	import com.trash.NewViewIos;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class TestState extends Sprite implements IDCState
	{
		private var _model:Object;
		private var _mainView:DcMainView;
		
		public function TestState(mainView:DcMainView, model:Object)
		{
			_mainView = mainView;
			_model = model
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function update():void
		{
		}
		
		public function destroy():void
		{
		}
	}
}