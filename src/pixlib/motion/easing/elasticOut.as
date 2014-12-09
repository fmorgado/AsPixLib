package pixlib.motion.easing {
	
	public function elasticOut(ratio:Number):Number {
		if (ratio == 0 || ratio == 1) return ratio;
		else {
			var p:Number = 0.3;
			var s:Number = p/4.0;                
			return Math.pow(2.0, -10.0*ratio) * Math.sin((ratio-s)*(2.0*Math.PI)/p) + 1;                
		}
	}
	
}