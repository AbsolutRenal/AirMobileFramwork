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
	 * @return Vector.Number => [0] : speed, [1] : orientation (in degrees)
	 * @param vect : moves vector
	 */
	public function convertVectorToAngleSpeed(moves:Point):Vector.<Number> {		
		var vect:Vector.<Number> = new Vector.<Number>();
		
		var speed:Number = Point.distance(new Point(), moves);
		vect[0] = speed;
		
		var orientationRad:Number = Math.atan2(moves.y, moves.x);
		if (orientationRad < 0) {
			orientationRad += Math.PI * 2;
		}
		var orientationDeg:Number = radToDeg(orientationRad);
		vect[1] = orientationDeg;
		
		return vect;
	}
}
