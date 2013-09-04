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

package fwk.utils.loaders {
	import flash.events.IEventDispatcher;
	import fwk.debug.DebugPanel;
	import fwk.utils.loaders.events.LoaderEvents;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;

	/**
	 * @author renaud.cousin
	 */
	public class AbstractLoader extends EventDispatcher {
		private var bytesTotalKnown:Boolean = false;
		private var _progressPercent:int = 0;
		private var _id:String;
		
		protected var url:String;

		public function AbstractLoader(url:String) {
			this.url = url;
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		protected function onLoadError(event:IOErrorEvent):void{
			DebugPanel.trace("[ERROR] :: " + event.toString(), "#FF0000");
			dispatchEvent(new LoaderEvents(LoaderEvents.LOAD_ERROR));
		}

		protected function onHTTPStatus(event:HTTPStatusEvent):void{
			DebugPanel.trace("[HTTP_STATUS] :: " + event.toString(), "#FF0000");
		}

		protected function onLoadStart(event:Event):void{
			dispatchEvent(new LoaderEvents(LoaderEvents.LOAD_START));
		}

		protected function onLoadProgress(event:ProgressEvent):void{
			if(event.bytesTotal > 0){
				if(!bytesTotalKnown){
					bytesTotalKnown = true;
					dispatchEvent(new LoaderEvents(LoaderEvents.BYTES_TOTAL_KNOWN, event.bytesTotal));
				}
				
				_progressPercent = Math.floor((event.bytesLoaded / event.bytesTotal) * 100);
				dispatchEvent(new LoaderEvents(LoaderEvents.LOAD_PROGRESS, event.bytesLoaded));
			}
		}

		protected function onLoadComplete(event:Event):void{
			dispatchEvent(new LoaderEvents(LoaderEvents.LOAD_COMPLETE));
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		
		//----------------------------------------------------------------------
		// P R O T E C T E D
		//----------------------------------------------------------------------
		
		protected function addListener(dispatcher:IEventDispatcher):void{
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			dispatcher.addEventListener(Event.OPEN, onLoadStart);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			dispatcher.addEventListener(Event.COMPLETE, onLoadComplete);			
		}
		
		protected function removeListener(dispatcher:IEventDispatcher):void{
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			dispatcher.removeEventListener(Event.OPEN, onLoadStart);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			dispatcher.removeEventListener(Event.COMPLETE, onLoadComplete);	
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		public function load():void{
			// XXX => TO BE OVERRIDEN
		}
		
		public function stopLoading():void{
			// XXX => TO BE OVERRIDEN
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------

		public function get progressPercent():int{
			return _progressPercent;
		}

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			_id = value;
		}
	}
}
