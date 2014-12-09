package pixlib.motion.easing {
	
	public function backInOut(r:Number):Number {
		return easeCombined(backIn, backOut, r);
	}
	
}