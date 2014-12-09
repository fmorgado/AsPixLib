package pixlib.utils {
	import flash.utils.Dictionary;
	
	public class Dispatcher {
		private var _listeners:Dictionary;
		
		/** Constructor. */
		public function Dispatcher() {}
		
		/** Add a <code>listener</code> for the given event <code>type</code>. */
		public final function addListener(type:String, listener:Function):void {
			if (_listeners == null) {
				_listeners = new Dictionary();
				_listeners[type] = listener;
				return;
			}
			
			var listeners:Object = _listeners[type];
			
			if (listeners == null) {
				_listeners[type] = listener;
				return;
			}
			
			if (listeners is Function) {
				if (listeners == listener)
					return;
				
				_listeners[type] = new <Function>[listeners as Function, listener];
				return;
			}
			
			const list:Vector.<Function> = listeners as Vector.<Function>;
			if (list.indexOf(listener) >= 0)
				return;
			
			const index:int = list.indexOf(null);
			if (index < 0)
				list[list.length] = listener;
			else
				list[index] = listener;
		}
		
		/** Remove a listener previously added with <code>addListener</code>. */
		public final function removeListener(type:String, listener:Function):void {
			if (_listeners == null)
				return;
			
			const listeners:Object = _listeners[type];
			if (listeners == null)
				return;
			
			if (listeners is Function) {
				if (listeners == listener)
					_listeners[type] = null;
				return;
			}
			
			const list:Vector.<Function> = listeners as Vector.<Function>;
			const index:int = list.indexOf(listener);
			if (index >= 0)
				list[index] = null;
		}
		
		// Remove all listeners for a given type.
		// Caller must ensure that _listeners is not null.
		// Listener arrays are preserved (but cleared).
		private function _removeListenersFor(type:String):void {
			var entry:Object = _listeners[type];
			if (entry != null) {
				if (entry is Array) {
					entry.length = 0;
				} else {
					// entry is a listener
					_listeners[type] = null;
				}
			}
		}
		
		/**
		 * Remove the listeners for a given type or all of them if
		 * <code>type</code> is <code>null</code>.
		 * Use with caution, as we may not know who else is listening.
		 */
		public final function removeListeners(type:String = null):void {
			if (_listeners == null)
				return;
			
			if (type) {
				_removeListenersFor(type);
			} else {
				for (var key:String in _listeners) {
					_removeListenersFor(key);
				}
			}
		}
		
		/** Indicates if there are registered listeners for the given type. */
		public final function hasListeners(type:String):Boolean {
			if (_listeners == null)
				return false;
			
			const listeners:Object = _listeners[type];
			if (listeners == null)
				return false;
			
			if (listeners is Function)
				return true;
			
			const list:Vector.<Function> = listeners as Vector.<Function>;
			const length:uint = list.length;
			for (var index:uint = 0; index < length; index++) {
				if (list[index] != null)
					return true;
			}
			return false;
		}
		
		/** Dispatch an event of the given type with the given value. */
		public final function dispatch(type:String, value:*):void {
			if (_listeners == null)
				return;
			
			const listeners:Object = _listeners[type];
			if (listeners == null)
				return;
			
			if (listeners is Function) {
				(listeners as Function)(value);
				return;
			}
			
			const list:Vector.<Function> = listeners as Vector.<Function>;
			/*
			* Listeners removed while dispatching are set to null. No problem
			* there. Listeners added while dispatching may be called if they
			* were added in a null position after current dispatching index.
			* Being such a rare corner case with little consequence, it's
			* ignored for performance reasons.
			*/
			const length:uint = list.length;
			for (var index:uint = 0; index < length; index++) {
				const listener:Function = list[index];
				if (listener != null)
					listener(value);
			}
		}
		
		/**
		 * Dispose the instance.
		 * 
		 * If <code>recursive</code> is true, all inner content will be disposed as well.
		 * The exact behavior depends on the sub-classes.
		 * 
		 * @param  recursive  Indicates if inner content must be disposed.
		 */
		public function dispose(recursive:Boolean = true):void {
			removeListeners();
		}
	}
}