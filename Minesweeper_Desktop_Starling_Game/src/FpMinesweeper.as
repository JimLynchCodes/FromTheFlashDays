package
{
	import com.configu.FPMConfig;
	import com.controllers.FPMController;
	import com.models.FPMModel;
	import com.views.FPMView;
	
	import flash.display.Sprite;
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(frameRate="60", width="800", height="600", backgroundColor="0x333333")]
	
	
	public class FpMinesweeper extends Sprite
	{
		private var _nativeStage:Object;
		private var _mainView:Starling;
		private var _controller:FPMController;
		private var _model:FPMModel;
		private var _config:FPMConfig;
		
		
		public function FpMinesweeper()
		{
			init();
		}
		
		
		private function init():void
		{
			assignVars();
		}
		
		
		private function assignVars():void
		{
			_nativeStage = stage;
			
			_config = new FPMConfig();
			_model = new FPMModel(_config);
			_controller = new FPMController(_model);
			_mainView = new Starling(FPMView, stage);
			
			_mainView.antiAliasing = 1;
			_mainView.addEventListener(Event.ROOT_CREATED, onMainViewCreated);
			
			_mainView.start();
			
		}		
		
		
		private function onMainViewCreated(e:Event):void
		{
			var createdView:FPMView = Starling.current.root as FPMView;
			
			createdView.passVars(_model, _controller);
			
		}
		
		
	}
}