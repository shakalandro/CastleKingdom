package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;
	
	public class Upgrade extends FlxGroup {
		
		public var name:String;
		public var unitWorth:Number;
		public var goldCost:Number;
		public var type:String;
		private var _onClick:Function;
		private var _box:FlxSprite;
		
		public function Upgrade(x:Number, y:Number, width:Number, height:Number, name:String, unitWorth:Number, 
				goldCost:Number, type:String, onClick:Function, bgColor:uint = FlxG.WHITE, borderThickness:Number = 3, padding:Number = 10, margin:Number = 5, borderColor:uint = FlxG.BLACK) {
			this.name = name;
			this.unitWorth = unitWorth;
			this.goldCost = goldCost;
			this.type = type;
			_onClick = onClick;
			
			ExternalImage.setData(new BitmapData(width - margin * 2, height - margin * 2, true, bgColor), name);
			_box = new FlxSprite(x + margin, y + margin, ExternalImage);
			var nameText:FlxText = new FlxText(x + padding, y + padding, width - padding * 4, name + "");
			var worthText:FlxText = new FlxText(x + padding, nameText.y + nameText.height + padding, width - padding * 2, "\t" + "unitWorth: " + unitWorth);
			var costText:FlxText = new FlxText(x + padding, worthText.y + worthText.height + padding, width - padding * 2, "\t" + "goldCost: " + goldCost);
			
			var right:Number = _box.width - borderThickness + 1;
			var bottom:Number = _box.height - borderThickness + 1;
			_box.drawLine(0, 0, right, 0, borderColor, borderThickness);
			_box.drawLine(right, 0, right, bottom, borderColor, borderThickness);
			_box.drawLine(right, bottom, 0, bottom, borderColor, borderThickness);
			_box.drawLine(0, bottom, 0, 0, borderColor, borderThickness);
			
			_box.allowCollisions = FlxObject.NONE;
			nameText.allowCollisions = FlxObject.NONE;
			worthText.allowCollisions = FlxObject.NONE;
			costText.allowCollisions = FlxObject.NONE;
			
			_box.immovable = true;
			nameText.immovable = true;
			worthText.immovable = true;
			costText.immovable = true;
			
			nameText.color = FlxG.BLACK;
			worthText.color = FlxG.BLACK;
			costText.color = FlxG.BLACK;
			
			add(_box);
			add(nameText);
			add(worthText);
			add(costText);
		}
		
		override public function update():void {
			var mouseCoords:FlxPoint = FlxG.mouse.getScreenPosition();
			if (Util.mouse.justPressed() && Util.checkClick(_box)) {
				if (_onClick != null) _onClick(this);
			}
		}
		
		
	}
}