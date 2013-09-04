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

package fwk.app.pages{
	import fwk.app.pages.events.PageEvents;
	import fwk.utils.bitmap.convertAsBitmap;

	import com.app.SiteApp;
	import com.greensock.TweenNano;
	import com.greensock.easing.Expo;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	/**
	 * @author renaud.cousin
	 */
	public class AbstractPage extends MovieClip implements IPage {
		protected const TRANSITION_DURATION:Number = 1;
		protected const TRANSTION_EASE:Object = Expo.easeInOut;
		
		protected var _assets:Object;
		protected var _parentContainerDepth:String;
		protected var _isCached:Boolean;
		protected var _dependencies:Vector.<AbstractPage> = new Vector.<AbstractPage>();
		protected var _dependenciesNames:Vector.<String> = new Vector.<String>();
		
		protected var transitionBmp:Bitmap;
		protected var destDisplay:int;
		protected var skipInit:Boolean = false;
		
		
		public function AbstractPage(){
			alpha = 0;
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		private function displayDependencies():void{
			for(var i:int = 0; i < dependencies.length; i++){
				if(SiteApp.main.previousPage != null && SiteApp.main.previousPage.dependencies.indexOf(dependencies[i]) == -1){
					dependencies[i].display();
				} else if(SiteApp.main.previousPage == null){
					dependencies[i].display();
				}
			}
		}
		
		private function closeDependencies():void{
			for(var i:int = 0; i < dependencies.length; i++){
				if(SiteApp.main.currentPage.dependencies.indexOf(dependencies[i]) == -1){
					dependencies[i].close();
				}
			}
		}
		
		
		//----------------------------------------------------------------------
		// P R O T E C T E D
		//----------------------------------------------------------------------
		
		protected function displayComplete():void{
			if(transitionBmp != null){
				visible = true;
				transitionBmp.visible = false;
			}
			
			dispatchEvent(new PageEvents(PageEvents.DISPLAY_COMPLETE));
			active();
		}
		
		protected function closeComplete():void{
			if(transitionBmp != null){
				SiteApp.main.depthContainer(_parentContainerDepth).removeChild(transitionBmp);
				transitionBmp.bitmapData.dispose();
				transitionBmp = null;
			}
			
			skipInit = false;
			clearAssets();
			dispatchEvent(new PageEvents(PageEvents.CLOSE_COMPLETE));
		}

		protected function clearAssets():void{
			for each (var item:* in _assets) {
				if(item is Bitmap){
					(item as Bitmap).bitmapData.dispose();
				}
			}
		}
		
		protected function display():void{
			cacheAsBitmapMatrix = this.transform.concatenatedMatrix;
			
			if(SiteApp.useBitmapTransition){
				setBitmapTransition();
				destDisplay = transitionBmp.x;
				
				if(SiteApp.firstLoad){
					TweenNano.to(transitionBmp, TRANSITION_DURATION, {alpha:1, onComplete:displayComplete});
				} else {
					alpha = 1;
					transitionBmp.alpha = 1;
					transitionBmp.x = destDisplay + SiteApp.APP_WIDTH;
					TweenNano.to(transitionBmp, TRANSITION_DURATION, {x:destDisplay, ease:TRANSTION_EASE, onComplete:displayComplete});
				}
			} else {
				destDisplay = x;
				if(SiteApp.firstLoad){
					TweenNano.to(this, TRANSITION_DURATION, {alpha:1, onComplete:displayComplete});
				} else {
					alpha = 1;
					x = destDisplay + SiteApp.APP_WIDTH;
					TweenNano.to(this, TRANSITION_DURATION, {x:destDisplay, ease:TRANSTION_EASE, onComplete:displayComplete});
				}
			}
		}
		
		protected function close():void{
			if(transitionBmp != null){
				transitionBmp.visible = true;
				TweenNano.to(transitionBmp, TRANSITION_DURATION, {x:destDisplay - SiteApp.APP_WIDTH, ease:TRANSTION_EASE, onComplete:closeComplete});
				visible = false;
				SiteApp.main.depthContainer(parentContainerDepth).removeChild(this);
			} else {
				TweenNano.to(this, TRANSITION_DURATION, {x:destDisplay - SiteApp.APP_WIDTH, ease:TRANSTION_EASE, onComplete:closeComplete});
			}
		}
		
		protected function setBitmapTransition():void{
			var origin:Shape = new Shape();
			origin.graphics.beginFill(0x00FF00);
			origin.graphics.drawRect(0, 0, 5, 5);
			origin.graphics.endFill();
			origin.alpha = 0;
			addChild(origin);
			
			alpha = 1;
			transitionBmp = convertAsBitmap(this, (SiteApp.APP_WIDTH < width) || (SiteApp.APP_HEIGHT < height));
			trace("------------------", this, x, y, "<:> [BMP]", transitionBmp.x, transitionBmp.y);
			transitionBmp.alpha = 0;
			SiteApp.main.depthContainer(_parentContainerDepth).addChild(transitionBmp);
			visible = false;
		}
		
		protected function refreshTransitionBitmap():void {
			if (transitionBmp != null) {
				if (SiteApp.main.depthContainer(_parentContainerDepth).contains(transitionBmp))
					SiteApp.main.depthContainer(_parentContainerDepth).removeChild(transitionBmp);

				transitionBmp = null;
			}

			transitionBmp = convertAsBitmap(this);
			SiteApp.main.depthContainer(_parentContainerDepth).addChild(transitionBmp);
			alpha = 0;
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------

		public function init():void {
		}

		public function displayPage():void {
			displayDependencies();
			
			display();
		}

		public function closePage():void {
			closeDependencies();
			
			close();
		}
		
		public function active():void{
			for(var i:int = 0; i < dependencies.length; i++){
				dependencies[i].active();
			}
		}
		
		public function desactive():void{
			for(var i:int = 0; i < dependencies.length; i++){
				dependencies[i].desactive();
			}
		}
		
		public function reinit():void{
			skipInit = true;
			alpha = 0;
			x += SiteApp.APP_WIDTH;
			
			for(var i:int = 0; i < dependencies.length; i++){
				if(SiteApp.main.previousPage.dependencies.indexOf(dependencies[i]) == -1){
					dependencies[i].reinit();
				}
			}
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
		
		public function get assets():Object{
			return _assets;
		}
		
		public function set assets(value:Object):void{
			_assets = value;
		}

		public function get parentContainerDepth():String {
			return _parentContainerDepth;
		}

		public function set parentContainerDepth(value:String):void {
			_parentContainerDepth = value;
		}

		public function get isCached():Boolean {
			return _isCached;
		}

		public function set isCached(value:Boolean):void {
			_isCached = value;
		}

		public function get dependencies():Vector.<AbstractPage> {
			return _dependencies;
		}

		public function get dependenciesNames():Vector.<String> {
			return _dependenciesNames;
		}
	}
}
