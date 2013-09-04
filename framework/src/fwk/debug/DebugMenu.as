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

package fwk.debug {
	import com.greensock.TweenNano;
	import com.greensock.easing.Strong;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author renaud.cousin
	 */
	public class DebugMenu extends Sprite {
		// ON STAGE
		public var container:MovieClip;
		// END ON STAGE
		
		private var clearBtn:MovieClip;
		private var pauseBtn:MovieClip;
		private var background:Sprite;
		private var stripes:Sprite;

		public function DebugMenu() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			container.alpha = 0;
			container.visible = false;
			
			clearBtn = container.clearBtn as MovieClip;
			pauseBtn = container.pauseBtn as MovieClip;
			background = container.background as Sprite;
			stripes = container.stripes as Sprite;
			
			pauseBtn.gotoAndStop(1);
		}

		private function onClickClear(event:MouseEvent):void {
			onBtnOut(event);
			
			dispatchEvent(new Event(Event.CLEAR));
		}

		private function onClickPause(event:MouseEvent):void {
			var frame:int = (pauseBtn.currentFrame == 1)? 2 : 1 ;
			pauseBtn.gotoAndStop(frame);
			onBtnOut(event);
			
			dispatchEvent(new Event(Event.SELECT));
		}

		private function onBtnDown(event:MouseEvent):void {
			onBtnOver(event);
		}

		private function onBtnOut(event:MouseEvent):void {
			(event.target as MovieClip).alpha = 1;
		}

		private function onBtnOver(event:MouseEvent):void {
			(event.target as MovieClip).alpha = .5;
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		private function active():void{
			clearBtn.mouseChildren = false;
			clearBtn.addEventListener(MouseEvent.MOUSE_DOWN, onBtnDown);
			clearBtn.addEventListener(MouseEvent.ROLL_OUT, onBtnOut);
			clearBtn.addEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			clearBtn.addEventListener(MouseEvent.CLICK, onClickClear);
			
			pauseBtn.mouseChildren = false;
			pauseBtn.addEventListener(MouseEvent.MOUSE_DOWN, onBtnDown);
			pauseBtn.addEventListener(MouseEvent.ROLL_OUT, onBtnOut);
			pauseBtn.addEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			pauseBtn.addEventListener(MouseEvent.CLICK, onClickPause);
		}
		
		private function desactive():void{
			clearBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onBtnDown);
			clearBtn.removeEventListener(MouseEvent.ROLL_OUT, onBtnOut);
			clearBtn.removeEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			clearBtn.removeEventListener(MouseEvent.CLICK, onClickClear);
			
			pauseBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onBtnDown);
			pauseBtn.removeEventListener(MouseEvent.ROLL_OUT, onBtnOut);
			pauseBtn.removeEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			pauseBtn.removeEventListener(MouseEvent.CLICK, onClickPause);
		}
		
		private function hide():void{
			container.alpha = 0;
			container.visible = false;
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		public function open():void{
			container.visible = true;
			TweenNano.killTweensOf(container);
			TweenNano.to(container, .4, {alpha:1, y:-container.height, ease:Strong.easeOut, onComplete:active});
		}
		
		public function close():void{
			desactive();
			
			TweenNano.killTweensOf(container);
			TweenNano.to(container, .3, {y:0, ease:Strong.easeIn, onComplete:hide});
		}
		
		public function resizePanel():void{
			y = stage.stageHeight;
			
			background.width = stage.stageWidth;
			stripes.x = stage.stageWidth / 2;
			clearBtn.x = stage.stageWidth / 4;
			pauseBtn.x = (stage.stageWidth / 4) * 3;
		}
	}
}
