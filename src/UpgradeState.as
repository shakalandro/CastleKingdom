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
			Database.getUpgradesInfo(function(info:Array):void {
				var padding:Number = 10;
				var upgrades:Array = createUpgrades(info, 0, info.length / 2, castle.x - Util.minX - padding * 2, 
						Util.maxY - Util.minY - 50 - padding * 2, 2, 4, acquireUpgrade);
				_leftMenu = new ScrollMenu(Util.minX, Util.minY, upgrades, closeMenus, "Castle Upgrades", 
					FlxG.WHITE, padding, castle.x - Util.minX, Util.maxY - Util.minY);
				
				upgrades = createUpgrades(info, info.length / 2 + 1, info.length, Util.maxX - (castle.x + castle.width) - padding * 2, 
					Util.maxY - Util.minY - 50 - padding * 2, 2, 4, acquireUpgrade);
				_rightMenu = new ScrollMenu(castle.x + castle.width, Util.minY, upgrades, closeMenus, "Castle Upgrades", 
					FlxG.WHITE, padding, Util.maxX - (castle.x + castle.width), Util.maxY - Util.minY);
				add(_leftMenu);
				add(_rightMenu);
			});
		}
		
		private function closeMenus():void {
			_leftMenu.kill();
			_rightMenu.kill();
			if (castle.numUpgrades > Castle.TUTORIAL_UPGRADES_NEEDED) {
				toggleButtons(0);
				add(new MessageBox(Util.assets[Assets.FIRST_ATTACK], "Okay", function():void {
					toggleButtons(4);
					Database.updateUserTutorialInfo(FaceBook.uid, Castle.TUTORIAL_ATTACK_FRIENDS);
					Castle.tutorialLevel = Castle.TUTORIAL_ATTACK_FRIENDS;
				}));
			}
		}
		
		private function acquireUpgrade(upgrade:Upgrade):void {
			castle.setUpgrade(upgrade);
		}
		
		private function createUpgrades(info:Array, min:int, max:int, width:Number, height:Number, perRow:int, perColumn:int, clickCallback:Function):Array {
			var pages:Array = [];
			for (var i:int = 0; i < (max - min) / (perRow * perColumn); i++) {
				var group:FlxGroup = new FlxGroup;
				var upgradeShown:int = 0;
				for (var j:int = 0; j < perColumn; j++) {
					for (var k:int = 0; k < perRow; k++) {
						var index:Number = min + i * (perRow * perColumn) + j * perRow + k;
						if (index < max) {
							var bgColor:uint = FlxG.WHITE;
							
							if (info[index].type == "mine") bgColor = 0xFFAA4E07;
							else if (info[index].type == "castle") bgColor = FlxG.PINK;
							else if (info[index].type == "aviary") bgColor = FlxG.BLUE;
							else if (info[index].type == "foundry") bgColor = 0xFF767473;
							else if (info[index].type == "barracks") bgColor = FlxG.GREEN;
							if(checkLevel(info[index])) {
								Util.log("Upgrade created: " + info[index].name);
								Util.log("Upgrade type: " + info[index].type);
								//k * (width / perRow), j * (height / perColumn)
								var upgrade:Upgrade = new Upgrade(upgradeShown%perRow * (width / perRow), upgradeShown/perColumn * (height / perColumn), 
									width / perRow, height / perColumn, info[index].name, info[index].unitWorth, info[index].level,
									info[index].goldCost, info[index].type, clickCallback, bgColor);
								group.add(upgrade);
								upgradeShown++;
							}
						}
					}
				}
				pages[i] = group;
			}
			return pages;
		}
		
		private function checkLevel(value:Object):Boolean {
			if( CastleKingdom.DEBUG || 
				(this.castle.upgrades[value.type] == value.level - 1
				&& (this.castle.upgrades["castle"] >= value.level || value.type == "castle") 
				&& checkMineLevel(value) && checkAviaryLevel(value))) {
				return true;
			} else {
				return false;
			}
		}
		
		private function checkAviaryLevel(value:Object):Boolean {
			var stage:Array = [0,8,11,15,21];
			return value.type != "aviary" || this.castle.upgrades["castle"] >= stage[value.level];
		}
		
		private function checkMineLevel(value:Object):Boolean {
			var stage:Array = [0,5,8,13,21];
			return value.type != "mine" || this.castle.upgrades["castle"] >= stage[value.level];
		}
	}
}
