package
{
	import org.flixel.system.FlxPreloader;
	import flash.display.LoaderInfo;
	
	public class Preloader extends FlxPreloader
	{
		private static var _flashVars:Object;
			
		public function Preloader()
		{
			_flashVars = getFlashVars();
			className = "CastleKingdom";
			super();
			minDisplayTime = 3;
		}
		
		private function getFlashVars():Object {
			return LoaderInfo(this.root.loaderInfo).parameters;
		}
		
		public static function get flashVars():Object {
			return _flashVars;
		}
	}
}