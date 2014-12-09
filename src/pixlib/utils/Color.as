package pixlib.utils {
	import flash.geom.ColorTransform;
	
	/**
	 * The Color class extends the Flash Player ColorTransform class,
	 * adding the ability to control brightness and tint.
	 * It also contains static methods for interpolating between two ColorTransform objects
	 * or between two color numbers.
	 */
	public final class Color extends ColorTransform {
		
		/**
		 * Blends smoothly from one ColorTransform object to another.
		 * @param fromColor The starting ColorTransform object.
		 * @param toColor The ending ColorTransform object.
		 * @param progress The percent of the transition as a decimal, where <code>0</code> is the start and <code>1</code> is the end.
		 * @return The interpolated ColorTransform object.
		 */
		public static function interpolateTransform(fromColor:ColorTransform, toColor:ColorTransform, progress:Number):ColorTransform {
			var q:Number = 1 - progress;
			return new ColorTransform(
				fromColor.redMultiplier   * q  + toColor.redMultiplier   * progress,
				fromColor.greenMultiplier * q  + toColor.greenMultiplier * progress,
				fromColor.blueMultiplier  * q  + toColor.blueMultiplier  * progress,
				fromColor.alphaMultiplier * q  + toColor.alphaMultiplier * progress,
				fromColor.redOffset       * q  + toColor.redOffset       * progress,
				fromColor.greenOffset     * q  + toColor.greenOffset     * progress,
				fromColor.blueOffset      * q  + toColor.blueOffset      * progress,
				fromColor.alphaOffset     * q  + toColor.alphaOffset     * progress);             
		}
		
		/**
		 * Blends smoothly from one color value to another.
		 * @param fromColor The starting color value, in the 0xRRGGBB or 0xAARRGGBB format.
		 * @param toColor The ending color value, in the 0xRRGGBB or 0xAARRGGBB format.
		 * @param progress The percent of the transition as a decimal, where <code>0</code> is the start and <code>1</code> is the end.
		 * @return The interpolated color value, in the 0xRRGGBB or 0xAARRGGBB format.
		 */
		public static function interpolateColor(fromColor:uint, toColor:uint, progress:Number):uint {
			var q:Number = 1-progress;
			var fromA:uint = (fromColor >> 24) & 0xFF;
			var fromR:uint = (fromColor >> 16) & 0xFF;
			var fromG:uint = (fromColor >>  8) & 0xFF;
			var fromB:uint =  fromColor        & 0xFF;
			
			var toA:uint = (toColor >> 24) & 0xFF;
			var toR:uint = (toColor >> 16) & 0xFF;
			var toG:uint = (toColor >>  8) & 0xFF;
			var toB:uint =  toColor        & 0xFF;
			
			var resultA:uint = fromA * q + toA * progress;
			var resultR:uint = fromR * q + toR * progress;
			var resultG:uint = fromG * q + toG * progress;
			var resultB:uint = fromB * q + toB * progress;
			
			return resultA << 24 | resultR << 16 | resultG << 8 | resultB;
		}
		
		/**
		 * Creates a <code>Color</code> instance from a brightness value.
		 * @param  value  The percentage of brightness, as a decimal between <code>-1</code> and <code>1</code>.
		 * @return A <code>Color</code> instance with the given brightness.
		 */
		public static function fromBrightness(value:Number):Color {
			var result:Color = new Color();
			result.brightness = value;
			return result;
		}
		
		/**
		 * Creates a <code>Color</code> instance from a tint.
		 * @param color       The tinting color value in the 0xRRGGBB format.
		 * @param multiplier  The percentage to apply the tint color, as a decimal value between <code>0</code> and <code>1</code>.
		 * @return A <code>Color</code> instance with the given tint parameters.
		 */
		public static function fromTint(color:Number, multiplier:Number):Color {
			var result:Color = new Color();
			result.setTint(color, multiplier);
			return result;
		}
		
		/**
		 * Constructor for Color instances.
		 *
		 * @param redMultiplier    The percentage to apply the color, as a decimal value between 0 and 1.
		 * @param greenMultiplier  The percentage to apply the color, as a decimal value between 0 and 1.
		 * @param blueMultiplier   The percentage to apply the color, as a decimal value between 0 and 1.
		 * @param alphaMultiplier  A decimal value that is multiplied with the alpha transparency channel value, as a decimal value between 0 and 1.
		 * @param redOffset        A number from -255 to 255 that is added to the red channel value after it has been multiplied by the <code>redMultiplier</code> value. 
		 * @param greenOffset      A number from -255 to 255 that is added to the green channel value after it has been multiplied by the <code>greenMultiplier</code> value. 
		 * @param blueOffset       A number from -255 to 255 that is added to the blue channel value after it has been multiplied by the <code>blueMultiplier</code> value. 
		 * @param alphaOffset      A number from -255 to 255 that is added to the alpha channel value after it has been multiplied by the <code>alphaMultiplier</code> value.     
		 */
		public function Color(redMultiplier:Number=1.0, greenMultiplier:Number=1.0, blueMultiplier:Number=1.0, 
						alphaMultiplier:Number=1.0, redOffset:Number=0, greenOffset:Number=0, 
						blueOffset:Number=0, alphaOffset:Number=0) {
			super(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
		}
		
		/**
		 * The percentage of brightness, as a decimal between <code>-1</code> and <code>1</code>. 
		 * Positive values lighten the object, and a value of <code>1</code> turns the object completely white.
		 * Negative values darken the object, and a value of <code>-1</code> turns the object completely black.     
		 */
		public function get brightness():Number {
			return this.redOffset ? (1-this.redMultiplier) : (this.redMultiplier-1);
		}
		public function set brightness(value:Number):void {
			if (value > 1) value = 1;
			else if (value < -1) value = -1;
			
			var percent:Number = 1 - Math.abs(value);
			var offset:Number = 0;
			
			if (value > 0) offset = value * 255;
			this.redMultiplier = this.greenMultiplier = this.blueMultiplier = percent;
			this.redOffset     = this.greenOffset     = this.blueOffset     = offset;
		}
		
		/**
		 * Sets the tint color and amount at the same time.
		 * @param tintColor The tinting color value in the 0xRRGGBB format.
		 * @param tintMultiplier The percentage to apply the tint color, as a decimal value between <code>0</code> and <code>1</code>.
		 * When <code>tintMultiplier = 0</code>, the target object is its original color and no tint color is visible.
		 * When <code>tintMultiplier = 1</code>, the target object is completely tinted and none of its original color is visible.         
		 */
		public function setTint(tintColor:uint, tintMultiplier:Number):void {
			this._tintColor = tintColor;
			this._tintMultiplier = tintMultiplier;
			this.redMultiplier = this.greenMultiplier = this.blueMultiplier = 1 - tintMultiplier;
			var r:uint = (tintColor >> 16) & 0xFF;
			var g:uint = (tintColor >>  8) & 0xFF;
			var b:uint =  tintColor        & 0xFF;
			this.redOffset   = Math.round(r * tintMultiplier);
			this.greenOffset = Math.round(g * tintMultiplier);
			this.blueOffset  = Math.round(b * tintMultiplier);
		}       
		
		private var _tintColor:Number = 0x000000;
		/** The tinting color value in the 0xRRGGBB format. @default 0x000000 (black) */
		public function get tintColor():uint { return this._tintColor; }
		public function set tintColor(value:uint):void {
			this.setTint(value, this.tintMultiplier);
		}
		
		private var _tintMultiplier:Number = 0;
		/**
		 * The percentage to apply the tint color, as a decimal value between <code>0</code> and <code>1</code>.
		 * When <code>tintMultiplier = 0</code>, the target object is its original color and no tint color is visible.
		 * When <code>tintMultiplier = 1</code>, the target object is completely tinted and none of its original color is visible.
		 * @default 0        
		 */
		public function get tintMultiplier():Number { return this._tintMultiplier; }
		public function set tintMultiplier(value:Number):void {
			this.setTint(this.tintColor, value);
		}
		
	}
}