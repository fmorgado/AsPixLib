package pixlib.data {
	import pixlib.utils.Dispatcher;
	
	public class MapController extends Dispatcher {
		//{ Constructor & Misc Members
		///////////////////////////////////////////////////////////////////////
		private var _map:Object;
		
		/**
		 * Constructor.
		 * @param  The source object. Optional.
		 */
		public function MapController(map:Object = null) {
			super();
			_map = map == null ? {} : map;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Public Methods
		///////////////////////////////////////////////////////////////////////
		/** Get all the property names. */
		public function get names():Vector.<String> {
			var result:Vector.<String> = new <String>[];
			for (var key:String in _map) {
				result[result.length] = key;
			}
			return result;
		}
		
		/** Remove all existing properties. */
		public function clear():void {
			var names:Vector.<String> = this.names;
			var length:uint = names.length;
			for (var index:uint = 0; index < length; index++) {
				unsetProperty(names[index]);
			}
		}
		
		/** Get a copy of the underlying properties object. */
		public function get properties():Object {
			var result:Object = {};
			for (var key:String in _map) {
				result[key] = _map[key];
			}
			return result;
		}
		
		/** Clear existing properties and set the properties from the argument. */
		public function set properties(value:Object):void {
			clear();
			for (var key:String in value) {
				setProperty(key, value[key]);
			}
		}
		
		/**
		 * Indicates if a property exists.
		 * @param  name  The name of the property.
		 * @return True if the property exists, false otherwise.
		 */
		public function hasProperty(name:String):Boolean {
			return _map.hasOwnProperty(name);
		}
		
		/**
		 * Get the value of a property.
		 * @param  name  The name of the property.
		 * @return The value of the property or undefined if not set.
		 */
		public function getProperty(name:String):Object {
			return _map[name];
		}
		
		/**
		 * Set a property.
		 * @param  name   The name of the property.
		 * @param  value  The new value of the property.
		 * @return The previous value of the property.
		 */
		public function setProperty(name:String, value:Object):Object {
			var oldValue:Object = _map[name];
			
			var event:MapEvent = MapEvent.obtain(this, MapEvent.PROPERTY_CHANGE, name, value, oldValue);
			if (_dispatchChanging(event)) {
				_map[name] = value;
				_dispatchChange(event);
			}
			MapEvent.release(event);
			
			return oldValue;
		}
		
		/**
		 * Unset a property.
		 * @param  name   The name of the property.
		 * @return The previous value of the property.
		 */
		public function unsetProperty(name:String):Object {
			var oldValue:Object = _map[name];
			
			var event:MapEvent = MapEvent.obtain(this, MapEvent.PROPERTY_CHANGE, name, undefined, oldValue);
			if (_dispatchChanging(event)) {
				delete _map[name];
				_dispatchChange(event);
			}
			MapEvent.release(event);
			
			return oldValue;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Event Helpers
		///////////////////////////////////////////////////////////////////////
		/**
		 * The type of the event dispatched before a change occurs.
		 * <code>MapEvent</code> instances are cancelable.
		 */
		public static const CHANGING:String = 'changing';
		/**
		 * The type of the event dispatched when a change occurs.
		 * <code>MapEvent</code> instances are not cancelable.
		 */
		public static const CHANGE:String = 'change';
		
		/**
		 * Dispatch the <code>CHANGING</code> event, which is cancelable.
		 * @param  event  The event to dispatch.
		 * @return True if the associated action must be performed,
		 *         or false if the event was canceled.
		 */
		private function _dispatchChanging(event:MapEvent):Boolean {
			event._cancelable = true;
			if (hasListeners(CHANGING)) {
				dispatch(CHANGING, event);
				return ! event.canceled;
			}
			return true;
		}
		
		/** Dispatch the <code>CHANGE</code> which is not cancelable. */
		private function _dispatchChange(event:MapEvent):void {
			event._cancelable = false;
			dispatch(CHANGE, event);
		}
		
		/**
		 * Add a listener for the <code>CHANGING</code> event.
		 * The argument for the listener is an instance of <code>MapEvent</code>.
		 * The actions associated to the event are cancelable.
		 * @param  listener  The listener to add.
		 */
		public function addChangingListener(listener:Function):void {
			addListener(CHANGING, listener);
		}
		/**
		 * Remove a listener added with <code>addChangingListener</code>.
		 * @param  listener  The listener to remove.
		 */
		public function removeChangingListener(listener:Function):void {
			removeListener(CHANGING, listener);
		}
		
		/**
		 * Add a listener for the <code>CHANGE</code> event.
		 * The argument for the listener is an instance of <code>MapEvent</code>.
		 * The actions associated to the event are not cancelable.
		 * @param  listener  The listener to add.
		 */
		public function addChangeListener(listener:Function):void {
			addListener(CHANGE, listener);
		}
		/**
		 * Remove a listener added with <code>addChangeListener</code>.
		 * @param  listener  The listener to remove.
		 */
		public function removeChangeListener(listener:Function):void {
			removeListener(CHANGE, listener);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}