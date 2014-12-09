package pixlib.motion.easing {
	
	public function quadInOut(r:Number):Number {
		return easeCombined(quadIn, quadOut, r);
	}
}