package
{
	import org.flixel.*;
	
	public class AttackFriendsState extends ActiveState
	{
		private var _leftMenu:ScrollMenu;
		private var _rightMenu:ScrollMenu;
		
		public function AttackFriendsState(map:FlxTilemap=null, castle:Castle=null, towers:FlxGroup=null, units:FlxGroup=null)
		{
			super(map, castle, towers, units);
		}
		
		override public function create():void {
			super.create();
			
			FaceBook.friends(function(friends:Array):void {
				//Util.logObj("Friends List returned:", friends);
				var padding:Number = 10;
				var pages:Array = formatFriends(friends, castle.x - Util.minX, Util.maxY - Util.minY, 5);
				_rightMenu = new ScrollMenu(castle.x + castle.width, Util.minY, pages, closeMenus, "Attack Friends", FlxG.WHITE, padding, castle.x - Util.minX, Util.maxY - Util.minY);
				_leftMenu = new ScrollMenu(Util.minX, Util.minY, [new FlxGroup()], closeMenus, "Attack Friends", FlxG.WHITE, padding, castle.x - Util.minX, Util.maxY - Util.minY);
				add(_rightMenu);
				add(_leftMenu);
			});
			
			setTutorialUI();
		}
		
		private function setTutorialUI():void {
			
		}
		
		private function closeMenus():void {
			if (Castle.tutorialLevel == Castle.TUTORIAL_ATTACK_FRIENDS) {
				toggleButtons(4);
			} else if (Castle.tutorialLevel == Castle.TUTORIAL_LEASE) {
				toggleButtons(5);
			} else {
				Util.log("Unknown tutorial leval: " + Castle.tutorialLevel);
			}
			_rightMenu.kill();
			_leftMenu.kill();
		}
		
		private function formatFriends(friends:Array, width:Number, height:Number, numPer:int):Array {
			var pages:Array = [];
			for (var i:int = 0; i < friends.length / numPer && i < 4; i++) {
				var page:FlxGroup = new FlxGroup();
				var max:int = Math.min(friends.length, i * numPer);
				//This variable is not part of the closure, used as a cumulative sum
				var y:Number = 0;
				for (var j:int = 0; j < max; j++) {
					FaceBook.picture(Util.closurizeAppend(function(pic:Class, realPage:FlxGroup, k:int):void {
							Util.log("name: " + friends[k].name + ", y: " + y);
							var profilePic:FlxSprite = new FlxSprite(20, y, pic);
							realPage.add(profilePic);
							realPage.add(new FlxText(60, y, 100, friends[k].name));
							y += profilePic.height + 5;
						}, page, j), 
					friends[j].id);
				}
				pages.push(page);
			}
			return pages;
		}
	}
}