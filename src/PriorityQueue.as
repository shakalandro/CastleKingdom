//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.

//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.


package  
{
	/**
	 * ...
	 * @author Chris
	 */
	public dynamic class PriorityQueue extends Array
	{
		
		public function PriorityQueue() 
		{
			
		}
		
		//push a node on the front
		AS3 override function push(...args):uint
		{
			var ret:uint = super.push(args[0]);
			this.sort(Unit.compare);
			return ret;
		}
		
		//get the first node in the queue
		public function front():Unit
		{
				return this[0];
		}
		
		//remove the first node in the queue
		AS3 override function pop():*
		{
			return splice(0, 1);
		}
		
		//check if the queue contains a certain node
		public function contains(node:Unit):Boolean
		{
			for (var i:int = 0; i != length; i++)
			{
				if (this[i]==(node))
					return true;
			}
			return false;
		}
		
	
	}

}