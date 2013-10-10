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
	public function calculateCirclesIntersectionsFromPointRadius(p0:Point, r0:Number, p1:Point, r1:Number):Vector.<Point>{
		var x0:Number = p0.x;
		var y0:Number = p0.y;
		var x1:Number = p1.x;
		var y1:Number = p1.y;
		
		var N:Number = (Math.pow(r1, 2) - Math.pow(r0, 2) - Math.pow(x1, 2) + Math.pow(x0, 2) - Math.pow(y1, 2) + Math.pow(y0, 2)) / (2 * (y0 - y1));
		var A:Number;
		var B:Number;
		var C:Number;
		var D:Number;
		var ix1:Number;
		var ix2:Number;
		var iy1:Number;
		var iy2:Number;
		
		if(y0 == y1){
			A = 1;
			B = -2 * y1;
			ix1 = ix2 = (Math.pow(r1, 2) - Math.pow(r0, 2) - Math.pow(x1, 2) + Math.pow(x0, 2)) / (2 * (x0 - x1));
			C = Math.pow(x1, 2) + Math.pow(ix1, 2) - (2 * x1 * ix1) + Math.pow(y1, 2) - Math.pow(r1, 2);
			D = Math.sqrt((Math.pow(B, 2) - 4 * A * C));
			
			if(D == 0){
				iy1 = iy2 = -B / (2 * A);
			} else if(D > 0){
				iy1 = (-B + D) / (2 * A);
				iy2 = (-B - D) / (2 * A);
			}
		} else {
			A = Math.pow((x0 - x1) / (y0 - y1), 2) + 1;
			B = 2 * y0 * ((x0 - x1) / (y0 - y1)) - 2 * N * ((x0 - x1) / (y0 - y1)) - (2 * x0);
			C = Math.pow(x0, 2) + Math.pow(y0, 2) + Math.pow(N, 2) - Math.pow(r0, 2) - (2 * y0 * N);
			D = Math.sqrt((Math.pow(B, 2) - 4 * A * C));
			
			ix1 = (-B + D) / (2 * A);
			ix2 = (-B - D) / (2 * A);
			iy1 = N - ix1 * ((x0 - x1) / (y0 - y1));
			iy2 = N - ix2 * ((x0 - x1) / (y0 - y1));
		}
		
//		var inter:Vector.<Point>;
//		if(p0.y >= p1.y && !(p1.y == p0.y && p1.x < p0.x))
//			inter = new <Point>[new Point(ix1, iy1), new Point(ix2, iy2)];
//		else
//			inter = new <Point>[new Point(ix2, iy2), new Point(ix1, iy1)];
//			
//		return inter;
		
		return new <Point>[new Point(ix1, iy1), new Point(ix2, iy2)];
	}
}
