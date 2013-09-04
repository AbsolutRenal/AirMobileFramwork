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

package fwk.debug.events {
	import flash.events.Event;

	/**
	 * @author renaud.cousin
	 */
	public class DebugSearchEvent extends Event {
		public static const SEARCH:String = "search";
		public static const SEARCH_CANCELLED:String = "searchCancelled";
		
		private var _datas:String;

		public function DebugSearchEvent(type:String, datas:String = "", bubbles:Boolean = false, cancelable:Boolean = false) {
			_datas = datas;
			super(type, bubbles, cancelable);
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
		
		public function get datas():String {
			return _datas;
		}
	}
}
