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

package fwk.utils.text{
	import flash.display.StageQuality;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;

	/**
	 * @author renaud.cousin
	 */
	public function textAsBitmap(mc:MovieClip, smooth:Boolean = true, add:Boolean = true, remove:Boolean = true, offsetSize:int = 0):Bitmap {
		mc.visible = true;
		var bmd:BitmapData = new BitmapData(mc.width + 2 * offsetSize, mc.height + 2 * offsetSize, true, 0x00FFFFFF);
		var p:Point = mc.getRect(mc).topLeft;
		bmd.draw(mc, new Matrix(1, 0, 0, 1, -p.x + offsetSize, -p.y + offsetSize));
		//
		var textBitmap:Bitmap = new Bitmap(bmd);
		textBitmap.smoothing = smooth;
		textBitmap.x = mc.x - offsetSize;
		textBitmap.y = mc.y - offsetSize;
		
		if(mc.getChildAt(0) is TextField){
			textBitmap.x  += (mc.tTexte as TextField).x;
			textBitmap.y  += (mc.tTexte as TextField).y;
		}
		
		if(add){
			if(mc.parent != null){
				mc.parent.addChild(textBitmap);
			} else {
				throw new Error("textAsBitmap : can't add bitmap because [mc] isn't added to stage");
			}
		}
		if(remove)
			mc.parent.removeChild(mc);
		else
			mc.visible = false;
		
		return textBitmap;
	}
}
