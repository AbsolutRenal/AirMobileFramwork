package fwk.utils.sound 
{
	import flash.system.Capabilities;
	import flash.events.Event;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author tsaintmartin
	 */
	public class SoundManager 
	{
		
		private var _music : Sound2;
		private var _file:String;
		private static var _instance:SoundManager;
		static private var _allowInstance:Boolean;
		
		private var _isSoundOn:Boolean = true;
		
		private var _vSound:Vector.<Sound2>;
		
		private var _musicVolume:Number;
		
		private var soundEnabled:Boolean = true;
		
		public function SoundManager():void 
		{
			if (!_allowInstance) {
				throw new Error("Error: use SoundManager.getInstance() instead of new keyword");
			} 
			_init();
		}
		
		private function _init():void 
		{
			soundEnabled = Capabilities.hasAudio;
			_vSound = new Vector.<Sound2>();
		}
		
		public static function getInstance() : SoundManager {
			if (_instance == null) {
				_allowInstance = true;
				_instance = new SoundManager();
				_allowInstance = false;
				
			}
			return _instance;
		}
		

		public function playMusic(file:String, volume:Number = 1,delay:int = 4):void {
			if(soundEnabled){
				_file = file;
				_musicVolume = volume;
				if (_music != null) {
					_music.fadeOut(delay/2);
					_music = null;
				}
				_music = new Sound2(_file,_musicVolume,true,null,true);
				_music.startfadeIn(_musicVolume,999,delay/2);
			}
		}
		
		public function playSound(id:String, volume:Number = 1, restartIfPlaying:Boolean = false, ignoreMute:Boolean = false ):void {
			if(soundEnabled){
				if (_isSoundOn||ignoreMute) {
					var sound:Sound2 = new Sound2(id, volume, restartIfPlaying);
					sound.addEventListener(Event.COMPLETE, _onSoundComplete);
					_vSound.push(sound);
					sound.start();
				}
			}
		}
		
		private function _onSoundComplete(e:Event):void 
		{
			var sound:Sound2 = e.target as Sound2;
			
			_vSound.splice(_vSound.indexOf(sound), 1);
			sound.dispose();
			trace(_vSound.length);
		}
		
		public function toggle():void {
			if (_isSoundOn) {
				soundOff();	
			}
			else {
				soundOn();
				
			}
				
		}
		
		public function soundOn():void {
			_isSoundOn = true;
			trace('soundOn');
			if (_music) {
				if (_music.isStopped) {
					_music.start(_musicVolume,999);				
				}
			}
		}
		
		public function soundOff():void  {
			_isSoundOn = false;
			trace('soundOff');
			if (_music) {
				if (!_music.isStopped) {
					_music.stop();
				}
			}
			for each(var sound:Sound2 in _vSound){
				_vSound.splice(_vSound.indexOf(sound), 1);
				sound.dispose();
			}
			trace(_vSound.length);
		}
		
		public function get isSoundOn():Boolean 
		{
			return _isSoundOn;
		}
	}

}