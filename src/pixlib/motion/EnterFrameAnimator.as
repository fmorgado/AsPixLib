package pixlib.motion {
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import pixlib.utils.EnterFrame;
	
	public class EnterFrameAnimator extends Animator {
		
		private static var _instance:EnterFrameAnimator;
		/** Get the singleton instance. */
		public static function get instance():EnterFrameAnimator {
			if (_instance == null)
				_instance = new EnterFrameAnimator();
			return _instance;
		}
		
		private var _lastTime:int;
		
		override protected function register():void {
			_lastTime = getTimer();
			EnterFrame.add(_onEnterFrame);
		}
		
		override protected function unregister():void {
			EnterFrame.remove(_onEnterFrame);
		}
		
		private function _onEnterFrame(event:Event):void {
			var currentTime:int = getTimer();
			advanceTime(Number(currentTime - _lastTime));
			_lastTime = currentTime;
		}
	}
}