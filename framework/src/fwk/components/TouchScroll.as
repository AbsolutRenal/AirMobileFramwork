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

package fwk.components 
{
	import com.greensock.TweenNano;
	import com.greensock.easing.Expo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import fwk.components.btns.TouchScrollBar;
	import fwk.components.events.TouchScrollEvent;
	import fwk.debug.DebugPanel;



	public class TouchScroll extends MovieClip {
		private static const SCROLL_DECELERATION:int = 5;
		private static const SCROLL_LIST_DECELERATION:int = 3;

		// ON STAGE
		public var touchScrollBar:TouchScrollBar;
		// END ON STAGE
		
		private var zone:Sprite;
		private var container:Sprite;
		private var containerMask:Sprite;
		
		private var contentWidth:int;
		private var contentHeight:int;
		private var touchScrollBarOffsetX:int;
		private var touchScrollBarOffsetTop:int;
		private var touchScrollBarOffsetBottom:int;
		
		private var removeEnterFrame:Boolean = true;
		private var isScrolling:Boolean = false;
		
		private var startPosition:int;
		private var listDesty:Number;
		private var startListPosition:Number;
		
		private var previousPosition:int = 0;
		private var currentPosition:int = 0;
		private var vitesseScroll:Number = NaN;
		
		private var _checkContainerHeight:Function = null;
		
		
		public function TouchScroll(content:Sprite, w:int, h:int, offset:int = -30, offsetTop:int = 20, offsetBottom:int = 20) {
			container = content;
			contentWidth = w;
			contentHeight = h;
			touchScrollBarOffsetX = offset;
			touchScrollBarOffsetTop = offsetTop;
			touchScrollBarOffsetBottom = offsetBottom;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}


		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			init();
		}

		private function onRemovedFromStage(event:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			desactive();
			desactiveContainer();
			kill();
		}

		private function onBtnStartDragging(event:TouchScrollEvent):void {
			if(isScrolling){
				if(container.hasEventListener(Event.ENTER_FRAME))
					container.removeEventListener(Event.ENTER_FRAME, scrollContainerFromList);
				if(hasEventListener(MouseEvent.MOUSE_MOVE))
					removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			
			removeEnterFrame = false;
			addEventListener(Event.ENTER_FRAME, scrollContainerFromBtn);
		}

		private function onBtnStopDragging(event:TouchScrollEvent):void {
			removeEnterFrame = true;
		}

		private function scrollContainerFromBtn(event:Event):void {
			var percent:Number = touchScrollBar.percent;
			
			var desty:Number = - percent * (getContainerHeight() - contentHeight);
			
			container.y -= (container.y - desty) / SCROLL_DECELERATION;
			
			if(Math.abs(Math.floor(container.y - desty)) < 1 && removeEnterFrame){
				container.y = desty;
				removeEventListener(Event.ENTER_FRAME, scrollContainerFromBtn);
				
				DebugPanel.trace("[TOUCH_SCROLL] => removeEnterFrame ", "#3333CC");
			}
		}

		private function onStageMouseDown(event:MouseEvent):void {
			touchScrollBar.appear();
			startPosition = event.stageY;
			startListPosition = container.y;
			currentPosition = container.y;
			vitesseScroll = NaN;
			isScrolling = false;
			
			if(container.hasEventListener(Event.ENTER_FRAME))
				container.removeEventListener(Event.ENTER_FRAME, scrollContainerFromList);
			
			DebugPanel.trace("STAGE DOWN => stageY: " + event.stageY, "#33BB33");
			
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		private function onMouseMove(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			isScrolling = true;
			removeEnterFrame = false;
			container.addEventListener(Event.ENTER_FRAME, scrollContainerFromList);
		}

		private function scrollContainerFromList(event:Event):void {
			if(!removeEnterFrame){
				previousPosition = currentPosition;
				currentPosition = container.y;
				listDesty = calculateDestination();
				
				container.y -= (container.y - listDesty) / SCROLL_LIST_DECELERATION;
			} else if(isNaN(vitesseScroll)){
				if(!isNaN(previousPosition)){
					vitesseScroll = currentPosition - previousPosition;
					container.y += vitesseScroll;
				}
			} else {
				vitesseScroll *= .9;
				container.y = ((container.y + vitesseScroll) > 0)? 0 : ((container.y + vitesseScroll) < (containerMask.height - getContainerHeight()))? (containerMask.height - getContainerHeight()) : (container.y + vitesseScroll) ;
				if(container.y == 0 || container.y == (containerMask.height - getContainerHeight()))
					vitesseScroll = 0;
			}
			
			touchScrollBar.percent = container.y / (containerMask.height - getContainerHeight());
			
			
			if(Math.abs(vitesseScroll) < 1 && removeEnterFrame){
				vitesseScroll = NaN;
				isScrolling = false;
				removeEnterFrame = false;
				previousPosition = currentPosition = NaN;
//				container.y = listDesty;
				container.removeEventListener(Event.ENTER_FRAME, scrollContainerFromList);
				
				DebugPanel.trace("[GESTURE_SCROLL] => removeEnterFrame ", "#3333CC");
			}
		}
		
		private function calculateDestination():Number{
			var dest:Number = Math.max(Math.min((startListPosition + (stage.mouseY - startPosition)), 0), containerMask.height - getContainerHeight());
			return dest;
		}

		private function onStageMouseUp(event:MouseEvent):void {
			DebugPanel.trace("STAGE UP => phase: " + event.eventPhase, "#33BB33");
			
			removeEnterFrame = true;
			if(hasEventListener(MouseEvent.MOUSE_MOVE))
				removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			touchScrollBar.disappear();
		}

		private function onClickItem(event:MouseEvent):void {
			if(!isScrolling){
				DebugPanel.trace("CLICK ITEM: event.target: " + event.target, "#33BB33");
				
				container.dispatchEvent(new TouchScrollEvent(TouchScrollEvent.LIST_ITEM_SELECTED, event.target));
			}
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		private function init():void{
			x = container.x;
			y = container.y;
			
			zone = new Sprite();
			zone.graphics.beginFill(0xFF0000);
			zone.graphics.drawRect(0, 0, contentWidth, getContainerHeight());
			zone.graphics.endFill();
			zone.alpha = 0;
			addChild(zone);
			
			container.x = 0;
			container.y = 0;
			addChild(container);
			
			containerMask = new Sprite();
			containerMask.graphics.beginFill(0x00FF00);
			containerMask.graphics.drawRect(0, 0, contentWidth, contentHeight);
			containerMask.graphics.endFill();
			addChild(containerMask);
			container.mask = containerMask;
			
//			touchScrollBar.needToActive = false;
			touchScrollBar.offsetTop = touchScrollBarOffsetTop;
			touchScrollBar.offsetBottom = touchScrollBarOffsetBottom;
			addChild(touchScrollBar);
			
			resizeTouchScrollBar();
			checkForScroller();
			
			dispatchEvent(new TouchScrollEvent(TouchScrollEvent.IS_READY));
		}

		private function resizeTouchScrollBar():void {
			touchScrollBar.x = contentWidth + touchScrollBarOffsetX;
			touchScrollBar.resize(contentHeight);
		}

		private function kill():void {
		}
		
		private function getContainerHeight():Number{
			var h:Number;
			if(_checkContainerHeight != null){
				h = _checkContainerHeight();
			} else {
				h = container.height;
			}
			
			return h;
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		public function checkForScroller():void{
			reinit();
			if(getContainerHeight() > contentHeight){
				active();
			} else {
				desactive();
			}
			activeContainer();
			
			DebugPanel.trace("[TOUCH_SCROLL] => hasScroll: " + touchScrollBar.visible, "#3333CC");
		}
		
		public function update(dest:Number = NaN):void{
			if(getContainerHeight() > contentHeight){
				if(!isNaN(dest)){
					goto(Math.min(Math.max(dest, containerMask.height - getContainerHeight()), 0), true);
				} else {
					if(container.y < (containerMask.height - getContainerHeight())){
						goto((containerMask.height - getContainerHeight()), true);
					} else {
						touchScrollBar.goto(container.y / (containerMask.height - getContainerHeight()), true);
					}
				}
				active();
			} else {
				reinit(true);
				desactive();
			}
			activeContainer();
		}

		private function reinit(smoothly:Boolean = false):void {
			if(smoothly){
				TweenNano.killTweensOf(container);
				TweenNano.to(container, .4, {y:0, ease:Expo.easeOut});
			} else {
				container.y = 0;
			}
			touchScrollBar.reinit(smoothly);
		}
		
		private function goto(dest:Number, smoothly:Boolean = false):void{
			if(smoothly){
				TweenNano.killTweensOf(container);
				TweenNano.to(container, .4, {y:dest, ease:Expo.easeOut});
			} else {
				container.y = dest;
			}
			touchScrollBar.goto(dest / (containerMask.height - getContainerHeight()), smoothly);
		}
		
		public function active():void{
			touchScrollBar.active();
			touchScrollBar.addEventListener(TouchScrollEvent.BTN_START_DRAGGING, onBtnStartDragging);
			touchScrollBar.addEventListener(TouchScrollEvent.BTN_STOP_DRAGGING, onBtnStopDragging);
			
			container.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		public function desactive():void{
			touchScrollBar.desactive();
			touchScrollBar.removeEventListener(TouchScrollEvent.BTN_START_DRAGGING, onBtnStartDragging);
			touchScrollBar.removeEventListener(TouchScrollEvent.BTN_STOP_DRAGGING, onBtnStopDragging);
			
			container.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		private function activeContainer():void{
			if(!container.hasEventListener(MouseEvent.CLICK))
				container.addEventListener(MouseEvent.CLICK, onClickItem);
		}
		
		private function desactiveContainer():void{
			if(container.hasEventListener(MouseEvent.CLICK))
				container.removeEventListener(MouseEvent.CLICK, onClickItem);
		}
		
		public function resize(w:int, h:int):void{
			if(isScrolling){
				if(container.hasEventListener(Event.ENTER_FRAME))
					container.removeEventListener(Event.ENTER_FRAME, scrollContainerFromList);
				if(hasEventListener(MouseEvent.MOUSE_MOVE))
					removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			} else if(removeEnterFrame){
				if(hasEventListener(Event.ENTER_FRAME))
					removeEventListener(Event.ENTER_FRAME, scrollContainerFromBtn);
			}
			
			contentWidth = w;
			contentHeight = h;
			
			zone.width = contentWidth;
			zone.height = getContainerHeight();
			
			containerMask.width = contentWidth;
			containerMask.height = contentHeight;
			
			resizeTouchScrollBar();
			checkForScroller();
		}

		public function set checkContainerHeight(value:Function):void {
			_checkContainerHeight = value;
		}
		
		public function openItem(id:int):void{
			container.getChildAt(id).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
	}
}
