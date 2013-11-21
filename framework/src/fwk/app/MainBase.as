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

package fwk.app {
	import fwk.app.pages.AbstractPage;
	import fwk.app.pages.events.PageEvents;
	import fwk.app.transitions.TransitionType;
	import fwk.app.vars.DepthContainer;
	import fwk.debug.DebugPanel;
	import fwk.text.TextDisplay;
	import fwk.utils.assets.AssetsManager;
	import fwk.utils.assets.events.AssetsManagerEvents;
	import fwk.utils.loaders.AbstractLoaderPage;
	import fwk.utils.loaders.DefaultLoaderPage;
	import fwk.utils.loaders.LoaderXML;
	import fwk.utils.loaders.events.LoaderEvents;
	import fwk.utils.types.boolean.parseBoolean;

	import net.hires.debug.Stats;

	import com.app.Config;

	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.KeyboardEvent;
	import flash.net.getClassByAlias;
	import flash.system.Capabilities;
	import flash.text.Font;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getDefinitionByName;





	/**
	 * @author renaud.cousin
	 */
	public class MainBase extends MovieClip implements IMainBase {

		protected var debugContainer:Sprite;
		protected var topContainer:Sprite;
		protected var middleContainer:Sprite;
		protected var bottomContainer:Sprite;
		
		protected var debug:DebugPanel;
		protected var loaderPage:AbstractLoaderPage;
		protected var configLoader:LoaderXML;
		protected var config:XML;
		
		private var cachePages:Boolean = true;
		private var pagesCached:Vector.<AbstractPage> = new Vector.<AbstractPage>();
		private var maxCachedPages:int = 20;
		
		protected var _sharedPath:String;
		protected var _countryPath:String;
		protected var _currentPage:AbstractPage;
		protected var _previousPage:AbstractPage;
		protected var _datas:XML;
		protected var css:String;
		protected var _assets:Object = {};
		protected var _transitionsType:String = TransitionType.PRELOAD;
		
		protected var stats:Stats;
		
		/*
		 * On exit : kill app or just sleep
		 */
		protected var runInBackground:Boolean = false;
		
		private var _textDisplayer:TextDisplay;
		

		public function MainBase() {
			init();
		}
		

		// ----------------------------------------------------------------------
		// E V E N T S
		// ----------------------------------------------------------------------
		
		protected function onAppDesactivate(event:Event):void {
			DebugPanel.trace("[DEACTIVATE]", "#FF33FF");
			
			if(!runInBackground)
				killApp();
		}

		protected function onAppActivate(event:Event):void {
			DebugPanel.trace("[ACTIVATE]", "#FF33FF");
		}

		private function onConfigLoaded(event:LoaderEvents):void {
			trace("CONFIG LOADED");

			config = (event.target as LoaderXML).data;
			clearConfigLoader();

			configureGlobalVars();
			loadAssets();
		}

		private function onConfigError(event:LoaderEvents):void {
			clearConfigLoader();
			trace("CONFIG ERROR");
		}

		private function onGlobalAssetsLoaded(event:AssetsManagerEvents):void {
			_assets = event.assets;

			(event.target as AssetsManager).removeEventListener(AssetsManagerEvents.ASSETS_LOADED, onGlobalAssetsLoaded);
			(event.target as AssetsManager).removeEventListener(AssetsManagerEvents.ASSETS_PROGRESS, onAssetsProgress);

			_datas = _assets["datas"];
			css = _assets["css"];
			_textDisplayer 	= new TextDisplay(css);

			launchFirstPage();
		}

		protected function onResizeScreen(event:Event):void {
			DebugPanel.trace("[RESIZE] => " + stage.stageWidth + "x" + stage.stageHeight, "#0066BB");

			if (loaderPage != null) {
				loaderPage.resize();
			}

			DebugPanel.resize();
		}

		private function onPageAssetsLoaded(event:AssetsManagerEvents):void {
			var pageAssets:Object = event.assets;
			_currentPage.assets = pageAssets;
			removeLoading();
			
			var dependenciesAssets:Object = event.dependenciesAssets;
			var page:AbstractPage;
			var klass:Class;
			for(var pageID:String in dependenciesAssets){
				
				_currentPage.dependenciesNames.push(pageID);
				if(_previousPage != null && _previousPage.dependenciesNames.indexOf(pageID) != -1){
					_currentPage.dependencies.push(_previousPage.dependencies[_previousPage.dependenciesNames.indexOf(pageID)]);
				} else {
					klass = getClassByAlias(pageID) as Class;
					page = new klass() as AbstractPage;
					page.assets = dependenciesAssets[pageID];
					page.parentContainerDepth = (config.pages.child(pageID).@depth != undefined)? config.pages.child(pageID).@depth : DepthContainer.MIDDLE ;
					depthContainer(page.parentContainerDepth).addChild(page);
					page.init();
					_currentPage.dependencies.push(page);
				}
			}
			
			
			(event.target as AssetsManager).removeEventListener(AssetsManagerEvents.ASSETS_LOADED, onPageAssetsLoaded);
			(event.target as AssetsManager).removeEventListener(AssetsManagerEvents.ASSETS_PROGRESS, onAssetsProgress);
			
			constructPage();
		}

		private function onPageCloseComplete(event:PageEvents):void {
			if(_transitionsType == TransitionType.PRELOAD && event.target == _previousPage)
				_currentPage.displayPage();
			
			// TODO => if isCached
			if(depthContainer((event.target as AbstractPage).parentContainerDepth).contains(event.target as AbstractPage))
				depthContainer((event.target as AbstractPage).parentContainerDepth).removeChild(event.target as AbstractPage);			
		}

		private function onPageDisplayComplete(event:PageEvents):void {
			Config.firstLoad = false;
			
			if(_transitionsType == TransitionType.REVERSE && _previousPage != null)
				_previousPage.closePage();
		}

		private function onKeyboardDown(event:KeyboardEvent):void {
			if(!DebugPanel.onKeyDown(event)){
				if((event.keyCode == Keyboard.BACK || event.keyCode == Keyboard.EXIT) && cachePages){
					event.preventDefault();
					event.stopImmediatePropagation();
					goPrevious();
				}
			}
		}

		private function onAssetsProgress(event:AssetsManagerEvents):void {
			trace("ASSETS LOADING:", (event.target as AssetsManager).globalProgressPercent + "%");
			
			if(loaderPage != null) {
				loaderPage.setProgress((event.target as AssetsManager).globalProgressPercent);
			}
		}


		// ----------------------------------------------------------------------
		// P R I V A T E
		// ----------------------------------------------------------------------

		private function loadConfig():void {
			configLoader = new LoaderXML("xml/appConfig.xml");
			configLoader.addEventListener(LoaderEvents.LOAD_COMPLETE, onConfigLoaded);
			configLoader.addEventListener(LoaderEvents.LOAD_ERROR, onConfigError);
			configLoader.load();

//			addLoading();
		}

		private function clearConfigLoader():void {
			if (configLoader != null) {
				configLoader.removeEventListener(LoaderEvents.LOAD_COMPLETE, onConfigLoaded);
				configLoader.removeEventListener(LoaderEvents.LOAD_ERROR, onConfigError);
				configLoader = null;
			}
		}

		private function loadAssets():void {
			var nbGlobalAssets:int = config.globalAssets.children().length();
			if (nbGlobalAssets == 0) {
				launchFirstPage();
			} else {
				addLoading();
				var assetsManager:AssetsManager = new AssetsManager();
				assetsManager.addEventListener(AssetsManagerEvents.ASSETS_LOADED, onGlobalAssetsLoaded);
				assetsManager.addEventListener(AssetsManagerEvents.ASSETS_PROGRESS, onAssetsProgress);
				assetsManager.loadAssets(config.globalAssets[0]);
			}
		}
		
		private function loadPageAssets(id:String):void{
			var nbAssets:int = config.pages.child(id).children().length();
			if (nbAssets == 0 && (config.pages.child(id).@dependencies == "" || config.pages.child(id).@dependencies == undefined || config.pages.child(id).@dependencies == "undefined")) {
				constructPage();
			} else {
				addLoading(config.pages.child(id).@loaderPage);
				var pageAssetsManager:AssetsManager = new AssetsManager();
				pageAssetsManager.addEventListener(AssetsManagerEvents.ASSETS_LOADED, onPageAssetsLoaded, false, 0, true);
				pageAssetsManager.addEventListener(AssetsManagerEvents.ASSETS_PROGRESS, onAssetsProgress, false, 0, true);
				pageAssetsManager.loadAssets(new XML(config.pages.child(id)[0]));
			}
		}
		
		private function constructPage(needInit:Boolean = true):void{
			if(needInit)
				_currentPage.init();
			depthContainer(_currentPage.parentContainerDepth).addChild(_currentPage);
			
			launchTransition();
		}
		
		private function launchTransition():void{
			if(_transitionsType == TransitionType.CROSS || _transitionsType == TransitionType.REVERSE){
				_currentPage.displayPage();
				if(_transitionsType == TransitionType.CROSS && _previousPage != null)
					_previousPage.closePage();
			} else if(_transitionsType == TransitionType.PRELOAD){
				if(_previousPage != null)
					_previousPage.closePage();
				else
					_currentPage.displayPage();
			} else {
				throw new Error("Invalid transition type:" + _transitionsType);
//				trace("INVALID TRANSITION TYPE");
//				DebugPanel.trace("INVALID TRANSITION TYPE", "#DD0000");
			}
		}
		
		private function launchFirstPage():void{
			removeLoading();
			registerPagesClass();
			
			checkFontName();
			onReady();
		}

		private function activePageEvents():void {
			if(_previousPage != null){
				if(!_previousPage.hasEventListener(PageEvents.DISPLAY_COMPLETE)){
					_previousPage.addEventListener(PageEvents.DISPLAY_COMPLETE, onPageDisplayComplete);
					_previousPage.addEventListener(PageEvents.CLOSE_COMPLETE, onPageCloseComplete);
				}
			}
			if(_currentPage != null){
				if(!_currentPage.hasEventListener(PageEvents.DISPLAY_COMPLETE)){
					_currentPage.addEventListener(PageEvents.DISPLAY_COMPLETE, onPageDisplayComplete);
					_currentPage.addEventListener(PageEvents.CLOSE_COMPLETE, onPageCloseComplete);
				}
			}
		}
		
		
		// ----------------------------------------------------------------------
		// P R O T E C T E D
		// ----------------------------------------------------------------------
		
		protected function init():void {
			bottomContainer = new Sprite();
			addChild(bottomContainer);
			middleContainer = new Sprite();
			addChild(middleContainer);
			topContainer = new Sprite();
			addChild(topContainer);
			
			debugContainer = new Sprite();
			addChild(debugContainer);
			
			initAppGlobalSettings();
			loadConfig();
		}

		protected function initAppGlobalSettings():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;

			stage.addEventListener(Event.RESIZE, onResizeScreen);

			// MULTITOUTCH INPUT MODE
			Multitouch.inputMode = MultitouchInputMode.GESTURE;

			// PREVENT FROM PHONE SLEEPING MODE
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;

			// FORCE KILLING APP AFTER CLOSING INSTEAD OF RUNNING IT IN BACKGROUND
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onAppDesactivate);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onAppActivate);
		}
		
		protected function configureGlobalVars():void{
			Config.defaultLanguage = config.languages.@default;
			Config.supportedLanguages = String(config.languages.@supported).split("/");
			Config.language = (Config.supportedLanguages.indexOf(Capabilities.language) != -1)? Capabilities.language : Config.defaultLanguage ;
			
			_sharedPath = config.paths.@sharedPath;
			_countryPath = String(config.paths.@countryPath).replace("%LANGUAGE%", Config.language);
			
			Config.debugMod = parseBoolean(config.debug.@debugMod);
			trace("set useStats:", config.debug.@useStats, parseBoolean(config.debug.@useStats));
			Config.useStats = parseBoolean(config.debug.@useStats);
			
			if(config.app.length() == 1){
				Config.APP_WIDTH = parseInt(config.app.@width);
				Config.APP_HEIGHT = parseInt(config.app.@height);
			} else {
				Config.APP_WIDTH = stage.stageWidth;
				Config.APP_HEIGHT = stage.stageHeight;
			}
			
			if(config.transitions.length() == 1){
				_transitionsType = config.transitions.@type;
				Config.useBitmapTransition = parseBoolean(config.transitions.@useBitmap);
			}
			
			if(config.onExit.length() == 1)
				runInBackground = parseBoolean(config.onExit.@sleep);
			
			if(config.pages.@cache != undefined)
				cachePages = parseBoolean(config.pages.@cache);
			
			if(config.pages.@maxCached != undefined)
				maxCachedPages = parseInt(config.pages.@maxCached);
			
			//if(cachePages){
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			//}
		}

		protected function addLoading(customLoaderClass:String = ""):void {
			var customLoader:Class;
			if(config != null){
				if(customLoaderClass != "" && customLoaderClass != null && customLoaderClass != "undefined")
					customLoader = getDefinitionByName(customLoaderClass) as Class;
				else if(config.pages.@loaderPage != undefined && config.pages.@loaderPage != "")
					customLoader = getDefinitionByName(config.pages.@loaderPage) as Class;
			}
			
			if(customLoader != null)
				loaderPage = new customLoader() as AbstractLoaderPage;
			else
				loaderPage = new DefaultLoaderPage();
			
			addChild(loaderPage);
			loaderPage.resize();
			loaderPage.display();
		}

		protected function removeLoading():void {
			if(loaderPage != null) {
				loaderPage.close();
			}
		}

		protected function setDebug():void {
			trace("useStats:", Config.useStats);
			if(Config.useStats){
				if(stats == null){
					trace("addStats();");
					stats = new Stats();
					debugContainer.addChild(stats);
				}
			}
			
			if(Config.debugMod){
				if(debug == null){
					debug = DebugPanel.getInstance();
					debugContainer.addChild(debug);
				}
			}
			
			DebugPanel.trace("OS: " + Capabilities.os, "#aa00aa");
			trace("OS:", Capabilities.os);
		}

		protected function registerPagesClass():void {
			// XXX => TO BE OVERRIDEN
			/*
			 * need to register class alias for each page class to be accessible in loadAndDisplayPage function
			 */
		}

		protected function onReady():void {
			setDebug();
			onResizeScreen(null);

			var firstPageToLoad:String = (config.pages.@default != "" && config.pages.@default != undefined)? config.pages.@default : config.pages.children()[0].localName() ;
			loadAndDisplayPage(firstPageToLoad);
		}
		
		protected function checkFontName():void // INUTILISE -> UNIQUEMENT AU DEBUT POUR LES NOMS DE TYPOS EN CSS
 		{
			var arr:Array = Font.enumerateFonts();
			for (var i:int = 0; i < arr.length; i++ ) {
				trace("[FONTS] :: fontName:", arr[i], Font(arr[i]).fontName);
			}
		}
		
		protected function checkIfPageExists(klass:Class):AbstractPage{
			var page:AbstractPage = null;
			for(var i:int = 0; i < pagesCached.length; i++){
//				trace("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", pagesCached[i], klass, pagesCached[i] is klass);
				if(pagesCached[i] is klass){
					page = pagesCached[i];
					break;
				}
			}
			return page;
		}


		// ----------------------------------------------------------------------
		// P U B L I C
		// ----------------------------------------------------------------------
		
		public function loadAndDisplayPage(id:String):void {
			trace("LOAD AND DISPLAY PAGE:", id);
			DebugPanel.trace("LOAD AND DISPLAY PAGE:" + id, "#22AA88");
			
			_previousPage = _currentPage;
			if(_previousPage != null)
				_previousPage.desactive();
			
			var klass:Class = getClassByAlias(id);
			
			var existingPage:AbstractPage = checkIfPageExists(klass);
			if(cachePages && existingPage != null){
				_currentPage = existingPage;
			} else {
				_currentPage = new klass() as AbstractPage;
				_currentPage.isCached = (config.pages.child(id).@cache != undefined)? parseBoolean(config.pages.child(id).@cache) : cachePages ;
			}
			
			_currentPage.parentContainerDepth = (config.pages.child(id).@depth != undefined)? config.pages.child(id).@depth : DepthContainer.MIDDLE ;
			
			if(cachePages && _currentPage.isCached){
				pagesCached.push(_currentPage);
				if(pagesCached.length > maxCachedPages)
					pagesCached.shift();
			}
			
			activePageEvents();
			
			if(existingPage == null){
				loadPageAssets(id);
			} else {
				_currentPage.reinit();
				constructPage(false);
			}
		}
		
		public function initTextFromString(mcT:MovieClip, label:String, style:String, scopeFunction:Function = null):void{
			if( _textDisplayer != null)
				_textDisplayer.initTextFromString(mcT, label, style, scopeFunction);
		}
		
		public function depthContainer(depth:String):Sprite{
			var container:Sprite;
			switch(depth){
				case DepthContainer.TOP:
					container = topContainer;
					break;
				case DepthContainer.MIDDLE:
					container = middleContainer;
					break;
				case DepthContainer.BOTTOM:
					container = bottomContainer;
					break;
				default:
					throw new Error("Invalid depth container: " + depth);
					break;
			}
			return container;
		}
		
		public function goPrevious():void{
			if(cachePages && pagesCached.length > 1){
				if(_currentPage.isCached)
					pagesCached.pop();
				
				_previousPage = _currentPage;
				_currentPage = pagesCached[pagesCached.length -1];
				
				_currentPage.reinit();
				
				constructPage(!_currentPage.isCached);
			} else {
				killApp();
			}
		}
		
		public function killApp():void{
			NativeApplication.nativeApplication.exit();
		}
		
		public function getDependencyAssets(id:String):XML{
			var xml:XML;
			if(_previousPage == null || _previousPage.dependenciesNames.indexOf(id) == -1){
				xml = config.pages.child(id)[0];
			} else {
				xml = null;
			}
			return xml;
		}
		
		public function switchLanguage(language:String):void{
			pagesCached = new Vector.<AbstractPage>();
			
			trace("++++++ SWITCH LANGUAGE ++++++", language);
			if(Config.supportedLanguages.indexOf(language) != -1){
				Config.language = language;
				_countryPath = String(config.paths.@countryPath).replace("%LANGUAGE%", Config.language);
				loadAssets();
			} else {
				DebugPanel.trace("[ERROR] :: language " + language + " not supported", "#FF0000", true);
				throw new Error("LANGUAGE " + language + " NOT SUPPORTED => SWITCHED TO " + Config.defaultLanguage);
			}
		}
		

		// ----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		// ----------------------------------------------------------------------
		
		public function get currentPage():AbstractPage {
			return _currentPage;
		}
		
		public function get previousPage():AbstractPage {
			return _previousPage;
		}

		public function get datas():XML {
			return _datas;
		}

		public function get sharedPath():String {
			return _sharedPath;
		}

		public function get countryPath():String {
			return _countryPath;
		}

		public function get assets():Object {
			return _assets;
		}

		public function get transitionsType():String {
			return _transitionsType;
		}

		public function set transitionsType(value:String):void {
			_transitionsType = value;
		}
	}
}