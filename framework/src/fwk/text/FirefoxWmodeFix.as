﻿package fwk.text {			import flash.text.TextField;        import flash.events.Event;        import flash.events.KeyboardEvent;        import flash.system.Capabilities;        public class FirefoxWmodeFix        {                               private static var usedKey:Array = new Array();                private static var usedShiftKey:Boolean;                private static var sLang:String;                private static var sCurrentText:String;                               public static function firefoxWmodeFix(_field:TextField):void                {                        sLang = Capabilities.language.substr(0,2);                        _field.addEventListener(Event.CHANGE, onFieldChangeHandler);                        _field.addEventListener(KeyboardEvent.KEY_DOWN, onFieldKeyDownHandler);                }                               private static function onFieldChangeHandler(evt:Event):void                {                        sCurrentText = evt.target.text;                        if(sLang == "fr")                        {                                if ((usedKey[usedKey.length-1] == "48") && (usedKey[usedKey.length-2] == "18") && (usedKey[usedKey.length-3] == "17"))                                {                                        evt.target.text = sCurrentText.substr(0, sCurrentText.length-1)+"@";                                }                                if (usedShiftKey && (usedKey[usedKey.length-1] == "190") )                                {                                        evt.target.text = sCurrentText.substr(0, sCurrentText.length-1)+".";                                }							/*	if (usedShiftKey && (usedKey[usedKey.length-1] == "60") )                                {                                        evt.target.text = sCurrentText.substr(0, sCurrentText.length-1)+"?";                                }*/                        }                        else                        {                                //-> http://bugs.adobe.com/jira/browse/FP-105                                if(evt.target.text.slice(evt.target.text.length-1, evt.target.text.length) == "\”")                                {                                        evt.target.text = evt.target.text.slice(0, evt.target.text.length-1)+"@";                                }                        }                }                               private static function onFieldKeyDownHandler(evt:KeyboardEvent):void                {                        usedKey.push(evt.keyCode);                        usedShiftKey = evt.shiftKey;                }                       }		}