package pixlib.motion.easing {
	
	public function quinticInOut(r:Number):Number {
		return easeCombined(quinticIn, quinticOut, r);
	}
}