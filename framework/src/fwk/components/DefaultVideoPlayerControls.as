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

package fwk.components {
	import fwk.components.events.VideoPlayerEvents;

	import com.greensock.TweenNano;
	import com.greensock.easing.Expo;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;



	/**
	 * @author renaud.cousin
	 */
	public class DefaultVideoPlayerControls extends MovieClip {
		private static const BTNS_OFFSET_X:int = 30;
		private static const BAR_OFFSET:int = 4;
		private static const TRANSITION_DURATION:Number = .4;
		private static const DISAPPEAR_DELAY:int = 2500;
		
		
		// ON STAGE
		public var progressbar:Sprite;
		public var loadbar:Sprite;
		public var progressbarBackground:Sprite;
		public var stopBt:Sprite;
		public var playBt:MovieClip;
		public var background:Sprite;
		// END ON STAGE
		
		private var isOpenned:Boolean = false;
		private var timer:Timer;

		public function DefaultVideoPlayerControls() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}

		private function onTimer(event:TimerEvent):void {
			killTimer();
			
			close();
		}

		private function onClickStop(event:MouseEvent):void {
			dispatchEvent(new VideoPlayerEvents(VideoPlayerEvents.STOP));
		}

		private function onClickPlay(event:MouseEvent):void {
			if(playBt.currentFrame == 1){
				dispatchEvent(new VideoPlayerEvents(VideoPlayerEvents.PAUSE));
				playBt.gotoAndStop(2);
			} else {
				dispatchEvent(new VideoPlayerEvents(VideoPlayerEvents.PLAY));
				playBt.gotoAndStop(1);
			}
		}

		private function onBtDown(event:MouseEvent):void {
			event.stopImmediatePropagation();
		}

		private function onSeek(event:MouseEvent):void {
			dispatchEvent(new VideoPlayerEvents(VideoPlayerEvents.SEEK, (loadbar.mouseX * loadbar.scaleX) / (progressbarBackground.width - 2 * BAR_OFFSET)));
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------

		private function init():void {
			resize(0);
			
			active();
		}

		private function active():void {
			playBt.addEventListener(MouseEvent.CLICK, onClickPlay);
			playBt.addEventListener(MouseEvent.MOUSE_DOWN, onBtDown);
			stopBt.addEventListener(MouseEvent.CLICK, onClickStop);
			stopBt.addEventListener(MouseEvent.MOUSE_DOWN, onBtDown);
			
			progressbar.mouseEnabled = false;
			loadbar.addEventListener(MouseEvent.CLICK, onSeek);
			loadbar.addEventListener(MouseEvent.MOUSE_DOWN, onBtDown);
		}
		
		private function open():void{
			isOpenned =  true;
			TweenNano.killTweensOf(this);
			TweenNano.to(this, TRANSITION_DURATION, {y:stage.stageHeight, ease:Expo.easeOut});
			createTimer();
		}
		
		private function close():void{
			isOpenned =  false;
			TweenNano.killTweensOf(this);
			if(stage != null)
				TweenNano.to(this, TRANSITION_DURATION, {y:stage.stageHeight + background.height, ease:Expo.easeOut});
		}
		
		private function createTimer():void{
			killTimer();
			
			timer = new Timer(DISAPPEAR_DELAY);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function killTimer():void{
			if(timer != null){
				timer.stop();
				if(timer.hasEventListener(TimerEvent.TIMER))
					timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
			}
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		public function resize(percent:Number):void{
			stopBt.x = BTNS_OFFSET_X;
			playBt.x = stopBt.x + stopBt.width + BTNS_OFFSET_X;
			progressbarBackground.x = playBt.x + playBt.width + BTNS_OFFSET_X;
			progressbarBackground.width = stage.stageWidth - BTNS_OFFSET_X - progressbarBackground.x;
			progressbar.x = progressbarBackground.x + BAR_OFFSET;
			progressbar.y = progressbarBackground.y + BAR_OFFSET;
			progressbar.height = progressbarBackground.height - (BAR_OFFSET * 2);
			loadbar.x = progressbarBackground.x + BAR_OFFSET;
			loadbar.y = progressbarBackground.y + BAR_OFFSET;
			loadbar.height = progressbarBackground.height - (BAR_OFFSET * 2);
			
			setProgress(percent); 
			
			background.width = stage.stageWidth;
			
			TweenNano.killTweensOf(this);
			if(isOpenned)
				y = stage.stageHeight;
			else
				y = stage.stageHeight + background.height;
		}
		
		public function setLoadProgress(percent:Number):void{
			loadbar.width = percent * (progressbarBackground.width - 2 * BAR_OFFSET);
		}

		public function setProgress(percent:Number):void {
			progressbar.width = percent * (progressbarBackground.width - 2 * BAR_OFFSET);
		}
		
		public function openClose():void{
			if(isOpenned)
				close();
			else
				open();
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
	}
}
