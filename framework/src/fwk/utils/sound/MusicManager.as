package fwk.utils.sound 
{
	import flash.system.Capabilities;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author tsaintmartin
	 */
	public class MusicManager 
	{
		
		private var _music : Sound2;
		private var _file:String;
		private static var _instance:MusicManager;
		static private var _allowInstance:Boolean;
		
		private var soundEnabled:Boolean = true;
		
		
		public function MusicManager():void 
		{
			if (!_allowInstance) {
				throw new Error("Error: use Board.getInstance() instead of new keyword");
			} else {
				soundEnabled = Capabilities.hasAudio;
			}
		}
		
		public static function getInstance() : MusicManager {
			if (_instance == null) {
				_allowInstance = true;
				_instance = new MusicManager();
				_allowInstance = false;
			}
			return _instance;
		}
		
		
		public function play(file:String, delay:int = 4):void {
			if(soundEnabled){
				_file = file;
				if (_music != null) {
					_music.fadeOut(delay/2);
					_music = null;
				}
				
				//setTimeout(_play2, delay * 1000);
				_music = new Sound2(_file,1,true,null,true);
				_music.startfadeIn(1,999,delay/2);
			}
			
		}
		
		private function _play2():void {
			if(soundEnabled){
				_music = new Sound2(_file,1,true,null,true);
				_music.startfadeIn(1,999,10);
			}
		}
		
		

		
	}

}