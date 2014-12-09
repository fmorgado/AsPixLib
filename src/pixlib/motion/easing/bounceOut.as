package pixlib.motion.easing {
	
	public function bounceOut(r:Number):Number {
		var s:Number = 7.5625;
		var p:Number = 2.75;
		var l:Number;
		if (r < (1.0/p)) {
			l = s * Math.pow(r, 2);
		} else {
			if (r < (2.0/p)) {
				r -= 1.5/p;
				l = s * Math.pow(r, 2) + 0.75;
			} else {
				if (r < 2.5/p) {
					r -= 2.25/p;
					l = s * Math.pow(r, 2) + 0.9375;
				} else {
					r -= 2.625/p;
					l =  s * Math.pow(r, 2) + 0.984375;
				}
			}
		}
		return l;
	}
	
}