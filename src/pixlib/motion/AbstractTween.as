package pixlib.motion {
	import pixlib.commands.Command;
	
	public class AbstractTween extends Command {
		
		//{ Constructor & Initialization
		///////////////////////////////////////////////////////////////////////
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function AbstractTween(params:Object = null) {
			initialize();
			if (params != null) _parseParams(params);
		}
		
		/**
		 * This method is called on construction, before parameters are parsed.
		 * Override this to initialize the object.
		 */
		protected function initialize():void {}
		
		private function _parseParams(params:Object):void {
			var mustStart:Boolean = false;
			var mustReverse:Boolean = false;
			
			for (var key:String in params) {
				switch (key) {
					case 'start':
						mustStart = params[key] === true;
						break;
					
					case 'reverse':
						mustReverse = params[key] === true;
						break;
					
					case 'onProgress':
						onProgress(params[key]);
						break;
					
					case 'onStart':
						onStart(params[key]);
						break;
					
					case 'onStop':
						onStop(params[key]);
						break;
					
					case 'onComplete':
						onComplete(params[key]);
						break;
						
					default:
						this[key] = params[key];
				}
			}
			
			if (mustStart) {
				start();
			} else if (mustReverse) {
				startReverse();
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Properties
		///////////////////////////////////////////////////////////////////////
		protected var _reverse:Boolean = false;
		/** Indicates if the tween is going backwards. */
		public final function get reverse():Boolean { return _reverse; }
		public function set reverse(value:Boolean):void { _reverse = value; }
		
		/** Indicates if the tween must restart on completion. */
		public var loop:Boolean = false;
		
		/** Indicates if the tween must reverse itself when it completes. */
		public var yoyo:Boolean = false;
		
		/** Get the total duration of the tween. */
		public function get totalDuration():Number {
			throw new Error(this + ' must override totalDuration getter');
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Extra methods
		///////////////////////////////////////////////////////////////////////
		/** Start the tween in reverse. */
		public function startReverse():void {
			throw new Error(this + ': function startReverse() must be overriden!');
		}
		
		/** Resumes the tween where it was stopped. */
		public function resume():void {
			throw new Error(this + ': function resume() must be overriden!');
		}
		
		public function resumeForward():void {
			reverse = false;
			resume();
		}
		
		public function resumeReverse():void {
			reverse = true;
			resume();
		}
		
		/** Set the tween state to its start. */
		public function gotoStart():void {
			throw new Error(this + ': function gotoStart() must be overriden!');
		}
		
		/** Set the tween state to its end. */
		public function gotoEnd():void {
			throw new Error(this + ': function gotoEnd() must be overriden!');
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}