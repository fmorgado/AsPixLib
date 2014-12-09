package pixlib.net {
	import flash.net.URLLoaderDataFormat;
	
	import pixlib.ErrorConstants;
	
	/** A command to load JSON data. */
	public class JsonLoader extends DataLoader {
		
		/**
		 * Constructor.
		 * @param	request      The request to use.
		 * @param	transformer  An transformer function to use.
		 */
		public function JsonLoader(request:*, transformer:Function = null) {
			super(request, URLLoaderDataFormat.TEXT, transformer);
		}
		
		override protected function parseData(data:*):void {
			var json:Object;
			try {
				json = JSON.parse(data);
			} catch (error:Error) {
				dispatchUrlError(ErrorConstants.INVALID_JSON_FORMAT, error.message);
				return;
			}
			transformAndComplete(json);
		}
		
	}
}