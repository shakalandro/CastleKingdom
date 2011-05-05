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
		
		override public function create():void {
			super.create();
			
			Database.getDefenseUnitInfo(function(info:Array):void {
				var pages:Array = createTowers(info);
				var sm:ScrollMenu = new ScrollMenu(CastleKingdom.WIDTH / 4, CastleKingdom.HEIGHT / 4, pages, unpause, "Tower Selector", 
						0xffffffff, 10, CastleKingdom.WIDTH / 2, CastleKingdom.HEIGHT / 2, 3, 
						function(draggable:Draggable, newX:Number, newY:Number, oldX:Number, oldY:Number):void {
							var tower:DefenseUnit = (draggable as DefenseUnit);
							towers.add(tower);
							Util.placeOnGround(tower, map,false, true);
							tower.dragCallback = function(draggable:Draggable, newX:Number, newY:Number, oldX:Number, oldY:Number):void {
								Util.placeOnGround(draggable as DefenseUnit, map,false, true);
							};
						});
				add(sm);
			});
		}
		
		public function createTowers(info:Array, perRow:int = 4, perColumn:int = 2, 
									 width:Number = CastleKingdom.WIDTH / 2, height:Number = CastleKingdom.HEIGHT / 2):Array {
			var result:Array = [];
			for (var i:int = 0; i < info.length / (perRow * perColumn); i++) {
				var group:FlxGroup = new FlxGroup;
				for (var j:int = 0; j < perColumn; j++) {
					for (var k:int = 0; k < perRow; k++) {
						var tower:DefenseUnit = new DefenseUnit(k * (width / perRow), j * (height / perColumn), info[i].id);
						group.add(tower);
					}
				}
				result[i] = group;
			}
			return result;
		}
		// Display Tower selection menu
		
		// Enable drag and drop
		// call placement check
		
		// Decrease towers available
		
		// 
		
	}
}