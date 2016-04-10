package  {
	
	import flash.display.MovieClip;
	import flash.system.Security;
	
	
	public class MainRect extends MovieClip {
		
		
		public function MainRect() {
			// constructor code
			
			Security.allowDomain("*")
		}
	}
	
}
