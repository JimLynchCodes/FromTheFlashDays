package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;


	public class Main extends MovieClip {


		public function Main() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e: Event) {
			trace("Added to stage.");

			showYashiAd();
		}

		private function showYashiAd(): void {
			var url: String = "http://ads.yashi.com/11133";
			var request: URLRequest = new URLRequest(url);
			try {
				navigateToURL(request, 'content');
			} catch (e: Error) {
				trace("Error occurred!");
			}
		}


	}

}