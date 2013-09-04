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

package fwk.utils.types.string{
	/**
	 * @author rcousin
	 */
	public function cropString(str:String, maxLength:int, addCut:Boolean = true, cut:String = "..."):String{
		if(str.length <= maxLength)
			return str;
		
		var max:int = (addCut)? maxLength -cut.length : maxLength ;
		var croppedStr:String = str.substr(0, max);
		var idx:int = croppedStr.lastIndexOf(" ");
		
		if(idx != -1 && idx > (max  / 2)){
			croppedStr = str.substring(0, idx);
		} else {
			croppedStr = str.substring(0, max);
		}
		
		if(addCut)
			croppedStr += cut;
		
		return croppedStr;
	}
}
