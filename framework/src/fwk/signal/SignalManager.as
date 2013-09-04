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

package fwk.signal{
	/**
	 * @author rcousin
	 */
	public class SignalManager{
		private static var signals:Vector.<Signal> = new Vector.<Signal>();
		
		public static function listenGlobal(signalName:String, callback:Function):void{
			listen(null, signalName, callback);
		}
		
		public static function listen(targetInstance:Object, signalName:String, callback:Function):void{
			var signal:Signal = checkExistingSignal(targetInstance, signalName);
			if(signal != null){
				trace(">> PUSH");
				signal.callbacks.push(callback);
			} else {
				signal = new Signal(targetInstance, signalName, callback);
				trace(">> NEW");
				signals.push(signal);
			}
		}
		
		public static function stopListenGlobal(signalName:String, callback:Function):void{
			stopListen(null, signalName, callback);
		}
		
		public static function stopListen(targetInstance:Object, signalName:String, callback:Function):void{
			var signal:Signal = checkExistingSignal(targetInstance, signalName);
			if(signal != null){
				var idx:int = signal.callbacks.indexOf(callback);
				if(idx != -1)
					signal.callbacks.splice(idx, 1);
			}
		}
		
		public static function dispatchGlobal(signalName:String):void{
			dispatch(null, signalName);
		}
		
		public static function dispatch(targetInstance:Object, signalName:String):void{
			var signal:Signal = checkExistingSignal(targetInstance, signalName);
			
			if(signal != null){
				for each (var callback:Function in signal.callbacks) {

					callback();
				}
			}
		}
		
		public static function checkExistingSignal(targetInstance:Object, name:String):Signal{
			for each (var signal:Signal in signals) {

				if(signal.name == name && (signal.targetInstance == targetInstance || targetInstance == null)){
					return signal;
				}

			}
			return null;
		}
	}
}
