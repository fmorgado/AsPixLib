package pixlib.motion.easing {
	
	public function bounceInOut(r:Number):Number {
		return easeCombined(bounceIn, bounceOut, r);
	}
	
}