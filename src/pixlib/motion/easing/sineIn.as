package pixlib.motion.easing {
	
	public function sineIn(r:Number):Number {
		return -1 * Math.cos(r * (Math.PI / 2)) + 1;
	}
}