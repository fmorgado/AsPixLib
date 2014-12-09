package pixlib.motion.easing {
	
	public function bounceIn(r:Number):Number {
		return 1.0 - bounceOut(1.0 - r);
	}
	
}