package fwk.text {	

	import flash.text.Font;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.text.StyleSheet;
	import fwk.interfaces.IFontManager;
	
	/**
	 * A font manager to register fonts easely
	 */
	public class FontManager extends MovieClip implements IFontManager {
		

		private var tabFontsRegistered:Array;
		private var tabFontsClassToRegister:Array;
		private var _fontRegistered:Boolean = false;
		
		/**
		 * Create an instance of FontManager
		 */
		function FontManager(){
			trace("new FontManager");
			
			tabFontsRegistered = new Array();
			tabFontsClassToRegister = new Array();
		}
		/**
		 * Add a font class name in the fontManager
		 * @param className A className of a font in the flash library
		 */
		public function addFontClass(className:String):void { 
			tabFontsClassToRegister.push(className);
			trace("addFontClass " + className);
		}
		/**
		 * Regiter all fonts added in the fontManager
		 */
		public function registerFonts():void { 
			trace("// FontManager");
			if(!_fontRegistered){
				_fontRegistered = true;
				for(var i=0;i<tabFontsClassToRegister.length;i++){
					addNewFont(tabFontsClassToRegister[i]);
				}
			}
		}
		//-----------------------------------------------------------------------
		private function addNewFont ( className:String ) { 
			var _f = getDefinitionByName( className ) as Class;
			Font.registerFont( _f );
			
			trace("   -- addNewFont New Font : " + className);
			tabFontsRegistered.push(className);
		}
		
	}
}
