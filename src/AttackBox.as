package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;
	import org.flixel.FlxGroup;
	
	/**
	 * A class for interacting with units and dropping them onto the board. 
	 * @author royman
	 * 
	 */	
	public class AttackBox extends FlxGroup implements Droppable {
		
		public static const PADDING:Number = 4;
		
		private var _canDrop:Boolean;
		private var maxX:Number;
		private var maxY:Number;
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		private var _box:FlxSprite;
		
		/**
		 * Creates a box that can accept dragged units 
		 * @param x 
		 * @param y
		 * @param width
		 * @param height
		 * @param title A unique string used for the title and by FlxSprite for image caching.
		 * @param bgColor
		 * 
		 */		
		public function AttackBox(x:Number, y:Number, width:Number, height:Number, title:String, bgColor:uint = 0x77ffffff) {
			_box = new FlxSprite(x, y, ExternalImage);
			_box.makeGraphic(width, height, bgColor);
			Util.drawBorder(_box, FlxG.BLACK);
			add(_box); 
			maxX = PADDING;
			maxY = PADDING;
			_x = x;
			_y = y;
			_width = width;
			_height = height;
		}
		
		/**
		 * Determines whether the given object can fit inside the box and places it there if it can.
		 *  
		 * @param obj A draggable object
		 * @param oldX obj's previous x coordinate
		 * @param oldY obj's previous y coordinate
		 * @return Whether the drop was successful
		 * 
		 */	
		public function dropOnto(obj:FlxObject, oldX:Number, oldY:Number):Boolean {
			if (maxX + obj.width + PADDING > width) {
				maxX = PADDING;
				maxY = getMaxY();
			}
			if (maxY + obj.height + PADDING > height) {
				return false;
			} else {
				obj.x = maxX + x;
				obj.y = maxY + y;
				maxX += obj.width;
				add(obj);
				return true;
			}
		}
		
		private function getMaxY():Number {
			var max:Number = 0;
			for each(var thing:FlxBasic in this.members) {
				if (thing is FlxObject && thing != boundingSprite) {
					var obj:FlxObject = thing as FlxObject;
					if ((obj.y + obj.height) - y > max) {
						max = (obj.y + obj.height) - y;
					}
				}
			}
			return max;
		}
		
		public function get canDrop():Boolean {
			return _canDrop;
		}
		public function set canDrop(t:Boolean):void {
			_canDrop = t;
		}
		public function get x():Number {
			return _box.x;
		}
		public function get y():Number {
			return _box.y;
		}
		public function set x(n:Number):void {
			_x = n;
		}
		public function set y(n:Number):void {
			_y = n;
		}
		public function get width():Number {
			return _width;
		}
		public function get height():Number {
			return _height;
		}
		public function get boundingSprite():FlxSprite {
			return _box;
		}
	}
}