package pixlib.motion {
	
	public class TweenSequence extends AbstractTween {
		
		//{ Constructor & Utilities
		///////////////////////////////////////////////////////////////////////
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function TweenSequence(params:Object = null) {
			super(params);
		}
		
		private function _requireTweens():void {
			if (_tweens == null || _tweens.length == 0)
				throw new Error("Doesn't have any tweens to play");
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Properties
		///////////////////////////////////////////////////////////////////////
		private var _tweens:Array;
		/** The tweens of this sequence. */
		public final function get tweens():Array { return _tweens; }
		public final function set tweens(value:Array):void {
			if (running)
				throw new Error('Cannot set tweens while running');
			_tweens = value;
			_currentIndex = 0;
		}
		
		/** @inheritDoc */
		override public function get totalDuration():Number {
			if (_tweens == null) return 0;
			
			var result:Number = 0;
			var length:uint = _tweens.length;
			for (var index:uint = 0; index < length; index < length) {
				result += _tweens[index].totalDuration;
			}
			
			return result;
		}
		
		/** @inheritDoc */
		override public function set reverse(value:Boolean):void {
			if (value == _reverse) return;
			_reverse = value;
			if (_currentTween != null)
				_currentTween.reverse = value;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Current Tween Handling
		///////////////////////////////////////////////////////////////////////
		private var _currentTween:AbstractTween;
		private var _currentIndex:int = 0;
		
		private function _clearCurrentTween():void {
			if (_currentTween != null) {
				_currentTween.removeOnComplete(_tweenOnComplete);
				_currentTween = null;
			}
		}
		
		private function _startCurrentTween():void {
			_requireTweens();
			
			if (_currentIndex < 0) {
				if (yoyo) {
					_reverse = false;
					_currentIndex = 0;
					_startCurrentTween();
				} else if (loop) {
					_reverse = true;
					_currentIndex = _tweens.length - 1;
					gotoEnd();
					_startCurrentTween();
				} else {
					setRunning(false);
				}
				dispatchComplete(false);
				
			} else if (_currentIndex >= _tweens.length) {
				if (yoyo) {
					_reverse = true;
					_currentIndex = _tweens.length - 1;
					_startCurrentTween();
				} else if (loop) {
					_reverse = false;
					_currentIndex = 0;
					gotoStart();
					_startCurrentTween();
				} else {
					setRunning(false);
				}
				dispatchComplete(false);
				
			} else {
				_currentTween = _tweens[_currentIndex];
				_currentTween.onComplete(_tweenOnComplete);
				if (_reverse) {
					_currentTween.startReverse();
				} else {
					_currentTween.start();
				}
				_dispatchSequenceProgress();
			}
		}
		
		private function _tweenOnComplete(tween:AbstractTween):void {
			_clearCurrentTween();
			if (_reverse) {
				_currentIndex --;
			} else {
				_currentIndex ++;
			}
			_startCurrentTween();
		}
		
		private function _dispatchSequenceProgress():void {
			dispatchProgress(_currentIndex, _tweens.length - 1);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Public Methods
		///////////////////////////////////////////////////////////////////////
		/** @inheritDoc */
		override public function start():void {
			if (running)
				throw new Error('already running');
			_requireTweens();
			_reverse = false;
			_currentIndex = 0;
			_startCurrentTween();
			_dispatchSequenceProgress();
		}
		
		/** @inheritDoc */
		override public function resume():void {
			if (running) return;
			setRunning(true);
			if (_currentTween != null) {
				_currentTween.resume();
			} else {
				_startCurrentTween();
			}
			_dispatchSequenceProgress();
		}
		
		/** @inheritDoc */
		override public function startReverse():void {
			if (running)
				throw new Error('already running');
			_requireTweens();
			_reverse = true;
			_currentIndex = _tweens.length - 1;
			_startCurrentTween();
			_dispatchSequenceProgress();
		}
		
		/** @inheritDoc */
		override public function stop():void {
			if (! running) return;
			setRunning(false);
			if (_currentTween != null)
				_currentTween.stop();
		}
		
		/** @inheritDoc */
		override public function gotoStart():void {
			_requireTweens();
			for (var index:int = _tweens.length - 1; index >= 0; index--) {
				_tweens[index].gotoStart();
			}
		}
		
		/** @inheritDoc */
		override public function gotoEnd():void {
			_requireTweens();
			var length:uint = _tweens.length;
			for (var index:uint = 0; index < length; index++) {
				_tweens[index].gotoEnd();
			}
		}
		
		/** @inheritDoc */
		override public function dispose(recursive:Boolean = true):void {
			super.dispose();
			if (_tweens != null) {
				if (recursive) {
					var length:uint = _tweens.length;
					for (var index:uint = 0; index < length; index++)
						_tweens[index].dispose(true);
				}
				_tweens = null;
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}