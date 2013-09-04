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
	import flash.net.URLLoaderDataFormat;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * @author renaud.cousin
	 */
	public class FileLoader extends AbstractLoader {
		
		private var _data:ByteArray;
		
		private var loader:URLLoader;
		private var request:URLRequest;

		public function FileLoader(url:String) {
			super(url);
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		override protected function onLoadError(event:IOErrorEvent):void{
			removeListener(loader);
			request = null;
			loader = null;
			
			super.onLoadError(event);
		}

		override protected function onLoadComplete(event:Event):void{
			_data = loader.data;
			
			removeListener(loader);
			request = null;
			loader = null;
			
			super.onLoadComplete(event);
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		override public function load():void{
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			request = new URLRequest(url);
			addListener(loader);
			loader.load(request);
		}
		
		override public function stopLoading():void{
			if(loader != null)
				loader.close();
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------

		public function get data():ByteArray{
			return _data;
		}
	}
}
