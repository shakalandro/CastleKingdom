package
{	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;
	
	import org.flixel.*;
	
	/**
	 * Handles atacking friends. 
	 * @author royman
	 * 
	 */	
	public class AttackFriendsState extends ActiveState
	{		
		public static const LEVEL_THRESHHOLD:Number = CastleKingdom.DEBUG ? 10000000 : 75;
		//TODO: change this back after the test round
		public static const NUM_UNKNOWN_FRIENDS:int = 0;
		
		private var _leftMenu:ScrollMenu;
		private var _rightMenu:ScrollMenu;
		private var _middleMenu:ScrollMenu;
		private var _dropboxes:Array;
		private var _accumulatedUnits:Number;
		
		public function AttackFriendsState(map:FlxTilemap=null, castle:Castle=null, towers:FlxGroup=null, units:FlxGroup=null)
		{
			super(map, castle, towers, units);
			
			_accumulatedUnits = 0;
		}
		
		override public function create():void {
			super.create();
			towers.setAll("canDrag", false);
			towers.setAll("canHighlight", false);
			if (castle.gold < castle.sendWaveCost() && !CastleKingdom.DEBUG) {
				add(new MessageBox(StringUtil.substitute(Util.assets[Assets.ATTACK_FRIENDS_BROKE], castle.sendWaveCost()), "Okay", function():void {
					if (Castle.tutorialLevel == Castle.TUTORIAL_ATTACK_FRIENDS) {
						toggleButtons(4);
					} else if (Castle.tutorialLevel == Castle.TUTORIAL_LEASE) {
						toggleButtons(5);
					} else {
						Util.log("AttackFriendsState.create not enough money, unknown tutorial level");
					}
				}));
			} else {
				_dropboxes = [];
				var padding:Number = 10;
				
				towers.setAll("canDrag", false);
				towers.setAll("canHighlight", false);
				
				var sides:Array = ["Left Side Units", "Right Side Units"];
				var page:Array = formatDropBoxes(castle.width - padding * 2, Util.maxY - Util.minY - 75, 1, 2, sides, _dropboxes, padding);

				Util.getFriendsInRange(Castle.computeValue(castle), LEVEL_THRESHHOLD, function(friends:Array):void {
					formatFriends(friends, castle.x - Util.minX - padding * 2, Util.maxY - Util.minY - 50, 5, function(friendPages:Array):void {
						_middleMenu = new ScrollMenu(castle.x, Util.minY, page, closeMenusAndSend, Util.assets[Assets.ATTACK_FRIENDS_MIDDLE_TITLE], Util.assets[Assets.ATTACK_FRIENDS_BUTTON], FlxG.WHITE, padding, castle.width, Util.maxY - Util.minY, 3);
						add(_middleMenu);
						
						var units:Array = castle.unitsUnlocked(Castle.ARMY, false);
						
						var pages:Array = formatUnits(units, castle.x - Util.minX, Util.maxY - Util.minY - 50, 2, 4);
						
						_rightMenu = new ScrollMenu(castle.x + castle.width, Util.minY, friendPages, closeMenus, Util.assets[Assets.ATTACK_FRIENDS_RIGHT_TITLE], Util.assets[Assets.BUTTON_CANCEL], FlxG.WHITE, 
							padding, Util.maxX - castle.x - castle.width, Util.maxY - Util.minY);
						add(_rightMenu);
						
						_leftMenu = new ScrollMenu(Util.minX, Util.minY, pages, closeMenus, Util.assets[Assets.ATTACK_FRIENDS_LEFT_TITLE], Util.assets[Assets.BUTTON_CANCEL], FlxG.WHITE, padding, 
							castle.x - Util.minX, Util.maxY - Util.minY, 3, moveUnit);
						add(_leftMenu);
					});
				}, Castle.computeValue, NUM_UNKNOWN_FRIENDS);
			}
			setTutorialUI();
		}
		
		private function setTutorialUI():void {
			toggleButtons(0);
		}
		
		/**
		 * Determines if the given unit is allowed to be dragged to the given location. 
		 * If so then the unit is added to the middle menu otherwise it is put back.
		 * 
		 * @param draggable The object being dragged
		 * @param newX
		 * @param newY
		 * @param oldX
		 * @param oldY
		 * 
		 */		
		public function moveUnit(draggable:Draggable, newX:Number, newY:Number, oldX:Number, oldY:Number):void {
			var enemy:EnemyUnit = (draggable as EnemyUnit);
			if (newX > castle.x && newX < castle.x + castle.width && 
					_middleMenu.dropOnto(draggable as FlxObject, oldX, oldY) &&
					_accumulatedUnits + enemy.cost*enemy.multiNumber <= castle.unitCapacity) {
				var newEnemy:EnemyUnit = enemy.clone() as EnemyUnit;
				newEnemy.x = oldX;
				newEnemy.y = oldY;
				newEnemy.setMultiple(castle.unitCapacity - _accumulatedUnits);
				_accumulatedUnits += enemy.cost * enemy.multiNumber;
				enemy.canDrag = false;
				_leftMenu.addToCurrentPage(newEnemy);
				_middleMenu.addToCurrentPage(enemy);
			} else {
				enemy.x = oldX;
				enemy.y = oldY;
				_leftMenu.addToCurrentPage(enemy.clone() as EnemyUnit);
			}
		}
		
		private function checkAttackStatuses():void {
			Database.getFinishedAttacks(function(attacks:Array):void {
				Util.logObj("AttackFriendsState.checkAttackStatuses attacks:", attacks);
				if (attacks != null && attacks.length > 0) {
					FaceBook.getNameByID(attacks[0].aid, function(name:String):void {
						Util.logObj("AttackFriendsState.checkAttackStatuses name:", name);
						if (attacks[0].winAmt > 0) {
							add(new MessageBox(StringUtil.substitute(Util.assets[Assets.ATTACK_FRIENDS_WIN], name, attacks[0].winAmt), Util.assets[Assets.BUTTON_DONE], null));
							castle.addGold(attacks[0].winAmt);
							Database.removeUserAttacks({
								id: FaceBook.uid,
								aid: attacks[0].aid
							});
						} else if (attacks[0].winAmt == 0) {
							add(new MessageBox(StringUtil.substitute(Util.assets[Assets.ATTACK_FRIENDS_LOSE], name), Util.assets[Assets.BUTTON_DONE], null));
							Database.removeUserAttacks({
								id: FaceBook.uid,
								aid: attacks[0].aid
							});
						}
					});
				}
			}, FaceBook.uid, true);
		}
		
		/**
		 * Closes all menus when a single menu is closed and also handles any ui that needs to be drawn as a result. 
		 * 
		 */		
		private function closeMenusAndSend():void {
			// Register an attack in the database if one was made by the user.
			if (FriendBox.selected != null) {
				var leftUnits:String = getAttackingUnits(_dropboxes[0]);
				var rightUnits:String = getAttackingUnits(_dropboxes[1]);
				if (leftUnits.length > 0 || rightUnits.length > 0) {
					var attack:Object = {
						uid: FaceBook.uid + "",
						aid: FriendBox.selected.uid,
						leftSide: leftUnits,
						rightSide: rightUnits
					};
					Util.logObj("Attack:", attack);
					Database.updateUserAttacks(attack);
				}
				castle.addGold(-castle.sendWaveCost());
				FaceBook.getNameByID(FriendBox.selected.uid, function(name:String):void {
					add(new TimedMessageBox(StringUtil.substitute(Util.assets[Assets.ATTACK_FRIENDS_SENT], name)));
					FriendBox.resetSelected();
				});
			} else {
				add(new TimedMessageBox(Util.assets[Assets.ATTACK_FRIENDS_NOT_SENT]));
			}
			closeMenus();
		}
		
		public function closeMenus():void {
			if (Castle.tutorialLevel == Castle.TUTORIAL_ATTACK_FRIENDS) {
				Database.updateUserTutorialInfo(FaceBook.uid, Castle.TUTORIAL_LEASE);
				Castle.tutorialLevel = Castle.TUTORIAL_LEASE;
				add(new MessageBox(Util.assets[Assets.SENT_WAVE], "Okay", function():void {
					toggleButtons(5);
				}));
			} else if (Castle.tutorialLevel == Castle.TUTORIAL_LEASE) {
				toggleButtons(5);
			} else {
				Util.log("Unknown tutorial leval: " + Castle.tutorialLevel);
			}
			_rightMenu.kill();
			_leftMenu.kill();
			_middleMenu.kill();
			checkAttackStatuses();
		}
		
		/**
		 * Builds a comma seperated string of the ids of the attackng units for the given dropbox
		 *  
		 * @param dropbox A Droppable object presumably filled with EnemyUnits
		 * @return A valid attack string of unit ids
		 * 
		 */		
		private function getAttackingUnits(dropbox:FlxGroup):String {
			var units:String = "";
			for each (var thing:FlxBasic in dropbox.members) {
				if (thing is EnemyUnit) {
					var enemy:EnemyUnit = thing as EnemyUnit;
					for(var i:int = 0; i < enemy.multiNumber; i++) {
						units += enemy.unitID + ",";
					}
				}
			}
			return units.substr(0, units.length - 1);
		}
		
		/**
		 * Creates and positions units in an array of FlxGroups suitable for a ScrollMenu
		 *  
		 * @param units An array of unit info, presumably from the Database
		 * @param width
		 * @param height
		 * @param perRow
		 * @param perColumn
		 * @param padding
		 * @return An array of FlxGroups containing EnemUnits
		 * 
		 */		
		private function formatUnits(units:Array, width:Number, height:Number, perRow:int, perColumn:int, padding:Number = 10):Array {
			//perRow = 3;
			var result:Array = [];
			for (var i:int = 0; i < units.length / (perRow * perColumn); i++) {
				var group:FlxGroup = new FlxGroup;
				for (var j:int = 0; j < perColumn; j++) {
					for (var k:int = 0; k < perRow; k++) {
						var index:Number = i * (perRow * perColumn) + j * perRow + k;
						
						if (index < units.length) {
							var baddy:EnemyUnit = new EnemyUnit(k * (width / perRow), j * (height / perColumn), units[index], true, null, false);
							baddy.setMultiple(castle.unitCapacity);
							var name:FlxText = new FlxText(k * (width / perRow), j * (height / perColumn), width / perRow - padding, baddy.name);
							name.color = FlxG.BLACK;
							
							baddy.y += name.height;
							
							group.add(baddy);
							group.add(name);
						}
					}
				}
				result[i] = group;
			}
			return result;
		}
		
		/**
		 * Creates an array of FlxGroups filled with FriendBoxes for use in a ScrollMenu. 
		 * Due to the asynchrony of fetching profile pics, a callback is taken and provided 
		 * with the Array when the work is done.
		 * 
		 * @param friends An array of friend info from FaceBook
		 * @param width
		 * @param height
		 * @param numPer A desired maximum number of FriendBoxes per page
		 * @param callback A callback with teh signature callback(friends:Array):void
		 * 
		 */		
		private function formatFriends(friends:Array, width:Number, height:Number, numPer:int, callback:Function):void {
			FaceBook.getAllPictures(friends, function(sprites:Array):void {
				var pages:Array = [];
				var page:FlxGroup = new FlxGroup();
				var i:int = 0;
				var y:Number = 0;
				var padding:Number = 10;
				while (i < sprites.length) {
					if (y + sprites[i].height + 2 * padding > height || page.members.length >= numPer) {
						y = 0;
						pages.push(page);
						page = new FlxGroup();
					}
					var friendBox:FriendBox = new FriendBox(0, y, width, sprites[i], friends[i].name, friends[i].id, function(uid:String, setCallback:Function):void {
						Database.isBeingAttacked(function(attacks:Array):void {
							setCallback(attacks == null || attacks.length == 0);
						}, uid, true);
					}, true);
					
					page.add(friendBox);
					
					y += friendBox.height + padding / 2;
					i++;
				}
				pages.push(page);
				callback(pages);
			});
		}
		
		/**
		 * Creates an Array of FlxGroups suitable for use in a ScrollMenu. Creates perRow * perColumn AttackBoxes with accompanying lables pulled from 'titles'.
		 * Also fills the given array with dropboxes for use elsewhere if desired.
		 *  
		 * @param width
		 * @param height
		 * @param perRow
		 * @param perColumn
		 * @param titles An array of strings to be used as dropbox labels. Must have length >= perRow * perColumn
		 * @param dropboxes An array to fill with the dropboxes.
		 * @param padding
		 * @param bgColor
		 * @return An array of FlxGroups filled with AttackBoxes for use in a ScrollMenu
		 * 
		 */		
		private function formatDropBoxes(width:Number, height:Number, perRow:int, perColumn:int, titles:Array, dropboxes:Array = null, padding:Number = 10, bgColor:uint = 0xff777777):Array {
			var boxWidth:Number = (width - padding * (perRow - 1)) / perRow;
			var boxHeight:Number = (height - padding * (perColumn - 1)) / perColumn;
			var page:Array = [];
			var boxes:FlxGroup = new FlxGroup();
			for (var i:int = 0; i < perRow; i++) {
				for (var j:int = 0; j < perColumn; j++) {
					var x:Number = boxWidth * i + i * padding;
					var y:Number = boxHeight * j + j * padding;
					
					var text:FlxText = new FlxText(x, y, boxWidth, titles[i * perColumn + j]);
					text.y -= text.height - 3;
					text.color = FlxG.BLACK;
					var box:AttackBox = new AttackBox(x, y, boxWidth, boxHeight, titles[i * perColumn + j]);
					if (dropboxes != null) dropboxes.push(box);
					boxes.add(box);
					boxes.add(text);
				}
			}
			page.push(boxes);
			return page;
		}
		
		override public function drawStats():void {
			super.drawStats();
			if (_middleMenu != null && _middleMenu.exists) {
				_armyDisplay.visible = true;
			} else {
				_armyDisplay.visible = false;
			}
			_armyDisplay.value = _accumulatedUnits;
			_armyDisplay.max = castle.unitCapacity;
		}
		
		public function get accumulatedUnits():int {
			return _accumulatedUnits;
		}
	}
}
