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
	import flash.text.TextField;

	/**
	 * @author renaud.cousin
	 */
	public class DefaultLoaderPage extends AbstractLoaderPage {
		// ON STAGE
		public var tTexte:TextField;
		public var loadingWheel:LoadingWheel;
		// END ON STAGE

		public function DefaultLoaderPage() {
			super();
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		override protected function onAddedToStage(event:Event):void {
			super.onAddedToStage(event);
			
			setProgress(0);
		}
		
		
		//----------------------------------------------------------------------
		// P R O T E C T E D
		//----------------------------------------------------------------------
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		override public function setProgress(percent:uint):void{
			tTexte.text = String(percent) + "%";
		}
	}
}
