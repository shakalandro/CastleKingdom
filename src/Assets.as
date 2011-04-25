package
{
	import org.flixel.FlxSprite;
	
	/**
	 * This class keeps track of different dictionaries filled with assets for Castle 
	 * Kingdom (attack units, defense units, castle upgrades) that pertain to different
	 * "skins". The overall dictionary is a map from String (skin name) to a dictionary
	 * for the assets for that skin. The containing dictionaries are maps from
	 * Strings to objects. 
	 * 
	 * @author Kimmy Win
	 * Kim is a pretty pretty princess
	 */
	public class Assets
	{
		
		private var _assets:Dictionary;
		
		private var _bunnySkin:Dictionary;
		private var _bloodySkin:Dictionary;
		
		
		/**
		 * Create the dictionaries of assets
		 * 
		 */
		public function Assets(){
			_assets = new Dictionary();
			
			_bunnySkin = new Dictionary();
			_bloodySkin = new Dictionary();
			
			_assets["bunny"] = _bunnySkin;
			_assets["bloody"] = _bunnySkin;
			
		}
		
		/**
		 * 
		 * @param skin
		 * @return 
		 * 
		 */
		public function get assets(skin:String):Dictionary{
			return _assets[skin];
		}

		
	}
}