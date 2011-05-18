package
{
	import org.flixel.*;
	
	/**
	 * Handles buying upgrades. 
	 * @author royman
	 * 
	 */	
	public class UpgradeState extends ActiveState
	{
		private var _leftMenu:ScrollMenu;
		private var _rightMenu:ScrollMenu;
		
		public function UpgradeState(map:FlxTilemap=null, castle:Castle=null, towers:FlxGroup=null, units:FlxGroup=null)
		{
			super(map, castle, towers, units);
		}
		
		override public function create():void {
			super.create();
			
			towers.setAll("canDrag", true);
			towers.setAll("canHighlight", true);
			
			Database.getUpgradesInfo(function(info:Array):void {
				var padding:Number = 10;
				
				info = info.filter(function(obj:Object, index:int, arr:Array):Boolean {
					return checkLevel(obj);
				});
				
				var upgrades:Array = createUpgrades(info.slice(0, (info.length + 1) / 2), castle.x - Util.minX - padding * 2, 
						Util.maxY - Util.minY - 50 - padding * 2, 2, 4, acquireUpgrade);
				_leftMenu = new ScrollMenu(Util.minX, Util.minY, upgrades, closeMenus, Util.assets[Assets.UPGRADE_LEFT_TITLE], Util.assets[Assets.BUTTON_DONE],
					FlxG.WHITE, padding, castle.x - Util.minX, Util.maxY - Util.minY);
				
				upgrades = createUpgrades(info.slice((info.length + 1) / 2, info.length), Util.maxX - (castle.x + castle.width) - padding * 2, 
					Util.maxY - Util.minY - 50 - padding * 2, 2, 4, acquireUpgrade);
				_rightMenu = new ScrollMenu(castle.x + castle.width, Util.minY, upgrades, closeMenus, Util.assets[Assets.UPGRADE_RIGHT_TITLE], Util.assets[Assets.BUTTON_DONE], 
					FlxG.WHITE, padding, Util.maxX - (castle.x + castle.width), Util.maxY - Util.minY);
				add(_leftMenu);
				add(_rightMenu);
			});
		}
		
		private function closeMenus():void {
			_leftMenu.kill();
			_rightMenu.kill();
			if (Castle.tutorialLevel == Castle.TUTORIAL_UPGRADE && castle.numUpgrades > Castle.TUTORIAL_UPGRADES_NEEDED) {
				toggleButtons(0);
				add(new MessageBox(Util.assets[Assets.FIRST_ATTACK], "Okay", function():void {
					toggleButtons(4);
					Database.updateUserTutorialInfo(FaceBook.uid, Castle.TUTORIAL_ATTACK_FRIENDS);
					Castle.tutorialLevel = Castle.TUTORIAL_ATTACK_FRIENDS;
				}));
			}
		}
		
		private function acquireUpgrade(upgrade:Upgrade):Boolean {
				if (upgrade.type == "castle") {
					Util.logging.logCastleUpgrade(upgrade.level);
				} else if (upgrade.type == "barracks") {
					Util.logging.logBarracksUpgrade(upgrade.level);
				} else if (upgrade.type == "foundry") {
					Util.logging.logFoundryUpgrade(upgrade.level);
				} else if (upgrade.type == "aviary"){
					Util.logging.logAviaryUpgrade(upgrade.level);
				}
			return castle.setUpgrade(upgrade);
		}
		
		private function createUpgrades(info:Array, width:Number, height:Number, perRow:int, perColumn:int, clickCallback:Function):Array {
			var pages:Array = [];
			for (var i:int = 0; i < info.length / (perRow * perColumn); i++) {
				var group:FlxGroup = new FlxGroup();
				for (var j:int = 0; j < perColumn; j++) {
					for (var k:int = 0; k < perRow; k++) {
						var index:Number =  i * (perRow * perColumn) + j * perRow + k;
						if (index < info.length) {
							var bgColor:uint = FlxG.WHITE;
							
							if (info[index].type == "mine") bgColor = 0xFFAA4E07;
							else if (info[index].type == "castle") bgColor = FlxG.PINK;
							else if (info[index].type == "aviary") bgColor = FlxG.BLUE;
							else if (info[index].type == "foundry") bgColor = 0xFF767473;
							else if (info[index].type == "barracks") bgColor = FlxG.GREEN;
							var upgrade:Upgrade = new Upgrade(k * (width / perRow), j * (height / perColumn), 
								width / perRow, height / perColumn, info[index].name, info[index].unitWorth, info[index].level,
								info[index].goldCost, info[index].type, info[index].id, clickCallback, bgColor);
							group.add(upgrade);
						}
					}
				}
				pages[i] = group;
			}
			return pages;
		}
		
		private function checkLevel(value:Object):Boolean {
			if( (CastleKingdom.DEBUG && (this.castle.upgrades[value.type] < parseInt(value.level.toString()))) || 
					(this.castle.upgrades[value.type.toString()] == parseInt(value.level.toString()) - 1
					&& (this.castle.upgrades["castle"] >= parseInt(value.level.toString()) || value.type.toString() == "castle") 
					&& checkMineLevel(value) && checkAviaryLevel(value))) {
				return true;
			} else {
				return false;
			}
		}
		
		private function checkAviaryLevel(value:Object):Boolean {
			var stage:Array = [0,8,11,15,21];
			return value.type.toString() != "aviary" || this.castle.upgrades["castle"] >= stage[parseInt(value.level.toString())];
		}
		
		private function checkMineLevel(value:Object):Boolean {
			var stage:Array = [0,5,7,11,15,21];
			return value.type.toString() != "mine" || this.castle.upgrades["castle"] >= stage[parseInt(value.level.toString())];
		}
	}
}
