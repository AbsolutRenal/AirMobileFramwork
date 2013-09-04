/**
 *
 * AirMobileFramework
 *
 * https://github.com/AbsolutRenal
 *
 * Copyright (c) 2012 AbsolutRenal (Renaud Cousin). All rights reserved.
 * 
 * This ActionScript source code is free.
 * You can redistribute and/or modify it in accordance with the
 * terms of the accompanying Simplified BSD License Agreement.
 *
 * This framework also include some third party free Classes like Greensocks Tweening engine, Text and Fonts manager, Audio manager, Stats manager (by mrdoob)
**/

package fwk.components.events {
	import flash.events.Event;

	/**
	 * @author renaud.cousin
	 */
	public class VideoPlayerEvents extends Event {
		public static const VIDEO_END:String = "videoEnd";
		public static const PLAY:String = "play";
		public static const PAUSE:String = "pause";
		public static const STOP:String = "stop";
		public static const SEEK:String = "seek";
		public static const START_SEEK:String = "startSeek";
		public static const CLOSE:String = "close";
		
		private var _data:*;

		public function VideoPlayerEvents(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			_data = data;
			super(type, bubbles, cancelable);
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
		
		public function get data():*{
			return _data;
		}
	}
}
