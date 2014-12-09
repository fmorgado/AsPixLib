package pixlib.utils {
	import flash.display.Stage;
	import flash.system.Capabilities;
	
	public final class Metric {
		
		//{ Metric Types
		///////////////////////////////////////////////////////////////////////
		public static const ACTIVATE:String = 'activate';
		public static const DEACTIVATE:String = 'deactivate';
		public static const VIEW:String = 'view';
		public static const HIDDEN:String = 'hidden';
		public static const SCREEN:String = 'screen';
		public static const LOGIN:String = 'login';
		public static const LOGOUT:String = 'logout';
		public static const EXIT:String = 'exit';
		public static const SLEEP:String = 'sleep';
		public static const WAKE:String = 'wake';
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Listeners Handling
		///////////////////////////////////////////////////////////////////////
		private static var _listeners:Vector.<Function> = new <Function>[];
		
		/**
		 * Add a metrics listener.
		 * @param  listener  The listener function to add.
		 *                   Its signature must be <code>function(metric:Metric):void</code>.
		 */
		public static function addListener(listener:Function):void {
			var index:int = _listeners.indexOf(listener);
			if (index < 0)
				_listeners[_listeners.length] = listener;
		}
		
		/**
		 * Remove a metric listener added with <code>addListener</code>.
		 * @param  listener  The metric listener to remove.
		 */
		public static function removeListener(listener:Function):void {
			var index:int = _listeners.indexOf(listener);
			if (index >= 0)
				_listeners.splice(index, 1);
		}
		
		/**
		 * Dispatch a metric.
		 * @param  type      The type of the metric.
		 * @param  argument  The argument of the metric.
		 */
		public static function dispatchMetric(type:String, argument:Object = null):void {
			var metric:Metric = new Metric(type, argument);
			var length:uint = _listeners.length;
			for (var index:uint = 0; index < length; index++)
				_listeners[index](metric);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Custom Methods
		///////////////////////////////////////////////////////////////////////
		/** Dispatch the <code>Exit</code> metric. */
		public static function exit():void {
			dispatchMetric(EXIT);
		}
		
		/** Dispatch the <code>ACTIVATE</code> metric. */
		public static function activate():void {
			dispatchMetric(ACTIVATE);
		}
		
		/** Dispatch the <code>DEACTIVATE</code> metric. */
		public static function deactivate():void {
			dispatchMetric(DEACTIVATE);
		}
		
		/** Dispatch the <code>VIEW</code> metric. */
		public static function view(argument:Object):void {
			dispatchMetric(VIEW, argument);
		}
		
		/** Dispatch the <code>HIDDEN</code> metric. */
		public static function hidden(argument:Object):void {
			dispatchMetric(HIDDEN, argument);
		}
		
		/** Dispatch the <code>SCREEN</code> metric. */
		public static function screen(stage:Stage):void {
			dispatchMetric(SCREEN, {width: stage.stageWidth, height: stage.stageHeight, dpi: Capabilities.screenDPI});
		}
		
		/** Dispatch the <code>LOGIN</code> metric. */
		public static function login(argument:Object):void {
			dispatchMetric(LOGIN, argument);
		}
		
		/** Dispatch the <code>LOGOUT</code> metric. */
		public static function logout(argument:Object):void {
			dispatchMetric(LOGOUT, argument);
		}
		
		/** Dispatch the <code>SLEEP</code> metric. */
		public static function sleep():void {
			dispatchMetric(SLEEP);
		}
		
		/** Dispatch the <code>WAKE</code> metric. */
		public static function wake():void {
			dispatchMetric(WAKE);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Instance Implementation
		///////////////////////////////////////////////////////////////////////
		/**
		 * Constructor.
		 * @param  type      The type of the metric.
		 * @param  argument  The argument of the metric.
		 */
		public function Metric(type:String, argument:Object = null) {
			_type = type;
			_argument = argument;
		}
		
		private var _type:String;
		/** The type of the metric. */
		public function get metricType():String { return _type; }
		
		private var _argument:Object;
		/** The argument of the metric. */
		public function get argument():Object { return _argument; }
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}