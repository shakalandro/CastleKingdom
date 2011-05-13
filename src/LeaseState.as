package
{
	import flash.text.*;
	
	import org.flixel.*;
	import org.flixel.system.input.Input;
	
	public class LeaseState extends ActiveState
	{
		public static const LEVEL_THRESHHOLD:Number = 75;
		
		private var _rightMenu:ScrollMenu;
		private var _leftMenu:ScrollMenu;
		private var _middleMenu:ScrollMenu;
		private var _slider:Slider;
		
		public function LeaseState(map:FlxTilemap=null, castle:Castle=null, towers:FlxGroup=null, units:FlxGroup=null)
		{
			super(map, castle, towers, units);
		}
		
		override public function create():void {
			super.create();
			var padding:Number = 10;
			
			Util.getFriendsInRange(Castle.computeValue(castle), LEVEL_THRESHHOLD, function(friends:Array):void {
				formatFriends(friends.slice(0, (friends.length + 1) / 2), castle.x - Util.minX - padding * 2, Util.maxY - Util.minY - 50, 5, function(pages:Array):void {
					_rightMenu = new ScrollMenu(Util.minX, Util.minY, pages, closeMenus, "Attack Friends", FlxG.WHITE, 
						padding, Util.maxX - castle.x - castle.width, Util.maxY - Util.minY);
					add(_rightMenu);
				});
				formatFriends(friends.slice((friends.length + 1) / 2, friends.length), castle.x - Util.minX - padding * 2, Util.maxY - Util.minY - 50, 5, function(pages:Array):void {
					_leftMenu = new ScrollMenu(castle.x + castle.width, Util.minY, pages, closeMenus, "Attack Friends", FlxG.WHITE, 
						padding, Util.maxX - castle.x - castle.width, Util.maxY - Util.minY);
					add(_leftMenu);
				});
				
				var page:Array = makeLeasePage(castle.x, Util.minY, castle.width, Util.maxY - Util.minY, padding);
				_middleMenu = new ScrollMenu(castle.x, Util.minY, page, closeMenus, "Close", FlxG.WHITE, padding, castle.width, Util.maxY - Util.minY); 
				add(_middleMenu);
			}, Castle.computeValue);
		}
		
		private function makeLeasePage(x:Number, y:Number, width:Number, height:Number, padding:Number = 10):Array {
			var page:Array = [];
			var group:FlxGroup = new FlxGroup();
			var text:FlxText = new FlxText(0, 0, width - padding * 2, "How many units of tower capacity would you like to lease?");
			text.alignment = "center";
			text.color = FlxG.BLACK;
			_slider = new Slider(0, text.height, width - padding * 2, 100, 10, castle.unitCapacity);
			group.add(text);
			group.add(_slider);
			page.push(group);
			return page;
		}
		
		private function closeMenus():void {
			if (FriendBox.selected != null) {
				Database.addUserLease({
					id: FriendBox.selected.uid,
					lid: FaceBook.uid,
					numUnits: _slider.value
				});
				Util.log("Leasing " + _slider.value + " units from " + FriendBox.selected.name);
				FriendBox.resetSelected();
			}
			_rightMenu.kill();
			_leftMenu.kill();
			_middleMenu.kill();
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