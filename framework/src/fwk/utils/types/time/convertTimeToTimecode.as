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
	import fwk.utils.types.string.setNumberStringLengthTo;
	/**
	 * @author renaud.cousin
	 */
	public function convertTimeToTimecode(time:Number, useMilli:Boolean = false, useHours:Boolean = false):String {
		var hours:int = Math.floor(time / 3600);
		var minutes:int = Math.floor((time % 3600) / 60);
		var secondes:int = Math.floor(time % 60);
		var milliArr:Array = String(time % 60).split(".");

		var milliAsString:String = (milliArr.length == 2)? setNumberStringLengthTo(milliArr[1], 3, true) : "000" ;
		var timecode:String = setNumberStringLengthTo(String(minutes), 2) + ":" + setNumberStringLengthTo(String(secondes), 2);
		
		if(useMilli)
			timecode = timecode + "." + milliAsString;
		if(useHours)
			timecode = String(hours) + ":" + timecode;
		return timecode;
	}
}
