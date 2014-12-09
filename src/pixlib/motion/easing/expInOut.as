package pixlib.motion.easing {
	
	public function expInOut(r:Number):Number {
		return easeCombined(expIn, expOut, r);
	}
}