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

package fwk.utils.types.number{
	/**
	 * @author rcousin
	 */
	public function map(value:Number, minRange:Number, maxRange:Number, destMinRange:Number, destMaxRange:Number):Number{
		return destMinRange + value * Math.abs(destMaxRange - destMinRange) / Math.abs(maxRange - minRange);
	}
}
