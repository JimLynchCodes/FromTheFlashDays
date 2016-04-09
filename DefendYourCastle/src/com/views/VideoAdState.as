package com.views
{
	import com.states.IDCState;
	
	import starling.display.Sprite;
	
	public class VideoAdState extends Sprite implements IDCState
	{
		private var _view:DcMainView;
	
		public function VideoAdState(view:DcMainView)
		{
			_view = view;
			
			trace("video ad state begun");
		}
		
		public function update():void
		{
		}
		
		public function destroy():void
		{
		}
	}
}