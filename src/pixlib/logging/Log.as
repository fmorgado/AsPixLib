package pixlib.logging {
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	/** Represents a <code>Logger</code> message instance. */
	public final class Log {
		public static const ALL:uint       =    0;
		public static const DEBUG:uint     =  100;
		public static const INFO:uint      =  200;
		public static const CONFIG:uint    =  300;
		public static const WARNING:uint   =  400;
		public static const ERROR:uint     =  500;
		public static const FATAL:uint     =  600;
		public static const OFF:uint       = 1000;
		
		/**
		 * Creates a <code>Log</code> instance from a JSON object.
		 * @param	json	The JSON object to parse.
		 * @return The <code>Log</code> instance equivalent of the JSON object.
		 */
		public static function fromJson(json:Object):Log {
			const result:Log = new Log(
				uint(json.level),
				String(json.message),
				json.details,
				json.source != null ? String(json.source) : null
			);
			result._timestamp = int(json.timestamp);
			return result;
		}
		
		/**
		 * Constructor.
		 * @param	level		The level of the log.
		 * @param	message		The message of the log.
		 * @param	details		An object containing additional information. Optional.
		 * @param	source		The origin of the log. Optional.
		 */
		public function Log(level:int, message:String, details:Object = null, source:* = null) {
			_level = level;
			_message = message;
			_details = details;
			_source = source;
			_timestamp = getTimer();
		}
		
		private var _level:uint;
		/** The type of the status. */
		public function get level():uint { return _level; }
		
		private var _message:String;
		/** The message of the log. */
		public function get message():String { return _message; }
		
		private var _timestamp:int;
		public function get timestamp():int { return _timestamp; }
		
		private var _details:Object;
		/** An object containing additional information. */
		public function get details():Object { return _details; }
		
		private var _source:*;
		/** Get the domain of the log. */
		public function get source():String { return _source; }
		
		public function get sourceName():String {
			const source:* = _source;
			if (source == null) {
				return '';
			} else if (source is String) {
				return source;
			} else {
				return getQualifiedClassName(source);
			}
		}
		
		/**
		 * Converts the log instance to a JSON object.
		 * @return A JSON object representing the Log instance.
		 */
		public function toJson():Object {
			const result:Object = {
				level:      _level,
				message:    _message,
				timestamp:  _timestamp
			};
			if (_details != null) result.details = _details;
			if (_source != null) result.source = sourceName;
			return result;
		}
		
		/** Get a string representation. */
		public function toString():String {
			var result:String = '[' + _level + '] ' + sourceName + ':  ' + _message;
			if (_details != null)
				result += ', ' + JSON.stringify(_details);
			return result;
		}
		
	}
}