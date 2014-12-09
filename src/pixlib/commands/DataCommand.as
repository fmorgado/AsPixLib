package pixlib.commands {
	
	/** Defines a <code>Command</code> that completes with a result. */
	public class DataCommand extends Command {
		
		protected var _data:*;
		/** Get the result data of the command. */
		public final function get data():* { return _data; }
		
		/**
		 * Call this method to set the data and dispatch the
		 * <code>COMPLETE</code> event.
		 */
		protected final function dispatchCompleteData(data:*):void {
			_data = data;
			dispatchComplete();
		}
		
		/**
		 * Dispose the instance.
		 * @param  recursive  This flag has no efect in this implementation.
		 */
		override public function dispose(recursive:Boolean = true):void {
			super.dispose(recursive);
			_data = null;
		}
		
	}
}