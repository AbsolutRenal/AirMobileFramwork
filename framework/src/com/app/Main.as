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

package com.app {
	//IMPORT_PAGE//
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import fwk.app.MainBase;



	/**
	 * @author renaud.cousin
	 */
	public class Main extends MainBase implements IMain{
		
		public function Main()
		{
			SiteApp.main = this;
			super();
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		override protected function onAppDesactivate(event:Event):void {
			super.onAppDesactivate(event);
		}

		override protected function onAppActivate(event:Event):void {
			super.onAppActivate(event);
		}

		override protected function onResizeScreen(event:Event):void {
			super.onResizeScreen(event);
			
			
		}
		
		
		//----------------------------------------------------------------------
		// P R O T E C T E D
		//----------------------------------------------------------------------
		
		override protected function registerPagesClass():void {
			//REGISTER_PAGE//
		}
		
		override protected function onReady():void {
			super.onReady();
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
	}
}