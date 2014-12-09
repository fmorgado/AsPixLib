package pixlib.data {
	
	public final class MapEvent {
		//{ Cache Handling
		///////////////////////////////////////////////////////////////////////
		private static var _cache:Vector.<MapEvent>;
		
		internal static function obtain(
			target:MapController,
			type:String,
			name:String = null,
			value:Object = null,
			oldValue:Object = null
		):MapEvent {
			var result:MapEvent;
			
			if (_cache == null || _cache.length == 0)
				result = new MapEvent();
			else
				result = _cache.pop();
			
			result._name = name;
			result._value = value;
			result._oldValue = oldValue;
			
			return result;
		}
		
		internal static function release(event:MapEvent):void {
			event._clear();
			
			if (_cache == null)
				_cache = new <MapEvent>[];
			
			_cache[_cache.length] = event;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Change Types
		///////////////////////////////////////////////////////////////////////
		public static const RESET:String = 'reset';
		public static const PROPERTY_CHANGE:String = 'propertyChange';
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Constructor & Misc Members
		///////////////////////////////////////////////////////////////////////
		public function MapEvent() {}
		
		private function _clear():void {
			_canceled = false;
			_cancelable = false;
			_target = null;
			_type = null;
			_name = null;
			_value = null;
			_oldValue = null;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Cancelation Handling
		///////////////////////////////////////////////////////////////////////
		internal var _cancelable:Boolean = false;
		/** Indicates if the action associated to this event is cancelable. */
		public function get cancelable():Boolean { return _cancelable; }
		
		private var _canceled:Boolean = false;
		/** Indicates if the action associated to this event was canceled. */
		public function get canceled():Boolean { return _canceled; }
		
		/**
		 * Cancel the action associated to this event.
		 * If <code>cancelable</code> is false, an error is thrown.
		 */
		public function cancel():void {
			if (! _cancelable)
				throw new Error('This event is not cancelable');
			_canceled = true;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Properties
		///////////////////////////////////////////////////////////////////////
		private var _target:MapController;
		/** The instance where this event originated. */
		public function get target():MapController { return _target; }
		
		private var _type:String;
		/**
		 * The type of the change to the source list.
		 * This is not the event type as dispatched by a <code>ListController</code>.
		 */
		public function get type():String { return _type; }
		
		private var _name:String;
		/** The name of the property that changed. */
		public function get name():String { return _name; }
		
		private var _value:Object;
		/** The value of the property. */
		public function get value():Object { return _value; }
		
		private var _oldValue:Object;
		/** The old value of the property. */
		public function get oldValue():Object { return _oldValue; }
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}