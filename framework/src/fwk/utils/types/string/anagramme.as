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
	public function anagramme(str:String):String{
		var randomStr:String = "";
		
		var strArr:Vector.<String> = new Vector.<String>();
		var nb:int = str.length;
		for (var i:int = 0; i < nb; i++) {
			strArr.push(str.charAt(i));
		}
		
		var idx:int;
		while(strArr.length > 0){
			idx = Math.floor(Math.random() * strArr.length);
			randomStr += strArr[idx];
			strArr.splice(idx, 1);
		}
		return randomStr;
	}
}
