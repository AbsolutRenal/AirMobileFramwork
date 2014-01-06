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

package fwk.utils.types.url{
	/**
	 * @author AbsolutRenal
	 */
	public function getCurrentUrl(removeEndSlash:Boolean = true):String{
		var url:String = ExternalInterface.call("eval", "window.location.href");
		if(removeEndSlash && currentUrl.charAt(url.length -1) == "/")
			url = url.substr(0, url.length -1);
		return url;
	}
}
