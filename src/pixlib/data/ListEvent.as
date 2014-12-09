package pixlib.data {
	
	public final class ListEvent {
		//{ Cache Handling
		///////////////////////////////////////////////////////////////////////
		private static var _cache:Vector.<ListEvent>;
		
		internal static function obtain(
			target:ListController,
			type:String,
			index:int = -1,
			item:Object = null,
			oldItem:Object = null,
			oldList:Array = null
		):ListEvent {
			var result:ListEvent;
			
			if (_cache == null || _cache.length == 0)
				result = new ListEvent();
			else
				result = _cache.pop();
			
			result._target = target;
			result._type = type;
			result._index = index;
			result._item = item;
			result._oldItem = oldItem;
			result._oldList = oldList;
			
			return result;
		}
		
		internal static function release(event:ListEvent):void {
			event._clear();
			
			if (_cache == null)
				_cache = new <ListEvent>[];
			
			_cache[_cache.length] = event;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Change Types
		///////////////////////////////////////////////////////////////////////
		/**
		 * The <code>RESET</code> type indicates there was A total change to the underlying list.
		 * The property <code>oldList</code> holds the array prior to the change.
		 */
		public static const RESET:String = 'reset';
		/**
		 * The <code>ITEM_ADDED</code> type indicates that an item was added.
		 * The property <code>oldList</code> holds the array prior to the change.
		 */
		public static const ITEM_ADDED:String = 'itemAdded';
		public static const ITEM_REMOVED:String = 'itemRemoved';
		public static const ITEM_REPLACED:String = 'itemReplaced';
		public static const ITEM_UPDATED:String = 'itemUpdated';
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Constructor & Misc Members
		///////////////////////////////////////////////////////////////////////
		public function ListEvent() {}
		
		private function _clear():void {
			_canceled = false;
			_cancelable = false;
			_target = null;
			_type = null;
			_index = -1;
			_item = null;
			_oldItem = null;
			_oldList = null;
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
		private var _target:ListController;
		/** The instance where this event originated. */
		public function get target():ListController { return _target; }
		
		private var _type:String;
		/**
		 * The type of the change to the source list.
		 * This is not the event type as dispatched by a <code>ListController</code>.
		 */
		public function get type():String { return _type; }
		
		private var _index:int;
		/**
		 * The index of the related item.
		 * For <code>ITEM_ADDED</code>, <code>ITEM_REMOVED</code> and
		 * <code>ITEM_REPLACE</code> events, holds the index of the item that
		 * was added removed or replaced.
		 * For other change types, the value is -1.
		 */
		public function get index():int { return _index; }
		
		private var _item:Object;
		public function get item():Object { return _item; }
		
		private var _oldItem:Object;
		public function get oldItem():Object { return _oldItem; }
		
		private var _oldList:Array;
		public function get oldList():Array { return _oldList; }
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}