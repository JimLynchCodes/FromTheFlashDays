package com.views
{
	import com.balls.Ball;
	import com.externaltween.FGtween;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	public class HackView extends MovieClip
	{
		private var _stage:Object;
		private var _model:Object;
		private var _controller:Object;
		private var _config:Object;
		private var _guy:MovieClip;
		private var _rStartY:Number;
		private var _targetY:Number;
		private var _lStartY:Number;
		private var _largetY:Number;
		private var _ball:Ball;
		private var _leftFoot:DisplayObject;
		private var _rightFoot:DisplayObject;
		private var _rect_1:Sprite;
		private var _guyCircle:Sprite;
		private var _foot:Sprite;
		private var _otherFoot:DisplayObject;
		private var _downFootY:Number;
		private var _guyWidth:Number;
		private var _rightFootKicking:Boolean;
		private var _leftFootKicking:Boolean;
		
		
		public function HackView(model:Object, controller:Object, config:Object, stage:Object, guy:MovieClip, rect_1:Sprite)
		{
			// standard mvc constructor setup
			_model = model;			
			_controller = controller;
			_config = config;
			_stage = stage;
			_guy = guy;
			_rect_1 = rect_1;
			
			trace("guy width 2: " + _guy.width);
				
			init();
			
		}
		
		
		private function init():void
		{
			
			assignVars();
			addListeners();
			
			trace("Main View Initialized.");
			
			trace(_model);
			trace(_controller);
			trace(_config);
			trace(_stage);
			
			_guy.addChild(_leftFoot);
			_guy.addChild(_rightFoot);
			
			_leftFoot.visible = false;
			_rightFoot.visible = false;

			_rightFoot.x = -20
			
				trace(_model)
				trace(_model.config)
				
			_downFootY = _model.config.DOWN_FOOT_Y;
			
			_rightFoot.y = _downFootY
			
			_leftFoot.x = 15.6
			_leftFoot.y = _downFootY
				
			_stage.addChild(_ball);
				
			_ball.y = 10;
			_ball.x = _guy.x + .5 * _guy.width
			
			_guyCircle = _guy["guyFoot"]
				
				_guyCircle.addChild(_otherFoot);
			
			_foot = _guy["foot"]
				trace("_foot " + _foot);
				
				
			_ball.addEventListener(Event.ENTER_FRAME, enterFrameBallRemovalHandler);
//			_stage.addEventListener(Event.ENTER_FRAME, moveGuyEnterFrame);
			
			trace("guy width 3: " + _guy.width);
			
		}
		
		
		private function moveGuyEnterFrame(e:Event):void
		{
			
			
			_guyWidth = _guy.width;
			
			var _halfGuyWidth:Number = _guyWidth * .5
			
			
			if (mouseX < (_guy.x - _halfGuyWidth))
			{
				_guy.x = _guy.x - _model.config.GUY_SPEED;
				// do walking left animation			
			}
			
			if (mouseX > (_guy.x - _halfGuyWidth)  && mouseX < (_guy.x + _halfGuyWidth) )
			{
				// do stanging still animation			
			}
			
			if (mouseX > (_guy.x + _halfGuyWidth))
			{
				_guy.x = _guy.x + _model.config.GUY_SPEED;
				// do walking right animation			
			}
			
			
//			trace("guy width g: " + _guy.width);
		}
		
		
		private function enterFrameBallRemovalHandler(e:Event):void
		{
			
			if (_rect_1.hitTestObject(_leftFoot) == true)
			{
				trace(" hitting rect")
			}
			
			
			
			if (e.currentTarget.y > _stage.stageHeight)
			{
				_stage.removeChild(_ball)
				_ball.removeEventListener(Event.ENTER_FRAME, enterFrameBallRemovalHandler)
					
				_model.kicks = 0;
					
				trace("ball removed");
			}
			
	
			
		}
		
		private function assignVars():void
		{
			
			var _footClass:Class = getDefinitionByName("com.feet.Foot") as Class;
			
			_leftFoot = new _footClass(_model) as DisplayObject;
			_rightFoot = new _footClass(_model) as DisplayObject;
			
			_model.leftFoot = _leftFoot;
			_model.rightFoot = _rightFoot;
			
			
//			_leftFoot = _guy["mattBoyd"]["hackHitterLeft"] as MovieClip;
//			_rightFoot = _guy["mattBoyd"]["hackHitterRight"]
//				
			var _ballClass:Class = getDefinitionByName("com.balls.Ball") as Class;
			_ball = new _ballClass(_model) as Ball;
			
			_otherFoot = new _ballClass(_model) as DisplayObject;
			
			_lStartY = _leftFoot.y; 
			
			_model.guy = _guy
				
			trace("_model.guy " + _model.guy);
			
		}
		
		
		private function addListeners():void
		{
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			// listen for events from model
			
			
			_model.addEventListener(_config.KEYBOARD_CHANGE, keyboardChangeHandler);
			_model.addEventListener(_config.MOUSE_CLICK_CHANGE, mouseChangeHandler);
			
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onTheMouseMove);
			
			
			trace(stage);
			
//			_stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			_stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightClick);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onLeftClick);
		}
		
		protected function mouseHandler(event:MouseEvent):void
		{
//			trace(event)
		}		
		
		private function onLeftClick(m:MouseEvent):void
		{
			
			
			if (_rightFootKicking == false && _leftFootKicking == false)
			{
				_guy["mattBoyd"].gotoAndPlay("myLeftKickSide");
				_rightFootKicking = true;
				_rightFoot.visible = true;
				_guy["mattBoyd"].gotoAndPlay("myLeftKickSide");
				
				_rightFoot.y = _downFootY
				
				_targetY = 	_downFootY - _model.config.KICK_HEIGHT;
				
				FGtween.to(_rightFoot, .5, {y:_targetY,  onComplete:onFinishRightAtTop});
			}
			
		}
		
		
		private function onFinishRightAtTop():void
		{
			
			FGtween.to(_rightFoot, .5, {y:_downFootY, onComplete:OnRightBackDown});
		}
		
		private function OnRightBackDown():void
		{
			_rightFoot.visible = false;
			_rightFootKicking = false;
			
		}
		
		
		private function onRightClick(m:MouseEvent):void
		{
//			trace("right click");
			
			if (_rightFootKicking == false && _leftFootKicking == false)
			{
				_guy["mattBoyd"].gotoAndPlay("myRightKickSide");
				_leftFootKicking = true;
				_leftFoot.visible = true;
				_guy["mattBoyd"].gotoAndPlay("myRightKickSide");
				
				_leftFoot.y = _downFootY
				
				_largetY = 	_downFootY - _model.config.KICK_HEIGHT;
				
				FGtween.to(_leftFoot, .5, {y:_largetY,  onComplete:onLeftAtTop});
			}
		}
		
		
		private function onLeftAtTop():void
		{
			FGtween.to(_leftFoot, .5, {y:_downFootY, onComplete:onLeftBackDown});
		}
		
		
		private function onLeftBackDown():void
		{
			_leftFoot.visible = false;
			_leftFootKicking = false;
			
		}
		
		private function onTheMouseMove(e:Event):void
		{
			_guy.x = mouseX;
//			trace(mouseX);
			
		}
		
		
		private function addedToStageHandler(event:Event):void
		{
			trace("main view added to stage");
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			
			
			
			
		}
		
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			// have controller process keyboard input.
			_controller.processKeyPress(event);
			
			trace(event.charCode);
			
			
				// if key pressed is space
			if (event.charCode == 32)
			{
				_model.kicks = 0;
				trace("space pressed");
				_stage.addChild(_ball)
				_ball.y = 10;
				_ball.x = _guy.x
				_ball.xPower = 0;
				
			}
			
		}
		
		
		private function onMouseClick(m:MouseEvent):void
		{
				// have controller process the mouse input.
			_controller.processMouseClick(m);
		}
		
		
		private function keyboardChangeHandler(event:Event):void
		{
			
		}
		
		
		private function mouseChangeHandler(e:Event):void
		{
			// display the updated model information.
//			trace(_model.clicks + " clicks");
			
			
			
		}
		
		
		
	}
}