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
		
		[Embed(source = "../images/grapple.png")]
		private static var grapple_normal:Class;
		public static const GRAPPLE:String = "Grapple";
		
		[Embed(source = "../images/sawblade.png")]
		private static var sawblade_normal:Class;
		public static const SAWBLADE:String = "Sawblade";
		
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
		
		[Embed(source = "../images/grapple_tower.png")]
		private static var grapple_tower_normal:Class;
		public static const GRAPPLE_TOWER:String = "Grapple Tower";
		
		[Embed(source = "../images/aa_tower.png")]
		private static var aa_tower_normal:Class;
		public static const AA_TOWER:String = "AA Gun";
		
		[Embed(source = "../images/underground_wall.png")]
		private static var underground_wall_normal:Class;
		public static const UNDERGROUND_WALL:String = "Underground Wall";
		
		[Embed(source = "../images/quake_machine.png")]
		private static var quake_machine_normal:Class;
		public static const QUAKE_MACHINE:String = "Quake Machine";
		
		[Embed(source = "../images/traps.png")]
		private static var traps_normal:Class;
		public static const TRAPS:String = "Traps";
		
		[Embed(source = "../images/space_needle.png")]
		private static var space_needle:Class;
		public static const SPACENEEDLE:String = "Space Needle";
		
		[Embed(source = "../images/cursor.png")]
		private static var cursor_img:Class;
		public static const CURSOR:String = "cursor";
		
		[Embed(source = "../images/cursorstatic.png")]
		private static var cursorstatic_img:Class;
		public static const CURSORSTATIC:String = "Cursor Static";
		
		[Embed(source = "../images/cursorprimed.png")]
		private static var cursorprimed_img:Class;
		public static const CURSORPRIMED:String = "Cursor Primed";
		
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
		
		[Embed(source = "../images/explode.png")]
		private static var explode:Class;
		public static const EXPLODE:String = "Explode";
		
		[Embed(source = "../images/vault_cover.png")]
		private static var vault_cover:Class;
		public static const VAULT_COVER:String = "vaultCover";
		
		[Embed(source = "../images/vault_grass.png")]
		private static var vault_grass:Class;
		public static const VAULT_GRASS:String = "vaultGrass";
		
		[Embed(source = "../images/castle1.png")]
		private static var castle1:Class;
		public static const CASTLE1:String = "castle1";
		
		[Embed(source = "../images/castle2.png")]
		private static var castle2:Class;
		public static const CASTLE2:String = "castle2";
		
		[Embed(source = "../images/castle3.png")]
		private static var castle3:Class;
		public static const CASTLE3:String = "castle3";
		
		[Embed(source = "../images/castle4.png")]
		private static var castle4:Class;
		public static const CASTLE4:String = "castle4";
		
		[Embed(source = "../images/castle5.png")]
		private static var castle5:Class;
		public static const CASTLE5:String = "castle5";
		
		[Embed(source = "../images/castle6.png")]
		private static var castle6:Class;
		public static const CASTLE6:String = "castle6";
		
		[Embed(source = "../images/castle7.png")]
		private static var castle7:Class;
		public static const CASTLE7:String = "castle7";
		
		[Embed(source = "../images/castle8.png")]
		private static var castle8:Class;
		public static const CASTLE8:String = "castle8";
		
		[Embed(source = "../images/castle9.png")]
		private static var castle9:Class;
		public static const CASTLE9:String = "castle9";
		
		[Embed(source = "../images/castle10.png")]
		private static var castle10:Class;
		public static const CASTLE10:String = "castle10";
		
		[Embed(source = "../images/castle11.png")]
		private static var castle11:Class;
		public static const CASTLE11:String = "castle11";
		
		[Embed(source = "../images/castle12.png")]
		private static var castle12:Class;
		public static const CASTLE12:String = "castle12";
		
		[Embed(source = "../images/castle13.png")]
		private static var castle13:Class;
		public static const CASTLE13:String = "castle13";
		
		[Embed(source = "../images/castle14.png")]
		private static var castle14:Class;
		public static const CASTLE14:String = "castle14";
		
		[Embed(source = "../images/castle15.png")]
		private static var castle15:Class;
		public static const CASTLE15:String = "castle15";
		
		[Embed(source = "../images/castle16.png")]
		private static var castle16:Class;
		public static const CASTLE16:String = "castle16";
		
		[Embed(source = "../images/castle17.png")]
		private static var castle17:Class;
		public static const CASTLE17:String = "castle17";
		
		[Embed(source = "../images/castle18.png")]
		private static var castle18:Class;
		public static const CASTLE18:String = "castle18";
		
		[Embed(source = "../images/castle19.png")]
		private static var castle19:Class;
		public static const CASTLE19:String = "castle19";
		
		[Embed(source = "../images/castle20.png")]
		private static var castle20:Class;
		public static const CASTLE20:String = "castle20";
		
		[Embed(source = "../images/castle21.png")]
		private static var castle21:Class;
		public static const CASTLE21:String = "castle21";
		
		[Embed(source = "../images/castle22.png")]
		private static var castle22:Class;
		public static const CASTLE22:String = "castle22";
		
		[Embed(source = "../images/aviary1.png")]
		private static var aviary1:Class;
		public static const AVIARY1:String = "aviary1";
		
		[Embed(source = "../images/aviary2.png")]
		private static var aviary2:Class;
		public static const AVIARY2:String = "aviary2";
		
		[Embed(source = "../images/aviary3.png")]
		private static var aviary3:Class;
		public static const AVIARY3:String = "aviary3";
		
		[Embed(source = "../images/barracks1.png")]
		private static var barracks1:Class;
		public static const BARRACKS1:String = "barracks1";
		
		[Embed(source = "../images/barracks2.png")]
		private static var barracks2:Class;
		public static const BARRACKS2:String = "barracks2";
		
		[Embed(source = "../images/barracks3.png")]
		private static var barracks3:Class;
		public static const BARRACKS3:String = "barracks3";
		
		[Embed(source = "../images/barracks4.png")]
		private static var barracks4:Class;
		public static const BARRACKS4:String = "barracks4";
		
		[Embed(source = "../images/barracks5.png")]
		private static var barracks5:Class;
		public static const BARRACKS5:String = "barracks5";
		
		[Embed(source = "../images/barracks6.png")]
		private static var barracks6:Class;
		public static const BARRACKS6:String = "barracks6";
		
		[Embed(source = "../images/barracks7.png")]
		private static var barracks7:Class;
		public static const BARRACKS7:String = "barracks7";
		
		[Embed(source = "../images/barracks8.png")]
		private static var barracks8:Class;
		public static const BARRACKS8:String = "barracks8";
		
		[Embed(source = "../images/barracks9.png")]
		private static var barracks9:Class;
		public static const BARRACKS9:String = "barracks9";
		
		[Embed(source = "../images/barracks10.png")]
		private static var barracks10:Class;
		public static const BARRACKS10:String = "barracks10";
		
		[Embed(source = "../images/barracks11.png")]
		private static var barracks11:Class;
		public static const BARRACKS11:String = "barracks11";
		
		[Embed(source = "../images/barracks12.png")]
		private static var barracks12:Class;
		public static const BARRACKS12:String = "barracks12";
		
		[Embed(source = "../images/barracks13.png")]
		private static var barracks13:Class;
		public static const BARRACKS13:String = "barracks13";
		
		[Embed(source = "../images/barracks14.png")]
		private static var barracks14:Class;
		public static const BARRACKS14:String = "barracks14";
		
		[Embed(source = "../images/barracks15.png")]
		private static var barracks15:Class;
		public static const BARRACKS15:String = "barracks15";
		
		[Embed(source = "../images/foundry1.png")]
		private static var foundry1:Class;
		public static const FOUNDRY1:String = "foundry1";
		
		[Embed(source = "../images/foundry2.png")]
		private static var foundry2:Class;
		public static const FOUNDRY2:String = "foundry2";
		
		[Embed(source = "../images/foundry3.png")]
		private static var foundry3:Class;
		public static const FOUNDRY3:String = "foundry3";
		
		[Embed(source = "../images/foundry4.png")]
		private static var foundry4:Class;
		public static const FOUNDRY4:String = "foundry4";
		
		[Embed(source = "../images/foundry5.png")]
		private static var foundry5:Class;
		public static const FOUNDRY5:String = "foundry5";
		
		[Embed(source = "../images/foundry6.png")]
		private static var foundry6:Class;
		public static const FOUNDRY6:String = "foundry6";
		
		[Embed(source = "../images/foundry7.png")]
		private static var foundry7:Class;
		public static const FOUNDRY7:String = "foundry7";
		
		[Embed(source = "../images/foundry8.png")]
		private static var foundry8:Class;
		public static const FOUNDRY8:String = "foundry8";
		
		[Embed(source = "../images/foundry9.png")]
		private static var foundry9:Class;
		public static const FOUNDRY9:String = "foundry9";
		
		[Embed(source = "../images/foundry10.png")]
		private static var foundry10:Class;
		public static const FOUNDRY10:String = "foundry10";
		
		[Embed(source = "../images/foundry11.png")]
		private static var foundry11:Class;
		public static const FOUNDRY11:String = "foundry11";
		
		[Embed(source = "../images/foundry12.png")]
		private static var foundry12:Class;
		public static const FOUNDRY12:String = "foundry12";
		
		[Embed(source = "../images/foundry13.png")]
		private static var foundry13:Class;
		public static const FOUNDRY13:String = "foundry13";
		
		[Embed(source = "../images/foundry14.png")]
		private static var foundry14:Class;
		public static const FOUNDRY14:String = "foundry14";
		
		[Embed(source = "../images/foundry15.png")]
		private static var foundry15:Class;
		public static const FOUNDRY15:String = "foundry15";
		
		[Embed(source = "../images/mine1.png")]
		private static var mine1:Class;
		public static const MINE1:String = "mine1";
		
		[Embed(source = "../images/mine2.png")]
		private static var mine2:Class;
		public static const MINE2:String = "mine2";
		
		[Embed(source = "../images/mine3.png")]
		private static var mine3:Class;
		public static const MINE3:String = "mine3";
		
		[Embed(source = "../images/mine4.png")]
		private static var mine4:Class;
		public static const MINE4:String = "mine4";
		
		[Embed(source = "../images/mine5.png")]
		private static var mine5:Class;
		public static const MINE5:String = "mine5";
		
		[Embed(source = "../images/castlebackground.png")]
		private static var castlebackground:Class;
		public static const CASTLEBACKGROUND:String = "Castle Background";
		
		[Embed(source = "../images/blingbling.png")]
		private static var blingbling:Class;
		public static const BLINGBLING:String = "blingbling";
		
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
		
		public static const ATTACK_WIN:String = "attack win";
		public static const ATTACK_LOSE:String = "attack lose";
		public static const ATTACK_FRIENDS_SENT:String = "attack friends sent";
		public static const ATTACK_FRIENDS_NOT_SENT:String = "attack friends not sent";
		public static const LEASE_SENT:String = "lease sent";
		public static const LEASE_NOT_SENT:String = "lease not sent";
		public static const INVITE_FRIEND:String = "invite friend";
		public static const ATTACK_LOW_GOLD:String = "attack low gold";
		
		public static const GAME_URL:String = "game url";
		
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
			_normal[Assets.GRAPPLE] = grapple_normal;
			_normal[Assets.SAWBLADE] = sawblade_normal;

			_normal[Assets.CASTLE1] = castle1;
			_normal[Assets.CASTLE2] = castle2;
			_normal[Assets.CASTLE3] = castle3;
			_normal[Assets.CASTLE4] = castle4;
			_normal[Assets.CASTLE5] = castle5;
			_normal[Assets.CASTLE6] = castle6;
			_normal[Assets.CASTLE7] = castle7;
			_normal[Assets.CASTLE8] = castle8;
			_normal[Assets.CASTLE9] = castle9;
			_normal[Assets.CASTLE10] = castle10;
			_normal[Assets.CASTLE11] = castle11;
			_normal[Assets.CASTLE12] = castle12;
			_normal[Assets.CASTLE13] = castle13;
			_normal[Assets.CASTLE14] = castle14;
			_normal[Assets.CASTLE15] = castle15;
			_normal[Assets.CASTLE16] = castle16;
			_normal[Assets.CASTLE17] = castle17;
			_normal[Assets.CASTLE18] = castle18;
			_normal[Assets.CASTLE19] = castle19;
			_normal[Assets.CASTLE20] = castle20;
			_normal[Assets.CASTLE21] = castle21;
			_normal[Assets.CASTLE22] = castle22;
			_normal[Assets.AVIARY1] = aviary1;
			_normal[Assets.AVIARY2] = aviary2;
			_normal[Assets.AVIARY3] = aviary3;
			_normal[Assets.BARRACKS1] = barracks1;
			_normal[Assets.BARRACKS2] = barracks2;
			_normal[Assets.BARRACKS3] = barracks3;
			_normal[Assets.BARRACKS4] = barracks4;
			_normal[Assets.BARRACKS5] = barracks5;
			_normal[Assets.BARRACKS6] = barracks6;
			_normal[Assets.BARRACKS7] = barracks7;
			_normal[Assets.BARRACKS8] = barracks8;
			_normal[Assets.BARRACKS9] = barracks9;
			_normal[Assets.BARRACKS10] = barracks10;
			_normal[Assets.BARRACKS11] = barracks11;
			_normal[Assets.BARRACKS12] = barracks12;
			_normal[Assets.BARRACKS13] = barracks13;
			_normal[Assets.BARRACKS14] = barracks14;
			_normal[Assets.BARRACKS15] = barracks15;
			_normal[Assets.FOUNDRY1] = foundry1;
			_normal[Assets.FOUNDRY2] = foundry2;
			_normal[Assets.FOUNDRY3] = foundry3;
			_normal[Assets.FOUNDRY4] = foundry4;
			_normal[Assets.FOUNDRY5] = foundry5;
			_normal[Assets.FOUNDRY6] = foundry6;
			_normal[Assets.FOUNDRY7] = foundry7;
			_normal[Assets.FOUNDRY8] = foundry8;
			_normal[Assets.FOUNDRY9] = foundry9;
			_normal[Assets.FOUNDRY10] = foundry10;
			_normal[Assets.FOUNDRY11] = foundry11;
			_normal[Assets.FOUNDRY12] = foundry12;
			_normal[Assets.FOUNDRY13] = foundry13;
			_normal[Assets.FOUNDRY14] = foundry14;
			_normal[Assets.FOUNDRY15] = foundry15;
			_normal[Assets.MINE1] = mine1;
			_normal[Assets.MINE2] = mine2;
			_normal[Assets.MINE3] = mine3;
			_normal[Assets.MINE4] = mine4;
			_normal[Assets.MINE5] = mine5;
			_normal[Assets.CASTLEBACKGROUND] = castlebackground;
			_normal[Assets.BLINGBLING] = blingbling;

			_normal[Assets.VAULT_COVER] = vault_cover;
			_normal[Assets.VAULT_GRASS] = vault_grass;


			_normal[Assets.MAP_TILES] = tilesImg_normal;
			_normal[Assets.SWORDSMAN] = swordsman_normal;
			_normal[Assets.PIKEMAN] = pikeman_normal;
			_normal[Assets.BLOB] = blob;
			_normal[Assets.SPACENEEDLE] = space_needle;
			_normal[Assets.EXPLODE] = explode;

			_normal[Assets.TILE_LAYOUT] = tileLayout_normal;
			_normal[Assets.HUD_HEADER] = hud_header;
			_normal[Assets.MENU_BG] = menu_bg;
			_normal[Assets.CASTLE] = castle_img;
			_normal[Assets.CURSOR] = cursor_img;
			_normal[Assets.CURSORSTATIC] = cursorstatic_img;
			_normal[Assets.CURSORPRIMED] = cursorprimed_img;
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
			_normal[Assets.GRAPPLE_TOWER] = grapple_tower_normal;
			_normal[Assets.ROCKET_TOWER] = rocket_tower_normal;
			_normal[Assets.PHOENIX] = phoenix_normal;
			_normal[Assets.MAGIC_WALL] = magic_wall_normal;
			_normal[Assets.AA_TOWER] = aa_tower_normal;
			_normal[Assets.UNDERGROUND_WALL] = underground_wall_normal;
			_normal[Assets.QUAKE_MACHINE] = quake_machine_normal;
			_normal[Assets.TRAPS] = traps_normal;
			_normal[Assets.FLAME_TOWER] = flame_tower_normal;


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
			_normal[Assets.PLACE_TOWER_BUTTON] = "Build";
			_normal[Assets.RELEASE_WAVE_BUTTON] = "Defend";
			_normal[Assets.UPGRADE_BUTTON] = "Upgrade";
			_normal[Assets.ATTACK_BUTTON] = "Attack Friends";
			_normal[Assets.LEASE_BUTTON] = "Borrow";
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
			_normal[Assets.INITIAL_PENDING_WAVE_TEXT] = "Welcome to the world of Castle Kingdom. " +
				"Build your castle up, and protect it from those who would steal your gold. Right now a band of" +
				" enemies is in wait to steal your gold. You must defend yourself.";
			_normal[Assets.FIRST_WIN] = "Congratulations on defending yourself from the attackers! You can now upgrade " +
				"your castle. Castle upgrades will allow you to place more towers, and even place completely new kinds " +
				"of towers. Save up your gold and try to buy 3 upgrades!";
			_normal[Assets.FIRST_LOSS] = "Hmm, that tower configuration didn't work too well against " +
				"those enemeies. Try a different configuration and remember that you can set up to {0} tower units";
			_normal[Assets.FIRST_DEFENSE] = "Let's see how that well your setup will work. Press Defend to " +
				"let the enemies start their attack!";
			_normal[Assets.FIRST_ATTACK] = "Your castle has become quite impressive. You are now ready to " +
				"send units to go attack your friends' castles!";
			_normal[Assets.SENT_WAVE] = "Now that you can attack friends, they can also attack you. Be on your gaurd.";
			_normal[Assets.INCOMING_WAVE] = "Watch out! Your friend {0} has sent a wave of enemies at you. Would you " +
				"like to try defending yourself or simply surrender {1} gold?";
			_normal[Assets.FRIEND_WAVE_WIN] = "Good job, way to fight off the enemies from {0}, they won't be messing with you again soon.";
			_normal[Assets.FRIEND_WAVE_LOSS] = "Too bad! {0} got away with {1} of your gold.";
			_normal[Assets.ATTACK_FRIENDS_BROKE] = "Sorry, you don't have enough money to attack anyone yet. Save up {0} gold and try again";
			_normal[Assets.ATTACK_FRIENDS_WIN] = "Congratulations, your attack on {0} was successful, and you stole {1} gold from them!";
			_normal[Assets.ATTACK_FRIENDS_LOSE] = "Too bad! Your attack on {0} failed, so you were unable to steal any gold.";
			_normal[Assets.LEASE_REQUEST_TEXT] = "{0} would like to borrow {1} of your units. What would you like to do?";
			_normal[Assets.LEASE_ACCEPTED] = "{0} has accepted your request to loan out {1} of their unit capacity. They have been added " +
				"to your capacity for the next attack wave.";
			_normal[Assets.LEASE_REJECTED] = "Too bad. {0} rejected your request to loan out some of their unit capacity this time.";
			_normal[Assets.ATTACK_WIN] = "Great! They didn't steal any of your gold - in fact they dropped {0} gold!" +
				"Your troops get tired the more gold they collect. They collected {1} of the gold available.";
			_normal[Assets.ATTACK_LOW_GOLD] = "Your troops are pretty tired from defending against so many enemies! \n" +
				"They still managed to pick up {1} of {0} of the dropped gold. They could have gotten more of what was dropped if they rested." +
				"You should take a break, so they can rest! Come back later and you'll gain more gold from each attack.";
			_normal[Assets.ATTACK_LOSE] = "Too bad! The enemies got away with {0} of your gold.";
			_normal[Assets.ATTACK_FRIENDS_SENT] = "Your army is on its way to try to steal gold from {0}.";
			_normal[Assets.ATTACK_FRIENDS_NOT_SENT] = "An army was not sent.";
			_normal[Assets.LEASE_SENT] = "A request was sent to {0} for {1} unit capacity.";
			_normal[Assets.LEASE_NOT_SENT] = "No request was made.";
			_normal[Assets.INVITE_FRIEND] = "{0} would like to invite you to play an awesome game, Castle Kingdom.";
			_normal[Assets.GAME_URL] = "http://games.cs.washington.edu/capstone/11sp/castlekd/roy/index.html";
			_normal[Assets.LEASE_SENT] = "A request was sent to {0} for {1} unit capacity.";
			_normal[Assets.LEASE_NOT_SENT] = "No request was made.";
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
