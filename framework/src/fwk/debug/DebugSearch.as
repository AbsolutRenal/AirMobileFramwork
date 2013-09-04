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

package fwk.debug {
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import fwk.debug.events.DebugSearchEvent;



	/**
	 * @author renaud.cousin
	 */
	public class DebugSearch extends Sprite {

		private static const OFFSET_X:int = 10;
		// ON STAGE
		public var container:MovieClip ;
		// END ON STAGE
		
		private var background:Sprite;
		private var searchBtn:Sprite;
		private var clearFieldBtn:Sprite;
		private var searchFieldBackground:Sprite;
		private var searchField:TextField;

		public function DebugSearch() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			container.alpha = 0;
			container.visible = false;
			
			background = container.background as Sprite;
			searchBtn = container.searchBtn as Sprite;
			clearFieldBtn = container.clearFieldBtn as Sprite;
			searchFieldBackground = container.searchFieldBackground as Sprite;
			searchField = container.searchField as TextField;
			
			clearFieldBtn.visible = false;
		}

		private function onClickSearch(event:MouseEvent):void {
			onBtnOut(event);
			dispatchEvent(new DebugSearchEvent(DebugSearchEvent.SEARCH, searchField.text));
		}

		private function onBtnDown(event:MouseEvent):void {
			onBtnOver(event);
		}

		private function onBtnOut(event:MouseEvent):void {
			(event.target as MovieClip).alpha = 1;
		}

		private function onBtnOver(event:MouseEvent):void {
			(event.target as MovieClip).alpha = .5;
		}

		private function onFieldChange(event:Event):void {
			if(searchField.length > 0){
				clearFieldBtn.visible = true;
			} else {
				clearFieldBtn.visible = false;
			}
		}

		private function onClickClear(event:MouseEvent):void {
			onBtnOut(event);
			searchField.text = "";
			clearFieldBtn.visible = false;
			
			dispatchEvent(new DebugSearchEvent(DebugSearchEvent.SEARCH_CANCELLED));
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		private function active():void{
			searchField.addEventListener(Event.CHANGE, onFieldChange);
			
			searchBtn.mouseChildren = false;
			searchBtn.addEventListener(MouseEvent.MOUSE_DOWN, onBtnDown);
			searchBtn.addEventListener(MouseEvent.ROLL_OUT, onBtnOut);
			searchBtn.addEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			searchBtn.addEventListener(MouseEvent.CLICK, onClickSearch);
			
			clearFieldBtn.mouseChildren = false;
			clearFieldBtn.addEventListener(MouseEvent.MOUSE_DOWN, onBtnDown);
			clearFieldBtn.addEventListener(MouseEvent.ROLL_OUT, onBtnOut);
			clearFieldBtn.addEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			clearFieldBtn.addEventListener(MouseEvent.CLICK, onClickClear);
		}
		
		private function desactive():void{
			searchField.removeEventListener(Event.CHANGE, onFieldChange);
			
			searchBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onBtnDown);
			searchBtn.removeEventListener(MouseEvent.ROLL_OUT, onBtnOut);
			searchBtn.removeEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			searchBtn.removeEventListener(MouseEvent.CLICK, onClickSearch);
			
			clearFieldBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onBtnDown);
			clearFieldBtn.removeEventListener(MouseEvent.ROLL_OUT, onBtnOut);
			clearFieldBtn.removeEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			clearFieldBtn.removeEventListener(MouseEvent.CLICK, onClickClear);
		}
		
		private function hide():void{
			container.alpha = 0;
			container.visible = false;
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		public function open():void{
			container.visible = true;
			TweenLite.killTweensOf(container);
			TweenLite.to(container, .4, {alpha:1, y:container.height, ease:Strong.easeOut, onComplete:active});
		}
		
		public function close():void{
			desactive();
			
			TweenLite.killTweensOf(container);
			TweenLite.to(container, .3, {y:0, ease:Strong.easeIn, onComplete:hide});
		}
		
		public function resizePanel():void{
			y = 0;
			
			background.width = stage.stageWidth;
			searchBtn.x = stage.stageWidth - OFFSET_X;
			searchFieldBackground.width = stage.stageWidth - (3 * OFFSET_X) - searchBtn.width;
			searchField.width = searchFieldBackground.width - (searchField.x - searchFieldBackground.x) - clearFieldBtn.width - 3;
			
			clearFieldBtn.x = searchFieldBackground.x + searchFieldBackground.width - 3;
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
	}
}
