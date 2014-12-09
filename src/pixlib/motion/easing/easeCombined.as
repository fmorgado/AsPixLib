package pixlib.motion.easing {
	
	public function easeCombined(f1:Function, f2:Function, r:Number):Number {
		if (r < 0.5)
			return 0.5 * f1(r*2.0);
		else
			return 0.5 * f2((r-0.5)*2.0) + 0.5;
	}
	
}