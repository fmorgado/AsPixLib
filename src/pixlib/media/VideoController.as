package pixlib.media {
	//{ Imports
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.getTimer;
	
	import pixlib.ErrorConstants;
	import pixlib.logging.Log;
	import pixlib.logging.logger;
	import pixlib.utils.Dispatcher;
	import pixlib.utils.EnterFrame;
	//}
	
	public final class VideoController extends Dispatcher {
		//{ Constructor & Initialization
		///////////////////////////////////////////////////////////////////////
		private var _stopped:Boolean = false;
		
		/** Constructor. */
		public function VideoController() {
			super();
			
			_soundTransform = new SoundTransform();
			
			var connection:NetConnection = new NetConnection();
			connection.connect(null);
			_stream = new NetStream(connection);
			_stream.client = {
				onMetaData: _onStreamMetaData,
				onPlayStatus: _onStreamPlayStatus
			};
			_stream.addEventListener(IOErrorEvent.IO_ERROR, _onStreamError);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, _onStreamAsyncError);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, _onStreamStatus);
			_stream.soundTransform = _soundTransform;
		}
		
		private function _onStreamMetaData(object:Object):void {
			if (object.duration is Number) {
				_duration = object.duration;
				dispatch(TIME_CHANGE, this);
			}
		}
		
		private function _onStreamPlayStatus(object:Object):void {}
		
		private function _clearState():void {
			_stopPlaying();
			_source = null;
			_playing = false;
			_time = 0;
			_duration = NaN;
			_error = null;
			_seeking = false;
			_stopped = false;
			_stream.close();
		}
		
		/** Clear the controller. Similar to <code>source = null;</code>. */
		public function clear():void {
			if (_state != VideoState.UNINITIALIZED) {
				_clearState();
				_setState(VideoState.UNINITIALIZED);
			}
		}
		
		/** Dispose the controller. */
		override public function dispose(recursive:Boolean = true):void {
			super.dispose(recursive);
			clear();
			_stream.dispose();
		}
		
		private function _requireOpenOrBufferingState():void {
			if (_state != VideoState.OPEN && _state != VideoState.BUFFERING)
				throw new Error('Invalid State, no stream open');
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Stream Handling
		///////////////////////////////////////////////////////////////////////
		private var _stream:NetStream;
		/** The underlying <code>NetStream</code> instance. */
		public function get stream():NetStream { return _stream; }
		
		private function _dispatchError(message:String, details:Object):void {
			details.source = _source;
			var error:Log = new Log(Log.ERROR, message, details, this);
			_clearState();
			_error = error;
			logger.log(error);
			_setState(VideoState.ERROR);
		}
		
		private function _onStreamError(event:IOErrorEvent):void {
			_clearState();
			_dispatchError(ErrorConstants.IO_ERROR, {text: event.text, errorID: event.errorID});
		}
		
		private function _onStreamAsyncError(event:AsyncErrorEvent):void {
			_dispatchError(ErrorConstants.ASYNC_ERROR, {text: event.text, errorID: event.errorID});
		}
		
		private function _onStreamStatus(event:NetStatusEvent):void {
			switch (event.info.level) {
				case 'status':
					switch (event.info.code) {
						case 'NetStream.Play.Start':
							_setState(VideoState.BUFFERING);
							_updateTime(0);
							playing = autoPlay;
							break;
						case 'NetStream.Play.Stop':
							_stopped = true;
							if (autoLoop) {
								time = 0;
							} else {
								playing = false;
							}
							dispatch(COMPLETE, this);
							logger.info('STOP', JSON.stringify(event.info), this);
							break;
						case 'NetStream.Buffer.Full':
							_setState(VideoState.OPEN);
							break;
						case 'NetStream.Seek.Notify':
							_setState(VideoState.BUFFERING);
							break;
						case 'NetStream.Buffer.Empty':
							break;
						// These are ignored
						case 'NetStream.Seek.Complete':
						case 'NetStream.Unpause.Notify':
						case 'NetStream.Pause.Notify':
						case 'NetStream.Buffer.Flush':
						case 'NetStream.SeekStart.Notify':
						case 'NetStream.Play.StreamNotFound':
						case 'NetStream.Video.DimensionChange':
							//logger.info('IGNORED', JSON.stringify(event.info), this);
							break;
						default:
							logger.info('Unknown NetStream Status Code', JSON.stringify(event.info), this);
					}
					break;
				
				default:
					logger.info('Unknown NetStream Status', JSON.stringify(event.info), this);
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ State Handling
		///////////////////////////////////////////////////////////////////////
		private var _state:String = VideoState.UNINITIALIZED;
		/**
		 * The state of the controller.
		 * @default VideoState.UNINITIALIZED
		 * @see pixui.controllers.VideoState
		 */
		public function get state():String { return _state; }
		
		private function _setState(value:String):void {
			_state = value;
			dispatch(STATE_CHANGE, this);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Playing Handling
		///////////////////////////////////////////////////////////////////////
		private var _reallyPlaying:Boolean = false;
		
		private function _onUpdateTimeEnterFrame(_):void {
			var time:int = getTimer();
			_updateTime(_stream.time);
			dispatch(TIME_CHANGE, this);
		}
		
		private function _stopPlaying():void {
			if (_reallyPlaying) {
				_reallyPlaying = false;
				EnterFrame.remove(_onUpdateTimeEnterFrame);
				_stream.pause();
			}
		}
		
		private function _startPlaying():void {
			if (! _reallyPlaying) {
				_reallyPlaying = true;
				EnterFrame.add(_onUpdateTimeEnterFrame);
				_stream.resume();
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Times Handling
		///////////////////////////////////////////////////////////////////////
		private function _updateTime(value:Number):void {
			_time = value;
			dispatch(TIME_CHANGE, this);
		}
		
		private var _time:Number = 0;
		/** The position of the playhead, in seconds. */
		public function get time():Number { return _time; }
		public function set time(value:Number):void {
			_requireOpenOrBufferingState();
			
			if (value < 0) {
				value = 0;
			} else if (! isNaN(_duration) && value > _duration) {
				value = _duration;
			}
			
			if (value == _time)
				return;
			
			if (_stopped) {
				_stopped = false;
				_stream.play(_source);
			}
			_stream.seek(value);
			_updateTime(value);
		}
		
		private var _duration:Number = NaN;
		/** The duration of the video, in seconds. */
		public function get duration():Number { return _duration; }
		
		private var _seeking:Boolean = false;
		/** Indicates if the playhead position is currently being moved. */
		public function get seeking():Boolean { return _seeking; }
		public function set seeking(value:Boolean):void {
			_requireOpenOrBufferingState();
			if (value == _seeking) return;
			
			_seeking = value;
			if (value) {
				_stopPlaying();
			} else if (_playing) {
				_startPlaying();
			}
		}
		
		private var _playing:Boolean = false;
		/** Indicates if the video is currently playing. */
		public function get playing():Boolean { return _playing; }
		public function set playing(value:Boolean):void {
			_requireOpenOrBufferingState();
			
			_playing = value;
			if (! _seeking) {
				if (value) {
					if (_stopped) {
						_stopped = false;
						_stream.play(_source);
					}
					_startPlaying();
				} else {
					_stopPlaying();
				}
			}
			dispatch(PLAYING_CHANGE, this);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Public Properties
		///////////////////////////////////////////////////////////////////////
		private var _error:Log;
		/** The error that occurred last, or null. */
		public function get error():Log { return _error; }
		
		/** Indicates if a video starts playing automatically when loaded. */
		public var autoPlay:Boolean = true;
		
		/** Indicates if the video must be restarted when it completes. */
		public var autoLoop:Boolean = false;
		
		private var _soundTransform:SoundTransform;
		/** Get the underlying <code>SoundTransform</code> instance. */
		public function get soundTransform():SoundTransform { return _soundTransform; }
		
		/** The sound volume, a value between 0 and 1. */
		public function get volume():Number { return _soundTransform.volume; }
		public function set volume(value:Number):void {
			if      (value < 0)  value = 0;
			else if (value > 1)  value = 1;
			
			_soundTransform.volume = value;
			_stream.soundTransform = _soundTransform;
			dispatch(VOLUME_CHANGE, this);
		}
		
		private var _source:String;
		/** The URL of the video file. */
		public function get source():String { return _source; }
		public function set source(value:String):void {
			if (value == _source) return;
			
			if (value == null) {
				clear();
				
			} else {
				_clearState();
				_source = value;
				_setState(VideoState.INITIALIZING);
				_stream.play(value);
			}
		}
		
		/** The number of bytes loaded. */
		public final function get bytesLoaded():uint { return _stream.bytesLoaded; }
		/** The total number of bytes. */
		public final function get bytesTotal():uint { return _stream.bytesTotal; }
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Listeners Handling
		///////////////////////////////////////////////////////////////////////
		/** The type of the event dispatched when the state changes. */
		public static const STATE_CHANGE:String = 'stateChange';
		/** The type of the event dispatched when the time changes. */
		public static const TIME_CHANGE:String = 'timeChange';
		/** The type of the event dispatched when the value of <code>playing</code> changes. */
		public static const PLAYING_CHANGE:String = 'playingChange';
		/** The type of the event dispatched when the volume changes. */
		public static const VOLUME_CHANGE:String = 'volumeChange';
		/** The type of the event dispatched when the video completes. */
		public static const COMPLETE:String = 'complete';
		
		/**
		 * Add a listener for the <code>STATE_CHANGE</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addStateChangeListener(listener:Function):void {
			this.addListener(STATE_CHANGE, listener);
		}
		/**
		 * Remove a listener for the <code>STATE_CHANGE</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeStateChangeListener(listener:Function):void {
			this.removeListener(STATE_CHANGE, listener);
		}
		
		/**
		 * Add a listener for the <code>TIME_CHANGE</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addTimeChangeListener(listener:Function):void {
			this.addListener(TIME_CHANGE, listener);
		}
		/**
		 * Remove a listener for the <code>TIME_CHANGE</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeTimeChangeListener(listener:Function):void {
			this.removeListener(TIME_CHANGE, listener);
		}
		
		/**
		 * Add a listener for the <code>PLAYING_CHANGE</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addPlayingChangeListener(listener:Function):void {
			this.addListener(PLAYING_CHANGE, listener);
		}
		/**
		 * Remove a listener for the <code>PLAYING_CHANGE</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removePlayingChangeListener(listener:Function):void {
			this.removeListener(PLAYING_CHANGE, listener);
		}
		
		/**
		 * Add a listener for the <code>VOLUME_CHANGE</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addVolumeChangeListener(listener:Function):void {
			this.addListener(VOLUME_CHANGE, listener);
		}
		/**
		 * Remove a listener for the <code>VOLUME_CHANGE</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeVolumeChangeListener(listener:Function):void {
			this.removeListener(VOLUME_CHANGE, listener);
		}
		
		/**
		 * Add a listener for the <code>COMPLETE</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addCompleteListener(listener:Function):void {
			this.addListener(COMPLETE, listener);
		}
		/**
		 * Remove a listener for the <code>COMPLETE</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeCompleteListener(listener:Function):void {
			this.removeListener(COMPLETE, listener);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}