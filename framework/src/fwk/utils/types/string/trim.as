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
	public function trim(str:String):String{
		while(str.charAt(0) == " "){
			str = str.substring(1);
		}
		
		while(str.charAt(str.length -1) == " "){
			str = str.substr(0, -1);
		}
		
		return str;
	}
}
