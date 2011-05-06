package
{
	public interface Highlightable
	{
		function checkHighlight():Boolean;
		function get highlighted():Boolean;
		function set highlightCallback(callback:Function):void;
		function get canHighlight():Boolean;
		function set canHighlight(t:Boolean):void;
	}
}