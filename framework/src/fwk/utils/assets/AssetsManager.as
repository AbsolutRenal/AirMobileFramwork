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

package fwk.utils.assets {
	import fwk.debug.DebugPanel;
	import fwk.utils.assets.events.AssetsManagerEvents;
	import fwk.utils.loaders.AbstractLoader;
	import fwk.utils.loaders.LoaderImg;
	import fwk.utils.loaders.LoaderMc;
	import fwk.utils.loaders.LoaderMp3;
	import fwk.utils.loaders.LoaderText;
	import fwk.utils.loaders.LoaderXML;
	import fwk.utils.loaders.events.LoaderEvents;

	import com.app.Config;

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * @author renaud.cousin
	 */
	public class AssetsManager  extends EventDispatcher{
		private const PROGRESS_INTERVAL:uint = 125;
		
		private var assets:Object = {};
		private var nbAssets:uint;
		private var nbLoadedAssets:uint = 0;
		private var assetsTotalBytesArr:Dictionary = new Dictionary();
		private var assetsXML:XML;
		private var assetsTotalBytes:uint = 0;
		private var assetsBytesLoaded:Dictionary = new Dictionary();
		private var loadersVect:Vector.<AbstractLoader> = new Vector.<AbstractLoader>();
		
		private var progressTimer:Timer;
		
		private var dependencies:Array;
		private var dependenciesAssets:Object = {};
		
		private var _globalProgressPercent:uint = 0;
		
		public function AssetsManager(){
		}
		
		
		//----------------------------------------------------------------------
		// E V E N T S
		//----------------------------------------------------------------------

		private function onLoadError(event:LoaderEvents):void {
			trace("ERROR LOADING ASSET:", (event.target as AbstractLoader).id);
			DebugPanel.trace("ERROR LOADING ASSET: " + (event.target as AbstractLoader).id, "#FFAA88", true);
			
			loadersVect.splice(loadersVect.indexOf(event.target as AbstractLoader), 1);
			
			killLoader(event);
			checkLoadedAssets();
		}
		
		private function onXmlLoadComplete(event:LoaderEvents):void {
			var id:String = (event.target as AbstractLoader).id;
			if(!checkIfDependencyAsset(id)){
				assets[id] = (event.target as LoaderXML).data;
			} else {
				var dependentPage:String = id.split(".")[0];
				if(dependenciesAssets[dependentPage] == null || dependenciesAssets[dependentPage] == undefined){
					dependenciesAssets[dependentPage] = {};
				}
				dependenciesAssets[dependentPage][id.split(".")[1]] = (event.target as LoaderXML).data;
			}
			
			killLoader(event);
			checkLoadedAssets();
		}
		
		private function onMp3LoadComplete(event:LoaderEvents):void {
			var id:String = (event.target as AbstractLoader).id;
			if(!checkIfDependencyAsset(id)){
				assets[id] = (event.target as LoaderMp3).data;
			} else {
				var dependentPage:String = id.split(".")[0];
				if(dependenciesAssets[dependentPage] == null || dependenciesAssets[dependentPage] == undefined){
					dependenciesAssets[dependentPage] = {};
				}
				dependenciesAssets[dependentPage][id.split(".")[1]] = (event.target as LoaderMp3).data;
			}
			
			killLoader(event);
			checkLoadedAssets();
		}


		private function onImgLoadComplete(event:LoaderEvents):void {
			var id:String = (event.target as AbstractLoader).id;
			if(!checkIfDependencyAsset(id)){
				assets[id] = (event.target as LoaderImg).data;
			} else {
				var dependentPage:String = id.split(".")[0];
				if(dependenciesAssets[dependentPage] == null || dependenciesAssets[dependentPage] == undefined){
					dependenciesAssets[dependentPage] = {};
				}
				dependenciesAssets[dependentPage][id.split(".")[1]] = (event.target as LoaderImg).data;
			}
			
			killLoader(event);
			checkLoadedAssets();
		}

		private function onMcLoadComplete(event:LoaderEvents):void {
			var id:String = (event.target as AbstractLoader).id;
			if(!checkIfDependencyAsset(id)){
				assets[(event.target as AbstractLoader).id] = (event.target as LoaderMc).data;
			} else {
				var dependentPage:String = id.split(".")[0];
				if(dependenciesAssets[dependentPage] == null || dependenciesAssets[dependentPage] == undefined){
					dependenciesAssets[dependentPage] = {};
				}
				dependenciesAssets[dependentPage][id.split(".")[1]] = (event.target as LoaderMc).data;
			}
			
			killLoader(event);
			checkLoadedAssets();
		}

		private function onCssLoadComplete(event:LoaderEvents):void {
			var id:String = (event.target as AbstractLoader).id;
			if(!checkIfDependencyAsset(id)){
				assets[(event.target as AbstractLoader).id] = (event.target as LoaderText).data;
			} else {
				var dependentPage:String = id.split(".")[0];
				if(dependenciesAssets[dependentPage] == null || dependenciesAssets[dependentPage] == undefined){
					dependenciesAssets[dependentPage] = {};
				}
				dependenciesAssets[dependentPage][id.split(".")[1]] = (event.target as LoaderText).data;
			}
			
			killLoader(event);
			checkLoadedAssets();
		}

		private function killLoader(event:LoaderEvents):void {
			(event.target as AbstractLoader).removeEventListener(LoaderEvents.LOAD_ERROR, onLoadError);
			
			if(event.target is LoaderXML)
				(event.target as LoaderXML).removeEventListener(LoaderEvents.LOAD_COMPLETE, onXmlLoadComplete);
				
			else if(event.target is LoaderMc)
				(event.target as LoaderMc).removeEventListener(LoaderEvents.LOAD_COMPLETE, onMcLoadComplete);
				
			else if(event.target is LoaderImg)
				(event.target as LoaderImg).removeEventListener(LoaderEvents.LOAD_COMPLETE, onImgLoadComplete);
				
			else if(event.target is LoaderText)
				(event.target as LoaderText).removeEventListener(LoaderEvents.LOAD_COMPLETE, onCssLoadComplete);
				
			else if(event.target is LoaderMp3)
				(event.target as LoaderMp3).removeEventListener(LoaderEvents.LOAD_COMPLETE, onMp3LoadComplete);
		}

		private function onLoadersLoadProgress(event:LoaderEvents):void {
			assetsBytesLoaded[event.target as AbstractLoader] = parseInt(event.data);
		}

		private function onAssetsProgress(event:TimerEvent):void {
			var tmp:uint = 0;
			for(var i:int = 0; i < loadersVect.length; i++){
				tmp += assetsBytesLoaded[loadersVect[i]];
			}
			_globalProgressPercent = Math.round(tmp * 100) / assetsTotalBytes;
			
			dispatchEvent(new AssetsManagerEvents(AssetsManagerEvents.ASSETS_PROGRESS, null));
		}
		
		
		//----------------------------------------------------------------------
		// P R I V A T E
		//----------------------------------------------------------------------
		
		private function load():void{
			var url:String = "";
			var loader:AbstractLoader;
			
			loadersVect = new Vector.<AbstractLoader>();
			
			nbLoadedAssets = 0;
			
			for(var i:int = 0; i < nbAssets; i++){
				url = "";
				if(assetsXML.children()[i].@path != "" && assetsXML.children()[i].@path != undefined){
					url = Config.main[assetsXML.children()[i].@path];
				}					
				url += assetsXML.children()[i].@src;
				
				switch(assetsXML.children()[i].localName()){
					case AssetType.XML:
						loader = new LoaderXML(url);
						loader.addEventListener(LoaderEvents.LOAD_COMPLETE, onXmlLoadComplete);
						break;
					case AssetType.SWF:
						loader = new LoaderMc(url);
						loader.addEventListener(LoaderEvents.LOAD_COMPLETE, onMcLoadComplete);
						break;
					case AssetType.IMG:
						loader = new LoaderImg(url);
						loader.addEventListener(LoaderEvents.LOAD_COMPLETE, onImgLoadComplete);
						break;
					case AssetType.CSS:
						loader = new LoaderText(url);
						loader.addEventListener(LoaderEvents.LOAD_COMPLETE, onCssLoadComplete);
						break;
					case AssetType.MP3:
						loader = new LoaderMp3(url);
						loader.addEventListener(LoaderEvents.LOAD_COMPLETE, onMp3LoadComplete);
						break;
					
				}
				loadersVect.push(loader);
				assetsBytesLoaded[loader] = 0;
				
				loader.addEventListener(LoaderEvents.LOAD_ERROR, onLoadError);
				loader.addEventListener(LoaderEvents.LOAD_PROGRESS, onLoadersLoadProgress);
				loader.id = assetsXML.children()[i].@id;
				trace("Load Asset: type:", assetsXML.children()[i].localName(), " / id =", assetsXML.children()[i].@id);
				loader.load();
			}
			
			progressTimer = new Timer(PROGRESS_INTERVAL);
			progressTimer.addEventListener(TimerEvent.TIMER, onAssetsProgress);
			progressTimer.start();
		}
		
		private function checkLoadedAssets():void {
			nbLoadedAssets++;
			
			if(nbLoadedAssets == nbAssets){
				progressTimer.stop();
				progressTimer.removeEventListener(TimerEvent.TIMER, onAssetsProgress);
				progressTimer = null;
				
				dispatchEvent(new AssetsManagerEvents(AssetsManagerEvents.ASSETS_LOADED, assets, dependenciesAssets));
			}
		}
		
		private function checkIfDependencyAsset(id:String):Boolean{
			var isDependencyAsset:Boolean = false;
			var idArr:Array = id.split(".");
			if(idArr.length > 1 && dependencies.indexOf(idArr[0]) != -1)
				isDependencyAsset = true;
			
			return isDependencyAsset;
		}
		
		
		//----------------------------------------------------------------------
		// P U B L I C
		//----------------------------------------------------------------------
		
		public function loadAssets(assetsXML:XML):void{
			if(assetsXML.@dependencies != undefined && assetsXML.@dependencies != ""){
				var dependenciesStr:String = assetsXML.@dependencies;
				while(dependenciesStr.search(" ") != -1){
					dependenciesStr = dependenciesStr.replace(" ", "");
				}
				dependencies = dependenciesStr.split(",");
				for(var n:int = 0; n < dependencies.length; n++){
					var tmpXML:XML = Config.main.getDependencyAssets(dependencies[n]);
					
					if(tmpXML != null){
						var formatedNode:String;
						if(tmpXML.children().length()){
							for(var k:int = 0; k < tmpXML.children().length(); k++){
								formatedNode = tmpXML.children()[k].toXMLString().split('id="').join('id="' + dependencies[n] + '.');
								assetsXML.appendChild(XML(formatedNode));
							}
						} else {
							// POUR FORCER L'OUVERTURE DE LA PAGE DEPENDENTE
							dependenciesAssets[dependencies[n]] = "No assets for that dependency";
						}
					} else {
						// PERMET D'EVITER DE CHARGER DES ASSETS DEJA CHARGES
						dependenciesAssets[dependencies[n]] = "assets already loaded by previous page";
					}
				}
			}
			
			this.assetsXML = assetsXML;
			nbAssets = assetsXML.children().length();
			
			trace("----------------- ASSETS -----------------");
			trace(assetsXML.toXMLString());
			trace("----------------- ASSETS -----------------");
			
			if(nbAssets > 0){
				var url:String = "";
				var loader:AbstractLoader;
				
				for(var i:int = 0; i < nbAssets; i++){
					url = "";
					if(assetsXML.children()[i].@path != "" && assetsXML.children()[i].@path != undefined){
						url = Config.main[assetsXML.children()[i].@path];
					}					
					url += assetsXML.children()[i].@src;
					
					switch(assetsXML.children()[i].localName()){
						case AssetType.XML:
							loader = new LoaderXML(url);
							break;
						case AssetType.SWF:
							loader = new LoaderMc(url);
							break;
						case AssetType.IMG:
							loader = new LoaderImg(url);
							break;
						case AssetType.CSS:
							loader = new LoaderText(url);
							break;
						case AssetType.MP3:
							loader = new LoaderMp3(url);
							break;
						default:
							throw new Error("Invalid asset type: " + assetsXML.children()[i].localName());
							break;
					}
					
					loadersVect.push(loader);
					assetsTotalBytesArr[loader] = 0;
					
					loader.addEventListener(LoaderEvents.BYTES_TOTAL_KNOWN, onAssetBytesSuccess);
					loader.addEventListener(LoaderEvents.LOAD_ERROR, onGetAssetBytesError);
					loader.id = assetsXML.children()[i].@id;
					loader.load();
				}
			} else {
				dispatchEvent(new AssetsManagerEvents(AssetsManagerEvents.ASSETS_LOADED, assets, dependenciesAssets));
			}
		}

		private function onAssetBytesSuccess(event:LoaderEvents):void {
			assetsTotalBytesArr[event.target] = event.data;
			getAssetBytes(event);
		}

		private function onGetAssetBytesError(event:LoaderEvents):void {
			loadersVect.splice(loadersVect.indexOf(event.target as AbstractLoader), 1);
			
			getAssetBytes(event);
		}
		
		private function getAssetBytes(event:LoaderEvents):void{
			(event.target as AbstractLoader).removeEventListener(LoaderEvents.BYTES_TOTAL_KNOWN, onAssetBytesSuccess);
			(event.target as AbstractLoader).removeEventListener(LoaderEvents.LOAD_ERROR, onGetAssetBytesError);
			(event.target as AbstractLoader).stopLoading();

			nbLoadedAssets++;
			
			if(nbLoadedAssets == nbAssets){
				for(var i:int = 0; i < loadersVect.length; i++){
					assetsTotalBytes += assetsTotalBytesArr[loadersVect[i]];
				}
				trace("ASSETS TOTAL BYTES TO LOAD:", assetsTotalBytes);
				
				load();
			}
		}
		
		
		//----------------------------------------------------------------------
		// G E T T E R / S E T T E R
		//----------------------------------------------------------------------
		
		public function get globalProgressPercent():int{
			return _globalProgressPercent;
		}
	}
}
