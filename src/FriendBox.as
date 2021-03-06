package
{
	import flash.display.BitmapData;
	
	import mx.utils.StringUtil;
	
	import org.flixel.*;
	
	/**
	 * A class for presenting friends in the AttackFriends class. Supports a single selectable friend box. 
	 * @author royman
	 * 
	 */	
	public class FriendBox extends FlxGroup
	{
		private var _box:FlxSprite;
		private var _pic:FlxSprite;
		private var _text:FlxText;
		private var _bgColor:uint;
		private var _uid:String;
		private var _clickCallback:Function;
		private var _beingAttacked:Boolean;
		private var _name:String;
		
		private static var _selected:FriendBox;
		
		/**
		 * Creates a new friend box. 
		 * @param x
		 * @param y
		 * @param width
		 * @param pic A flxSprite pic of the person
		 * @param name The person's name
		 * @param bgColor
		 * @param padding
		 * 
		 */		
		public function FriendBox(x:Number, y:Number, width:Number, pic:FlxSprite, name:String, uid:String, clickCallback:Function = null, attacking:Boolean = true, bgColor:uint = 0x77ffffff, padding:Number = 5)
		{
			super(0);
			_pic = pic;
			_bgColor = bgColor;
			_uid = uid;
			_clickCallback = clickCallback;
			_beingAttacked = false;
			_name = name;
			pic.x = x + padding;
			pic.y = y + padding;
			pic.height = Math.min(pic.height, 50);
			_text = new FlxText(x + pic.width + padding, y, width - pic.width - padding * 3, name);
			_text.y += pic.height / 2;
			_text.color = FlxG.BLACK;
			_text.size = 11;
			
			_box = new FlxSprite(x, y);
			_box.makeGraphic(width, pic.height + padding * 2, bgColor);
			Util.drawBorder(_box);
			if (attacking) {
				Database.isBeingAttacked(function(attacks:Array):void {
					_beingAttacked = attacks != null && attacks.length > 0;
				}, uid, true);
			} else {
				Database.getPendingUserLeases(function(pendingLeases:Array):void {
					Database.getUserLeaseInfo(function(leases:Array):void {
						_beingAttacked = pendingLeases != null && pendingLeases.length > 0 && leases != null && leases.length > 0;
					}, uid, true);
				}, uid, true);
			}
			
			Database.getUserInfo(function(info:Array):void {
				if (info != null && info.length > 0) {
					_text.text += "\n\tGold: " + info[0].gold + "\n\tUnits: " + info[0].units;
					Util.centerY(_text, _box);
				} else {
					var invite:FlxButton = new FlxButton(0, 0, "Invite", function():void {
						if (!CastleKingdom.DEBUG) {
							Database.addNewUser(_uid);
						}
						FaceBook.post(FaceBook.uid, _uid, StringUtil.substitute(Util.assets[Assets.INVITE_FRIEND], FaceBook.name), null);
						_text.text = name + "\n\tGold: " + Database.START_GOLD + "\n\tUnits: " + Database.START_UNITS;
						remove(invite, true);
						invite.kill();
					});
					_text.y = _box.y + padding;
					invite.y = _box.y + _box.height - invite.height - padding;
					invite.x = _box.x + _box.width + (((_pic.x + _pic.width - padding) - (_box.x + _box.width + padding)) - invite.width) / 2;
					add(invite);
				}
			}, uid, true);
			
			add(_box);
			add(_pic);
			add(_text);
		}
		
		/**
		 * Detects a mouse click on this FriendBox and if it occurred sets this to be the slected box.
		 * If a clickCallback was provided to this FriendBox then that callback is called with the uid 
		 * of the clicked friend and a callback with the signature callback(set:Boolean):void. 
		 * It is expected that the callback will be called with 'set' meaning whether to select the clicked friend. 
		 * Note: The two stage callback system is necessary because determining if we want to 
		 * 		select is likely based on an asynchonous database call.
		 */		
		override public function preUpdate():void {
			if (FlxG.mouse.justReleased() && Util.checkClick(_box)) {
				if (_clickCallback != null) {
					Util.log("Calling click callback");
					_clickCallback(uid, setSelected);
				} else {
					FriendBox._selected = this;
				}
			}
		}
		
		/**
		 * Sets selected to this object if set is true
		 * @param set Whether to set selected to this object
		 * 
		 */		
		private function setSelected(set:Boolean):void {
			if (set) {
				_selected = this;
			} else {
				_beingAttacked = true;
			}
		}
		
		/**
		 * Draw the selected box with a different color 
		 * 
		 */		
		override public function update():void {
			super.update();
			if (FriendBox._selected == this) {
				_box.color = FlxG.GREEN;
			} else if (_beingAttacked) {
				_box.color = FlxG.RED;
			} else {
				_box.color = _bgColor;
			}
		}
		
		public function get height():Number {
			return _box.height;
		}
		public function get width():Number {
			return _box.width;
		}
		public function get uid():String {
			return _uid;
		}
		public function get name():String {
			return _name;
		}
		public static function get selected():FriendBox {
			return _selected;
		}
		public static function resetSelected():void {
			_selected = null;
		}
		public function set isBeingAttacked(t:Boolean):void {
			_beingAttacked = t;
		}
	}
}