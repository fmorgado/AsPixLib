package pixlib.commands {
	import pixlib.logging.Log;
	
	/** A command that completes with an error. */
	public final class DelayedError extends DelayedData {
		
		/**
		 * Constructor.
		 * @param  milliseconds  The delay in milliseconds.
		 * @param  result        The result to complete with. 
		 */
		public function DelayedError(milliseconds:Number, error:Log) {
			super(milliseconds, null);
			_error = error;
		}
		
		override protected function onTimerComplete(_:*):void {
			this.dispatchError(_error);
		}
		
		/** @inheritDoc */
		override public function dispose(recursive:Boolean = true):void {
			super.dispose(recursive);
			_error = null;
		}
	}
}