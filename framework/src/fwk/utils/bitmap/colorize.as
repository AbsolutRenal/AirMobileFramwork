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

package fwk.utils.bitmap{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	/**
	 * @author rcousin
	 */
	public function colorize(mc:DisplayObject, color:uint):void{
		var r:uint = (color >> 16) & 0xFF;
        var g:uint = (color >> 8) & 0xFF;
        var b:uint = color & 0xFF;

        var n:Number = 1/3;

        var matrix:Array = new Array();
        matrix = matrix.concat([n, n, n, 0, r]);
        matrix = matrix.concat([n, n, n, 0, g]);
        matrix = matrix.concat([n, n, n, 0, b]);
        matrix = matrix.concat([0, 0, 0, 1, 0]);
        
		var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
		mc.filters = [filter];
	}
}
