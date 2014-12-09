package pixlib.motion.easing {
	
	public function backIn(r:Number):Number {
		var s:Number = 1.70158;
		return r * r * ((s + 1.0) * r - s);
	}
}