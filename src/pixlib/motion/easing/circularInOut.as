package pixlib.motion.easing {
	
	public function circularInOut(r:Number):Number {
		return easeCombined(circularIn, circularOut, r);
	}
}