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
	
	/**
	 * @param perpendicularPoints : indicates whether the specified points comes from the line with coef or from perpendicular line from coef
	 */
	public function calculateAngleFromCoef(coef:Number, p1:Point, p2:Point, perpendicularPoints:Boolean = false):Number{
		var angleDeg:Number = radToDeg(Math.atan(coef));
		
		if(perpendicularPoints){
			if(coef < 0)
				angleDeg += 180;
			if(p1.x > p2.x)
				angleDeg = angleDeg - 180;
		} else {
			if(coef < 0 && p2.y > p1.y)
				angleDeg += 180;
			else if(coef > 0 && p1.y > p2.y)
				angleDeg -= 180;
				
		}
		
		return angleDeg;
	}
}
