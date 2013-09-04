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

package fwk.utils.types.string {
	/**
	 * @author renaud.cousin
	 */
	 
	/**
	 * @params regExp:String
	 * 	- [0-9] => suite de chiffre
	 * 	- * 	=> délimiteur de group de valeur
	 * 		
	 * 	@example
	 * 	- "4*58*32*19" 						=> renvoie [4, 58, 32, 19]
	 * 	- "[0-59]"							=> renvoie [0, 1, 2, ..., 57, 58, 59]
	 * 	- "[7-23]*0"						=> renvoie [7, 8, 9, 10, ..., 22, 23, 0]
	 * 	- "0*5*8*[15-22]*[28-30]*34*38"		=> renvoie [0, 5, 8, 15, 16, 17, ..., 21, 22, 28, 29, 30, 34, 38]
	 */
	public function numericArrayFromPattern(regExp:String, charsCount2:Boolean = true):Array {
		var arr:Array = [];
		var value:String;
		var tmpArr:Array = regExp.split("*");
		var tmpValues:Array;
		
		for(var i:int = 0; i < tmpArr.length; i++){
			value = tmpArr[i];
			if(value.search("-") != -1){
				value = value.replace("[", "");
				value = value.replace("]", "");
				tmpValues = value.split("-");
				
				for(var j:int = int(tmpValues[0]); j <= int(tmpValues[1]); j++){
					var val:String = String(j);
					if(charsCount2 && String(j).length == 1)
						val = "0" + val;
					arr.push(val);
				}
			} else {
				if(charsCount2 && value.length == 1)
					value = "0" + value;
				arr.push(value);
			}
		}
		
		return arr;
	}
}
