package
{
	import org.flixel.*;
	
	public class DefenseState extends ActiveState
	{		
		public function DefenseState(tutorial:Boolean=false, menusActive:Boolean=false, map:FlxTilemap=null)
		{
			super(tutorial, menusActive, map);
		}
		
		/**
		 * Displays the drag and drop defenseunit menu 
		 * 
		 */		
		override public function create():void {
			super.create();
			
			Database.getDefenseUnitInfo(function(info:Array):void {
				var pages:Array = createTowers(info);
				var sm:ScrollMenu = new ScrollMenu(CastleKingdom.WIDTH / 4, CastleKingdom.HEIGHT / 4, pages, unpause, "Tower Selector", 
						0xffffffff, 10, CastleKingdom.WIDTH / 2, CastleKingdom.HEIGHT / 2, 3, takeTower);
				add(sm);
			});
		}
		
		/**
		 * Takes a tower from the menu and puts it into the state 
		 * @param draggable the tower being pulled over
		 * @param newX its new x position
		 * @param newY its new y position
		 * @param oldX its x position before being dragged
		 * @param oldY its y position before being dragged
		 * 
		 */		
		public function takeTower(draggable:Draggable, newX:Number, newY:Number, oldX:Number, oldY:Number):void {
			var tower:DefenseUnit = (draggable as DefenseUnit);
			towers.add(tower);
			Util.placeOnGround(tower, map,false, true);
			tower.allowCollisions = FlxObject.ANY;
			tower.immovable = true;
			tower.dragCallback = function(draggable:Draggable, newX:Number, newY:Number, oldX:Number, oldY:Number):void {
				Util.placeOnGround(draggable as DefenseUnit, map,false, true);
			};
		}
		
		/**
		 * Given an array of tower info objects constructs and returns an Array of FlxGroups intended for plcement in a ScrollMenu 
		 * @param info The array of towers
		 * @param perRow how many towers per row in a group
		 * @param perColumn how many towers per column in a group
		 * @param width how wide can the group spread
		 * @param height how tall can the group spread
		 * @return An array of FlxGroups containing towers in a grid pattern.
		 * 
		 */		
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
		
		override public function update():void {
			super.update();
		}
		
	}
}
