package pixlib.motion.easing {
	
	public function elasticInOut(ratio:Number):Number {
		return easeCombined(elasticIn, elasticOut, ratio);
	}
	
}