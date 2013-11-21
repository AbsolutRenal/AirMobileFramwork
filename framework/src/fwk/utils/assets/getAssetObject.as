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
