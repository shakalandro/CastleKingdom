package org.flixel.data
{
	import org.flixel.*;
	
	/**
	 * The world's smallest linked list class.
	 * Useful for optimizing time-critical or highly repetitive tasks!
	 * See FlxQuadTree for how to use it, IF YOU DARE.
	 */
	public class FlxList
	{
		/**
		 * Stores a reference to a FlxObject.
		 */
		public var object:FlxObject;
		/**
		 * Stores a reference to the next link in the list.
		 */
		public var next:FlxList;
		
		/**
		 * Creates a new link, and sets object and next to null.
		 */
		public function FlxList()
		{
			object = null;
			next = null;
		}
	}
}