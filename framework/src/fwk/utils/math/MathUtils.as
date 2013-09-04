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

package fwk.utils.math{
	import flash.geom.Point;
	/**
	 * @author renaudcousin
	 */
	public class MathUtils{
		
		/////////////////////////////////////////////////////////////////////
	    // Constants
	    /////////////////////////////////////////////////////////////////////
	    
		/**
		 * math constant: change degrees to radians ... Math.PI/180
		 */
		public static const DEG2RAD:Number = 0.0174532925199433;
		
		/**
		 * math constant: change radians to degrees ... 180/Math.PI
		 */
		public static const RAD2DEG:Number = 57.2957795130823;
		
		/**
		 * math constant: the golden mean (phi) ... (1+Math.sqrt(5))/2
		 */
		public static const PHI:Number = 1.61803398874989;
		
		/** math constant: Euler-Mascheroni constant (lamda or C) ...
	     *        (    n              )
	     *  lim   ( sigma 1/k - ln(n) )
	     *  n->oo (   k=1             )
	     */
		public static const LAMBDA:Number = 0.57721566490143;
		
		
		
		//////////////////////////////////////////////////////////////////////
	    // Trigonometry extensions
	    //////////////////////////////////////////////////////////////////////
	
	    //////////////////////////////////////////////////
	    // Trig-decimal functions
	    //////////////////////////////////////////////////
    
		/**
		 * @return sin in degrees
		 */
		public static function sinD(angle:Number):Number{
			return Math.sin( angle * ( Math.PI / 180 ) );
		}
		
		/**
		 * @return cos in degrees
		 */
		public static function cosD(angle:Number):Number{
			return Math.cos( angle * ( Math.PI / 180 ) );
		}
		
		/**
		 * @return tan in degrees
		 */
		public static function tanD(angle:Number):Number{
			return Math.tan( angle * ( Math.PI / 180 ) );
		}
		 
		 /**
		 * @return asin in degrees
		 */
		public static function asinD(ratio:Number):Number{
			return Math.asin( ratio ) * ( 180 / Math.PI );
		}
		
		/**
		 * @return acos in degrees
		 */
		public static function acosD(ratio:Number):Number{
			return Math.acos( ratio ) * ( 180 / Math.PI );
		}
		
		/**
		 * @return atan in degrees
		 */
		public static function atanD(ratio:Number):Number{
			return Math.atan( ratio ) * ( 180 / Math.PI );
		}
		
		/**
		 * @return atan2 in degrees
		 */
		public static function atan2D(y:Number, x:Number):Number{
			return Math.atan2( y, x ) * ( 180 / Math.PI );
		}
		
		
		
		//////////////////////////////////////////////////
	    // Circular trigonometric functions
	    //////////////////////////////////////////////////
		 
		/**
		 * @return secant
		 */
		public static function sec(angle:Number):Number{
			return ( 1 / Math.cos( angle ) );
		}
		  
		/**
		 * @return arcsecant
		 */
		public static function asec(ratio:Number):Number{
			return ( Math.acos( 1 / ratio ) );
		}
		
		/**
		 * @return cosecant
		 */
		public static function csc(angle:Number):Number{
			return ( 1 / Math.sin( angle ) );
		}
		
		/**
		 * @return arccosecant
		 */
		public static function acsc(ratio:Number):Number{
			return ( Math.asin( 1 / ratio ) );
		}
		
		/**
		 * @return cotangent
		 */
		public static function cot(angle:Number):Number{
			return ( 1 / Math.tan( angle ) );
		}
		
		/**
		 * @return arccotangent
		 */
		public static function acot(ratio:Number):Number{
			return ( Math.atan( 1 / ratio ) );
		}
		
		/**
		 * @return versine
		 */
		public static function vers(n:Number):Number{
			return 1 - Math.cos( n );
		}
		
		/**
		 * @return coversine
		 */
		public static function covers(n:Number):Number{
			return 1 - Math.sin( n );
		}
		
		/**
		 * @return haversine
		 */
		public static function havers(n:Number):Number{
			return 0.5 * ( 1 - Math.cos( n ) );
		}
		
		/**
		 * @return cohaversine
		 */
		public static function cohavers(n:Number):Number{
			return 0.5 * ( 1 - Math.sin( n ) );
		}
		
		/**
		 * @return exsecant
		 */
		public static function exsec(n:Number):Number{
			return 1 / Math.cos( n ) - 1;
		}
		
		/**
		 * @return coexsecant
		 */
		public static function coexsec(n:Number):Number{
			return 1 / Math.sin( n ) - 1;
		}
		
		/**
		 * @return arcversine
		 */
		public static function avers(n:Number):Number{
			return Math.atan( Math.sqrt( 2 * n - n * n ) / ( 1 - n ) );
		}
		
		/**
		 * @return arccoversine
		 */
		public static function acovers(n:Number):Number{
			return Math.atan( ( 1 - n ) / Math.sqrt( 2 * n - n * n ) );
		}
		
		/**
		 * @return archaversine
		 */
		public static function ahavers(n:Number):Number{
			return Math.atan( 2 * Math.sqrt( n - n * n ) / ( 1 - 2 * n ) );
		}
		
		/**
		 * @return arcexsecant
		 */
		public static function aexsec(n:Number):Number{
			return Math.atan( Math.sqrt( n * n + 2 * n ) );
		}
		
		
		
		//////////////////////////////////////////////////
		// Hyperbolic trigonometric functions
		//////////////////////////////////////////////////
		
		/**
		 * @return hyperbolic sine = (Eª-E-ª)/2
		 */
		public static function sinh(n:Number):Number{
			return ( Math.exp( n ) - Math.exp( -n ) ) / 2;
		}
		
		/**
		 * @return hyperbolic arcsine = ln(n+sqrt(n²+1)
		 */
		public static function asinh(n:Number):Number{
			return Math.log( n + Math.sqrt( n * n + 1 ) );
		}
		
		/**
		 * @return hyperbolic cosine = (Eª+E-ª)/2
		 */
		public static function cosh(n:Number):Number{
			return ( Math.exp( n ) + Math.exp( -n ) ) / 2;
		}
		
		/**
		 * @return hyperbolic arccosine = ln(n+sqrt(n²-1)
		 */
		public static function acosh(n:Number):Number{
			return Math.log( n + Math.sqrt( n * n - 1 ) );
		}
		
		/**
		 * @return hyperbolic tangent = sinh(n)/cosh(n) = (Eª-E-ª)/(Eª+E-ª)
		 */
		public static function tanh(n:Number):Number{
			var t1:Number = Math.exp( n );
	        var t2:Number = Math.exp( -n );
	        return ( t1 - t2 ) / ( t1 + t2 );
		}
		
		/**
		 * @return hyperbolic arctangent = ln((1+n)/(1-n))/2
		 */
		public static function atanh(n:Number):Number{
			return Math.log( ( 1 + n ) / ( 1 - n ) ) / 2;
		}
		
		/**
		 * @return hyperbolic secant = 1/cosh(n) = 1/(Eª+E-ª)/2
		 */
		public static function sech(n:Number):Number{
			return ( 1 / cosh( n ) );
		}
		
		/**
		 * @return hyperbolic arcsecant = acosh(1/n) = ln((1/n)+sqrt((1/n)²-1)
		 */
		public static function asech(n:Number):Number{
			return ( acosh( 1 / n ) );
		}
		
		/**
		 * @return hyperbolic cosecant = 1/sinh(n) = 1/((Eª-E-ª)/2)
		 */
		public static function csch(n:Number):Number{
			return ( 1 / sinh( n ) );
		}
		
		/**
		 * @return hyperbolic arccosecant = asinh(1/n) = ln((1/n)+sqrt((1/n)²+1)
		 */
		public static function acsch(n:Number):Number{
			return ( asinh( 1 / n ) );
		}
		
		/**
		 * @return hyperbolic cotangent = 1/tanh(n) = 1/(sinh(n)/cosh(n)) = 1/((Eª-E-ª)/(Eª+E-ª))
		 */
		public static function coth(n:Number):Number{
			return ( 1 / tanh( n ) );
		}
		
		/**
		 * @return hyperbolic arccotangent = atanh(1/n) = ln((1+(1/n))/(1-(1/n)))/2
		 */
		public static function acoth(n:Number):Number{
			return ( atanh( 1 / n ) );
		}
		
		/**
		 * @return hyperbolic versine = 1-0.5*(exp(n)+exp(-n))
		 */
		public static function versh(n:Number):Number{
			return 1 - 0.5 * ( Math.exp( n ) + Math.exp( -n ) );
		}
		
		/**
		 * @return hyperbolic coversine = 1-0.5*(exp(n)-exp(-n))
		 */
		public static function coversh(n:Number):Number{
			return 1 - 0.5 * ( Math.exp( n ) - Math.exp( -n ) );
		}
		
		/**
		 * @return hyperbolic haversine 0.5*(1-0.5*(exp(n)+exp(-n)))
		 */
		public static function haversh(n:Number):Number{
			return 0.5 * ( 1 - 0.5 * ( Math.exp( n ) + Math.exp( -n ) ) );
		}
		
		
		
		/////////////////////////////////////////////////////////////////////
	    // Graphics extensions
	    /////////////////////////////////////////////////////////////////////
	    
		/**
		 * @return total distance between 2 points
		 */
		public static function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number{
			var dX:Number = x2 - x1;
	        var dY:Number = y2 - y1;
	        return Math.sqrt( dX * dX + dY * dY );
		}
		
		/**
		 * @return angle of line in degrees
		 */
		public static function angle(x1:Number, y1:Number, x2:Number, y2:Number):Number{
			return Math.atan2( y2 - y1, x2 - x1 ) * 180 / Math.PI;
		}
		
		/**
		 * @return changes a Flash angle into standard position - angle in degrees
		 */
		public static function angle2Standard(angle:Number):Number{
			var ang = 360 - ( ( ( angle %= 360 ) < 0 ) ? angle + 360 : angle );
        	return ( ang == 360 ) ? 0 : ang;
		}
		
		/**
		 * @return angle of line changed from Flash into standard position - angle in degrees
		 */
		public static function lineAngle2Standard(x1:Number, y1:Number, x2:Number, y2:Number):Number{
			var angle = angle(x1, y1, x2, y2);
	        return angle2Standard( angle );
		}
		
		/**
		 * @return dependent sort by number function
		 */
		public static function numSort(a:Number, b:Number):Number{
			return (a - b);
		}
		
		/**
		 * @return average angle
		 * @argument: an array of angles in degrees
		 */
		public static function averageAngle(arr:Array):Number{
			// sort array to prepare for hemisphere check
	        arr.sort( numSort );
			
	        // hemisphere check and summation
	        var len:int = arr.length;
	        var temp = arr[0];
	        for (var j:int = 1; j < len; j++) {
	            if( arr[j] > arr[0] + 180 ){
	                arr[j] = -( 360 - arr[j] );
	            }
	            temp += arr[j];
	        }
			
	        // average of summation
	        temp /= len;
			
	        // change final average angle to a positive reading
	        if ( temp < 0 )
				temp += 360;
	        return temp;
		}
		
		/**
		 * @return the area of a convex or concave, non-self-intersecting polygon
		 * @argument: Vector.<Point>
		 */
		public static function polygonArea(arr:Vector.<Point>):Number{
			var op1:Number, op2:Number;
	        var len:int = arr.length;
	        for(var j:int = 0; j < len - 1; j++) {
	            op1 += arr[j].x * arr[j + 1].y;
	            op2 += arr[j + 1].x * arr[j].y;
	        }
	        return Math.abs( ( ( op1 + ( arr[len - 1].x * arr[0].y ) ) - ( op2 + ( arr[0].x * arr[len - 1].y ) ) ) / 2 );
		}
		
		/**
		 * @return vector Cartesian coordinates - expects to be passed: {a:n,r:n} (angle & radius)
		 */
		public static function toPoint(angle:Number, radius:Number):Point{
			var x:Number = radius * cosD(angle);
        	var y:Number = radius * sinD(angle);
			return new Point(x, y);
		}
		
		/**
		 * @return vector polar coordinates
		 * @argument: Point
		 */
		public static function toPolar(vec:Point):Object{
			var a:Number = atan2D( vec.y, vec.x );
	        var r:Number = Math.sqrt( vec.x * vec.x + vec.y * vec.y );
	        return {angle:a, radius:r};
		}
		
		/**
		 * @return intersection of 2 lines
		 * @arguments: line objects = {p1x:val,p1y:val,p2x:val,p2y:val}
		 */
		public static function intersectLines(line1:Object, line2:Object):Point{
			var m1:Number = ( line1.p1y - line1.p2y ) / ( line1.p1x - line1.p2x );
	        var m2:Number = ( line2.p1y - line2.p2y ) / ( line2.p1x - line2.p2x );
	        if ( m1 == Infinity )
				m1 = 1e304;
	        else if( m1 == -Infinity )
				m1 = -1e304;
	        if ( m2 == Infinity )
				m2 = 1e304;
	        else if( m2 == -Infinity )
				m2 = -1e304;
	        var x1:Number = line1.p1x;
	        var y1:Number = line1.p1y;
	        var x2:Number = line2.p1x;
	        var y2:Number = line2.p1y;
	        var x:Number = ( ( -m2 * x2 ) + y2 + ( m1 * x1 ) - y1 ) / ( m1 - m2 );
	        var y:Number = ( m1 * ( x - x1 ) ) + y1;
	        return new Point(x, y);
		}
		
		
		
		//////////////////////////////////////////////////
	    // Angle conversion functions
	    //////////////////////////////////////////////////
		
		/**
		 * @return string with degrees[:minutes[:seconds]] to decimal deg
		 */
		public static function dms2Deg(dms_str:String):Number{
			var dpos:int = dms_str.indexOf(":");
	        var spos:int = dms_str.lastIndexOf(":");
	        var deg:int, mn:int, sc:int;
			deg = mn = sc = 0;
	        if( spos == dpos )
				spos = -1;
	        if( dpos > 0 ) { // there is a deg and min
	            deg = parseInt( dms_str.substring(0, dpos) );
	            if( spos > 0 ) { // there is a sec
	                mn = parseInt( dms_str.substring(dpos + 1, spos) );
	                sc = parseFloat( dms_str.substring(spos + 1, dms_str.length) );
	            } else { // no sec
	                mn = parseInt( dms_str.substring(dpos + 1, dms_str.length) );
	                sc = 0;
	            }
	        } else { // only deg
	            deg = parseInt(dms_str);
	            mn = 0;
	            sc = 0;
	        }
	        return deg + ( mn + ( sc / 60 ) ) / 60; //decimal degrees
		}
		
		/**
		 * @return decimal degrees to deg:min:sec string
		 */
		public static function deg2Dms(deg:Number):String{
			var adg:int = Math.abs(deg);
	        var fdg:int = Math.floor(adg);
	        var fsc:int = adg * 3600 % 60;
	        var fmn:int = Math.floor(adg * 60 % 60);
	        if (deg < 0)
	        	fdg = -fdg;
	        return fdg.toString() + ":" + fmn.toString() + ":" + fsc.toString();
		}
		
		/**
		 * @return deg in :: out_str = 'dms','rad','multPI'
		 */
		public static function convertDeg(deg:Number, out_str:String):*{
			if (out_str == 'dms')
				return deg2Dms(deg);
	        else if(out_str == 'rad' )
	        	return deg * Math.PI / 180;
	        else if(out_str=='multPI')
	        	return deg / 180;
		}
		
		/**
		 * @return rad in :: out_str = 'dms','deg','multPI'
		 */
		public static function convertRad(rad:Number, out_str:String):*{
			if (out_str=='dms')
				return deg2Dms(rad * 180 / Math.PI);
	        else if(out_str == 'deg')
	        	return rad * 180 / Math.PI;
	        else if(out_str == 'multPI')
	        	return rad / Math.PI;
		}
		
		/**
		 * @return multPI in :: out_str = 'dms','deg','rad'
		 */
		public static function convertMultPI(dms_str:String, out_str:String):Number{
			var x:Number = dms2Deg(dms_str);
	        if (out_str == 'multPI')
	        	return x / 180;
	        else if(out_str == 'deg')
	        	return  x;
	        else if(out_str == 'rad')
	        	return  x * Math.PI / 180;
		}



		/////////////////////////////////////////////////////////////////////
	    // Miscellaneous number extensions
	    /////////////////////////////////////////////////////////////////////
		
		/**
		 * @return the natural logarithm of "n"
		 */
		public static function ln(a:Number):Number{
			return Math.log(a);
		}
		
		/**
		 * @return the logarithm with base "a" of "n"
		 */
		public static function log_a(a:Number, n:Number):Number{
			return (Math.log(n) / Math.log(a));
		}
		
		/**
		 * @return the sign of the number
		 */
		public static function sign(n:Number):Number{
			return (n == 0)? 0 : ((n > 0) ? 1 : -1);
		}
		
		/**
		 * @return rounds "a" to "b" number of decimal places
		 */
		public static function placesRound(a:Number, b:int):Number{
			return (Math.round(a * Math.pow(10, b)) / Math.pow(10, b));
		}
		
		/**
		 * @return a random number between "a" and "b"
		 */
		public static function randomBetween(a:Number, b:Number):Number{
			var greater:Number = Math.max(a,b);
	        var smaller:Number = Math.min(a,b);
	        return (Math.random() * (greater - smaller) + smaller);
		}
		
		/**
		 * @return the sum of all the numbers between one and "n" raised to the "x" power.
		 */
		public static function summation(n:int, x:int):Number{
			var sum:int = 0;
	        for (var j:int = 1; j <= n; j++) {
	            sum += Math.pow(j, x);
	        }
	        return sum;
		}
		
		/**
		 * @return product of "arr" elements
		 */
		public static function product(arr:Array):Number{
			var k = 1;
	        for (var h:int = 0; h < arr.length; h++){
	        	k *= arr[h];
	        }
	        return k;
		}
		
		/**
		 * @return sum of "arr" elements
		 */
		public static function sum(arr:Array):Number{
			var k:int = 0;
	        for (var h:int = 0; h < arr.length; h++){
	        	k += arr[h];
	        }
	        return k;
		}
		
		/**
		 * @return the square of a number
		 */
		public static function square(n:Number):Number{
			return n * n;			
		}
		
		/**
		 * @return the inverse of a number
		 */
		public static function inverse(n:Number):Number{
			return 1 / n;
		}
		
		/**
		 * @return the decimal portion of a floating point number
		 */
		public static function portion(n:Number):Number{
			return n - Math.floor(n);
		}
		
		/**
		 * @return solves the negative value input bug
		 */
		public static function pow2(a:Number, n:int):Number{
			return (a == 0) ? 0 : ((a > 0) ? Math.pow(a, n) : Math.pow(a * -1, n) * -1);
		}
		
		/**
		 * @return the nth root of a number
		 */
		public static function nRoot(a:int, n:int):Number{
			return pow2(a, 1 / n);
		}
	}
}
