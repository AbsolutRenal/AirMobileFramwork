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

package com.app {
	/**
	 * @author renaud.cousin
	 */
	public class SiteApp {
		public static var main:IMain;
		public static var supportedLanguages:Array = [];
		public static var defaultLanguage:String;
		public static var language:String;
		
		public static var firstLoad:Boolean = true;
		public static var APP_WIDTH:int = NaN;
		public static var APP_HEIGHT:int = NaN;
		public static var useBitmapTransition:Boolean = false;
		
		public static var debugMod:Boolean = false;
		public static var useStats:Boolean = false;
	}
}
