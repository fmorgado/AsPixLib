package pixlib.motion {
	
	public class Tween extends AbstractTween implements IAnimatable {
		//{ Static Helpers
		///////////////////////////////////////////////////////////////////////
		/**
		 * @private
		 * The default easing function.
		 */
		private static function _easeLinear(ratio:Number):Number {
			return ratio;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Constructor & Privates
		///////////////////////////////////////////////////////////////////////
		private var _mustLoop:Boolean = false;
		
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function Tween(params:Object = null) {
			super(params);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Properties
		///////////////////////////////////////////////////////////////////////
		protected var _target:Object;
		/** The target of the tween. */
		public function get target():Object { return _target; }
		public function set target(value:Object):void { _target = value; }
		
		private var _animator:Animator;
		/** Get or set the animator used to advance this tween. */
		public final function get animator():Animator {
			const animator:Animator = _animator;
			return animator == null ? EnterFrameAnimator.instance : animator;
		}
		public final function set animator(value:Animator):void {
			if (running)
				animator.remove(this);
			_animator = value;
			if (running)
				animator.add(this);
		}
		
		/** The duration of the tween, in milliseconds. */
		public var duration:Number = 1000;
		
		/** The delay at the start of the tween. */
		public var delayBefore:Number = 0;
		
		/** The delay at the end of the tween. */
		public var delayAfter:Number = 0;
		
		/** @inheritDoc */
		override public function get totalDuration():Number { return duration + delayBefore + delayAfter; }
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Implementation Methods
		///////////////////////////////////////////////////////////////////////
		/**
		 * This method is called when the progress changes.
		 * Override it to update the state based on the
		 * current progress and easing.
		 */
		protected function updateState():void {}
		
		/**
		 * Get the value corresponding to the current progress inside the given range.
		 * @param  minimum  The minimum value.
		 * @param  maximum  The maximum value.
		 * @return  The value between in the given range that corresponds to the current progress.
		 */
		protected final function getProgressBetween(minimum:Number, maximum:Number):Number {
			return (maximum - minimum) * _progress + minimum;
		}
		
		private function _setProgress(value:Number):void {
			_progress = value;
			updateState();
			dispatch(PROGRESS, this);
		}
		
		private var _time:Number = 0;
		public final function get time():Number { return _time; }
		public final function set time(value:Number):void {
			if (value < 0) value = 0;
			else if (value > totalDuration) value = totalDuration;
			_time = value;
			if (_time <= delayBefore) {
				_setProgress(0);
			} else if (_time >= delayBefore + duration) {
				_setProgress(1);
			} else {
				_setProgress(easing((value - delayBefore) / duration));
			}
		}
		
		/** The easing function to use. */
		public var easing:Function = _easeLinear;
		
		/** @inheritDoc */
		public function advanceTime(milliseconds:Number):void {
			if (_mustLoop) {
				time = reverse ? duration : 0.0;
				_mustLoop = false;
				return;
			}
			
			if (reverse) {
				time -= milliseconds;
				if (_time <= 0.0) {
					if (loop) {
						_mustLoop = true;
					} else if (yoyo) {
						reverse = false;
					} else {
						stop();
					}
					dispatchComplete(false);
				}
			} else {
				time += milliseconds;
				if (_time >= totalDuration) {
					if (loop) {
						_mustLoop = true;
					} else if (yoyo) {
						reverse = true;
					} else {
						stop();
					}
					dispatchComplete(false);
				}
			}
		}
		
		/** @inheritDoc */
		override public function start():void {
			if (! running) {
				setRunning(true);
				animator.add(this);
			}
			reverse = false;
			time = 0;
		}
		
		/** @inheritDoc */
		override public function startReverse():void {
			if (! running) {
				setRunning(true);
				animator.add(this);
			}
			reverse = true;
			time = totalDuration;
		}
		
		/** @inheritDoc */
		override public function resume():void {
			if (running) return;
			setRunning(true);
			animator.add(this);
		}
		
		/** @inheritDoc */
		override public function stop():void {
			if (! running) return;
			setRunning(false);
			animator.remove(this);
		}
		
		/** @inheritDoc */
		override public function gotoStart():void {
			time = 0;
		}
		
		/** @inheritDoc */
		override public function gotoEnd():void {
			time = totalDuration;
		}
		
		/** @inheritDoc */
		override public function dispose(recursive:Boolean = true):void {
			super.dispose();
			target = null;
			_animator = null;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}