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

package fwk.utils.types.time {
	/**
	 * @author renaud.cousin
	 */
	public function convertTimecodeToTime(timecode:String):Number{
		var secondes:Number;
		var arr:Array = timecode.split(":");
		if(arr.length == 2)
			secondes = parseInt(arr[0]) * 60 + parseInt(arr[1]);
		else if(arr.length == 3)
			secondes = parseInt(arr[0]) * 3600 + parseInt(arr[1]) * 60 + parseInt(arr[2]);
		
		return secondes;
	}
}
