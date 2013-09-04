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

package fwk.app.pages.events {
	import flash.events.Event;

	/**
	 * @author renaud.cousin
	 */
	public class PageEvents extends Event {
		public static const DISPLAY_COMPLETE:String = "displayComplete";
		public static const CLOSE_COMPLETE:String = "closeComplete";

		public function PageEvents(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
