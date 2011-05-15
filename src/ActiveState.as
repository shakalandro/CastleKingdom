package
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.utils.StringUtil;
	
	import org.flixel.*;
	import org.flixel.system.FlxWindow;
	
	/**
	 * Creates additional functionality for game states whether the player is actively involved. 
	 * Handles things like menu interaction, ranged collision detection and adding units to the map. 
	 * @author royman
	 * 
	 */	
	public class ActiveState extends GameState
	{	
		public static const UPGRADE_MENU:String = "upgrade";
		public static const ATTACK_MENU:String = "attack";
		public static const DEFEND_MENU:String = "defend";
		public static const BUTTON_DIST:Number = 75;
						
		private static const HUD_BUTTON_PADDING:uint = 10;
		
		/**
		 * A reference to the singleton castle object.
		 */		
		private var _castle:Castle;
		
		/**
		 * A group of DefenseUnits 
		 */		
		private var _towers:FlxGroup;
		
		/**
		 * A group of EnemyUnits 
		 */		
		private var _units:FlxGroup;
		
		/** FlxSprites for unit caps/gold;
		 * 
		 * */
		private var _goldDisplay:FlxText;
		private var _towerDisplay:FlxText;
		private var _armyDisplay:FlxText;
		private var _hudButtons:Array;
		private var _attackTimer:Timer;
		private var _attackAnims:FlxGroup;
		
		public var attackPending:Boolean;
		
		/** 
		 * An active state is a helper super class for interactive game states such as DefendState and UpgradeState. 
		 * Maintains the tilemap and a reference to the castle object. Performs ranged collision calculation.
		 * 
		 * @param tutorial Whether the state should display tutorial information and UI components.
		 * @param menusActive Whether the menu buttons are active
		 * 
		 */		
		public function ActiveState(map:FlxTilemap = null, castle:Castle = null, towers:FlxGroup = null, units:FlxGroup = null)
		{
			super(map);
			_towers = towers || new FlxGroup();
			_units = units || new FlxGroup();
			_attackAnims = new FlxGroup();
			_hudButtons = [];
			_castle = castle;
			attackPending = false;
		}
		
		/**
		 * Sets up the Tilemap based on the information in FlxSave or the Database
		 * Draws tutorial UI components if tutorial is true. Draws the menu buttons on the screen.
		 * 
		 */		
		override public function create():void {
			super.create();
			add(_towers);
			add(_units);
			add(_attackAnims);
			_castle = _castle || new Castle(0, 0, Util.assets[Assets.CASTLE]);
			Util.centerX(_castle);
			Util.placeInZone(_castle, map);
			add(_castle);
			
			if (CastleKingdom.FACEBOOK_ON) {
				FaceBook.picture(function(pic:Class):void {
					var profilePic:FlxSprite = new FlxSprite(0, 0, pic);
					profilePic.allowCollisions = FlxObject.NONE;
					profilePic.immovable = true;
					Util.center(profilePic, header);
					profilePic.x = Util.maxX - profilePic.width;
					hud.add(profilePic);
				}, "me", false);
			}
			
			if (!attackPending) {
				checkForPendingAttacks(function():void {
					
					if (CastleKingdom.DEBUG) {
						var clear:CKButton = new CKButton(0, 0, "Clear", function():void {
							Util.log("Clearing the tutorial info: " + FaceBook.uid + ", " + Castle.TUTORIAL_NEW_USER);
							Database.updateUserTutorialInfo(FaceBook.uid, Castle.TUTORIAL_NEW_USER);
						});
						clear.x = _hudButtons[0].x + _hudButtons[0].width + 20;
						Util.centerY(clear, header);
						clear.allowCollisions = FlxObject.NONE;
						clear.immovable = true;
						add(clear);
					}
					 
					setTutorialUI();
				});
			} else {
				setTutorialUI();
			}
		}
		
		/**
		 * Handles what buttons and other ui should be displayed based on the tutorial level. 
		 * 
		 */		
		private function setTutorialUI():void {
			Util.log("ActiveState Tutorial Level: " + Castle.tutorialLevel);
			if (Castle.tutorialLevel == Castle.TUTORIAL_NEW_USER) {
				toggleButtons(0);
				add(new MessageBox(Util.assets[Assets.INITIAL_PENDING_WAVE_TEXT], "Close", function():void {
					Database.updateUserTutorialInfo(FaceBook.uid, Castle.TUTORIAL_FIRST_DEFEND);
					Castle.tutorialLevel = Castle.TUTORIAL_FIRST_DEFEND;
					toggleButtons(1);
				}));
			} else if (Castle.tutorialLevel == Castle.TUTORIAL_FIRST_DEFEND) {
				toggleButtons(1);
			} else if (Castle.tutorialLevel == Castle.TUTORIAL_FIRST_WAVE) {
				toggleButtons(2);
			} else if (Castle.tutorialLevel == Castle.TUTORIAL_UPGRADE) {
				toggleButtons(3);
			} else if (Castle.tutorialLevel == Castle.TUTORIAL_ATTACK_FRIENDS) {
				toggleButtons(4);
			} else if (Castle.tutorialLevel == Castle.TUTORIAL_LEASE) {
				toggleButtons(5);
			} else {
				Util.log("ActiveState.setTutorialUI: unexpected tutorial level " + Castle.tutorialLevel);
			}
		}
		
		/**
		 * Checks if there is an attack pending and if so the attack is started, 
		 * otherwise the callback is executed which presumably establishes other ui 
		 * @param callback A callback with the signature callback():void
		 * 
		 */		
		private function checkForPendingAttacks(callback:Function):void {
			Util.log("ActiveState.checkForPendingAttacks looking for pending attack");
			Database.pendingAttacks(function(attacks:Array):void {
				if (attacks == null || attacks.length == 0) {
					Util.log("ActiveState.checkForPendingAttacks, no pending attack");
					callback();
				} else {
					FaceBook.getNameByID(attacks[0].id, function(name:String):void {
						if (name != null) {
							Util.log("ActiveState.checkForPendingAttacks attack found: " + name);
							toggleButtons(0);
							attacks[0].name = name;
							var box:MessageBox = new MessageBox(StringUtil.substitute(Util.assets[Assets.INCOMING_WAVE], name, castle.surrenderCost()), "Defend", function():void {
								FlxG.switchState(new DefenseState(map, remove(castle) as Castle, remove(towers) as FlxGroup, true, attacks[0]));
							}, "Surrender", function():void {
								castle.addGold(-castle.surrenderCost());
								setTutorialUI();
								Database.removeUserAttacks({
									id: attacks[0].id, 
									aid: attacks[0].aid
								});
								box.close();
							});
							FlxG.state.add(box);
						} else {
							callback();
							Util.logObj("ActiveState.checkForPendingAttacks pending attack, but user unknown ", attacks[0]);
						}
					});
				}
			}, FaceBook.uid);
		}
		
		override public function update():void {
			super.update();
			drawStats();
		}
		
		/**
		 * Sets the first index buttons to active and visible and the rest to inactive and invisible. 
		 * @param index 
		 * 
		 */		
		protected function toggleButtons(index:int):void {
			for (var i:int = 0; i < _hudButtons.length; i++) {
				_hudButtons[i].active = (i < index);
				_hudButtons[i].visible = (i < index);
			}
		}
		
		/**
		 * In addition to normal collision detection, detects collisions between units with ranges. 
		 * If a unit does have a ranged collisions, the unit's hitRanged method is called.
		 * The object that the unit collided with is passed as the first parameter to hitRanged.
		 * <ul>
		 * 		<li>ex) an archer moves within its range of a wall</li>
		 * 		<li>ex) an arrow tower has a guy come within its range</li>
		 * </ul>
		 * 
		 */		
		public function collide():void {
			FlxG.collide(units, towers, fightCollide);
			FlxG.collide(units, this.castle, endGameCollide);
			FlxG.collide(units, this.map);
			//FlxG.collide(units, attackAnims, animCollide);
			//FlxG.collide(towers, attackAnims, animCollide);
		}
		
		private function fightCollide(unit1:FlxSprite, unit2:FlxSprite):void {
			(unit1 as Unit).hitRanged(unit2);
			(unit2 as Unit).hitRanged(unit1);
		}
		
		/**
		 * Initiates procedure for units hitting the arrows
		 * */
		private function animCollide(unit1:FlxSprite, unit2:FlxSprite):void {
			if(unit1 is AttackAnimation) {
				(unit1 as AttackAnimation).hitLeft(unit2);
				
			} else {
				(unit2 as AttackAnimation).hitLeft(unit1);	
			}
		}
		
		
		
		/**
		 * Initiates procedure for units hitting the castle
		 * */
		private function endGameCollide(unit1:FlxSprite, unit2:FlxSprite):void {
			if(unit1 is Castle) {
				(unit1 as Castle).hitRanged(unit2);
				(unit2 as Unit).hitRanged(unit1);
			} else {
				(unit1 as Unit).hitRanged(unit2);
				(unit2 as Castle).hitRanged(unit1);	
			}
		}
		
		/** Initiates procedure for interacting with ground
		 * */
		private function groundCollide(unit1:FlxSprite, unit2:FlxSprite):void {
			(unit1 as Unit).hitRanged(unit2);
			(unit2 as Unit).hitRanged(unit1);
		}
		
		
		/**
		 * 
		 * @return The singleton castle object
		 * 
		 */		
		public function get castle():Castle {
			return _castle;
		}
		
		/**
		 * 
		 * @return The FlxGroup of units.
		 * 
		 */		
		public function get units():FlxGroup {
			return _units;
		}
		
		/**
		 * 
		 * @return The FlxGroup of towers.
		 * 
		 */		
		public function get towers():FlxGroup {
			return _towers;
		}
		
		public function get attackAnims():FlxGroup {
			return _attackAnims;
		}
 		
		/**
		 * Adds the given DefenseUnit to the display list at the closest tile indices (rounded down) if possible. 
		 *  
		 * @param tower Which tower to add to the tilemap
		 * @param place Where to add the tile
		 * @return Whether placing the tower was successful. This could fail if the given place is not open.
		 * 
		 */				
		public function addDefenseUnit(tower:DefenseUnit, snapToGround:Boolean = true):Boolean {
			return addUnit(_towers, tower, snapToGround);
		}
		
		/**
		 * Adds the given EnemyUnit to the display list at the closest tile indices (rounded down) if possible.
		 * 
		 * @param unit The unit being added.
		 * @param x A cartesian x coordinate
		 * @param y A cartesian y coordinate
		 * @return Whether the given unit was able to be placed.
		 * 
		 */	
		public function addEnemyUnit(enemy:EnemyUnit, snapToGround:Boolean = false):Boolean {				
			return addUnit(_units, enemy, snapToGround);
		}
		
		/**
		 * Adds the given Unit to the given group at the closest tile indices (rounded down) if possible.
		 * 
		 * @param group The desired group to add to
		 * @param unit A unit to add if possible
		 * @param x A cartesian x coordinate
		 * @param y A cartesian y coordinate
		 * @return 
		 * 
		 */		
		private function addUnit(group:FlxGroup, unit:Unit, snapToGround:Boolean = true):Boolean {
			if (placeable(unit.x, unit.y)) {
				var coordinates:FlxPoint = Util.roundToNearestTile(new FlxPoint(unit.x, unit.y));
				unit.x = coordinates.x;
				unit.y = coordinates.y;
				if (unit.clas == "ground") Util.placeInZone(unit, map, true, true);
			
				group.add(unit);
				//add(unit);
				return true;
			}
			return false;
		}
		
		/**
		 * This method determines whether the given (x, y) coordinate is a valid place to put a tower.
		 * Checks whether the location is obstructed by a collidable tile (terrain) 
		 * or the location is already taken by an existing tower.
		 * 
		 * @param x The cartesian x coordinate being considered
		 * @param y The cartesian y coordinate being considered
		 * @return Whether a tower could be placed at (x, y)
		 * 
		 */		
		public function placeable(x:int, y:int):Boolean {
			if (!Util.inBounds(x, y)) return false;
			var indices:FlxPoint = Util.cartesianToIndices(new FlxPoint(x, y));
			var tileType:int = map.getTile(indices.x, indices.y);
			if (tileType >= map.collideIndex) {
				return false;
			}
			for each (var obj:FlxObject in _towers.members) {
				if( obj != null) {
					var objIndices:FlxPoint = Util.cartesianToIndices(new FlxPoint(obj.x, obj.y), true);
					if (objIndices.x == indices.x && objIndices.y == indices.y) {
						return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * 
		 * @param x A cartesian x coordinate
		 * @param y A cartesian y coordinate
		 * @return 
		 * 
		 */		
		public function droppable(x:int, y:int):Boolean {
			if (!Util.inBounds(x, y)) return false;
			var indices:FlxPoint = Util.cartesianToIndices(new FlxPoint(x, y));
			var castleStart:int = Util.cartesianToIndices(new FlxPoint(Util.castle.x, Util.castle.y)).x;
			var castleStop:int = Util.cartesianToIndices(new FlxPoint(Util.castle.x + Util.castle.width, Util.castle.y)).x;
			if (indices.x >= castleStart && indices.x < castleStop) {
				return false;
			}
			//fix weird null bug
			for each (var obj:FlxObject in towers.members) {
				if (obj == null) {
					towers.remove(obj);
				}
			}
			for each (obj in towers.members) {
				var objStart:FlxPoint = Util.cartesianToIndices(new FlxPoint(obj.x, obj.y));
				var objStop:FlxPoint = Util.cartesianToIndices(new FlxPoint(obj.x + obj.width, obj.y));
				if (obj is DefenseUnit) {
					var tower:DefenseUnit = obj as DefenseUnit;
					if (tower.clas == Unit.GROUND) {
						if (indices.x >= objStart.x && indices.x < objStop.x) {
							return false;
						}
					} else {
						if (indices.x >= objStart.x && indices.x < objStop.x && 
							indices.y >= objStart.y && indices.y <= objStop.y) {
							return false;
						}
					}
				}
			}
			return true;
		}
		
		override protected function createHUD():void {
			super.createHUD();
			var _prepare:CKButton = new CKButton(0, 0, Util.assets[Assets.PLACE_TOWER_BUTTON], function():void {
				var oldCastle:Castle = remove(castle);
				var defTowers:FlxGroup = remove(towers);
				Util.logging.startDquest(Castle.TUTORIAL_FIRST_DEFEND);
				FlxG.switchState(new DefenseState(map, oldCastle, defTowers));
			});
			var _release:CKButton = new CKButton(0, 0, Util.assets[Assets.RELEASE_WAVE_BUTTON], function():void {
				var defTowers:FlxGroup = remove(towers);
				var oldCastle:Castle = remove(castle);
				Util.logging.startDquest(Castle.TUTORIAL_FIRST_WAVE);
				FlxG.switchState(new AttackState(map, oldCastle, defTowers));
			});
			var _upgrade:CKButton = new CKButton(0, 0, Util.assets[Assets.UPGRADE_BUTTON], function():void {
				var oldCastle:Castle = remove(castle);
				var defTowers:FlxGroup = remove(towers);
				Util.logging.startDquest(Castle.TUTORIAL_UPGRADE);
				FlxG.switchState(new UpgradeState(map, oldCastle, defTowers));
			});
			var _attack:CKButton = new CKButton(0, 0, Util.assets[Assets.ATTACK_BUTTON], function():void {
				var oldCastle:Castle = remove(castle);
				var defTowers:FlxGroup = remove(towers);
				Util.logging.startDquest(Castle.TUTORIAL_ATTACK_FRIENDS);
				FlxG.switchState(new AttackFriendsState(map, oldCastle, defTowers));
			});
			var _lease:CKButton = new CKButton(0, 0, Util.assets[Assets.LEASE_BUTTON], function():void {
				Util.logging.startDquest(Castle.TUTORIAL_LEASE);
				var oldCastle:Castle = remove(castle);
				var defTowers:FlxGroup = remove(towers);
				FlxG.switchState(new LeaseState(map, oldCastle, defTowers));

			});
			
			_hudButtons.push(_prepare);
			_hudButtons.push(_release);
			_hudButtons.push(_upgrade);
			_hudButtons.push(_attack);
			_hudButtons.push(_lease);
			
			Util.centerY(_prepare, header);
			Util.centerY(_release, header);
			Util.centerY(_upgrade, header);
			Util.centerY(_attack, header);
			Util.centerY(_lease, header);
			spreadPosition(_prepare, 5, 5);
			spreadPosition(_release, 5, 4);
			spreadPosition(_upgrade, 5, 3);
			spreadPosition(_attack, 5, 2);
			spreadPosition(_lease, 5, 1);
			
			_armyDisplay = new FlxText(0, 10, 100, "");
			_towerDisplay = new FlxText(0, 20,100, "");
			_goldDisplay = new FlxText(0, 0, 100, "");
			hud.add(_goldDisplay);
			hud.add(_armyDisplay);
			hud.add(_towerDisplay);

			hud.add(_prepare);
			hud.add(_release);
			hud.add(_upgrade);
			hud.add(_attack);
			hud.add(_lease);
		}
		
		private function spreadPosition(thing:FlxObject, peices:Number, place:int):void {
			var width:Number = (FlxG.width - BUTTON_DIST * 2) / (peices + 1);
			thing.x = place * width + BUTTON_DIST - thing.width / 2;
		}
		
		public function drawStats(startX:int = 0, startY:int = 0):void {
			_armyDisplay.text = this.castle.unitCapacity - this.castle.armyUnitsAvailable + " of " + this.castle.unitCapacity + " Armies";
			_towerDisplay.text = (this.castle.towerCapacity - this.castle.towerUnitsAvailable) + " of " + this.castle.towerCapacity + " Towers";
			_goldDisplay.text = "Gold: " + this.castle.gold;
		}
	}
}

import org.flixel.FlxButton;

class CKButton extends FlxButton {	
	public function CKButton(x:Number, y:Number, text:String, onClick:Function = null, onOver:Function = null, onOut:Function = null) {
		super(x, y, text, onClick, onOver, onOut);
	}
	public function set onClick(callback:Function):void {
		_onClick = callback;
	}
	public function get onClick():Function {
		return _onClick;
	}
}
