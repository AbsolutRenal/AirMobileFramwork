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

package fwk.utils.timer{
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;

	/**
	 * @author rcousin
	 */
	public class TimerExt extends EventDispatcher{
		private var t:Timer;
		private var lastTime:int;
		private var delayAfterPause:int;
		private var isPaused:Boolean = true;
		
		private var _delay:Number;
		private var _repeatCount:int;
		
		public function TimerExt(delay:Number, repeatCount:int = 0){
			_delay = delay;
			_repeatCount = repeatCount;
			
			init();
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		private function onTimer(event:TimerEvent):void{
			if(t.delay != _delay)
				t.delay = _delay;
			dispatchEvent(event.clone());
		}

		private function onTimerComplete(event:TimerEvent):void{
			dispatchEvent(event.clone());
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------

		private function init():void{
			t = new Timer(_delay, _repeatCount);
		}
		
		private function addEvents():void{
			t.addEventListener(TimerEvent.TIMER, onTimer);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
		private function removeEvents():void{
			t.removeEventListener(TimerEvent.TIMER, onTimer);
			t.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		public function start():void{
			if(!running){
				isPaused = false;
				addEvents();
				lastTime = getTimer();
				t.start();
			}
		}
		
		public function pause():void{
			if(!isPaused){
				isPaused = true;
				t.stop();
				delayAfterPause = _delay - (getTimer() - lastTime);
			}
		}
		
		public function resume():void{
			if(isPaused){
				isPaused = false;
				t.delay = delayAfterPause;
				t.start();
			}
		}
		
		public function stop():void{
			if(t.running){
				t.stop();
				removeEvents();
			}
		}
		
		public function reset():void{
			t.reset();
			removeEvents();
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R  /  S E T T E R
		//----------------------------------------------------------------------
		
		public function get currentCount():int{
			return t.currentCount;
		}
		
		public function get repeatCount():int{
			return t.repeatCount;
		}
		
		public function set repeatCount(value:int):void{
			_repeatCount = value;
			t.repeatCount = value;
		}
		
		public function get delay():Number{
			return t.delay;
		}
		
		public function set delay(value:Number):void{
			_delay = value;
			t.delay = value;
		}
		
		public function get running():Boolean{
			return t.running;
		}
	}
}
