package pixlib.motion.easing {
	
	public function quinticOut(r:Number):Number {
		r = r - 1;
		return r * r * r * r * r + 1;
	}
}