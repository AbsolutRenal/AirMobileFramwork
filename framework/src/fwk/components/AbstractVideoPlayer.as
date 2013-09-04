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
	import fwk.debug.DebugPanel;
	import fwk.utils.loaders.LoadingWheel;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author renaud.cousin
	 */
	public class AbstractVideoPlayer extends Sprite {
		
		protected var videoURL:String;
		protected var buffer:int = 2;
		protected var video:Video;
		protected var netStr:NetStream;
		protected var netConn:NetConnection;
		
		protected var waitingToStart:Boolean = false;
		protected var duree:Number = NaN;
		
		protected var bufferWheel:LoadingWheel;
		
		protected var isPlaying:Boolean = false;
		
		public function AbstractVideoPlayer(url:String){
			videoURL = url;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		protected function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			init();
		}

		protected function onRemovedFromStage(event:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			kill();
		}
		
		protected function netStatusHandler(event:NetStatusEvent):void {
            DebugPanel.trace(">> " + event.info.code, "#FFFFFF", true);
			
			switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetStream.Play.Stop":
					if (netStr.time == duree)
						closeVideo();
                    break;
                case "NetStream.Play.Start":
					playVideo();
					break;
                case "NetStream.Play.StreamNotFound":
                    DebugPanel.trace("Stream not found: " + videoURL, "#FFFFFF", true);
					throw new Error("[AbstractVideoPlayer] stream not found : " + videoURL);
                    break;
				case "NetStream.Buffer.Empty":
					if(!isNaN(duree) && ((duree - netStr.time) < .3)) {
						closeVideo();
					} else {
						addBuffer();
					}
					break;
				case "NetStream.Buffer.Full":
					removeBuffer();
					break;
				case "NetStream.Buffer.Flush":
					if (duree && ((duree - netStr.time) < .3)) {
						closeVideo();
					}
					break;
            }
        }

        protected function securityErrorHandler(event:SecurityErrorEvent):void {
            DebugPanel.trace("securityErrorHandler: " + event);
        }
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		protected function init():void{
			netConn = new NetConnection();
			netConn.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            netConn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			netConn.connect(null);
		}
		
		protected function connectStream():void {
			netStr = new NetStream(netConn);
			netStr.bufferTime = buffer;
            netStr.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            netStr.client = {onMetaData:onMetaData};
            video = new Video();
            video.attachNetStream(netStr);
            netStr.play(videoURL);
			
			video.alpha = 0;
            addChild(video);
            
            active();
		}
		
		protected function active():void{
		}
		
		protected function desactive():void{
		}
		
		protected function onMetaData(info:Object):void {
			DebugPanel.trace("onMetaData( width:" + info.width + " height:" + info.height + " duration:" + info.duration + " );", "#FFFFFF", true);
			
			duree = info.duration;
			video.width = info.width;
			video.height = info.height;
			video.alpha = 1;
			
			checkForPlaying();
			resize();
		}
		
		protected function onXMPData(info:Object):void{
			DebugPanel.trace("onXMPData();", "#FFFFFF", true);
		}
		
		protected function checkForPlaying():void {
			if (waitingToStart) {
				waitingToStart = false;
				playVideo();
			}
		}
		
		protected function addBuffer():void {
			if (bufferWheel == null) {
				bufferWheel = new LoadingWheel();
				bufferWheel.x = stage.stageWidth / 2;
				bufferWheel.y = stage.stageHeight / 2;
				addChild(bufferWheel);
			}
		}
		
		protected function removeBuffer():void {
			if (bufferWheel != null) {
				if(contains(bufferWheel))
					removeChild(bufferWheel);
				bufferWheel = null;
			}
		}
		
		protected function kill():void{
			desactive();
			
			if(netStr != null){
				netStr.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				netStr.close();
				netStr = null;
			}
			
			if (netConn != null) {
				netConn.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				netConn.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				netConn.close();
				netConn = null;
			}
			
			if(video != null) {
				if (this.contains(video))
					removeChild(video);
				
				video = null;
			}
		}
		
		protected function calculateImgSize(obj:DisplayObject):Array{
			var arr:Array = [];
			var stageRatio:Number = stage.stageWidth / stage.stageHeight;
			
			var imgRatio:Number = obj.width / obj.height;
			
			if(stageRatio > imgRatio){
				arr.push(stage.stageHeight * imgRatio);
				arr.push(stage.stageHeight);
			} else {
				arr.push(stage.stageWidth);
				arr.push(stage.stageWidth/ imgRatio);
			}
			
			return arr;
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		public function closeVideo():void {
			isPlaying = false;
			netStr.pause();
			netStr.close();
			netConn.close();
			
			dispatchEvent(new VideoPlayerEvents(VideoPlayerEvents.VIDEO_END));
		}
		
		public function playVideo():void {
			isPlaying = true;
			removeBuffer();
			netStr.resume();
		}
		
		public function pauseVideo():void {
			isPlaying = false;
			removeBuffer();
			netStr.pause();
		}
		
		public function resize():void{
			var size:Array = calculateImgSize(video);
			video.width = size[0];
			video.height = size[1];
			
			if(bufferWheel != null){
				bufferWheel.x = stage.stageWidth / 2;
				bufferWheel.y = stage.stageHeight / 2;
			}
			
			video.x = (stage.stageWidth - video.width) / 2;
			video.y = (stage.stageHeight - video.height) / 2;
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
	}
}
