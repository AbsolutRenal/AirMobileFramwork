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

package fwk.utils.types.string {
	/**
	 * @author renaud.cousin
	 */
	public function setNumberStringLengthTo(number:String, desiredLength:int, behind:Boolean = false):String {
		if(number.length < desiredLength){
			while(number.length < desiredLength){
				if(!behind)
					number = "0" + number;
				else
					number = number + "0";
			}
		} else if(number.length > desiredLength && behind){
			number = number.substr(0, 3);
		}
		return number;
	}
}
