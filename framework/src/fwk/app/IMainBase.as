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

package fwk.app {
	import fwk.app.pages.AbstractPage;

	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author renaud.cousin
	 */
	public interface IMainBase {
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		function loadAndDisplayPage(id:String):void;
		function initTextFromString(mcT:MovieClip, label:String, style:String, scopeFunction:Function = null):void;
		function depthContainer(depth:String):Sprite;
		function goPrevious():void;
		function killApp():void;
		function switchLanguage(language:String):void;
		
		function getDependencyAssets(id:String):XML;
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
		
		function get previousPage():AbstractPage
		function get currentPage():AbstractPage;
		function get datas():XML;
		function get countryPath():String;
		function get sharedPath():String;
		function get assets():Object
		function get transitionsType():String;
		function set transitionsType(value:String):void;
	}
}
