package pixlib.net {
	import flash.net.URLLoaderDataFormat;
	
	/** A command to load <code>String</code> data from an URL. */
	public class StringLoader extends DataLoader {
		
		/**
		 * Constructor.
		 * @param  request      The request to use. Supports String or URLRequest.
		 * @param  transformer  The transformer function to use.
		 */
		public function StringLoader(request:* = null, transformer:Function = null) {
			super(request, URLLoaderDataFormat.TEXT, transformer);
		}
		
	}
}