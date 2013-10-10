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
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * @author rcousin
	 */
	public function calculateCircleTangentePointFromPoint(center:Point, radius:Number, O:Point):Vector.<Point>{
		var p0:Point = new Point(O.x + (center.x - O.x) * .5, O.y + (center.y - O.y) * .5);
		var r0:Number = Point.distance(center, O) * .5;
		
		return calculateCirclesIntersectionsFromPointRadius(p0, r0, center, radius);
	}
}
