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

package fwk.utils.assets{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.display.DisplayObject;

	/**
	 * @author AbsolutRenal
	 */
	public function getAssetObject(id:String):DisplayObject{
		var klass:Class;
		klass = getDefinitionByName(id) as Class;
		if(klass == null)
			klass = ApplicationDomain.currentDomain.getDefinition(id) as Class;
			
		if(klass != null)
			return new klass() as DisplayObject;
		else
			return null;
	}
}
