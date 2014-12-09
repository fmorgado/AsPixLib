package pixlib.motion {
	
	public interface IAnimatable {
		
		/** Advances the animation by the given amount of milliseconds. */
		function advanceTime(milliseconds:Number):void;
		
	}
}