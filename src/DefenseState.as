package
{
	import org.flixel.*;
	
	public class DefenseState extends ActiveState
	{
		private var _towerChoices:Array;
		private var _towerPlacing:FlxSprite; // keeps user 
		private var _mode:String;  // stores whether the user is placing or destroying
		
		
		public function DefenseState(tutorial:Boolean=false, menusActive:Boolean=false, map:FlxTilemap=null)
		{
			super(tutorial, menusActive, map);
			_towerChoices = new Array();
		//	_towerChoices = this.castle.unitsUnlocked(Castle.TOWER);
			
			/*Database.getTowerUnits(function(towers:Array):void {
				var group:FlxGroup = new FlxGroup();
				for (var i:int = 0; i < towers.length; i++) {
					var towerStats:Object = towers[i];
					group.add(new FlxSprite(i * 20 % CastleKingdom.WIDTH / 2, i * 20 / (CastleKingdom.WIDTH / 2), Util.assets[Assets.SWORDSMAN]));
				}*/
			
				//Util.window(CastleKingdom.WIDTH / 4, CastleKingdom.HEIGHT / 4, group, unpause, menu, 0xffffffff, 10, 
				//	CastleKingdom.WIDTH / 2, CastleKingdom.HEIGHT / 2);
			//});
		}
		
		public function generateUnitSelector(uid:int):FlxGroup {
			
			// getUnitInfo
			// Put on image
			// Put on descriptive text
			// on click, ... be able 
			//loc = FlxG.getScreenPosition();
			return null;
			
		}
		
		/** Displays tower placement menu
		 * */
		override public function create():void {
			super.create();
			var group:FlxGroup = new FlxGroup();
			var text:FlxText = new FlxText(0,0,20,"hi");
			text.color = 0xffff0000;
			group.add(text);
			
			group.add(createPlaceableTowerGroup(0,0,0,10));
			var sm:ScrollMenu = new ScrollMenu(CastleKingdom.WIDTH / 4, CastleKingdom.HEIGHT / 4, group, unpause, "Tower Selector", 0xffffffff, 10, 
				CastleKingdom.WIDTH / 2, CastleKingdom.HEIGHT / 2);
			setScrollMenu(sm);
			add(sm.window);
			
			
			//Util.window(10,Util.minY,
		}
		
		private function createPlaceableTowerGroup(x:int,y:int,unitID:int,num:int):FlxGroup {
			var group:FlxGroup = new FlxGroup();
			group.add(new DefenseUnit(x,y,unitID,true));
			for(var i:int = 0; i < num-1; i++) {
				group.add(new DefenseUnit(x,y,unitID, false));
			}
			return group;
		}
		
		// Display Tower selection menu
		
		// Enable drag and drop
		// call placement check
		
		// Decrease towers available
		
		// 
		
		override public function update():void {
			
			
			
			
			super.update();
		
		}
		
	}
}