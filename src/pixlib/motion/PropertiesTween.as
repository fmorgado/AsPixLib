package pixlib.motion {
	
	public class PropertiesTween extends Tween {
		
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function PropertiesTween(params:Object = null) { super(params); }
		
		public var properties:Array;
		public var startValues:Array;
		public var endValues:Array;
		
		override protected function updateState():void {
			const length:uint = properties.length;
			for (var index:uint = 0; index < length; index++) {
				target[properties[index]] = getProgressBetween(startValues[index], endValues[index]);
			}
		}
		
		/** @inheritDoc */
		override public function dispose(recursive:Boolean = true):void {
			super.dispose();
			properties = null;
			startValues = null;
			endValues = null;
		}
		
	}
}