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
	public class TouchScrollEvent extends Event {
		public static const IS_READY:String = "isReady";
		public static const BTN_START_DRAGGING:String = "btnStartDragging";
		public static const BTN_STOP_DRAGGING:String = "btnStopDragging";
		public static const LIST_START_DRAGGING:String = "btnStartDragging";
		public static const LIST_STOP_DRAGGING:String = "btnStopDragging";
		public static const LIST_ITEM_SELECTED:String = "listItemSelected";
		
		private var _datas:*;

		public function TouchScrollEvent(type:String, datas:* = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			_datas = datas;
			super(type, bubbles, cancelable);
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------

		public function get datas():* {
			return _datas;
		}
	}
}
