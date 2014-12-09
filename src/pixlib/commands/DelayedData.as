package pixlib.commands {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/** A command that completes with a given result. */
	public class DelayedData extends DataCommand {
		private var _timer:Timer;
		
		/**
		 * Constructor.
		 * @param  milliseconds  The delay in milliseconds.
		 * @param  data          The data to complete with. 
		 */
		public function DelayedData(milliseconds:Number, data:*) {
			_timer = new Timer(milliseconds, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_data = data;
		}
		
		/**
		 * Get or set the delay in milliseconds.
		 * If set while the command is running, the command is restarted.
		 */
		public final function get milliseconds():Number { return _timer.delay; }
		public final function set milliseconds(value:Number):void { _timer.delay = value; }
		
		protected function onTimerComplete(_:*):void {
			dispatchComplete();
		}
		
		/** @inheritDoc */
		override public function start():void {
			if (running) return;
			setRunning(true);
			_timer.start();
		}
		
		/** @inheritDoc */
		override public function stop():void {
			if (! running) return;
			setRunning(false);
			_timer.reset();
		}
		
		/** @inheritDoc */
		override public function dispose(recursive:Boolean = true):void {
			super.dispose(recursive);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer = null;
		}
	}
}