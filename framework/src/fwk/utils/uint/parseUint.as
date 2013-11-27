package fwk.utils.types.uint{
	/**
	 * @author AbsolutRenal
	 */
	public function parseUint(color:String):uint{
		color = color.replace("#", "");
		return parseInt(color, 16);
	}
}
