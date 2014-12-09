package pixlib.motion.easing {
	
	public function sineInOut(r:Number):Number {
		return easeCombined(sineIn, sineOut, r);
	}
}