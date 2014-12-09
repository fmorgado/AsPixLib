package pixlib.motion.easing {
	
	public function quarticOut(r:Number):Number {
		r = r - 1;
		return -1 * (r * r * r * r - 1);
	}
}