package pixlib.utils {
	import flash.display.Sprite;
	import flash.events.Event;
	
	/** An utility to listen to <code>ENTER_FRAME</code> events. */
	public class EnterFrame {
		
		private static var _sprite:Sprite;
		
		/**
		 * Add an <code>Event.ENTER_FRAME</code> event listener.
		 * @param  listener  The listener to add.
		 */
		public static function add(listener:Function):void {
			if (_sprite == null) _sprite = new Sprite();
			_sprite.addEventListener(Event.ENTER_FRAME, listener);
		}
		
		/**
		 * Remove an <code>Event.ENTER_FRAME</code> event listener.
		 * @param  listener  The listener to remove.
		 */
		public static function remove(listener:Function):void {
			if (_sprite == null) return;
			_sprite.removeEventListener(Event.ENTER_FRAME, listener);
		}
		
	}
}