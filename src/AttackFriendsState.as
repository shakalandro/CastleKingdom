package
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxTilemap;
	
	public class AttackFriendsState extends ActiveState
	{
		public function AttackFriendsState(map:FlxTilemap=null, castle:Castle=null, towers:FlxGroup=null, units:FlxGroup=null)
		{
			super(map, castle, towers, units);
		}
		
		override public function create():void {
			super.create();
			
			FaceBook.friends(function(friends:Array):void {
				var pages:Array = formatFriends(friends);
			}, true);
		}
		
		private function formatFriends(friends:Array):Array {
			return [];
		}
	}
}