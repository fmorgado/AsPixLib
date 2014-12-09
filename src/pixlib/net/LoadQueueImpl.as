package pixlib.net {
	//{ Imports
	import flash.net.URLLoaderDataFormat;
	
	import pixlib.commands.Command;
	import pixlib.commands.DataCommand;
	import pixlib.logging.Log;
	import pixlib.utils.Dispatcher;
	//}
	
	public final class LoadQueueImpl extends Dispatcher {
		//{ Public Helpers
		///////////////////////////////////////////////////////////////////////
		/**
		 * Start <code>command</code>, invokes given listeners then disposes the command.
		 * When the command completes, <code>onComplete</code> is invoked with the result and the command is disposed.
		 * When the command fails, <code>onError</code> is invoked with the error and the command is disposed.
		 * @param  command     The command to start and dispose.
		 * @param  onComplete  The result handler. The function signature must be <code>function(data:Object):void</code>.
		 * @param  onError     The error handler. The function signature must be <code>function(error:Log):void</code>.
		 * @param  onProgress  The progress handler. The function signature must be <code>function(progress:Number, total:Number):void</code>.
		 */
		public function addThenDispose(command:DataCommand, onComplete:Function, onError:Function, onProgress:Function = null):void {
			command.onComplete(function(command:DataCommand):void {
				var data:Object = command.data;
				command.dispose();
				onComplete(data);
			});
			command.onError(function(command:DataCommand):void {
				var error:Log = command.error;
				command.dispose();
				onError(error);
			});
			if (onProgress != null) {
				command.onProgress(function(command:DataCommand):void {
					onProgress(command.progress, command.progressTotal);
				});
			}
			add(command);
		}
		
		public function loadData(request:Object, onComplete:Function,
								 onError:Function, onProgress:Function = null,
								 transformer:Function = null,
								 dataFormat:String = URLLoaderDataFormat.BINARY):void {
			addThenDispose(new DataLoader(request, dataFormat, transformer), onComplete, onError, onProgress);
		}
		
		public function loadJson(request:Object, onComplete:Function,
										onError:Function, onProgress:Function = null,
										transformer:Function = null):void {
			addThenDispose(new JsonLoader(request, transformer), onComplete, onError, onProgress);
		}
		
		public function loadString(request:Object, onComplete:Function, onError:Function,
										  onProgress:Function = null, transformer:Function = null):void {
			addThenDispose(new StringLoader(request, transformer), onComplete, onError, onProgress);
		}
		
		public function loadImage(request:Object, onComplete:Function, onError:Function, onProgress:Function = null):void {
			addThenDispose(new ImageLoader(request), onComplete, onError, onProgress);
		}
		
		public function loadXML(request:Object, onComplete:Function, onError:Function, onProgress:Function = null, transformer:Function = null):void {
			addThenDispose(new XMLLoader(request, transformer), onComplete, onError, onProgress);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Variables
		///////////////////////////////////////////////////////////////////////
		private var _waiting:Vector.<Command> = new <Command>[];
		private var _loading:Vector.<Command> = new <Command>[];
		
		private var _concurrentLoads:uint = 3;
		/**
		 * The number of concurrent loads.
		 * If 0, all commands are automatically started.
		 */
		public function get concurrentLoads():uint { return _concurrentLoads; }
		public function set concurrentLoads(value:uint):void {
			_concurrentLoads = value;
			_startNext();
		}
		
		/** The number of commands in the queue. */
		public function get numWaiting():uint { return _waiting.length; }
		
		/** The number of running commands. */
		public function get numLoading():uint { return _loading.length; }
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Public Methods
		///////////////////////////////////////////////////////////////////////
		/**
		 * Add a command to the queue.
		 * @param  command     The command to add.
		 * @param  prioritary  Indicates if the command should be the next to start.
		 */
		public function add(command:Command, prioritary:Boolean = false):void {
			if (command.running)
				throw new ArgumentError('Command is already running');
			if (_waiting.indexOf(command) >= 0)
				throw new ArgumentError('Command was already added');
			
			if (prioritary) {
				_waiting[_waiting.length] = command;
			} else {
				_waiting.unshift(command);
			}
			
			_startNext();
		}
		
		public function remove(command:Command):void {
			var index:int = _waiting.indexOf(command);
			if (index >= 0) {
				_waiting.splice(index, 1);
				return;
			}
			
			index = _loading.indexOf(command);
			if (index >= 0) {
				command.stop();
				return;
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Implementation
		///////////////////////////////////////////////////////////////////////
		private function _startNext():void {
			while (_waiting.length > 0 && (_concurrentLoads == 0 || _loading.length < _concurrentLoads)) {
				var command:Command = _waiting.pop();
				command.onStop(_onCommandStop);
				command.start();
				_loading[_loading.length] = command;
			}
		}
		
		private function _onCommandStop(command:Command):void {
			var index:int = _loading.indexOf(command);
			if (index >= 0) {
				_loading.splice(index, 1);
				command.removeOnStop(_onCommandStop);
				_startNext();
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
	}
}