package pixlib.motion {
	
	public class PropertyTween extends Tween {
		
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function PropertyTween(params:Object = null) {
			super(params);
		}
		
		public var property:String;
		public var startValue:Number = 0.0;
		public var endValue:Number = 1.0;
		
		override protected function updateState():void {
			target[property] = getProgressBetween(startValue, endValue);
		}
		
		/** @inheritDoc */
		override public function dispose(recursive:Boolean = true):void {
			super.dispose();
			property = null;
		}
		
	}
}