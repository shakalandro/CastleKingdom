package
{
	import flash.text.*;
	
	import mx.utils.StringUtil;
	
	import org.flixel.*;
	import org.flixel.system.input.Input;
	
	public class LeaseState extends ActiveState
	{
		public static const LEVEL_THRESHHOLD:Number = CastleKingdom.DEBUG ? 10000000 : 75;
		
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
			
			towers.setAll("canDrag", false);
			towers.setAll("canHighlight", false);
			
			var padding:Number = 10;
			
			Util.getFriendsInRange(Castle.computeValue(castle), LEVEL_THRESHHOLD, function(friends:Array):void {
				formatFriends(friends.slice(0, (friends.length + 1) / 2), castle.x - Util.minX - padding * 2, Util.maxY - Util.minY - 50, 5, function(pages:Array):void {
					_rightMenu = new ScrollMenu(Util.minX, Util.minY, pages, closeMenus, Util.assets[Assets.LEASE_RIGHT_TITLE], Util.assets[Assets.BUTTON_CANCEL], FlxG.WHITE, 
						padding, Util.maxX - castle.x - castle.width, Util.maxY - Util.minY);
					add(_rightMenu);
				});
				formatFriends(friends.slice((friends.length + 1) / 2, friends.length), castle.x - Util.minX - padding * 2, Util.maxY - Util.minY - 50, 5, function(pages:Array):void {
					_leftMenu = new ScrollMenu(castle.x + castle.width, Util.minY, pages, closeMenus, Util.assets[Assets.LEASE_LEFT_TITLE], Util.assets[Assets.BUTTON_CANCEL], FlxG.WHITE, 
						padding, Util.maxX - castle.x - castle.width, Util.maxY - Util.minY);
					add(_leftMenu);
				});
				
				var page:Array = makeLeasePage(castle.x, Util.minY, castle.width, Util.maxY - Util.minY, padding);
				_middleMenu = new ScrollMenu(castle.x, Util.minY, page, closeMenusAndSend, Util.assets[Assets.LEASE_MIDDLE_TITLE], Util.assets[Assets.LEASE_MIDDLE_BUTTON], FlxG.WHITE, padding, castle.width, Util.maxY - Util.minY); 
				add(_middleMenu);
			}, Castle.computeValue);
		}
		
		private function makeLeasePage(x:Number, y:Number, width:Number, height:Number, padding:Number = 10):Array {
			var page:Array = [];
			var group:FlxGroup = new FlxGroup();
			var text:FlxText = new FlxText(0, 0, width - padding * 2, "How many units of tower capacity would you like to lease?");
			text.alignment = "center";
			text.color = FlxG.BLACK;
			_slider = new Slider(0, text.height, width - padding * 2, 100, 0, 0);
			group.add(text);
			group.add(_slider);
			page.push(group);
			return page;
		}
		
		private function closeMenus():void {
			_rightMenu.kill();
			_leftMenu.kill();
			_middleMenu.kill();
			Database.getPendingUserLeases(function(leases:Array):void {
				if (leases != null && leases.length > 0) {
					FaceBook.getNameByID(leases[0].lid, function(name:String):void {
						add(new MessageBox(StringUtil.substitute(Util.assets[Assets.LEASE_REQUEST_TEXT], name, leases[0].numUnits), Util.assets[Assets.LEASE_REQUEST_ACCEPT], function():void {
							Database.confirmUserLease({
								id: FaceBook.uid,
								lid: leases[0].lid,
								numUnits: leases[0].numUnits
							});
							castle.leasedOutUnits = parseInt(leases[0].numUnits);
						}, Util.assets[Assets.LEASE_REQUEST_REJECT], function():void {
							Database.rejectUserLease({
								id: FaceBook.uid,
								lid: leases[0].lid
							});
						}));
					});
				} else {
					Database.getUserLeaseInfo(function(userLeases:Array):void {
						Util.logObj("userLeases object:", userLeases);
						if (userLeases != null && userLeases.length > 0) {
							var lease:Object = userLeases[0];
							FaceBook.getNameByID(lease.id, function(name:String):void {
								if (lease.accepted == 1) {
									add(new MessageBox(StringUtil.substitute(Util.assets[Assets.LEASE_ACCEPTED], name, lease.numUnits), Util.assets[Assets.BUTTON_DONE], null));
									castle.leasedInUnits += parseInt(lease.numUnits);
									Database.removeUserLease({
										id: lease.id,
										lid: lease.lid
									});
								} else if (lease.accepted == 0) {
									add(new MessageBox(StringUtil.substitute(Util.assets[Assets.LEASE_REJECTED], name), Util.assets[Assets.BUTTON_DONE], null));
									Database.removeUserLease({
										id: lease.id,
										lid: lease.lid
									});
								} else if (lease.accepted != null) {
									Util.log("LeaseState.closeMenus unknown user lease accepted value");
								}
							});
						} else {
							Util.log("LeaseState.closeMenus no confirmed or rejected user leases found");
						}
					}, FaceBook.uid, true);
				}
			}, FaceBook.uid, true);
		}
		
		private function closeMenusAndSend():void {
			if (FriendBox.selected != null && _slider.value > 0) {
				Database.addUserLease({
					id: FriendBox.selected.uid,
					lid: FaceBook.uid,
					numUnits: _slider.value
				});
				Util.log("Leasing " + _slider.value + " units from " + FriendBox.selected.name);
				FaceBook.getNameByID(FriendBox.selected.uid, function(name:String):void {
					add(new TimedMessageBox(StringUtil.substitute(Util.assets[Assets.LEASE_SENT], name, _slider.value)));
					FriendBox.resetSelected();
				});
			} else {
				add(new TimedMessageBox(Util.assets[Assets.LEASE_NOT_SENT]));
			}
			closeMenus();
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
							setCallback(leases == null || leases.length < 1);
							if (leases == null || leases.length <= 0) {
								Database.getUserInfo(function(info:Array):void {
									if (info == null || info.length <= 0) {
										Util.logObj("LeaseState.formatFriends user info null or empty for ", info);
										_slider.max = 0;
									} else {
										var correctOne:Array = info.filter(function(obj:Object, index:int, arr:Array):Boolean {
											return obj.id == uid;
										});
										_slider.max = Math.floor(correctOne[0].units / 4);
									}
								}, [uid, FaceBook.uid], true);
							}
						}, uid, true);
					}, false);
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