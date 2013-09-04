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

package fwk.utils.loaders.events {
	import flash.events.Event;

	/**
	 * @author renaud.cousin
	 */
	public class LoaderEvents extends Event {
		public static const LOAD_START:String = "loadStart";
		public static const LOAD_PROGRESS:String = "loadProgress";
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_ERROR:String = "loadError";
		public static const BYTES_TOTAL_KNOWN:String = "bytesTotalKnown";
		
		private var _data:*;

		public function LoaderEvents(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false) {
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
