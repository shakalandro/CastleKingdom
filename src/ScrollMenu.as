
package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;

	public class ScrollMenu
	{
		
		private var _window:FlxGroup = new FlxGroup();
		private var _windowContents:FlxGroup = new FlxGroup();
		private var scollNum:int = 0;
		private var _width:int = 0;
		private var _startX:int = 0;
		private var _startY:int = 0;
		
		public function ScrollMenu(	x:Number, y:Number, contents:FlxBasic, 
								   	closeCallback:Function, title:String = "", bgColor:uint = FlxG.WHITE, 
									padding:Number = 10, width:int = 100, height:int = 100, 
									borderThickness:Number = 3) {
			_startX = x;
			_startY = y;
			ExternalImage.setData(new BitmapData(width, height, true, bgColor), title);
			var box:FlxSprite = new FlxSprite(x, y, ExternalImage);
			box.alpha = .5;
			var right:Number = box.width - borderThickness + 1;
			var bottom:Number = box.height - borderThickness + 1;
			box.drawLine(0, 0, right, 0, FlxG.BLACK, borderThickness);
			box.drawLine(right, 0, right, bottom, FlxG.BLACK, borderThickness);
			box.drawLine(right, bottom, 0, bottom, FlxG.BLACK, borderThickness);
			box.drawLine(0, bottom, 0, 0, FlxG.BLACK, borderThickness);
			box.x = x;
			box.y = y;
			_window.add(box);
			
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
			
			_window.add(close);
			text.x += close.width;
			_window.add(text);
			for each(var m:FlxBasic in _window.members) {
				if (m is FlxObject) {
					(m as FlxObject).allowCollisions = FlxObject.NONE;
				}
			}
		}
		
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
		
		public function replace(element:Unit):void {
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
		
		public function scrollLeft():void {
			scrollHelp(-10);
		}
		
		public function scrollRight():void {
			scrollHelp(10);
		}
		
		public function scrollHelp(scrollNum:int):void {
			for each (var n:FlxBasic in (_windowContents as FlxGroup).members) {
				if (n is FlxObject) {
					(n as FlxObject).x += scrollNum;
					if( (n as FlxObject).x < _startX || (n as FlxObject).x > _startX + _width-(n as FlxObject).width  ) {
						//n.visible = false;
						n.visible = false;
						trace("out of screen");
					} else {
						n.visible = true;
						trace("on screen");
					}
				}
			}
		}
		
		public function get window():FlxBasic {
			return _window;
		}
		
		
	}
}