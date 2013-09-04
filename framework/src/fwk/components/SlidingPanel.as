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

package fwk.components {
	import com.greensock.easing.Cubic;
	import flash.geom.Rectangle;
	import com.greensock.TweenNano;
	import com.greensock.easing.Strong;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;

	/**
	 * @author renaud.cousin
	 */
	public class SlidingPanel extends Sprite {
		// ON STAGE
		public var slidingBackground:Sprite;
		public var bottomBtn:MovieClip;
		// END ON STAGE
		
		private var _isOpenned:Boolean = false;
		private var buttonDown:Boolean = false;
		private var _contentObj:DisplayObject;
		private var closedY:int;
		private var _buttonVisibility:Boolean;
		
		private var _openByDraging:Boolean = true;
		private var isDragging:Boolean;
		private var dragingOffset:int = NaN;
		private var previousPos:int = NaN;

		public function SlidingPanel(contentObj:DisplayObject) {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_contentObj = contentObj;
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if(_contentObj != null)
				addChild(_contentObj);
			
			defineClosedY();
			y = closedY;
		}

		private function onStageDown(event:MouseEvent):void {
			if(event.stageY < bottomBtn.height && !_isOpenned){
				event.stopImmediatePropagation();
				
				if(!_buttonVisibility){
					TweenNano.killTweensOf(this);
					TweenNano.to(this, .2, {y:-slidingBackground.height + bottomBtn.height, ease:Strong.easeOut});
				}
				
				onDown(null);
			} else if(_isOpenned){
				event.stopImmediatePropagation();
			}
		}

		private function onStageUp(event:MouseEvent):void {
			buttonDown = false;
			bottomBtn.background.gotoAndStop(1);
			
			if(isDragging){
				stopDrag();
				isDragging = false;
				removeEventListener(Event.ENTER_FRAME, checkDraggingOffset);
				// XXX
				
				if(dragingOffset > 0){
					_isOpenned = true;
					TweenNano.to(this, .3, {y:0, ease:Cubic.easeInOut});
				} else {
					_isOpenned = false;
					TweenNano.to(this, .3, {y:closedY, ease:Cubic.easeInOut});
				}
				
				previousPos = NaN;
				dragingOffset = NaN;
				
				return;
			}
			
			if(_isOpenned){
				if(event != null)
					event.stopPropagation();
				
//				TweenNano.killTweensOf(this);
//				TweenNano.to(this, .4, {y:0, ease:Strong.easeOut});
			} else {
				TweenNano.killTweensOf(this);
				TweenNano.to(this, .3, {y:closedY, ease:Strong.easeIn});
			}
		}

		private function onDown(event:MouseEvent):void {
			buttonDown = true;
			bottomBtn.background.gotoAndStop(2);
			
			if(_openByDraging){
				isDragging = true;
				previousPos = y;
				
				startDrag(false, new Rectangle(x, -slidingBackground.height + bottomBtn.height, 0, slidingBackground.height));
				addEventListener(Event.ENTER_FRAME, checkDraggingOffset);
			}
		}

		private function checkDraggingOffset(event:Event):void {
			dragingOffset = y - previousPos;
			previousPos = y;
		}
		
		private function onSwipe(event:TransformGestureEvent):void{
			if(buttonDown && event.offsetY == 1){
				open();
			} else if(buttonDown && event.offsetY == -1){
//				onStageUp(null);
				close();
			} else if(!_isOpenned){
//				TweenNano.killTweensOf(this);
//				TweenNano.to(this, .2, {y:-debugBackground.height, ease:Strong.easeOut});
			}
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		private function open():void{
			if(!_isOpenned){
				onStageUp(null);
				
				_isOpenned = true;
				TweenNano.killTweensOf(this);
				TweenNano.to(this, .4, {y:0, ease:Strong.easeOut});
			}
		}

		private function defineClosedY():void {
			if(_buttonVisibility){
				closedY = -slidingBackground.height + bottomBtn.height;
			} else {
				closedY = -slidingBackground.height;
			}
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		public function close():void{
			if(_isOpenned){
				onStageUp(null);
				
				_isOpenned = false;
				TweenNano.killTweensOf(this);
				TweenNano.to(this, .4, {y:closedY, ease:Strong.easeIn});
			}
		}
		
		public function active():void{
			bottomBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageUp);
			
			if(!_openByDraging)
				stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
		}
		
		public function desactive():void{
			bottomBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageUp);
			
			if(!_openByDraging)
				stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
		}
		
		public function resizePanel(w:int, h:int):void{
			slidingBackground.width = w;
			slidingBackground.height = h;
			
			defineClosedY();
			
			if(isOpenned)
				y = 0;
			else
				y = closedY;
			
			bottomBtn.y = h;
			bottomBtn.background.width = w;
			bottomBtn.circles.x = w / 2;
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------

		public function get isOpenned():Boolean {
			return _isOpenned;
		}
		
		public function set buttonAlwaysVisible(visibility:Boolean):void{
			_buttonVisibility = visibility;
		}
		
		public function set openByDraging(value:Boolean):void{
			_openByDraging = value;
		}
	}
}
