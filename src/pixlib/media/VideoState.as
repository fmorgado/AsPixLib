package pixlib.media {
	
	/** Constant for the <code>state</code> property of <code>VideoController</code>. */
	public class VideoState {
		
		/** The state when <code>source</code> is null. */
		public static const UNINITIALIZED:String = 'uninitialized';
		
		/** The state when the controller is initializing. */
		public static const INITIALIZING:String = 'initializing';
		
		/** The state when an error occurred. */
		public static const ERROR:String = 'error';
		
		/** The state when the video is buffering. */
		public static const BUFFERING:String = 'buffering';
		
		/** The state when the video is playing. */
		public static const OPEN:String = 'open';
		
	}
}