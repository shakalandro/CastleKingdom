package
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxTilemap;
	
	public class LeaseState extends ActiveState
	{
		private var _rightMenu:ScrollMenu;
		private var _leftMenu:ScrollMenu;
		
		public function LeaseState(map:FlxTilemap=null, castle:Castle=null, towers:FlxGroup=null, units:FlxGroup=null)
		{
			super(map, castle, towers, units);
		}
		
		override public function create():void {
			Util.getFriendsInRange(Castle.computeValue(castle), LEVEL_THRESHHOLD, function(friends:Array):void {
				formatFriends(friends.slice(0, (friends.length + 1) / 2), castle.x - Util.minX - padding * 2, Util.maxY - Util.minY - 50, 5, function(pages:Array):void {
					_rightMenu = new ScrollMenu(castle.x + castle.width, Util.minY, pages, closeMenus, "Attack Friends", FlxG.WHITE, 
						padding, Util.maxX - castle.x - castle.width, Util.maxY - Util.minY);
					add(_rightMenu);
				});
				formatFriends(friends.slice((friends.length + 1) / 2, friends.length), castle.x - Util.minX - padding * 2, Util.maxY - Util.minY - 50, 5, function(pages:Array):void {
					_leftMenu = new ScrollMenu(castle.x + castle.width, Util.minY, pages, closeMenus, "Attack Friends", FlxG.WHITE, 
						padding, Util.maxX - castle.x - castle.width, Util.maxY - Util.minY);
					add(_rightMenu);
				});
			});
		}
		
		/**
		 * 
		 * 
		 * @param friends An array of friend info from FaceBook
		 * @param width
		 * @param height
		 * @param numPer A desired maximum number of FriendBoxes per page
		 * @param callback A callback with teh signature callback(friends:Array):void
		 * 
		 */		
		private function formatFriends(friends:Array, width:Number, height:Number, numPer:int, callback:Function):void {
			FaceBook.getAllPictures(friends, function(sprites:Array):void {
				var pages:Array = [];
				var page:FlxGroup = new FlxGroup();
				var i:int = 0;
				var y:Number = 0;
				var padding:Number = 10;
				while (i < sprites.length) {
					if (y + sprites[i].height + 2 * padding > height || page.members.length >= numPer) {
						y = 0;
						pages.push(page);
						page = new FlxGroup();
					}
					var friendBox:FriendBox = new FriendBox(0, y, width, sprites[i], friends[i].name, friends[i].id, function(uid:String, setCallback:Function):void {
						Database.getUserLeaseInfo(function(leases:Array):void {
							setCallback(leases == null || leases.length == 0);
						}, uid, true);
					});
					page.add(friendBox);
					
					y += friendBox.height + padding / 2;
					i++;
				}
				pages.push(page);
				callback(pages);
			});
		}
	}
}