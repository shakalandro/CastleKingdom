package
{
	import org.flixel.*;
	
	public class DefenseState extends ActiveState
	{		
		
		private var _menu:ScrollMenu;
		private var _forcedAttack:Boolean;
		private var _pendingAttack:Object;
		
		public function DefenseState(map:FlxTilemap=null, castle:Castle = null, towers:FlxGroup = null, forcedAttack:Boolean = false, pendingAttack:Object = null)
		{
			super(map, castle, towers);
			_forcedAttack = forcedAttack;
			_pendingAttack = pendingAttack;
			if (_pendingAttack != null) {
				attackPending = true;
			}
			for each (var tower:Unit in towers.members) {
				if(tower != null ) {
					tower.health = tower.maxHealth;
				}
			}
		}
		
		/**
		 * Displays the drag and drop defenseunit menu 
		 * 
		 */		
		override public function create():void {
			super.create();
			
			towers.setAll("canDrag", true);
			towers.setAll("canHighlight", true);
			towers.setAll("dragCallback", handleMapTowerDrag);

			// create selection menu of all avaiable towers
			var unitsUnlocked:Array = this.castle.unitsUnlocked(Castle.TOWER);
			
			var pages:Array = createTowers(unitsUnlocked, 2, 4, Castle.TILE_WIDTH * CastleKingdom.TILE_SIZE, Util.maxY - Util.minY - 50);
			_menu = new ScrollMenu(castle.x, Util.minY, pages, closeHandler, Util.assets[Assets.DEFEND_MENU_TITLE], Util.assets[Assets.DEFEND_MENU_BUTTON], 
				0xffffffff, 10, Castle.TILE_WIDTH * CastleKingdom.TILE_SIZE, Util.maxY - Util.minY, 3, takeTower);
			add(_menu);
			
			setTutorialUI();
		}
		
		private function closeHandler():void {
			if (_forcedAttack) {
				FlxG.switchState(new AttackState(map, remove(castle) as Castle, remove(towers) as FlxGroup, null, _pendingAttack));
			}
		}
		
		private function setTutorialUI():void {
			toggleButtons(0);
			if (_forcedAttack) {
				_menu.onClose = closeHandler;
			} else {
				Util.log("Got into the tutorial if tree");
				if (Castle.tutorialLevel == Castle.TUTORIAL_FIRST_DEFEND || Castle.tutorialLevel == Castle.TUTORIAL_FIRST_WAVE) {
					_menu.onClose = function():void {
						unpause();
						add(new MessageBox(Util.assets[Assets.FIRST_DEFENSE], "Okay", function():void {
							toggleButtons(2);
						}));
					};
				} else if (Castle.tutorialLevel == Castle.TUTORIAL_UPGRADE) {
					_menu.onClose = function():void {
						unpause();
						toggleButtons(3);
					};
				} else if (Castle.tutorialLevel == Castle.TUTORIAL_ATTACK_FRIENDS) {
					_menu.onClose = function():void {
						unpause();
						toggleButtons(4);
					};
				} else if (Castle.tutorialLevel == Castle.TUTORIAL_LEASE) {
					_menu.onClose = function():void {
						unpause();
						toggleButtons(5);
					};
				} else {
					Util.log("Unexpected tutorial level: " + Castle.tutorialLevel);
				}
			}
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
			if (!droppable(newX, newY) || tower.cost > (FlxG.state as ActiveState).castle.towerUnitsAvailable) {
				tower.x = oldX;
				tower.y = oldY;
				_menu.addToCurrentPage(tower.clone());
			} else {
				tower = (draggable as DefenseUnit);
				var newTower:DefenseUnit = tower.clone() as DefenseUnit;
				newTower.x = oldX;
				newTower.y = oldY;
				_menu.addToCurrentPage(newTower);
				towers.add(tower);
				var tileCoords:FlxPoint = Util.roundToNearestTile(new FlxPoint(newX, newY));
				tower.x = tileCoords.x;
				tower.y = tileCoords.y;
				Util.placeInZone(tower, map, true, true);
				tower.allowCollisions = FlxObject.ANY;
				tower.immovable = true;
				tower.dragCallback = handleMapTowerDrag;
			}
		}
		
		private function handleMapTowerDrag(draggable:Draggable, newX:Number, newY:Number, oldX:Number, oldY:Number):void {
			var tower:DefenseUnit = draggable as DefenseUnit;
			tower.x = oldX;
			tower.y = oldY;
			if (droppable(newX, newY)) {
				tower.x = newX;
				tower.y = newY;
				Util.placeInZone(tower, map,true, true);
				//Util.placeOnGroundOld(tower, map, false, true);
			} else if (newX > castle.x && newX < castle.x + castle.width && _menu.visible) {
				towers.remove(tower, true);
			}			
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
				width:Number = CastleKingdom.WIDTH / 2, height:Number = CastleKingdom.HEIGHT / 2, padding:Number = 10):Array {
			var result:Array = [];
			for (var i:int = 0; i < info.length / (perRow * perColumn); i++) {
				var group:FlxGroup = new FlxGroup;
				for (var j:int = 0; j < perColumn; j++) {
					for (var k:int = 0; k < perRow; k++) {
						var index:Number = i * (perRow * perColumn) + j * perRow + k;

						if (index < info.length) {
							//var towerGroup:FlxGroup = new FlxGroup();
							var tower:DefenseUnit = new DefenseUnit(k * (width / perRow), j * (height / perColumn), info[index]);
							var name:FlxText = new FlxText(k * (width / perRow), j * (height / perColumn), width / perRow - padding, tower.name);
							name.color = FlxG.BLACK;
							
							tower.y += name.height;
							
							group.add(tower);
							group.add(name);
						}
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
