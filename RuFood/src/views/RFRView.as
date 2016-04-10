package views
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	
	public class RFRView extends Sprite
	{
		private var _stage:Object;
		private var _model:Object;
		private var _controller:Object;
		private var _configu:Object;
		
		
		public function RFRView(model:Object, controller:Object, stage:Object)
		{
			_model = model;			
			_controller = controller;
			_stage = stage;
			
			init();
			
		}
		
		
		private function init():void
		{
			
			assignVars();
			addListeners();
			
			trace("Main View Initialized.");
			
			
		}
		
		
		private function assignVars():void
		{
			_configu = _model.configu;
			
			
		}
		
		
		private function addListeners():void
		{
			
			_model.addEventListener(_configu.KEYBOARD_CHANGE, keyboardChangeHandler);
			_model.addEventListener(_configu.MOUSE_CLICK_CHANGE, mouseChangeHandler);
			
			_stage.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		
		private function addedToStageHandler(event:Event):void
		{
			trace("Main view added to stage.");
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			_stage.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		
		private function keyDownHandler(event:KeyboardEvent):void
		{

			_controller.processKeyPress(event);
			
		}
		
		
		private function onMouseClick(m:MouseEvent):void
		{

			_controller.processMouseClick(m);
		
		}
		
		
		private function keyboardChangeHandler(event:Event):void
		{

			trace("the " + _model.keyDirection + "key")
			
			
		}
		
		
		private function mouseChangeHandler(e:Event):void
		{

			trace(_model.clicks + " clicks");
			
			
			
		}
		
		
		
	}
}