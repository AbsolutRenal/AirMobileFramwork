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

package fwk.utils.assets.events {
	import flash.events.Event;

	/**
	 * @author renaud.cousin
	 */
	public class AssetsManagerEvents extends Event {
		public static const ASSETS_LOADED:String = "assetsLoaded";
		public static const ASSETS_PROGRESS:String = "assetsProgress";
		
		private var _assets:Object;
		private var _dependenciesAssets:Object;

		public function AssetsManagerEvents(type:String, assets:Object = null, dependenciesAssets:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			_assets = assets;
			_dependenciesAssets = dependenciesAssets;
			super(type, bubbles, cancelable);
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
		
		public function get assets():Object{
			return _assets;
		}
		
		public function get dependenciesAssets():Object{
			return _dependenciesAssets;
		}
	}
}
