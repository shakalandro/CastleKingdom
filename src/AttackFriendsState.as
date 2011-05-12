package
{	
	import flash.display.BitmapData;
	
	import org.flixel.*;
	
	public class AttackFriendsState extends ActiveState
	{
		private var _leftMenu:ScrollMenu;
		private var _rightMenu:ScrollMenu;
		private var _middleMenu:ScrollMenu;
		
		public function AttackFriendsState(map:FlxTilemap=null, castle:Castle=null, towers:FlxGroup=null, units:FlxGroup=null)
		{
			super(map, castle, towers, units);
		}
		
		override public function create():void {
			super.create();
			var padding:Number = 10;
			
			var page:Array = formatDropBoxes(castle.width - padding * 2, Util.maxY - Util.minY - 50, 2, 3, padding);
			_middleMenu = new ScrollMenu(castle.x, Util.minY, page, closeMenus, "Place Here", FlxG.WHITE, padding, castle.width, Util.maxY - Util.minY, 3);
			add(_middleMenu);
			
			FaceBook.friends(function(friends:Array):void {
				formatFriends(friends.slice(0, 30), castle.x - Util.minX, Util.maxY - Util.minY - 50, 5, function(pages:Array):void {
					_rightMenu = new ScrollMenu(castle.x + castle.width, Util.minY, pages, closeMenus, "Attack Friends", FlxG.WHITE, 
						padding, Util.maxX - castle.x - castle.width, Util.maxY - Util.minY);
					add(_rightMenu);
				});
			});
			
			Database.getEnemyInfo(function(units:Array):void {
				var pages:Array = formatUnits(units, castle.x - Util.minX, Util.maxY - Util.minY - 50, 2, 4);
				_leftMenu = new ScrollMenu(Util.minX, Util.minY, pages, closeMenus, "Attack Friends", FlxG.WHITE, padding, 
					castle.x - Util.minX, Util.maxY - Util.minY, 3, moveUnit);
				add(_leftMenu);
			});
			
			setTutorialUI();
		}
		
		private function setTutorialUI():void {
			
		}
		
		public function moveUnit(draggable:Draggable, newX:Number, newY:Number, oldX:Number, oldY:Number):void {
			var enemy:EnemyUnit = (draggable as EnemyUnit);
			if (newX > castle.x && newX < castle.x + castle.width) {
				var newEnemy:EnemyUnit = enemy.clone() as EnemyUnit;
				newEnemy.x = oldX;
				newEnemy.y = oldY;
				_leftMenu.addToCurrentPage(newEnemy);
				_middleMenu.addToCurrentPage(enemy);
				Util.log("should have dropped a clone: " + (enemy == newEnemy));
			} else {
				enemy.x = oldX;
				enemy.y = oldY;
				_leftMenu.addToCurrentPage(enemy.clone() as EnemyUnit);
			}
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
			_middleMenu.kill();
		}
		
		private function formatDropBoxes(width:Number, height:Number, perRow:int, perColumn:int, padding:Number = 10, bgColor:uint = 0xffffffff):Array {
			var boxWidth:Number = width / perRow - padding * (perRow - 1);
			var boxHeight:Number = height / perColumn - padding * (perColumn - 1);
			var page:Array = [];
			var boxes:FlxGroup = new FlxGroup();
			for (var i:int = 0; i < perRow; i++) {
				for (var j:int = 0; j < perColumn; j++) {
					var x:Number = boxWidth * i + i * padding;
					var y:Number = boxHeight * j + j * padding;
					var bmd:BitmapData = new BitmapData(boxWidth, boxHeight, true, bgColor);
					ExternalImage.setData(bmd, "attackfriendsdropbox" + i + j);
					var box:FlxSprite = new FlxSprite(x, y, ExternalImage); 
					Util.drawBorder(box, bgColor);
					boxes.add(box);
					Util.log("box: ",box.x, box.y);
					add(box);
				}
			}
			page.push(boxes);
			return page;
		}
		
		private function formatUnits(units:Array, width:Number, height:Number, perRow:int, perColumn:int, padding:Number = 10):Array {
			var result:Array = [];
			for (var i:int = 0; i < units.length / (perRow * perColumn); i++) {
				var group:FlxGroup = new FlxGroup;
				for (var j:int = 0; j < perColumn; j++) {
					for (var k:int = 0; k < perRow; k++) {
						var index:Number = i * (perRow * perColumn) + j * perRow + k;
						
						if (index < units.length) {
							//var towerGroup:FlxGroup = new FlxGroup();
							var baddy:EnemyUnit = new EnemyUnit(k * (width / perRow), j * (height / perColumn), units[index].id, true, null, false);
							var name:FlxText = new FlxText(k * (width / perRow), j * (height / perColumn), width / perRow - padding, baddy.name);
							name.color = FlxG.BLACK;
							
							baddy.y += name.height;
							
							group.add(baddy);
							group.add(name);
						}
					}
				}
				result[i] = group;
			}
			return result;
		}
				
		private function formatFriends(friends:Array, width:Number, height:Number, numPer:int, callback:Function):void {
			FaceBook.getAllPictures(friends, function(sprites:Array):void {
				var pages:Array = [];
				var page:FlxGroup = new FlxGroup();
				var i:int = 0;
				var y:Number = 0;
				var leftOffset:Number = 20;
				while (i < sprites.length) {
					Util.log(y);
					var pic:FlxSprite = sprites[i];
					if (y + pic.height + 10 > height) {
						Util.log("new page made");
						y = 0;
						pages.push(page);
						page = new FlxGroup();
					}
					pic.x = leftOffset;
					pic.y = y;
					page.add(pic);
					var text:FlxText = new FlxText(leftOffset + pic.width + 10, y + 10, width - leftOffset - pic.width,friends[i].name);
					text.color = FlxG.BLACK;
					page.add(text);
					y += pic.height + 10;
					i++;
				}
				pages.push(page);
				Util.log("pages length: " + pages.length);
				callback(pages);
			});
		}
	}
}