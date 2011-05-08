package
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxTilemap;
	
	public class UpgradeState extends ActiveState
	{
		private var _leftMenu:ScrollMenu;
		private var _rightMenu:ScrollMenu;
		
		public function UpgradeState(map:FlxTilemap=null, castle:Castle=null, towers:FlxGroup=null, units:FlxGroup=null)
		{
			super(map, castle, towers, units);
		}
		
		override public function create():void {
			Database.getBarracksInfo(function(info:Array):void {
				var upgrades:Array = [];
				formatUpgrade(info);
			});
			_leftMenu = new ScrollMenu(Util.minX, Util.minY,
		}
	}
}