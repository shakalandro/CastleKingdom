package
{
	import flash.utils.Dictionary;
	
	import org.flixel.FlxSprite;
	
	/**
	 * This class keeps track of different dictionaries filled with assets for Castle 
	 * Kingdom (attack units, defense units, castle upgrades) that pertain to different
	 * skins. The overall dictionary is a map from String (skin name) to a dictionary
	 * for the assets for that skin. The containing dictionaries are maps from
	 * Strings to objects. 
	 * 
	 * @author Kimmy Win, Roy McElmurry
	 */
	public class Assets
	{
		
		public static const SKIN_NORMAL:String = "normal";
		public static const SKIN_BUNNY:String = "bunny";
		private var _assets:Dictionary;
		
		// Embed all resources here
		
		// Images
		
		[Embed(source = "../images/tiles.png")] 
		private static var tilesImg_normal:Class;
		public static const MAP_TILES:String = "tiles";
		
		[Embed(source = "../images/swordsman.png")]
		private static var swordsman_normal:Class;
		public static const SWORDSMAN:String = "Swordsman";
		
		[Embed(source = "../images/Spearman.png")]
		private static var pikeman_normal:Class;
		public static const PIKEMAN:String = "Spearman";
		
		[Embed(source = "../images/archer.png")]
		private static var archer_normal:Class;
		public static const ARCHER:String = "Archer";
		
		[Embed(source = "../images/ram.png")]
		private static var ram_normal:Class;
		public static const RAM:String = "Battering Ram";
		
		[Embed(source = "../images/cannon.png")]
		private static var cannon_normal:Class;
		public static const CANNON:String = "Cannon";
		
		[Embed(source = "../images/spearman.png")]
		private static var spearnman_normal:Class;
		public static const SPEARMAN:String = "Spearman";
		
		[Embed(source = "../images/tank.png")]
		private static var tank_normal:Class;
		public static const TANK:String = "Tank";
		
		[Embed(source = "../images/leprechaun.png")]
		private static var leprechaun_normal:Class;
		public static const LEPRECHAUN:String = "Leprechaun";
		
		[Embed(source = "../images/airplane.png")]
		private static var airplane_normal:Class;
		public static const AIRPLANE:String = "Airplane";
		
		[Embed(source = "../images/gryffin.png")]
		private static var gryffin_normal:Class;
		public static const GRYFFIN:String = "Gryffin";
		
		[Embed(source = "../images/dragon.png")]
		private static var dragon_normal:Class;
		public static const DRAGON:String = "Dragon";
		
		[Embed(source = "../images/hornet.png")]
		private static var hornet_normal:Class;
		public static const HORNET:String = "Hornet";
		
		[Embed(source = "../images/warrior_angel.png")]
		private static var warrior_angel_normal:Class;
		public static const WARRIOR_ANGEL:String = "Warrior Angel";
		
		[Embed(source = "../images/zeppelin.png")]
		private static var zeppelin_normal:Class;
		public static const ZEPPELIN:String = "Zeppelin";
		
		[Embed(source = "../images/mutant_mole.png")]
		private static var mutant_mole_normal:Class;
		public static const MUTANT_MOLE:String = "Mutant Mole";
		
		[Embed(source = "../images/tunneler.png")]
		private static var tunneler_normal:Class;
		public static const TUNNELER:String = "Tunneler";
		
		[Embed(source = "../images/smart_tunneler.png")]
		private static var smart_tunneler_normal:Class;
		public static const SMART_TUNNELER:String = "Smart Tunneler";
		
		[Embed(source = "../images/hud_header.png")]
		private static var hud_header:Class;
		public static const HUD_HEADER:String = "hud_header";
		
		[Embed(source = "../images/menu_bg.png")]
		private static var menu_bg:Class;
		public static const MENU_BG:String = "menu_bg";
		
		[Embed(source = "../images/castle.png")]
		private static var castle_img:Class;
		public static const CASTLE:String = "castle";
	
		[Embed(source = "../images/wall.png")]
		private static var wall_normal:Class;
		public static const WALL:String = "Wall";
		
		[Embed(source = "../images/arrow_tower.png")]
		private static var arrow_tower_normal:Class;
		public static const ARROW_TOWER:String = "Arrow Tower";
		
		[Embed(source = "../images/blob.png")]
		private static var blob:Class;
		public static const BLOB:String = "Blob";
		
		[Embed(source = "../images/arrow.png")]
		private static var arrow_normal:Class;
		public static const ARROW:String = "Arrow";
		
		[Embed(source = "../images/cannonball.png")]
		private static var cannonball_normal:Class;
		public static const CANNONBALL:String = "Cannonball";
		
		[Embed(source = "../images/fireball.png")]
		private static var fireball_normal:Class;
		public static const FIREBALL:String = "Fireball";
		
		[Embed(source = "../images/spear.png")]
		private static var spear_normal:Class;
		public static const SPEAR:String = "Spear";
		
		[Embed(source = "../images/bullet.png")]
		private static var bullet_normal:Class;
		public static const BULLET:String = "Bullet";

		[Embed(source = "../images/rocket.png")]
		private static var rocket_normal:Class;
		public static const ROCKET:String = "Rocket";
		
		[Embed(source = "../images/shockwave.png")]
		private static var shockwave_normal:Class;
		public static const SHOCKWAVE:String = "Shockwave";
		
		[Embed(source = "../images/flame_tower.png")]
		private static var flame_tower_normal:Class;
		public static const FLAME_TOWER:String = "Flame Tower";
		
		[Embed(source = "../images/multishot_tower.png")]
		private static var multishot_tower_normal:Class;
		public static const MULTISHOT_TOWER:String = "Multi-Shot Tower";
		
		[Embed(source = "../images/iron_tower.png")]
		private static var iron_tower_normal:Class;
		public static const IRON_TOWER:String = "Iron Tower";
		
		[Embed(source = "../images/sniper_tower.png")]
		private static var sniper_tower_normal:Class;
		public static const SNIPER_TOWER:String = "Sniper Tower";
		
		[Embed(source = "../images/spiked_wall.png")]
		private static var spiked_wall_normal:Class;
		public static const SPIKED_WALL:String = "Spike Wall";
		
		[Embed(source = "../images/landmine.png")]
		private static var landmine_normal:Class;
		public static const LANDMINE:String = "Land Mine";
		
		[Embed(source = "../images/fast_tower.png")]
		private static var fast_tower_normal:Class;
		public static const FAST_TOWER:String = "Fast Tower";
		
		[Embed(source = "../images/deep_land_mine.png")]
		private static var deep_land_mine_normal:Class;
		public static const DEEP_LAND_MINE:String = "Deep Land Mine";
		
		[Embed(source = "../images/air_mine.png")]
		private static var air_mine_normal:Class;
		public static const AIR_MINE:String = "Air Mine";
		
		[Embed(source = "../images/rocket_tower.png")]
		private static var rocket_tower_normal:Class;
		public static const ROCKET_TOWER:String = "Rocket Tower";
		
		[Embed(source = "../images/phoenix.png")]
		private static var phoenix_normal:Class;
		public static const PHOENIX:String = "Tamed Phoenix";
		
		[Embed(source = "../images/magic_wall.png")]
		private static var magic_wall_normal:Class;
		public static const MAGIC_WALL:String = "Magic Wall";
		
		[Embed(source = "../images/underground_wall.png")]
		private static var underground_wall_normal:Class;
		public static const UNDERGROUND_WALL:String = "Underground Wall";
		
		[Embed(source = "../images/quake_machine.png")]
		private static var quake_machine_normal:Class;
		public static const QUAKE_MACHINE:String = "Quake Machine";
		
		[Embed(source = "../images/space_needle.png")]
		private static var space_needle:Class;
		public static const SPACENEEDLE:String = "Space Needle";
		
		[Embed(source = "../images/cursor.png")]
		private static var cursor_img:Class;
		public static const CURSOR:String = "cursor";
		
		[Embed(source = "../images/wholemap.png")]
		private static var background_img:Class;
		public static const BACKGROUND:String = "background";
		
		[Embed(source = "../images/button_small.png")]
		private static var button_small_img:Class;
		public static const BUTTON_SMALL:String = "Small Button";
		
		[Embed(source = "../images/loader.png")]
		private static var loader_img:Class;
		public static const LOADER:String = "Loader";
		
		[Embed(source = "../images/startpage_background.png")]
		private static var startpage_background:Class;
		public static const LOGIN_BACKGROUND:String = "Login Background";
		
		[Embed(source = "../images/play_button.png")]
		private static var play_button:Class;
		public static const PLAY_BUTTON:String = "Play Button";
		
		[Embed(source = "../images/gold_counter.png")]
		private static var gold_counter:Class;
		public static const GOLD_COUNTER:String = "Gold Counter";
		
		[Embed(source = "../images/tower_counter.png")]
		private static var tower_counter:Class;
		public static const TOWER_COUNTER:String = "Tower Counter";
		
		[Embed(source = "../images/unit_counter.png")]
		private static var unit_counter:Class;
		public static const UNIT_COUNTER:String = "Unit Counter";
		
		// Text resources
		
		public static const HELP_BUTTON:String = "help button";
		public static const HELP_TEXT:String = "help text";
		public static const PLACE_TOWER_BUTTON:String = "place tower button";
		public static const RELEASE_WAVE_BUTTON:String = "release wave button";
		public static const UPGRADE_BUTTON:String = "upgrade button";
		public static const ATTACK_BUTTON:String = "attack button";
		public static const LEASE_BUTTON:String = "lease button";
		public static const INITIAL_PENDING_WAVE_TEXT:String = "initial pending wave text";
		public static const DEFEND_MENU_BUTTON:String = "defend menu button";
		public static const DEFEND_MENU_TITLE:String = "defend menu title";
		public static const BUTTON_CANCEL:String = "button close";
		public static const BUTTON_DONE:String = "button done";
		public static const ATTACK_FRIENDS_BUTTON:String = "attack friends button";
		public static const ATTACK_FRIENDS_LEFT_TITLE:String = "attack friends left title";
		public static const ATTACK_FRIENDS_RIGHT_TITLE:String = "attack friends right title";
		public static const ATTACK_FRIENDS_MIDDLE_TITLE:String = "attack friends middle menu";
		public static const ATTACK_FRIENDS_WIN:String = "attack friends win";
		public static const ATTACK_FRIENDS_LOSE:String = "attack friends lose";
		public static const LEASE_RIGHT_TITLE:String = "lease right title";
		public static const LEASE_LEFT_TITLE:String = "lease left title";
		public static const LEASE_MIDDLE_TITLE:String = "lease middle title";
		public static const LEASE_MIDDLE_BUTTON:String = "lease middle button";
		public static const UPGRADE_LEFT_TITLE:String = "upgrade left title";
		public static const UPGRADE_RIGHT_TITLE:String = "upgrade right title";
		public static const LEASE_REQUEST_TEXT:String = "lease request text";
		public static const LEASE_REQUEST_ACCEPT:String = "lease request accept";
		public static const LEASE_REQUEST_REJECT:String = "lease request reject";
		public static const LEASE_ACCEPTED:String = "lease accepted";
		public static const LEASE_REJECTED:String = "lease rejected";
		
		public static const FIRST_WIN:String = "first win";
		public static const FIRST_LOSS:String = "first loss";
		public static const UPGRADE_AVAILABLE:String = "upgrade available";
		public static const FIRST_DEFENSE:String = "first defense";
		public static const FIRST_ATTACK:String = "first attack";
		public static const SENT_WAVE:String = "sent wave";
		public static const INCOMING_WAVE:String = "incoming wave";
		public static const FRIEND_WAVE_LOSS:String = "friend wave loss";
		public static const FRIEND_WAVE_WIN:String = "friend wave win";
		public static const ATTACK_FRIENDS_BROKE:String = "attack friends broke";
		
		// Other resources
		
		[Embed(source = "mapLayout.txt", mimeType = "application/octet-stream")]
		private static var tileLayout_normal:Class;
		public static const TILE_LAYOUT:String = "tileLayout";
			
		// End resource embed area
		
		/**
		 * Create the dictionaries of assets
		 * 
		 */
		public function Assets(){
			_assets = new Dictionary();
			
			var _bunny:Dictionary = new Dictionary();
			var _normal:Dictionary = new Dictionary();
			
			_assets[SKIN_BUNNY] = _bunny;
			_assets[SKIN_NORMAL] = _normal;
			
			_normal[Assets.ARROW] = arrow_normal;
			_normal[Assets.CANNONBALL] = cannonball_normal;
			_normal[Assets.FIREBALL] = fireball_normal;
			_normal[Assets.SPEAR] = spear_normal;
			_normal[Assets.BULLET] = bullet_normal;
			_normal[Assets.ROCKET] = rocket_normal;
			_normal[Assets.SHOCKWAVE] = shockwave_normal;

			
			_normal[Assets.MAP_TILES] = tilesImg_normal;
			_normal[Assets.SWORDSMAN] = swordsman_normal;
			_normal[Assets.PIKEMAN] = pikeman_normal;
			_normal[Assets.BLOB] = blob;
			_normal[Assets.SPACENEEDLE] = space_needle;

			_normal[Assets.TILE_LAYOUT] = tileLayout_normal;
			_normal[Assets.HUD_HEADER] = hud_header;
			_normal[Assets.MENU_BG] = menu_bg;
			_normal[Assets.CASTLE] = castle_img;
			_normal[Assets.CURSOR] = cursor_img;
			_normal[Assets.BACKGROUND] = background_img;
			_normal[Assets.LOGIN_BACKGROUND] = startpage_background;
			_normal[Assets.BUTTON_SMALL] = button_small_img;
			_normal[Assets.PLAY_BUTTON] = play_button;
			_normal[Assets.GOLD_COUNTER] = gold_counter;
			_normal[Assets.TOWER_COUNTER] = tower_counter;
			_normal[Assets.UNIT_COUNTER] = unit_counter;
			
			_normal[Assets.ARROW_TOWER] = arrow_tower_normal;
			_normal[Assets.SNIPER_TOWER] = sniper_tower_normal;
			_normal[Assets.IRON_TOWER] = iron_tower_normal;
			_normal[Assets.MULTISHOT_TOWER] = multishot_tower_normal;
			_normal[Assets.LANDMINE] = landmine_normal;
			_normal[Assets.FAST_TOWER] = fast_tower_normal;
			_normal[Assets.SPIKED_WALL] = spiked_wall_normal;
			_normal[Assets.DEEP_LAND_MINE] = deep_land_mine_normal;
			_normal[Assets.AIR_MINE] = air_mine_normal;
			_normal[Assets.ROCKET_TOWER] = rocket_tower_normal;
			_normal[Assets.PHOENIX] = phoenix_normal;
			_normal[Assets.MAGIC_WALL] = magic_wall_normal;
			_normal[Assets.UNDERGROUND_WALL] = underground_wall_normal;
			_normal[Assets.QUAKE_MACHINE] = quake_machine_normal;


			_normal[Assets.WALL] = wall_normal;
			_normal[Assets.CANNON] = cannon_normal;
			_normal[Assets.ARCHER] = archer_normal;
			_normal[Assets.RAM] = ram_normal;
			_normal[Assets.TANK] = tank_normal;
			_normal[Assets.LEPRECHAUN] = leprechaun_normal;
			_normal[Assets.GRYFFIN] = gryffin_normal;
			_normal[Assets.DRAGON] = dragon_normal;
			_normal[Assets.AIRPLANE] = airplane_normal;
			_normal[Assets.HORNET] = hornet_normal;
			_normal[Assets.LOADER] = loader_img;
			_normal[Assets.WARRIOR_ANGEL] = warrior_angel_normal;
			_normal[Assets.ZEPPELIN] = zeppelin_normal;
			_normal[Assets.MUTANT_MOLE] = mutant_mole_normal;
			_normal[Assets.TUNNELER] = tunneler_normal;
			_normal[Assets.SMART_TUNNELER] = smart_tunneler_normal;
			
			//Textual assets
			
			_normal[Assets.HELP_BUTTON] = "Help";
			_normal[Assets.HELP_TEXT] = "This is CastleKingdom, a tower defense OCD hybrid game. Bring your castle to glory as " +
				"you battle your friends for treasure.\n\nAuthors: Gabe Groen, Justin Harding, Robert Johnson, Roy McElmurry, Kim Nguyen" +
				"\n\nSpring 2011";
			_normal[Assets.BUTTON_CANCEL] = "Cancel";
			_normal[Assets.BUTTON_DONE] = "Done";
			_normal[Assets.PLACE_TOWER_BUTTON] = "Defend";
			_normal[Assets.RELEASE_WAVE_BUTTON] = "Release";
			_normal[Assets.UPGRADE_BUTTON] = "Upgrade";
			_normal[Assets.ATTACK_BUTTON] = "Attack";
			_normal[Assets.LEASE_BUTTON] = "Lease";
			_normal[Assets.DEFEND_MENU_BUTTON] = "Done";
			_normal[Assets.DEFEND_MENU_TITLE] = "Drag And Drop";
			_normal[Assets.ATTACK_FRIENDS_BUTTON] = "Send";
			_normal[Assets.ATTACK_FRIENDS_LEFT_TITLE] = "";
			_normal[Assets.ATTACK_FRIENDS_RIGHT_TITLE] = "";
			_normal[Assets.ATTACK_FRIENDS_MIDDLE_TITLE] = "";
			_normal[Assets.LEASE_RIGHT_TITLE] = "";
			_normal[Assets.LEASE_LEFT_TITLE] = "";
			_normal[Assets.LEASE_MIDDLE_TITLE] = "";
			_normal[Assets.LEASE_MIDDLE_BUTTON] = "Request";
			_normal[Assets.UPGRADE_LEFT_TITLE] = "Castle Upgrades";
			_normal[Assets.UPGRADE_RIGHT_TITLE] = "Castle Upgrades";
			_normal[Assets.LEASE_REQUEST_ACCEPT] = "Accept";
			_normal[Assets.LEASE_REQUEST_REJECT] = "Reject";
			_normal[Assets.INITIAL_PENDING_WAVE_TEXT] = "Welcome to the cutthroat world of Castle Kingdom. " +
				"Your castle is your life and the gold within is your means to glory. But right now a band of" +
				" enemies is on their way to steal your gold. You must defend yourself.";
			_normal[Assets.FIRST_WIN] = "Congratulations on defeating all those enemies. You can now upgrade " +
				"your castle. Castle upgrades will allow you to use new kinds of towers, imcrease your stats " +
				"and more. Save up your gold and try to buy 3 upgrades!";
			_normal[Assets.FIRST_LOSS] = "Hmm, that tower configuration didn't seem to put up a fight against " +
				"those enemeies. Try a different configuration and remember that you can set up to {0} tower units";
			_normal[Assets.FIRST_DEFENSE] = "Let's see how that defensive strategy plays out, release " +
				"the enemies to find out.";
			_normal[Assets.FIRST_ATTACK] = "Your castle has become quite impressive. You are now ready to " +
				"venture out and try stealing gold from your friends castles! But don't go nuts, an attack comes with an initial investment.";
			_normal[Assets.SENT_WAVE] = "Now that you can attack friends, they can also attack you. Try asking " +
				"your friends to lease some of their resources to help you in battle.";
			_normal[Assets.INCOMING_WAVE] = "OMG, your friend {0} has sent a wave of enemies at you. Would you " +
				"like to defend yourself or simply surrender {1} gold?";
			_normal[Assets.FRIEND_WAVE_WIN] = "Good job, way to fight off the enemies from {0}, they won't be messing with you again soon.";
			_normal[Assets.FRIEND_WAVE_LOSS] = "Shoot {0} got away with {1} of your gold.";
			_normal[Assets.ATTACK_FRIENDS_BROKE] = "Dang, you don't have enough money to attack an enemy yet, save up {0} gold and try again";
			_normal[Assets.ATTACK_FRIENDS_WIN] = "Congratulations, your attack on {0} was successful, you have gained {1} hold as a result!";
			_normal[Assets.ATTACK_FRIENDS_LOSE] = "Dang, your attack on {0} failed, you were unable to steal any gold.";
			_normal[Assets.LEASE_REQUEST_TEXT] = "{0} would like to lease {1} of your units. What would you like to do?";
			_normal[Assets.LEASE_ACCEPTED] = "{0} has accepted your request to lease out {1} of his/her unit capacity. They have been added " +
				"to your capacity for the next attack wave.";
			_normal[Assets.LEASE_REJECTED] = "Dang, {0} rejected your request to lease out some of his/her unit capacity.";
		}
		
		/**
		 * Gives access to the assets dictioanry of resources.
		 * 
		 * @return A dictionary from skin strings to dictionaries from resource name to resource.
		 * 
		 */
		public function get assets():Dictionary{
			return _assets;
		}
	}
}
