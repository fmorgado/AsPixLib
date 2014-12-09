package pixlib.data {
	import pixlib.utils.Dispatcher;
	
	public final class ListController extends Dispatcher {
		//{ Constructor & Misc Members
		///////////////////////////////////////////////////////////////////////
		private var _list:Array;
		
		/**
		 * Constructor.
		 * @param  source  The source data. Optional.
		 */
		public function ListController(list:Array = null) {
			super();
			_list = list == null ? [] : list;
		}
		
		private function _checkIndex(index:uint):void {
			if (index >= _list.length)
				throw new RangeError('Index out of bounds:  index=' + index + ', length=' + length);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Public Methods
		///////////////////////////////////////////////////////////////////////
		/** Get a copy of the underlying list. */
		public function get list():Array { return _list.concat(); }
		
		/** The length of the underlying array. */
		public function get length():uint { return _list.length; }
		
		/**
		 * Get the item at the given index.
		 * @param  index  The index of the item to retrieve.
		 */
		public function getAt(index:uint):Object {
			_checkIndex(index);
			return _list[index];
		}
		
		/**
		 * Get the index of the first occurrence of an item.
		 * @param  item       The item to search for.
		 * @param  fromIndex  The index where to start looking. Default is 0.
		 * @return The index of the item, or -1 if not found.
		 */
		public function indexOf(item:Object, fromIndex:uint = 0):int {
			return _list.indexOf(item, fromIndex);
		}
		
		/**
		 * Get the index of the last occurrence of an item.
		 * @param  item  The item to search for.
		 * @param  fromIndex  The index where to start looking. Default is 0x7FFFFFF.
		 * @return The index of the item, or -1 if not found.
		 */
		public function lastIndexOf(item:Object, fromIndex:uint = 0x7FFFFFFF):int {
			return _list.lastIndexOf(item, fromIndex);
		}
		
		/**
		 * Update the item at the given index.
		 * This does not change the list in any way
		 * but provides a way to broadcast item changes.
		 * @param  index  The index of the item to update.
		 */
		public function updateAt(index:uint):void {
			_checkIndex(index);
			var event:ListEvent = ListEvent.obtain(this, ListEvent.ITEM_UPDATED, index, _list[index], null, null);
			_dispatchChange(event);
			ListEvent.release(event);
		}
		
		/**
		 * Update the given item.
		 * This does not change the list in any way
		 * but provides a way to broadcast item changes.
		 * @param  item  The item to update.
		 */
		public function update(item:Object):void {
			var index:int = indexOf(item);
			if (index >= 0)
				updateAt(index);
		}
		
		/**
		 * Add an item at the given index.
		 * @param  item   The item to add.
		 * @param  index  The index where to add the item.
		 */
		public function addAt(item:Object, index:uint):void {
			if (index > length)
				index = length;
			
			var event:ListEvent = ListEvent.obtain(this, ListEvent.ITEM_ADDED, index, item, null, null);
			if (_dispatchChanging(event)) {
				_list.splice(index, 0, item);
				_dispatchChange(event);
			}
			ListEvent.release(event);
		}
		
		/**
		 * Add an item to the end of the list.
		 * @param  item  The item to add.
		 */
		public function add(item:Object):void {
			addAt(item, length);
		}
		
		/**
		 * Remove the item at a given index.
		 * @param  index  The index of the item to remove.
		 */
		public function removeAt(index:uint):Object {
			_checkIndex(index);
			var item:Object = _list[index];
			
			var event:ListEvent = ListEvent.obtain(this, ListEvent.ITEM_REMOVED, index, item, null, null);
			if (_dispatchChanging(event)) {
				_list.splice(index, 1);
				_dispatchChange(event);
			}
			ListEvent.release(event);
			
			return item;
		}
		
		/**
		 * Remove an item from the list.
		 * @param  item  The item to remove.
		 */
		public function remove(item:Object):void {
			var index:int = indexOf(item);
			if (index >= 0)
				removeAt(index);
		}
		
		/**
		 * Remove the last item.
		 * @return The item that was removed.
		 */
		public function removeLast():Object {
			if (length == 0)
				throw new RangeError('No items to remove');
			return removeAt(length - 1);
		}
		
		/**
		 * Set the item at the given index, replacing the previous item.
		 * @param  item   The item to replace with.
		 * @param  index  The index of the item to replace.
		 * @return The item that was replaced.
		 */
		public function setAt(item:Object, index:uint):Object {
			_checkIndex(index);
			var oldItem:Object = _list[index];
			
			var event:ListEvent = ListEvent.obtain(this, ListEvent.ITEM_REPLACED, index, item, oldItem, null);
			if (_dispatchChanging(event)) {
				_list[index] = item;
				_dispatchChange(event);
			}
			ListEvent.release(event);
			
			return oldItem;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Event Helpers
		///////////////////////////////////////////////////////////////////////
		/**
		 * The type of the event dispatched before a change occurs.
		 * <code>ListEvent</code> instances are cancelable.
		 */
		public static const CHANGING:String = 'changing';
		/**
		 * The type of the event dispatched when a change occurs.
		 * <code>ListEvent</code> instances are not cancelable.
		 */
		public static const CHANGE:String = 'change';
		
		/**
		 * Dispatch the <code>CHANGING</code> event, which is cancelable.
		 * @param  event  The event to dispatch, which is not released.
		 * @return True if the associated action must be performed,
		 *         or false if the event was canceled.
		 */
		private function _dispatchChanging(event:ListEvent):Boolean {
			event._cancelable = true;
			if (hasListeners(CHANGING)) {
				dispatch(CHANGING, event);
				return ! event.canceled;
			}
			return true;
		}
		
		/** Dispatch the <code>CHANGE</code> which is not cancelable. */
		private function _dispatchChange(event:ListEvent):void {
			event._cancelable = false;
			dispatch(CHANGE, event);
		}
		
		/**
		 * Add a listener for the <code>CHANGING</code> event.
		 * The argument for the listener is an instance of <code>ListEvent</code>.
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
		 * The argument for the listener is an instance of <code>ListEvent</code>.
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