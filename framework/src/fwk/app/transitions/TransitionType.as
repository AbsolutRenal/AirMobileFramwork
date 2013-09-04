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

package fwk.app.transitions {
	/**
	 * @author renaud.cousin
	 */
	public class TransitionType {
		/*
		 * Preload/Close previous/Open new
		 */
		public static const PRELOAD:String = "preload";
		
		/*
		 * Preload/Close previous + Open new
		 */
		public static const CROSS:String = "cross";
		
		/*
		 * Preload/Open new/Close previous
		 */
		public static const REVERSE:String = "reverse";
	}
}
