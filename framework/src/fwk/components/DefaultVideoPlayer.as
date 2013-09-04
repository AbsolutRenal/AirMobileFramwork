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

	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.utils.Timer;


	/**
	 * @author renaud.cousin
	 */
	public class DefaultVideoPlayer extends AbstractVideoPlayer{
		protected var controls:DefaultVideoPlayerControls;
		
		protected var updateTimer:Timer;
		protected var updateDelay:int = 250;
		
		public function DefaultVideoPlayer(url:String){
			super(url);
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		protected function onControlsStop(event:VideoPlayerEvents):void {
			closeVideo();
		}

		protected function onControlsPause(event:VideoPlayerEvents):void {
			pauseVideo();
		}

		protected function onControlsPlay(event:VideoPlayerEvents):void {
			playVideo();
		}

		protected function onUpdate(event:TimerEvent):void {
			if(controls != null){
				controls.setLoadProgress(netStr.bytesLoaded / netStr.bytesTotal);
				if(!isNaN(duree))
					controls.setProgress(netStr.time / duree);
			}
		}

		protected function onControlsSeek(event:VideoPlayerEvents):void {
			netStr.seek(duree * event.data);
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		override protected function connectStream():void {
			netStr = new NetStream(netConn);
			netStr.bufferTime = buffer;
            netStr.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            netStr.client = {onMetaData:onMetaData};
            video = new Video();
            video.attachNetStream(netStr);
            netStr.play(videoURL);
			
			video.alpha = 0;
            addChild(video);
            
            controls = new DefaultVideoPlayerControls();
            addChild(controls);
            
            active();
		}
		
		override protected function active():void{
			controls.addEventListener(VideoPlayerEvents.PLAY, onControlsPlay);
			controls.addEventListener(VideoPlayerEvents.PAUSE, onControlsPause);
			controls.addEventListener(VideoPlayerEvents.STOP, onControlsStop);
			controls.addEventListener(VideoPlayerEvents.SEEK, onControlsSeek);
			
			createTimer();
		}
		
		override protected function desactive():void{
			killTimer();
			
			controls.removeEventListener(VideoPlayerEvents.PLAY, onControlsPlay);
			controls.removeEventListener(VideoPlayerEvents.PAUSE, onControlsPause);
			controls.removeEventListener(VideoPlayerEvents.STOP, onControlsStop);
			controls.removeEventListener(VideoPlayerEvents.SEEK, onControlsSeek);
		}

		protected function createTimer():void {
			killTimer();
			
			updateTimer = new Timer(updateDelay);
			updateTimer.addEventListener(TimerEvent.TIMER, onUpdate);
			updateTimer.start();
		}
		
		protected function killTimer():void{
			if(updateTimer != null){
				updateTimer.stop();
				if(updateTimer.hasEventListener(TimerEvent.TIMER))
					updateTimer.removeEventListener(TimerEvent.TIMER, onUpdate);
				updateTimer = null;
			}
		}
		
		override protected function checkForPlaying():void {
			if(controls != null)
				controls.openClose();
			
			super.checkForPlaying();
		}
		
		override protected function kill():void{
			super.kill();
			
			if(controls != null) {
				if (this.contains(controls))
					removeChild(controls);
				
				controls = null;
			}
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		override public function playVideo():void {
			super.playVideo();
			
			createTimer();
		}
		
		override public function pauseVideo():void {
			super.pauseVideo();
			
			killTimer();
		}
		
		override public function resize():void{
			super.resize();
			
			if(controls != null)
				controls.resize(netStr.time / duree);
		}

		public function showControls():void {
			if(controls != null){
				controls.openClose();
			}
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
	}
}
