package pixlib.net {
	//{ Imports
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import pixlib.ErrorConstants;
	//}
	
	public class ImageLoader extends DataLoader {
		
		//{ Constructor
		///////////////////////////////////////////////////////////////////////
		/**
		 * Constructor.
		 * @param  request  The request to use. Supports String or URLRequest.
		 */
		public function ImageLoader(request:*) {
			super(request);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Loader Handling
		///////////////////////////////////////////////////////////////////////
		private var _loader:Loader;
		
		/** @private */
		private function _createLoader(bytes:ByteArray):void {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, _onLoaderComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onLoaderError);
			_loader.loadBytes(bytes, new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		/** @private */
		private function _destroyLoader():void {
			if (_loader != null) {
				try { _loader.close(); } catch (error:Error) {}
				_loader.contentLoaderInfo.removeEventListener(Event.INIT, _onLoaderComplete);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _onLoaderError);
				_loader = null;
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Public Methods
		///////////////////////////////////////////////////////////////////////
		override public function dispose(recursive:Boolean = true):void {
			super.dispose(recursive);
			_destroyLoader();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Event Handlers
		///////////////////////////////////////////////////////////////////////
		override protected function parseData(data:*):void {
			_createLoader(data);
		}
		
		private function _onLoaderComplete(event:Event):void {
			var result:Loader = _loader;
			_destroyLoader();
			dispatchCompleteData(result);
		}
		
		private function _onLoaderError(event:IOErrorEvent):void {
			_destroyLoader();
			dispatchUrlError(ErrorConstants.INVALID_IMAGE_FORMAT, event.text);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}