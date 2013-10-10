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

package fwk.utils.trigonometry{
	import flash.geom.Point;
	/**
	 * @author rcousin
	 */
	public function calculateCoefFromPoints(p1:Point, p2:Point):Number{
		var coef:Number;
		if(p1.x != p2.x && p1.y != p2.y)
			coef = (p2.y - p1.y)/(p2.x - p1.x);
		else if(p1.x == p2.x)
			coef = 999999999999999;
		else
			coef = 0;
			
		return coef;
	}
}
