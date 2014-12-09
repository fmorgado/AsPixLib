package pixlib.motion.easing {
	
	public function circularOut(r:Number):Number {
		r = r - 1;
		return Math.sqrt(1 - r * r);
	}
}