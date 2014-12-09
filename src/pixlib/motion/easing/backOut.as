package pixlib.motion.easing {
	
	public function backOut(r:Number):Number {
		var ir:Number = r - 1.0;            
		var s:Number = 1.70158;
		return Math.pow(ir, 2) * ((s + 1.0)*ir + s) + 1.0;
	}
	
}