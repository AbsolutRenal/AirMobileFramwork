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
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;


	/**
	 * @author renaud.cousin
	 */
	public class LoaderMp3 extends AbstractLoader{
		
		private var sound:Sound;
		
		public function LoaderMp3(url:String){
			super(url);
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		override protected function onLoadError(event:IOErrorEvent):void {
			removeListener(sound);
			sound = null;
			
			super.onLoadError(event);
		}

		override protected function onLoadComplete(event:Event):void {
			removeListener(sound);
			
			super.onLoadComplete(event);
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		override public function load():void{
			sound = new Sound();
			addListener(sound);
			sound.load(new URLRequest(url), new SoundLoaderContext());
		}
		
		override public function stopLoading():void{
			if(sound != null)
				sound.close();
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------

		public function get data():Sound {
			return sound;
		}
	}
}
