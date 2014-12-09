package pixlib.net {
	import flash.net.URLLoaderDataFormat;
	import pixlib.ErrorConstants;
	
	/** A command to load JSON data. */
	public class XMLLoader extends DataLoader {
		
		/**
		 * Constructor.
		 * @param	request      The request to use.
		 * @param	transformer  An transformer function to use.
		 */
		public function XMLLoader(request:*, transformer:Function = null) {
			super(request, URLLoaderDataFormat.TEXT, transformer);
		}
		
		override protected function parseData(data:*):void {
			var node:XML;
			try {
				node = new XML(data);
			} catch (error:Error) {
				dispatchUrlError(ErrorConstants.INVALID_XML_FORMAT, error.message);
				return;
			}
			transformAndComplete(node);
		}
		
	}
}