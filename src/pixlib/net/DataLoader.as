package pixlib.net {
	//{ Imports
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import pixlib.ErrorConstants;
	import pixlib.commands.DataCommand;
	import pixlib.logging.Log;
	//}
	
	public class DataLoader extends DataCommand {
		
		//{ Event Types
		///////////////////////////////////////////////////////////////////////
		/** The type of the event dispatched when the HTTP status is available. */
		public static const HTTP_STATUS:String = 'httpStatus';
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Constructor & Initialization
		///////////////////////////////////////////////////////////////////////
		private var _loader:URLLoader;
		
		/**
		 * Constructor.
		 * @param  request      The request to use. Supports String or URLRequest.
		 * @param  dataFormat   Indicates how to interpret the received data.
		 *                      @see flash.net.URLLoaderDataFormat
		 * @param  transformer  The transformer function to use.
		 */
		public function DataLoader(request:Object = '',
						dataFormat:String = URLLoaderDataFormat.BINARY,
						transformer:Function = null) {
			if (request is String) {
				this.request = new URLRequest(request as String);
			} else if (request is URLRequest) {
				this.request = request as URLRequest;
			} else {
				throw new ArgumentError('Invalid URL request:  ' + request);
			}
			this.transformer = transformer;
			_createLoader();
			this.dataFormat = dataFormat;
		}
		
		/** @private */
		private function _createLoader():void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, _loaderOnComplete);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, _loaderOnHttpStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, _loaderOnIoError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _loaderOnSecurityError);
			loader.addEventListener(ProgressEvent.PROGRESS, _loaderOnProgress);
			_loader = loader;
		}
		
		/** @private */
		private function _disposeLoader():void {
			_loader.removeEventListener(Event.COMPLETE, _loaderOnComplete);
			_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _loaderOnHttpStatus);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, _loaderOnIoError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _loaderOnSecurityError);
			_loader.removeEventListener(ProgressEvent.PROGRESS, _loaderOnProgress);
			_loader = null;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Properties
		///////////////////////////////////////////////////////////////////////
		/** The request to use. */
		public var request:URLRequest;
		
		private var _httpStatus:int = -1;
		/** Get the HTTP status the loader completed with. */
		public final function get httpStatus():int { return _httpStatus; }
		
		/** Get or set the format of the loaded data. */
		public final function get dataFormat():String { return _loader.dataFormat; }
		public final function set dataFormat(value:String):void { _loader.dataFormat = value; }
		
		/**
		 * A function used to transform the received data.
		 * The function has the following signature: <code>function(data:*Object):Object</code>.
		 * The returned value is used as result of the command.
		 * If the function throws, the command completes with an error.
		 */
		public var transformer:Function;
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Protected Utility Methods
		///////////////////////////////////////////////////////////////////////
		/**
		 * Completes the loader with an error.
		 * @param	code		The message code of the error.
		 * @param	message		The message of the underlying exception.
		 */
		protected final function dispatchUrlError(code:String, message:String):void {
			const error:Log = new Log(Log.ERROR, code, {message: message, url: request.url}, this);
			if (_httpStatus >= 0) error.details.httpStatus = _httpStatus;
			dispatchError(error);
		}
		
		/**
		 * Call this method to use the property <code>transformer</code>,
		 * if available, to transform the data, and complete the command.
		 */
		protected final function transformAndComplete(data:*):void {
			if (transformer != null) {
				try {
					data = transformer(data);
				} catch (error:*) {
					dispatchError(error);
					return;
				}
			}
			dispatchCompleteData(data);
		}
		
		/**
		 * Override this method to parse the received data.
		 * Either <code>dispatchComplete</code> or <code>dispatchError</code> must be called.
		 * @param	data		The data to parse.
		 */
		protected function parseData(data:*):void {
			transformAndComplete(data);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Public Overrides
		///////////////////////////////////////////////////////////////////////
		/** @inheritDoc */
		override public function start():void {
			if (running) return;
			setRunning(true);
			_loader.load(request);
		}
		
		/** @inheritDoc */
		override public function stop():void {
			if (! running) return;
			_loader.close();
			setRunning(false);
		}
		
		/**
		 * Dispose the instance.
		 * @param  recursive  This flag has no efect in this implementation.
		 */
		override public function dispose(recursive:Boolean = true):void {
			super.dispose(recursive);
			_disposeLoader();
			request = null;
			transformer = null;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ URLLoader Events
		///////////////////////////////////////////////////////////////////////
		private function _loaderOnComplete(event:Event):void {
			parseData(_loader.data);
		}
		private function _loaderOnHttpStatus(event:HTTPStatusEvent):void {
			_httpStatus = event.status;
			dispatch(HTTP_STATUS, this);
		}
		private function _loaderOnIoError(event:IOErrorEvent):void {
			dispatchUrlError(ErrorConstants.IO_ERROR, event.text);
		}
		private function _loaderOnSecurityError(event:SecurityErrorEvent):void {
			dispatchUrlError(ErrorConstants.SECURITY_ERROR, event.text);
		}
		private function _loaderOnProgress(event:ProgressEvent):void {
			dispatchProgress(event.bytesLoaded, event.bytesTotal);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Events Handling
		///////////////////////////////////////////////////////////////////////
		/**
		 * Add a listener for the <code>HTTP_STATUS</code> event.
		 * The argument of the listener is the command itself.
		 * @return The object itself.
		 */
		public final function onHttpStatus(listener:Function):DataLoader {
			this.addListener(HTTP_STATUS, listener);
			return this;
		}
		///////////////////////////////////////////////////////////////////////
		//}
	}
}