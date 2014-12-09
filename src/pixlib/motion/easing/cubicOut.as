package pixlib.motion.easing {
	
	public function cubicOut(r:Number):Number {
		r = r - 1;
		return r * r * r + 1;
	}
}