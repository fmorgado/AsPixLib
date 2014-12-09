package pixlib.motion.easing {
	
	public function expOut(r:Number):Number {
		return r == 1 ? 1 : -Math.pow(2, -10 * r) + 1;
	}
}