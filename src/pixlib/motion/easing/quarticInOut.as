package pixlib.motion.easing {
	
	public function quarticInOut(r:Number):Number {
		return easeCombined(quarticIn, quarticOut, r);
	}
}