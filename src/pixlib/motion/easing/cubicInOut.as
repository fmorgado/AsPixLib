package pixlib.motion.easing {
	
	public function cubicInOut(r:Number):Number {
		return easeCombined(cubicIn, cubicOut, r);
	}
}