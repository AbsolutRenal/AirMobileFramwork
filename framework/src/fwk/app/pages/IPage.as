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

package fwk.app.pages {
	/**
	 * @author renaud.cousin
	 */
	public interface IPage {
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		function init():void;
		function displayPage():void;
		function closePage():void;
		function active():void;
		function desactive():void;
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
		
		function get assets():Object;
		function set assets(value:Object):void;
		function get parentContainerDepth():String;
		function set parentContainerDepth(value:String):void;
	}
}
