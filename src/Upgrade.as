package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;
	
	public class Upgrade extends FlxGroup {
		
		public var name:String;
		public var unitWorth:Number;
		public var goldCost:Number;
		public var type:String;
		public var level:Number;
		public var upgradeID:String;
		private var _onClick:Function;
		private var _box:FlxSprite;
		private var _nameText:FlxText;
		private var _unlocks:String;
		
		public function Upgrade(x:Number, y:Number, width:Number, height:Number, name:String, unitWorth:Number, level:Number,
				goldCost:Number, type:String, upgradeID:String, onClick:Function, bgColor:uint = FlxG.WHITE, borderThickness:Number = 3, 
				padding:Number = 10, margin:Number = 5, borderColor:uint = FlxG.BLACK, unlocks:String = null) {
			this.name = name;
			this.unitWorth = unitWorth;
			this.goldCost = goldCost;
			this.type = type;
			this.level = level;
			_onClick = onClick;
			this.upgradeID = upgradeID;
			_unlocks = unlocks;
			
			_box = new FlxSprite(x + margin, y + margin);
			_box.makeGraphic(width - margin * 2, height - margin * 2, bgColor, true);
			_nameText = new FlxText(x, y + padding, width, name + "");
			_nameText.alignment = "center";
			_nameText.size += 2;
			
			Util.drawBorder(_box, borderColor, borderThickness);
			_box.allowCollisions = FlxObject.NONE;
			_nameText.allowCollisions = FlxObject.NONE;
			_box.immovable = true;
			_nameText.immovable = true;
			add(_box);
			add(_nameText);
			
			
			var textIndex:int = _nameText.y + _nameText.height;
			var costText:FlxText = new FlxText(x, textIndex, width, "Cost: " + goldCost);
			textIndex += costText.height;
			costText.alignment = "center";
			costText.allowCollisions = FlxObject.NONE;
			costText.immovable = true;
			costText.color = FlxG.BLACK;

			add(costText);
			
			if(type != "barracks") {
				var towerText:FlxText = new FlxText(x, textIndex, width, "Towers: +" + unitWorth);
				textIndex += towerText.height;
				towerText.alignment = "center";
				towerText.allowCollisions = FlxObject.NONE;
				towerText.immovable = true;
				towerText.color = FlxG.BLACK;
				add(towerText);

			} 
			if (type != "foundry") {
				var armyText:FlxText = new FlxText(x, textIndex, width, "Armies: +" + unitWorth);
				textIndex += armyText.height;
				armyText.allowCollisions = FlxObject.NONE;
				armyText.alignment = "center";
				armyText.immovable = true;
				armyText.color = FlxG.BLACK;
				add(armyText);

			} 
			if(type == "castle") {
				_unlocks = "Barracks and Foundry " + (level);
			} else {
				_unlocks = (FlxG.state as ActiveState).castle.getNamesByLevel(type, level);
			}
			if(_unlocks != "") {
				var unlockText:FlxText = new FlxText(x,textIndex,width, "Unlocks: " + _unlocks);
				textIndex += unlockText.height;
				unlockText.allowCollisions = FlxObject.NONE;
				unlockText.alignment = "center";
				unlockText.immovable = true;
				unlockText.color = FlxG.BLACK;
				add(unlockText);
			}
			
			
			
			

		
		}
		
		public function xOut():void {
			_box.drawLine(0, 0, _box.width, _box.height, FlxG.RED, 5);
			_box.drawLine(0, _box.height, _box.width, 0, FlxG.RED, 5);
			this.active = false;
		}
		
		override public function preUpdate():void {
			var mouseCoords:FlxPoint = FlxG.mouse.getScreenPosition();
			if (Util.mouse.justPressed() && _box.visible && Util.checkClick(_box)) {
				Util.log("xed-out: " + _nameText.text);
				if (_onClick != null && _onClick(this)) {
					xOut();
				}
			}
		}
		
		
	}
}