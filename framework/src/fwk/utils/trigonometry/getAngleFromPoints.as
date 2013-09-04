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

package fwk.utils.trigonometry {
	import fwk.utils.types.angle.radToDeg;

	import flash.geom.Point;
	/**
	 * @author renaud.cousin
	 * @return angle:int (in degrees)
	 * @param vect : moves vector
	 */
	public function getAngleFromPoints(p1:Point, p2:Point):int {		
		return radToDeg(Math.atan2(p2.y - p1.y, p2.x - p1.x));
	}
}
