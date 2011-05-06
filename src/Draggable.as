package
{
	public interface Draggable 
	{
		/**
		 * Should check for mouse clicks and perform the necessary drag operations
		 * When the drag is complete a user provided callback should be invoked.
		 * This callback should have the signature 
		 * callback(obj:Draggable, newX:Number, newY:Number, oldX:Number, oldY:Number):void.
		 * 
		 */	
		function checkDrag():Boolean;
		function set dragCallback(callback:Function):void;
		function get canDrag():Boolean;
		function set canDrag(t:Boolean):void;
		function get objx():Number;
		function get objy():Number;
		function set objx(n:Number):void;
		function set objy(n:Number):void;
	}
}
