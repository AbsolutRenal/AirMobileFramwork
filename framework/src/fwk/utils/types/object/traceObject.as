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

package fwk.utils.types.object{
	/**
	 * @author AbsolutRenal
	 */
	public function traceObject(obj:Object, level:int = 0):void{
		var tab:String = "";
		for(var i:int = 0; i < level; i++)
			tab += "	";
		
		for(var prop:* in obj){
			trace(tab + "{" + level + "}> prop:", prop, "=>", obj[prop]);
			if(prop is Object){
				traceObject(obj[prop], level +1);
			}
		}
	}
}
