package pixlib.motion.easing {
	
	public function expIn(r:Number):Number {
		return r == 0 ? 0 : Math.pow(2, 10 * (r - 1));
	}
}