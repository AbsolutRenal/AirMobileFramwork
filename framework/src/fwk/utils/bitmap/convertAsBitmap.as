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

package fwk.utils.bitmap {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * @author renaud.cousin
	 */
	public function convertAsBitmap(obj:DisplayObject, smooth:Boolean = false, transparent:Boolean = true, color:uint = 0x00000000):Bitmap {
		var bmd:BitmapData = new BitmapData(obj.width, obj.height, transparent, color);
		var p:Point = obj.getRect(obj).topLeft;
		bmd.draw(obj, new Matrix(1, 0, 0, 1, -p.x, -p.y));
		var bmp:Bitmap = new Bitmap(bmd);
		bmp.x = obj.x + p.x;
		bmp.y = obj.y + p.y;
		bmp.cacheAsBitmap = true;
		bmp.cacheAsBitmapMatrix = bmp.transform.concatenatedMatrix;
		return bmp;
	}
}
