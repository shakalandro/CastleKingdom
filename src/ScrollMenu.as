
package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;
	
	/**
	 * A closable menu box that contains multiple pages.
	 * @author royman
	 * 
	 */	
	public class ScrollMenu extends FlxGroup implements Droppable {
		private var _text:FlxText;
		private var _pages:Array;
		private var _currentPage:int;
		private var _closeCallback:Function;
		private var _width:int = 0;
		private var _height:int = 0;
		private var _leftButton:FlxButton;
		private var _rightButton:FlxButton;
		private var _pageCount:FlxText;
		private var _padding:Number;
		private var _x:Number;
		private var _y:Number;
		private var _dragCallback:Function;
		private var _canDrop:Boolean;
		private var _box:FlxSprite;
		
		/**
		 * The ScrollMenu requires an Array of FlxGroups that are displayed one at a time like pages in a book.
		 * Objects in the pageContents array should be positioned with coordinates relative to the upperleft corner of the menu. 
		 * ex) if the scroll menu is at (50, 50) an object positioned at (0, 0) will be repositioned 
		 * to be in the upperleft corner of the window.
		 * This menu can respond to dragging its children by calling the given dragCallback. The callback must 
		 * have the following signature callback(thing:FlxBasic, newX:Number, newY:Number, oldX:Number, oldY:Number):void
		 * 
		 * @param x A cartesian x coordinate
		 * @param y A cartesian y coordinate
		 * @param pageContents An Array of FlxGroups where each index represents a page
		 * @param closeCallback A callback for when the menu is closed
		 * @param title A title string for the window
		 * @param bgColor The background color of the window
		 * @param padding A padding to be maintained between the edge of the box and its contents
		 * @param width The width of the menu
		 * @param height The height of the menu
		 * @param borderThickness The thickness of the border
		 * @param dragCallback A callback for when a draggable item on the page is dragged off of the menu.
		 * 
		 */		
		public function ScrollMenu(x:Number, y:Number, pageContents:Array, closeCallback:Function, 
				title:String = "", buttonText:String = "Cancel", bgColor:uint = FlxG.WHITE, padding:Number = 10, width:int = 100, 
				height:int = 100, borderThickness:Number = 3, dragCallback:Function = null) {
			super();
			_pages = pageContents || [];
			_width = width;
			_height = height;
			_padding = padding;
			_x = x;
			_y = y;
			_dragCallback = dragCallback;
			_closeCallback = closeCallback;
			_canDrop = true;
			
			//Set the title text and pageText;
			_text = new FlxText(_x, _y, width - padding * 2, title);
			_text.color = FlxG.BLACK;
			_text.alignment = "center";
			_pageCount = new FlxText(_x, _y, width - padding * 2, "0/" + _pages.length);
			_pageCount.color = FlxG.BLACK;
			_pageCount.alignment = "right";
			
			//Set the button
			var me:ScrollMenu = this;
			var close:FlxButton = new FlxButton(x + width / 2, y + height - padding	* 2, buttonText, this.onClose);
			close.x -= close.width / 2;
			close.y -= close.height / 2;
			_leftButton = new FlxButton(x + padding, y + height - padding * 2, "<<", scrollLeft);
			_leftButton.loadGraphic(Util.assets[Assets.BUTTON_SMALL], false, false, 35, 20);
			_leftButton.y -= _leftButton.height / 2;
			_rightButton = new FlxButton(x + width - padding, y + height - padding * 2, ">>", scrollRight);
			_rightButton.loadGraphic(Util.assets[Assets.BUTTON_SMALL], false, false, 35, 20);
			_rightButton.x -= _rightButton.width;
			_rightButton.y -= _rightButton.height / 2;	
			
			//Set up window box
			_box = new FlxSprite(x, y);
			_box.makeGraphic(width, height, bgColor);
			_box.alpha = .65;
			Util.drawBorder(_box, FlxG.BLACK, borderThickness);
			_box.x = x;
			_box.y = y;

			//Add everything 
			add(_box);
			add(_text);
			add(_pageCount);
			add(_leftButton);
			add(_rightButton);
			add(close);
			
			//set the page contents
			formatPages();
			if (_pages.length == 0) {
				_pages.push(new FlxGroup());
			}
			add(_pages[0]);
			_currentPage = 0;
			pageCount = 0;
			checkButtons();
		}

		/**
		 * Scrolls the menu to the previous page if possible. 
		 * 
		 */		
		public function scrollLeft():void {
			if (_currentPage - 1 >= 0) {
				_currentPage--;
				displayPage(_currentPage, _currentPage + 1);
				pageCount = _currentPage;
			}
			checkButtons();
		}
		
		/**
		 * Scrolls to the next page if possible. 
		 * 
		 */		
		public function scrollRight():void {
			if (_currentPage + 1 < _pages.length) {
				_currentPage++;
				displayPage(_currentPage, _currentPage - 1);
				pageCount = _currentPage;
			}
			checkButtons();
		}
		
		/**
		 * Checks to see if buttons should be activated or deactivated. 
		 * 
		 */		
		private function checkButtons():void {
			if (_currentPage == 0) {
				_leftButton.visible = false;
			} else {
				_leftButton.visible = true;
			}
			if (_currentPage == _pages.length - 1) {
				_rightButton.visible = false;
			} else {
				_rightButton.visible = true;
			}
		}
		
		/**
		 * Formats the pages by properly offsetting each of the items in the pages. 
		 * 
		 */		
		private function formatPages():void {
			for (var i:int = 0; i < _pages.length; i++) {
				var stuff:FlxGroup = _pages[i];
				for each (var thing:FlxBasic in stuff.members) {
					formatObject(thing);
				}
			}
		}
		
		/**
		 * Formats the given object so that  
		 * @param thing
		 * 
		 */		
		private function formatObject(thing:FlxBasic):void {
			if (thing is FlxGroup) {
				for each (var member:FlxBasic in (thing as FlxGroup).members) {
					formatObject(member);
				}
			} else if (thing is FlxObject) {
				var obj:FlxObject = (thing as FlxObject);
				obj.x += _x + _padding;
				obj.y += _y + _padding + _text.height;
				obj.allowCollisions = FlxObject.NONE;
				obj.immovable = true;
			}
			if (thing is Draggable) {
				(thing as Draggable).dragCallback = function(tower:Draggable, newX:Number, newY:Number, oldX:Number, oldY:Number):void {
					if (inWindow(newX, newY)) {
						tower.objx = oldX;
						tower.objy = oldY;
					} else {
						_dragCallback(tower, newX, newY, oldX, oldY);
						_pages[_currentPage].remove(tower, true);
						displayPage(_currentPage, _currentPage);
					}
				};
			}
		}
		
		/**
		 * Checks if the given coordinates are inside of the scroll menu. 
		 * @param x
		 * @param y
		 * @return Whether this scroll menu collides with (x, y).
		 * 
		 */		
		private function inWindow(x:Number, y:Number):Boolean {
			return x > _x && x < _x + _width && y > _y && y < _y + _height;
		}
		
		/**
		 * Displays the given page and removes the given old page. 
		 * @param n The new page number to display, 0 based indexing
		 * @param old The old page that should be removed, 0 based indexing
		 * 
		 */		
		public function displayPage(n:int, old:int):void {
			remove(_pages[old], true);
			add(_pages[n]);
		}
		
		/**
		 * Adds the given FlxObject to the current page. 
		 * @param thing An object to add
		 * @param absoluteCoords Whether the objects coordinates should be treated as absolute or 
		 * relative to the upperleft corner of the menu.
		 * 
		 */		
		public function addToCurrentPage(thing:FlxObject, absoluteCoords:Boolean = true):void {
			_pages[_currentPage].add(thing);
			formatObject(thing);
			if (absoluteCoords) {
				thing.x -= _x + _padding;
				thing.y -= _y + _padding + _text.height;
			}
			displayPage(_currentPage, _currentPage);
		}
		
		/**
		 * Passes the buck to any Droppable children that interesect with the drop location 
		 * Drops to the first child in the members array for which draopOnto returns true.
		 * 
		 * @param obj The droppable object
		 * @param oldX The object's old x coordinate
		 * @param oldY The object's old y coordinate
		 * @return Whether the drop was successful or not
		 * 
		 */		
		public function dropOnto(obj:FlxObject, oldX:Number, oldY:Number):Boolean {
			if (!_canDrop) {
				return false;
			}
			Util.log("ScrollMenu.dropOnto called:");
			for each (var thing:FlxBasic in _pages[_currentPage].members) {
				if ((thing is Droppable) && obj.overlaps((thing as Droppable).boundingSprite) && (thing as Droppable).dropOnto(obj, oldX, oldY)) {
					displayPage(_currentPage, _currentPage);
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Sets the current page number text. 
		 * @param n The page number
		 * 
		 */		
		public function set pageCount(n:int):void {
			if (_pages.length <= 1) {
				_pageCount.text = "";
			} else {
				_pageCount.text = (n + 1) + "/" + _pages.length;
			}
		}
		
		public function get x():Number {
			return _x;
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function get width():Number {
			return _width;
		}
		
		public function get height():Number {
			return _height;
		}
		
		public function get canDrop():Boolean {
			return _canDrop;
		}
		
		public function set canDrop(t:Boolean):void {
			_canDrop = t;
		}
		
		public function get currentPage():FlxGroup {
			return _pages[_currentPage];
		}
		
		public function set onClose(callback:Function):void {
			_closeCallback = callback;
		}
		
		public function get boundingSprite():FlxSprite {
			return _box;
		}
		
		public function get onClose():Function {
			return function():void {
				if (_closeCallback != null) _closeCallback();
				kill();
			}
		}
	}
}
