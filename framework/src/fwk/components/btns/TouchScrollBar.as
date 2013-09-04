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

package fwk.components.btns {
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import fwk.components.events.TouchScrollEvent;
	import fwk.debug.DebugPanel;



	/**
	 * @author renaud.cousin
	 */
	public class TouchScrollBar extends Sprite {
		private static const DISAPPEAR_SCROLL_DELAY:Number = .5;
		
		// ON STAGE
		public var scrollerMc:Sprite;
		public var pisteMc:Sprite;
		// END ON STAGE
		
		private var isScrolling:Boolean = false;
		
		private var _scrollLength:Number;
		private var _needToActive:Boolean = true;
		
		private var _offsetTop:int = 0;
		private var _offsetBottom:int = 0;
		
		public function TouchScrollBar() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		private function onAddedToStage(event:Event):void {
			DebugPanel.trace("[TOUCH_SCROLL_BAR] => onAddedToStage();", "#CCFF00");
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			alpha = 0;
			scrollerMc.y = (scrollerMc.height / 2) + _offsetTop;
			
			_scrollLength = pisteMc.height - (scrollerMc.height / scrollerMc.scaleX);
		}

		private function onScrollerDown(event:Event):void {
			appear();
			
			event.stopImmediatePropagation();
			isScrolling = true;
			scrollerMc.startDrag(true, new Rectangle(0, (scrollerMc.height / 2) + _offsetTop, 0, _scrollLength));
			
			TweenLite.killTweensOf(scrollerMc);
			TweenLite.to(scrollerMc, .4, {scaleX:1.2, scaleY:1.2, ease:Expo.easeOut});
			
			dispatchEvent(new TouchScrollEvent(TouchScrollEvent.BTN_START_DRAGGING));
		}

		private function onStageMouseUp(event:MouseEvent):void {
			if(isScrolling){
				event.stopImmediatePropagation();
				isScrolling = false;
				scrollerMc.stopDrag();
				
				TweenLite.killTweensOf(scrollerMc);
				TweenLite.to(scrollerMc, .4, {scaleX:1, scaleY:1, ease:Expo.easeIn});
				
				dispatchEvent(new TouchScrollEvent(TouchScrollEvent.BTN_STOP_DRAGGING));
				
				disappear();
			}
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------

		public function active():void {
			DebugPanel.trace("[TOUCH_SCROLL_BAR] => active();", "#CCFF00");
			visible = true;
			scrollerMc.mouseChildren = false;
			
			if(_needToActive){
				scrollerMc.addEventListener(MouseEvent.MOUSE_DOWN, onScrollerDown);
				stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			}
			
			appear();
			disappear();
		}
		
		public function desactive():void{
			visible = false;
			
			if(_needToActive){
				scrollerMc.removeEventListener(MouseEvent.MOUSE_DOWN, onScrollerDown);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			}
		}

		public function reinit(smoothly:Boolean = false):void {
			TweenLite.killTweensOf(scrollerMc);
			scrollerMc.scaleX = scrollerMc.scaleY = 1;
			
			if(smoothly){
				TweenLite.to(scrollerMc, .4, {y:(scrollerMc.height / 2) + _offsetTop, ease:Expo.easeOut});
			} else {
				scrollerMc.y = (scrollerMc.height / 2) + _offsetTop;
			}
		}

		public function goto(percent:Number, smoothly:Boolean = false):void {
			TweenLite.killTweensOf(scrollerMc);
			scrollerMc.scaleX = scrollerMc.scaleY = 1;
			
			var dest:Number = (percent * _scrollLength) + ((scrollerMc.height / scrollerMc.scaleX) / 2) + _offsetTop;
			
			if(smoothly){
				TweenLite.to(scrollerMc, .4, {y:dest, ease:Expo.easeOut});
			} else {
				scrollerMc.y = dest;
			}
		}
		
		public function resize(h:int):void{
			pisteMc.y = _offsetTop;
			pisteMc.height = h - _offsetTop - _offsetBottom;
			_scrollLength = pisteMc.height - (scrollerMc.height / scrollerMc.scaleX);
		}
		
		public function appear():void{
			DebugPanel.trace("[TOUCH_SCROLL_BAR] => appear();", "#CCFF00");
			alpha = 1;
			TweenLite.killTweensOf(this);
			TweenLite.killDelayedCallsTo(this);
		}
		
		public function disappear():void{
			DebugPanel.trace("[TOUCH_SCROLL_BAR] => disappear();", "#CCFF00");
			TweenLite.killTweensOf(this);
			TweenLite.to(this, DISAPPEAR_SCROLL_DELAY, {alpha:0, delay:.5, ease:Expo.easeIn});
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------

		public function get scrollLength():Number {
			return _scrollLength;
		}

		public function get percent():Number {
			return (scrollerMc.y - ((scrollerMc.height / scrollerMc.scaleX) / 2) - _offsetTop) / _scrollLength;
		}

		public function set percent(value:Number):void {
			scrollerMc.y = (value * _scrollLength) + ((scrollerMc.height / scrollerMc.scaleX) / 2) + _offsetTop;
		}

		public function set needToActive(value:Boolean):void {
			_needToActive = value;
		}

		public function set offsetTop(value:int):void {
			_offsetTop = value;
		}

		public function set offsetBottom(value:int):void {
			_offsetBottom = value;
		}
	}
}
