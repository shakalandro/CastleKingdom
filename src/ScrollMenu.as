
package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;

	public class ScrollMenu extends FlxGroup {
		private var _text:FlxText;
		private var _pages:Array;
		private var _currentPage:int;
		private var _width:int = 0;
		private var _height:int = 0;
		private var _leftButton:FlxButton;
		private var _rightButton:FlxButton;
		private var _pageCount:FlxText;
		private var _padding:Number;
		private var _x:Number;
		private var _y:Number;
		private var _dragCallback:Function;
		
		public function ScrollMenu(x:Number, y:Number, pageContents:Array, closeCallback:Function, title:String = "", bgColor:uint = FlxG.WHITE, 
									padding:Number = 10, width:int = 100, height:int = 100, borderThickness:Number = 3, dragCallback:Function = null) {
			super();
			_pages = pageContents || [];
			_width = width;
			_height = height;
			_padding = padding;
			_x = x;
			_y = y;
			_dragCallback = dragCallback;
			
			//Set the title text and pageText;
			_text = new FlxText(_x, _y, width - padding * 2, title);
			_text.color = FlxG.BLACK;
			_text.alignment = "center";
			_pageCount = new FlxText(_x, _y, width - padding * 2, "0/" + _pages.length);
			_pageCount.color = FlxG.BLACK;
			_pageCount.alignment = "right";
			
			//Set the button
			var me:ScrollMenu = this;
			var close:FlxButton = new FlxButton(x + width / 2, y + height - padding	* 2, "Close", function():void {
				if (closeCallback != null) closeCallback();
				me.kill();
			});
			close.x -= close.width / 2;
			close.y -= close.height / 2;
			_leftButton = new FlxButton(x + padding, y + height - padding * 2, "<<", scrollLeft);
			_leftButton.y -= _leftButton.height / 2;
			_rightButton = new FlxButton(x + width - padding, y + height - padding * 2, ">>", scrollRight);
			_rightButton.x -= _rightButton.width;
			_rightButton.y -= _rightButton.height / 2;	
			
			//Set up window box
			ExternalImage.setData(new BitmapData(width, height, true, bgColor), title);
			var box:FlxSprite = new FlxSprite(x, y, ExternalImage);
			box.alpha = .65;
			var right:Number = box.width - borderThickness + 1;
			var bottom:Number = box.height - borderThickness + 1;
			box.drawLine(0, 0, right, 0, FlxG.BLACK, borderThickness);
			box.drawLine(right, 0, right, bottom, FlxG.BLACK, borderThickness);
			box.drawLine(right, bottom, 0, bottom, FlxG.BLACK, borderThickness);
			box.drawLine(0, bottom, 0, 0, FlxG.BLACK, borderThickness);
			box.x = x;
			box.y = y;
			/*
<<<<<<< HEAD
			var text:FlxText = new FlxText(x + padding, y, width - padding * 3, title);
			text.color = FlxG.BLACK;
			var close:FlxButton = new FlxButton(x + borderThickness, y + borderThickness	, "Close", function():void {
				if (closeCallback != null) closeCallback();
				_window.kill();
			});
			
			// Draws contents of menu
			if (contents) {
				if (contents is FlxGroup) {
					_windowContents = contents as FlxGroup;
					for each (var n:FlxBasic in _windowContents.members) {
						if(n is FlxGroup) {
							// is group of placeable towers/armies
							for each (var n2:FlxBasic in n) {
							//	if(n2.visible == true) {
									(n as FlxGroup).remove(n2);
									drawIfObject(n2);
							//	}
							}
						}
						else {
							drawIfObject(n);
						}
					}
				} else {
					
					_windowContents = new FlxGroup();
					(_windowContents as FlxGroup).add(contents);
					if(n is FlxGroup) {
						for each (var n3:FlxBasic in n) {
							drawIfObject(n3);
						//	n3.visible = false;
						}
					} else {
						(contents as FlxObject).x += x + padding;
						(contents as FlxObject).y += y + text.height + padding;
					}
				}
				_width = width;
				_startX = x;
				//_window.add(contents);
			}
			
			// Draws scroll buttons
			var leftButton:FlxButton = new FlxButton(x+5,y+height-25,"<<", scrollLeft);
			var rightButton:FlxButton = new FlxButton(x+width - 85,y+height-25,">>",scrollRight);
			_window.add(leftButton);
			_window.add(rightButton);
======= */
			//Add everything
			add(box);
			add(_text);
			add(_pageCount);
			add(_leftButton);
			add(_rightButton);
			add(close);
			
			//set the page contents
			formatPages();
			if (_pages.length > 0) {
				Util.log("ScrollMenu: pages given");
				add(_pages[0]);
				_currentPage = 0;
				pageCount = 0;
			}
		}
		/*
		public function drawIfObject(n:FlxBasic):void {
			_window.add(n);
			if (n is FlxObject) {
				(n as FlxObject).x += _startX;
				(n as FlxObject).y += _startY + 10;
				if( (n as FlxObject).x > _startX + _width-(n as FlxObject).width  ) {
					n.visible = false;
					trace("out of screen");
				} else {
					n.visible = true;
					trace("on screen");
				}
				_window.add(n);

			}
		}
		
		
		public function replaceUnit(element:Unit):void {
			var idToReplace:int = element.unitID;
			for each ( var thing:String in _windowContents) {
				if(thing is FlxGroup) {
					var thingy:Array = (thing as FlxGroup).members;
					if((thingy[0] as Unit).unitID == idToReplace) {
						(thingy[0] as Unit).visible = true;
						_window.add(thingy[0] );
						(thing as FlxGroup).remove(thingy[0]);
						
					}
				}
			}
			_window.remove(element);

		}
*/		
		public function scrollLeft():void {
			if (_currentPage - 1 >= 0) {
				_currentPage--;
				displayPage(_currentPage, _currentPage + 1);
				pageCount = _currentPage;
			}
		}
		
		public function scrollRight():void {
			if (_currentPage + 1 < _pages.length) {
				_currentPage++;
				displayPage(_currentPage, _currentPage - 1);
				pageCount = _currentPage;
			}
		}
		
		public function formatPages():void {
			for (var i:int = 0; i < _pages.length; i++) {
				var stuff:FlxGroup = _pages[i];
				for each (var thing:FlxBasic in stuff.members) {
					formatObject(thing);
				}
			}
		}
		
		private function formatObject(thing:FlxBasic):void {
			if (thing is FlxObject) {
				var obj:FlxObject = (thing as FlxObject);
				obj.x += _x + _padding + _pageCount.height;
				obj.y += _y + _padding + _text.height;
				obj.allowCollisions = FlxObject.NONE;
				obj.immovable = true;
			}
			if (thing is Draggable) {
				(thing as Draggable).dragCallback = function(tower:Draggable, newX:Number, newY:Number, oldX:Number, oldY:Number):void {
					if (inWindow(newX, newY) || !(FlxG.state as ActiveState).droppable(newX, newY)) {
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
		
		private function inWindow(x:Number, y:Number):Boolean {
			return x > _x && x < _x + _width && y > _y && y < _y + _height;
		}
	
		public function displayPage(n:int, old:int):void {
			remove(_pages[old]);
			add(_pages[n]);
		}
		
		public function addToCurrentPage(thing:FlxObject, absoluteCoords:Boolean = true):void {
			_pages[_currentPage].add(thing);
			formatObject(thing);
			if (absoluteCoords) {
				thing.x -= _x + _padding + _pageCount.height;
				thing.y -= _y + _padding + _text.height;
			}
		}
		
		public function set pageCount(n:int):void {
			_pageCount.text = (n + 1) + "/" + _pages.length;
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
		
		public function get currentPage():FlxGroup {
			return _pages[_currentPage];
		}
	}
}
