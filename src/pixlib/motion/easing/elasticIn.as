package pixlib.motion.easing {
	
	public function elasticIn(ratio:Number):Number {
		if (ratio == 0 || ratio == 1) {
			return ratio;
		} else {
			var p:Number = 0.3;
			var s:Number = p/4.0;
			var invRatio:Number = ratio - 1;
			return -1.0 * Math.pow(2.0, 10.0*invRatio) * Math.sin((invRatio-s)*(2.0*Math.PI)/p);                
		}            
	}
	
}