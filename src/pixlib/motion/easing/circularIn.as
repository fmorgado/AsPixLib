package pixlib.motion.easing {
	
	public function circularIn(ratio:Number):Number {
		return -1 * (Math.sqrt(1 - (ratio) * ratio) - 1);
	}
}