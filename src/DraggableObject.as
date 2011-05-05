package
{
	import org.flixel.*;

	public class DraggableObject
	{
		var _x:int;
		var _y:int;
		var _currentObj:FlxBasic;
		
		
		public function DraggableObject(x:int, y:int, obj:Draggable)	{
			
		}
		
		public function checkDrag():void {
			
			var mouseCoords:FlxPoint = FlxG.mouse.getScreenPosition();
			if (FlxG.mouse.justPressed() && checkClick()) {
				_dragging = true;
				_dragOffset = new FlxPoint(mouseCoords.x - this.x, mouseCoords.y - this.y);
			} else if (_dragging && FlxG.mouse.justReleased()) {
				_dragging = false;
				this.x = mouseCoords.x - _dragOffset.x;
				Util.placeOnGround(this, Util.state.map, false, true);
				
				_dragOffset = null;
			}
			if (_dragging) {
				this.x = mouseCoords.x - _dragOffset.x;
				this.y = mouseCoords.y - _dragOffset.y;
			}
		}
		
		private function checkClick():Boolean {
			return this.overlapsPoint(FlxG.mouse.getScreenPosition(), true);
		}
		
		
		
		
	}
}