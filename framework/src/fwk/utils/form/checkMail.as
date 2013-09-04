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

package fwk.utils.form{
	/**
	 * @author rcousin
	 */
	public function checkMail(str:String):Boolean{
		var regExpPattern : RegExp = /^[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,4}$/;
	
		if( str.match(regExpPattern) == null ){
			return false;
		} else {
			return true;
		}
	}
}
