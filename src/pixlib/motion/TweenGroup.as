package pixlib.motion {
	public class TweenGroup extends AbstractTween {
		
		//{ Constructor & Utilities
		///////////////////////////////////////////////////////////////////////
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function TweenGroup(params:Object = null) {
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
			var length:uint;
			var index:uint;
			
			if (_tweens != null) {
				length = _tweens.length;
				for (index = 0; index < length; index++)
					_tweens[index].removeOnComplete(_tweenOnComplete);
			}
			_tweens = value;
			if (value != null) {
				length = value.length;
				for (index = 0; index < length; index++)
					value[index].onComplete(_tweenOnComplete);
			}
		}
		
		/** @inheritDoc */
		override public function get totalDuration():Number {
			_requireTweens();
			
			var result:Number = 0;
			var length:uint = _tweens.length;
			for (var index:uint = 0; index < length; index < length) {
				var tweenDuration:Number = _tweens[index].totalDuration;
				if (tweenDuration > result)
					result = tweenDuration;
			}
			
			return result;
		}
		
		/** @inheritDoc */
		override public function set reverse(value:Boolean):void {
			if (value == _reverse) return;
			_reverse = value;
			if (! running || _tweens == null) return;
			
			var length:uint = _tweens.length;
			for (var index:uint = 0; index < length; index++) {
				var tween:AbstractTween = _tweens[index];
				tween.reverse = value;
				
				if (! tween.running) {
					if (value) {
						tween.startReverse();
					} else {
						tween.start();
					}
				}
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Core Implementation
		///////////////////////////////////////////////////////////////////////
		private var _completeCount:uint = 0;
		
		private function _tweenOnComplete(tween:AbstractTween):void {
			_completeCount ++;
			if (_completeCount >= _tweens.length) {
				if (yoyo) {
					if (_reverse) {
						_startTweens();
					} else {
						_startTweensReverse();
					}
					
				} else if (loop) {
					if (_reverse) {
						_startTweensReverse();
					} else {
						_startTweens();
					}
					
				} else {
					setRunning(false);
				}
				
				dispatchComplete(false);
			}
		}
		
		private function _startTweens():void {
			_reverse = false;
			_completeCount = 0;
			var length:uint = _tweens.length;
			for (var index:uint = 0; index < length; index++)
				_tweens[index].start();
		}
		
		private function _resumeTweens():void {
			_completeCount = 0;
			var length:uint = _tweens.length;
			for (var index:uint = 0; index < length; index++)
				_tweens[index].resume();
		}
		
		private function _startTweensReverse():void {
			_reverse = true;
			_completeCount = 0;
			var length:uint = _tweens.length;
			for (var index:uint = 0; index < length; index++)
				_tweens[index].startReverse();
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
			_startTweens();
		}
		
		/** @inheritDoc */
		override public function resume():void {
			if (running) return;
			setRunning(true);
			_resumeTweens();
		}
		
		/** @inheritDoc */
		override public function startReverse():void {
			if (running)
				throw new Error('already running');
			_requireTweens();
			_startTweensReverse();
		}
		
		/** @inheritDoc */
		override public function stop():void {
			if (! running) return;
			setRunning(false);
			var length:uint = _tweens.length;
			for (var index:uint = 0; index < length; index++)
				_tweens[index].stop();
		}
		
		/** @inheritDoc */
		override public function gotoStart():void {
			if (_tweens == null) return;
			for (var index:int = _tweens.length - 1; index >= 0; index--)
				_tweens[index].gotoStart();
		}
		
		/** @inheritDoc */
		override public function gotoEnd():void {
			if (_tweens == null) return;
			for (var index:int = _tweens.length - 1; index >= 0; index--)
				_tweens[index].gotoEnd();
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