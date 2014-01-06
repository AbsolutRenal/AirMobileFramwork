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

package fwk.debug{
	import fwk.components.SlidingPanel;
	import fwk.debug.events.DebugSearchEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.ui.Keyboard;



	/**
	 * @author renaud.cousin
	 */

	 
	 public class DebugPanel extends Sprite {
		private static const MAX_TRACE:int = 100;

		private static var _instance:DebugPanel;
		
		// ON STAGE
		public var debugTxt:TextField;
		public var debugMenu:DebugMenu;
		public var debugSearch:DebugSearch;
		// END ON STAGE
		
		private var menuOpenned:Boolean = false;
		private var tracePaused:Boolean = false;
		
		private var slidingPanel:SlidingPanel;
		
		private var traceVect:Vector.<String> = new Vector.<String>();
		private var currentSearchPattern:String = "";
		private var offsetX:int;
		private var offsetY:int;
		private var iosMod:Boolean;

		public function DebugPanel(singleton:SingletonEnforcer) {
			if(singleton != null)
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			init();
		}

		private function onMenuKeyDown(event:KeyboardEvent):Boolean {
//			DebugPanel.trace("KEY_DOWN : DEBUG_PANEL : " + event.eventPhase, "#AA8800", true);
			var isStopped:Boolean = false;
			if(event.keyCode == Keyboard.MENU && slidingPanel.isOpenned && !menuOpenned){
				isStopped = true;
				event.stopImmediatePropagation();
				event.preventDefault();
				openMenu();
			} else if(event.keyCode == Keyboard.BACK){
				if(menuOpenned){
					isStopped = true;
					event.stopImmediatePropagation();
					event.preventDefault();
					closeMenu();
				} else if(slidingPanel.isOpenned){
					isStopped = true;
					event.stopImmediatePropagation();
					event.preventDefault();
					slidingPanel.close();
				}
			}
			return isStopped;
		}
		
		private function clearDebug(event:Event):void{
			traceVect = new Vector.<String>();
			debugTxt.text = "";
		}

		private function togglePause(event:Event):void {
			tracePaused = !tracePaused;
		}

		private function onSearch(event:DebugSearchEvent):void {
			if(!iosMod)
				closeMenu();
			
			debugTxt.text = "";
			currentSearchPattern = event.datas.toLowerCase();
			for(var i:int = 0; i < traceVect.length; i++){
				if(traceVect[i].toLowerCase().search(currentSearchPattern) != -1)
					debugTxt.htmlText += traceVect[i];
			}
			debugTxt.scrollV = debugTxt.maxScrollV;
		}

		private function onSearchCancelled(event:DebugSearchEvent):void {
			debugTxt.text = "";
			for(var i:int = 0; i < traceVect.length; i++){
				debugTxt.htmlText += traceVect[i];
			}
			debugTxt.scrollV = debugTxt.maxScrollV;
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		private function init():void{
			iosMod = (Capabilities.os.indexOf("iPhone OS") != -1 || Capabilities.os.indexOf("Mac OS") != -1 || Capabilities.os.indexOf("Windows") != -1);
			slidingPanel = new SlidingPanel(this);
			this.parent.addChildAt(slidingPanel, this.parent.getChildIndex(this));
			
			offsetX = debugTxt.x;
			offsetY = debugTxt.y;
			
			debugTxt.mouseEnabled = false;
			debugTxt.multiline = true;
			debugTxt.wordWrap = true;
			active();
			
			iosConfig();
		}

		private function iosConfig():void{
			if(iosMod){
				openMenu();
				debugTxt.height = stage.stageHeight - debugSearch.height - (offsetY * 2) - slidingPanel.bottomBtn.height;
				debugTxt.y = offsetY + debugSearch.height;
				
				debugMenu.width = Math.max(stage.stageWidth / 6, 100);
				debugMenu.scaleY = debugMenu.scaleX;
				debugMenu.x = stage.stageWidth - debugMenu.width;
				debugMenu.y = debugSearch.y + debugSearch.height + debugMenu.height;
			}
		}
		
		private function debugTrace(msg:String, color:String, forceTrace:Boolean):void{
			if(!tracePaused || forceTrace){
				msg = "<font color='" + color + "'>" + msg + "</font><br>";
				traceVect.push(msg);
				if(traceVect.length > MAX_TRACE)
					traceVect.shift();
				
				if(msg.toLowerCase().search(currentSearchPattern) != -1){
					debugTxt.htmlText += msg;
					debugTxt.scrollV = debugTxt.maxScrollV;
				}
			}
		}
		
		private function resizePanel():void{
			if(!iosMod)
				debugMenu.resizePanel();
			debugSearch.resizePanel();
			
			slidingPanel.resizePanel(stage.stageWidth, stage.stageHeight);
			
			debugTxt.width = stage.stageWidth - (offsetX * 2);
			debugTxt.height = stage.stageHeight - (offsetY * 2) - slidingPanel.bottomBtn.height;
			debugTxt.scrollV = debugTxt.maxScrollV;
			
			iosConfig();
		}
		
		private function active():void{
			slidingPanel.active();
			
			debugMenu.addEventListener(Event.CLEAR, clearDebug);
			debugMenu.addEventListener(Event.SELECT, togglePause);
			
			debugSearch.addEventListener(DebugSearchEvent.SEARCH, onSearch);
			debugSearch.addEventListener(DebugSearchEvent.SEARCH_CANCELLED, onSearchCancelled);
			
			stage.getChildAt(0).loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onError);
		}

		private function onError(event:UncaughtErrorEvent):void {
			DebugPanel.trace(event.error.toString(), "#FF0000", true);
			
//			if(event.error is Error){
//				trace("ERROR");
//				var error:Error = event.error as Error;
//				DebugPanel.trace(error.getStackTrace(), "#FF0000");
////				DebugPanel.trace(String(error.errorID) + " :: " + error.name + " :: " + error.message, "#FF0000");
//			} else if (event.error is ErrorEvent){
//				trace("ERROR_EVENT");
//				var errorEvent:ErrorEvent = event.error as ErrorEvent;
//				DebugPanel.trace(event.error.toString(), "#FF0000");
////				DebugPanel.trace(String(errorEvent.errorID) + " :: " + errorEvent.text, "#FF0000");
//			} else {
//				DebugPanel.trace(event.error.toString(), "#FF0000");
//			}
		}
		
		private function openMenu():void{
			menuOpenned = true;
			debugMenu.open();
			debugSearch.open();
		}
		
		private function closeMenu():void{
			menuOpenned = false;
			debugMenu.close();
			debugSearch.close();
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		public static function trace(msg:String, color:String = "#FFFFFF", forceTrace:Boolean = false):void{
			if(_instance != null)
				_instance.debugTrace(msg, color, forceTrace);
		}
		
		public static function resize():void{
			if(_instance != null)
				_instance.resizePanel();
		}
		
		public static function onKeyDown(event:KeyboardEvent):Boolean{
			var isStopped:Boolean = false;
			if(_instance != null)
				isStopped = _instance.onMenuKeyDown(event);
			
			return isStopped;
		}
		
		public static function getInstance():DebugPanel{
			if(_instance == null)
				_instance = new DebugPanel(new SingletonEnforcer());
			return _instance;
		}
	}
}


internal class SingletonEnforcer{
	public function SingletonEnforcer(){}
}
