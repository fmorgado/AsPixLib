package pixlib.commands {
	import pixlib.ErrorConstants;
	import pixlib.logging.Log;
	import pixlib.utils.Dispatcher;
	
	/**
	 * Represents an abstract asynchronous command.
	 * It must be extended to provide implementation.
	 */
	public class Command extends Dispatcher {
		//{ Event Types
		///////////////////////////////////////////////////////////////////////
		/** The type dispatched when the command completes. */
		public static const COMPLETE:String = 'complete';
		/** The type dispatched when an error occurs. */
		public static const ERROR:String = 'error';
		/** The type dispatched when the command progresses. */
		public static const PROGRESS:String = 'progress';
		/** the type dispatched when the command starts. */
		public static const START:String = 'start';
		/** The type dispatched when the command stops. */
		public static const STOP:String = 'stop';
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Constructor
		///////////////////////////////////////////////////////////////////////
		/** Constructor. */
		public function Command() { super(); }
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Properties
		///////////////////////////////////////////////////////////////////////
		private var _running:Boolean = false;
		/** Indicates if the command is currently running. */
		public final function get running():Boolean { return _running; }
		
		protected var _progress:Number = 0;
		/** Get the current progress. */
		public final function get progress():Number { return _progress; }
		
		protected var _progressTotal:Number = 1;
		/** Get the progress total. */
		public final function get progressTotal():Number { return _progressTotal; }
		
		protected var _error:Log;
		/** Get the error. */
		public final function get error():Log { return _error; }
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Protected utility methods
		///////////////////////////////////////////////////////////////////////
		/**
		 * Call this method to change the value of the <code>running</code>
		 * property. This method dispatches the <code>START</code> or
		 * <code>STOP</code> events if necessary.
		 */
		protected final function setRunning(value:Boolean):void {
			if (value == _running) return;
			_running = value;
			_error = null;
			dispatch(value ? START : STOP, this);
		}
		
		/**
		 * Call this method to dispatch the <code>COMPLETE</code> event
		 * and the <code>STOP</code> event if necessary.
		 */
		protected final function dispatchComplete(stop:Boolean = true):void {
			dispatch(COMPLETE, this);
			if (stop) setRunning(false);
		}
		
		/**
		 * Call this method to dispatch the <code>ERROR</code> event
		 * and the <code>STOP</code> event if necessary.
		 */
		protected final function dispatchError(error:*, stop:Boolean = true):void {
			if (stop) setRunning(false);
			_error = error is Log ? error
				: new Log(Log.ERROR, ErrorConstants.UNKNOWN_ERROR, {message: String(error)}, this);
			dispatch(ERROR, this);
		}
		
		/** Call this method to provide progress information. */
		protected final function dispatchProgress(current:Number, total:Number):void {
			_progress = current;
			_progressTotal = total;
			dispatch(PROGRESS, this);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Implementation Methods
		///////////////////////////////////////////////////////////////////////
		/** Start the command. */
		public function start():void {
			throw new Error(this + ': function start() must be overriden!');
		}
		
		/** Stop the command. */
		public function stop():void {
			throw new Error(this + ' cannot be stopped!');
		}
		
		/** @inheritDoc */
		override public function dispose(recursive:Boolean = true):void {
			stop();
			_error = null;
			super.dispose();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Events Handling
		///////////////////////////////////////////////////////////////////////
		/**
		 * Add a listener for the <code>COMPLETE</code> event.
		 * The argument of the listener is the command itself.
		 * @return The object itself.
		 */
		public final function onComplete(listener:Function):Command {
			this.addListener(COMPLETE, listener);
			return this;
		}
		
		/** Remove a listener added with <code>onComplete</code>. */
		public final function removeOnComplete(listener:Function):Command {
			this.removeListener(COMPLETE, listener);
			return this;
		}
		
		/**
		 * Add a listener for the <code>ERROR</code> event.
		 * The argument of the listener is an instance of <code>Log</code>.
		 * @see pixlib.logging.Log
		 * @return The object itself.
		 */
		public final function onError(listener:Function):Command {
			this.addListener(ERROR, listener);
			return this;
		}
		
		/** Remove a listener added with <code>onError</code>. */
		public final function removeOnError(listener:Function):Command {
			this.removeListener(ERROR, listener);
			return this;
		}
		
		/**
		 * Add a listener for the <code>PROGRESS</code> event.
		 * The argument of the listener if the command itself.
		 * @return The object itself.
		 */
		public final function onProgress(listener:Function):Command {
			this.addListener(PROGRESS, listener);
			return this;
		}
		
		/** Remove a listener added with <code>onProgress</code>. */
		public final function removeOnProgress(listener:Function):Command {
			this.removeListener(PROGRESS, listener);
			return this;
		}
		
		/**
		 * Add a listener for the <code>START</code> event.
		 * The argument of the listener is the command itself.
		 * @return The object itself.
		 */
		public final function onStart(listener:Function):Command {
			this.addListener(START, listener);
			return this;
		}
		
		/** Remove a listener added with <code>onStart</code>. */
		public final function removeOnStart(listener:Function):Command {
			this.removeListener(START, listener);
			return this;
		}
		
		/**
		 * Add a listener for the <code>STOP</code> event.
		 * The argument of the listener is the command itself.
		 * @return The object itself.
		 */
		public final function onStop(listener:Function):Command {
			this.addListener(STOP, listener);
			return this;
		}
		
		/** Remove a listener added with <code>onStop</code>. */
		public final function removeOnStop(listener:Function):Command {
			this.removeListener(STOP, listener);
			return this;
		}
		///////////////////////////////////////////////////////////////////////
		//}
	}
}