package pixlib.motion {
	
	public class Animator implements IAnimatable {
		private const _animatables:Vector.<IAnimatable> = new Vector.<IAnimatable>();
		private var _numAnimatables:uint = 0;
		
		private function _add(animatable:IAnimatable):void {
			const list:Vector.<IAnimatable> = _animatables;
			const length:uint = list.length;
			for (var index:uint = 0; index < length; index++) {
				if (list[index] == null) {
					list[index] = animatable;
					return;
				}
			}
			list.push(animatable);
		}
		
		/** Add an animatable. */
		public final function add(animatable:IAnimatable):void {
			if (animatable == null) return;
			_add(animatable);
			_numAnimatables++;
			if (_numAnimatables == 1)
				register();
		}
		
		/** Remove an animatable. */
		public final function remove(animatable:IAnimatable):void {
			if (animatable == null) return;
			const list:Vector.<IAnimatable> = _animatables;
			const index:int = list.indexOf(animatable);
			if (index >= 0) {
				list[index] = null;
				_numAnimatables--;
				if (_numAnimatables == 0)
					unregister();
			}
		}
		
		/** @inheritDoc */
		public final function advanceTime(time:Number):void {
			const list:Vector.<IAnimatable> = _animatables;
			const length:uint = list.length;
			for (var index:uint = 0; index < length; index++) {
				const animatable:IAnimatable = list[index];
				if (animatable != null)
					animatable.advanceTime(time);
			}
		}
		
		/** This method is called when the animator starts having animatables. */
		protected function register():void {}
		
		/** This method is called when the animator stops having animatables. */
		protected function unregister():void {}
		
	}
}