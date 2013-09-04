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

package fwk.components{
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * @author renaudcousin
	 */
	public class RoundRect extends Sprite{
		private var _width:Number;
		private var _height:Number;
		
		private var color:uint;
		private var radius:int;
		private var thickness:int;
		private var strokeOnly:Boolean;
		
		private var topLeft:Shape;
		private var topRight:Shape;
		private var bottomLeft:Shape;
		private var bottomRight:Shape;
		private var top:Shape;
		private var center:Shape;
		private var bottom:Shape;
		private var left:Shape;
		private var right:Shape;
		
		public function RoundRect(color:uint, w:Number, h:Number, radius:int, stroke:Boolean = false, thickness:int = 1){
			this.color = color;
			this.radius = radius;
			this.thickness = thickness;
			strokeOnly = stroke;
			_width = w;
			_height = h;
			
			init();
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		private function init():void{
			if(strokeOnly)
				drawStroke();
			else
				drawShape();
		}
		
		private function drawShape():void{
			top = new Shape();
			top.graphics.beginFill(color);
			top.graphics.drawRect(0, 0, _width - 2 * radius, radius);
			top.graphics.endFill();
			top.x = radius ;
			addChild(top);
			
			bottom = new Shape();
			bottom.graphics.beginFill(color);
			bottom.graphics.drawRect(0, - radius, _width - 2 * radius, radius);
			bottom.graphics.endFill();
			bottom.x = radius ;
			bottom.y = _height;
			addChild(bottom);
			
			center = new Shape();
			center.graphics.beginFill(color);
			center.graphics.drawRect(0, 0, _width, _height - 2 * radius);
			center.graphics.endFill();
			center.y = radius ;
			addChild(center);
			
			topLeft = new Shape();
			topLeft.graphics.beginFill(color);
			topLeft.graphics.moveTo(0, radius);
			topLeft.graphics.curveTo(0, 0, radius, 0);
			topLeft.graphics.lineTo(radius, radius);
			topLeft.graphics.lineTo(0, radius);
			topLeft.graphics.endFill();
			addChild(topLeft);
			
			topRight = new Shape();
			topRight.graphics.beginFill(color);
			topRight.graphics.moveTo(0, 0);
			topRight.graphics.curveTo(radius, 0, radius, radius);
			topRight.graphics.lineTo(0, radius);
			topRight.graphics.lineTo(0, 0);
			topRight.graphics.endFill();
			topRight.x = _width - radius;
			addChild(topRight);
			
			bottomLeft = new Shape();
			bottomLeft.graphics.beginFill(color);
			bottomLeft.graphics.moveTo(0, -radius);
			bottomLeft.graphics.curveTo(0, 0, radius, 0);
			bottomLeft.graphics.lineTo(radius, -radius);
			bottomLeft.graphics.lineTo(0, -radius);
			bottomLeft.graphics.endFill();
			bottomLeft.y = _height;
			addChild(bottomLeft);
			
			bottomRight = new Shape();
			bottomRight.graphics.beginFill(color);
			bottomRight.graphics.moveTo(-radius, 0);
			bottomRight.graphics.curveTo(0, 0, 0, -radius);
			bottomRight.graphics.lineTo(-radius, -radius);
			bottomRight.graphics.lineTo(-radius, 0);
			bottomRight.graphics.endFill();
			bottomRight.x = _width;
			bottomRight.y = _height;
			addChild(bottomRight);
		}
		
		private function drawStroke():void{
			top = new Shape();
			top.graphics.lineStyle(thickness, color, 1, true, "horizontal");
			top.graphics.moveTo(0, 0);
			top.graphics.lineTo(_width - 2 * radius, 0);
			top.x = radius ;
			addChild(top);
			
			bottom = new Shape();
			bottom.graphics.lineStyle(thickness, color, 1, true, "horizontal");
			bottom.graphics.moveTo(0, 0);
			bottom.graphics.lineTo(_width - 2 * radius, 0);
			bottom.x = radius ;
			bottom.y = _height;
			addChild(bottom);
			
			left = new Shape();
			left.graphics.beginFill(color);
			left.graphics.drawRect(-thickness * .5, 0, thickness, _height - 2 * radius);
			left.graphics.endFill();
			left.y = radius ;
			addChild(left);
			
			right = new Shape();
			right.graphics.beginFill(color);
			right.graphics.drawRect(-thickness * .5, 0, thickness, _height - 2 * radius);
			right.graphics.endFill();
			right.x = _width;
			right.y = radius ;
			addChild(right);
			
			topLeft = new Shape();
			topLeft.graphics.lineStyle(thickness, color, 1, true, "none");
			topLeft.graphics.moveTo(0, radius);
			topLeft.graphics.curveTo(0, 0, radius, 0);
			addChild(topLeft);
			
			topRight = new Shape();
			topRight.graphics.lineStyle(thickness, color, 1, true, "none");
			topRight.graphics.moveTo(0, 0);
			topRight.graphics.curveTo(radius, 0, radius, radius);
			topRight.x = _width - radius;
			addChild(topRight);
			
			bottomLeft = new Shape();
			bottomLeft.graphics.lineStyle(thickness, color, 1, true, "none");
			bottomLeft.graphics.moveTo(0, -radius);
			bottomLeft.graphics.curveTo(0, 0, radius, 0);
			bottomLeft.y = _height;
			addChild(bottomLeft);
			
			bottomRight = new Shape();
			bottomRight.graphics.lineStyle(thickness, color, 1, true, "none");
			bottomRight.graphics.moveTo(-radius, 0);
			bottomRight.graphics.curveTo(0, 0, 0, -radius);
			bottomRight.x = _width;
			bottomRight.y = _height;
			addChild(bottomRight);
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		
		//----------------------------------------------------------------------
		// G E T T E R  /  S E T T E R
		//----------------------------------------------------------------------
		
		override public function set width(value:Number):void{
			_width = value;
			
			top.width = _width - 2 * radius;
			bottom.width = _width - 2 * radius;
			
			topRight.x = _width - radius;
			bottomRight.x = _width;
			
			if(strokeOnly){
				right.x = _width;
			} else {
				center.width = _width;
			}
		}
		
		override public function get width():Number{
			return _width;
		}
		
		override public function set height(value:Number):void{
			_height = value;
			
			bottom.y = _height;
			
			bottomLeft.y = _height;
			bottomRight.y = _height;
			
			if(strokeOnly){
				left.height = right.height = _height - 2 * radius;
			} else {
				center.height = _height - 2 * radius;
			}
		}
		
		override public function get height():Number{
			return _height;
		}
	}
}
