package pixlib.logging {
	
	/** <code>Logger</code> implements a centralized way to handle logging. */
	public final class LoggerImpl {
		private const _listeners:Vector.<Function> = new Vector.<Function>();
		
		/** Constructor. */
		public function LoggerImpl() {}
		
		private var _level:int = Log.INFO;
		/** Get or set the level of the logger. @see pixlib.logging.LogLevel */
		public function get level():int { return _level; }
		public function set level(value:int):void { _level = value; }
		
		/** Indicates if the given level is loggable. */
		public function isLoggable(level:int):Boolean {
			return level >= _level;
		}
		
		private function _sendLog(log:Log):void {
			for each (var listener:Function in _listeners) {
				listener(log);
			}
		}
		
		/**
		 * Captures a log message.
		 * @param	log		The log message to capture.
		 */
		public function log(log:Log):void {
			if (log.level < _level) return;
			_sendLog(log);
		}
		
		/**
		 * Captures a log message with the given properties.
		 * @param	level    The level of the log.
		 * @param	code     The message code of the log.
		 * @param	details  The details of the log.
		 * @param	source   The source of the log.
		 */
		public function logWith(level:int, code:String, details:Object = null, source:* = null):void {
			if (level < _level) return;
			_sendLog(new Log(level, code, details, source));
		}
		
		/**
		 * Log a debug message.
		 * @param	code     The message code of the log.
		 * @param	details  The details of the log.
		 * @param	source   The source of the log.
		 */
		public function debug(code:String, details:Object = null, source:* = null):void {
			logWith(Log.DEBUG, code, details, source);
		}
		
		/**
		 * Log an information message.
		 * @param	code     The message code of the log.
		 * @param	details  The details of the log.
		 * @param	source   The source of the log.
		 */
		public function info(code:String, details:Object = null, source:* = null):void {
			logWith(Log.INFO, code, details, source);
		}
		
		/**
		 * Log a config message.
		 * @param	code     The message code of the log.
		 * @param	details  The details of the log.
		 * @param	source   The source of the log.
		 */
		public function config(code:String, details:Object = null, source:* = null):void {
			logWith(Log.CONFIG, code, details, source);
		}
		
		/**
		 * Log a warning message.
		 * @param	code     The message code of the log.
		 * @param	details  The details of the log.
		 * @param	source   The source of the log.
		 */
		public function warning(code:String, details:Object = null, source:* = null):void {
			logWith(Log.WARNING, code, details, source);
		}
		
		/**
		 * Log an error message.
		 * @param	code     The message code of the log.
		 * @param	details  The details of the log.
		 * @param	source   The source of the log.
		 */
		public function error(code:String, details:Object = null, source:* = null):void {
			logWith(Log.ERROR, code, details, source);
		}
		
		/**
		 * Log a fatal error message.
		 * @param	code     The message code of the log.
		 * @param	details  The details of the log.
		 * @param	source   The source of the log.
		 */
		public function fatal(code:String, details:Object = null, source:* = null):void {
			logWith(Log.FATAL, code, details, source);
		}
		
		/**
		 * Add a listener.
		 * @param listener The listener to add.
		 */
		public function addListener(listener:Function):void {
			if (_listeners.indexOf(listener) < 0)
				_listeners[_listeners.length] = listener;
		}
		
		/**
		 * Remove a listener.
		 * @param listener The listener to remove.
		 */
		public function removeListener(listener:Function):void {
			var index:Number = _listeners.indexOf(listener);
			if (index >= 0)
				_listeners.splice(index, 1);
		}
		
		/** Get the number of registered listeners. */
		public function get numListeners():int {
			return _listeners.length;
		}
		
		/** Removes all listeners. */
		public function clearListeners():void {
			_listeners.length = 0;
		}
		
	}
}