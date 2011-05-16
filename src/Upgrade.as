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
		
		public function Upgrade(x:Number, y:Number, width:Number, height:Number, name:String, unitWorth:Number, level:Number,
				goldCost:Number, type:String, upgradeID:String, onClick:Function, bgColor:uint = FlxG.WHITE, borderThickness:Number = 3, 
				padding:Number = 10, margin:Number = 5, borderColor:uint = FlxG.BLACK) {
			this.name = name;
			this.unitWorth = unitWorth;
			this.goldCost = goldCost;
			this.type = type;
			this.level = level;
			_onClick = onClick;
			this.upgradeID = upgradeID;
			
			_box = new FlxSprite(x + margin, y + margin);
			_box.makeGraphic(width - margin * 2, height - margin * 2, bgColor, true);
			_nameText = new FlxText(x, y + padding, width, name + "");
			_nameText.alignment = "center";
			_nameText.size += 2;
			var costText:FlxText = new FlxText(x, _nameText.y + _nameText.height, width, "Cost: " + goldCost);
			var towerText:FlxText = new FlxText(x, costText.y + costText.height, width, "Towers: +" + unitWorth);
			var armyText:FlxText = new FlxText(x, towerText.y + towerText.height, width, "Armies: +" + unitWorth);
			Util.drawBorder(_box, borderColor, borderThickness);
			costText.alignment = "center";
			towerText.alignment = "center";
			armyText.alignment = "center";
			
			_box.allowCollisions = FlxObject.NONE;
			_nameText.allowCollisions = FlxObject.NONE;
			towerText.allowCollisions = FlxObject.NONE;
			armyText.allowCollisions = FlxObject.NONE;
			costText.allowCollisions = FlxObject.NONE;
			
			_box.immovable = true;
			_nameText.immovable = true;
			towerText.immovable = true;
			armyText.immovable = true;
			costText.immovable = true;
			
			_nameText.color = FlxG.BLACK;
			towerText.color = FlxG.BLACK;
			armyText.color = FlxG.BLACK;
			costText.color = FlxG.BLACK;
			
			add(_box);
			add(_nameText);
			
			add(costText);
			add(towerText);
			add(armyText);
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