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
	import com.greensock.TweenLite;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author renaud.cousin
	 */
	public class AbstractLoaderPage extends MovieClip {
		protected const DISPLAY_DURATION:Number = .4;

		public function AbstractLoaderPage() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		protected function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			alpha = 0;
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		
		//----------------------------------------------------------------------
		// P R O T E C T E D
		//----------------------------------------------------------------------
		
		protected function closeComplete():void{
			if(this.parent != null){
				this.parent.removeChild(this);
			}
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		public function display():void{
			TweenLite.to(this, DISPLAY_DURATION, {alpha:1});
		}
		
		public function close():void{
			TweenLite.killTweensOf(this);
			TweenLite.to(this, DISPLAY_DURATION, {alpha:0, onComplete:closeComplete});
		}
		
		public function setProgress(percent:uint):void{
			// XXX => TO BE OVERRIDEN
		}
		
		public function resize():void{
			if(stage != null){
				x = stage.stageWidth / 2;
				y = stage.stageHeight / 2;
			}
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
	}
}
