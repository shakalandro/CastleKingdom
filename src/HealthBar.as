package
{
	import org.flixel.FlxSprite;
	
	public class HealthBar extends FlxSprite
	{
		private var _maxWidth:int;
		private var _maxHealth:int;
		private var _curHealth:int;
		
		public function HealthBar(X:Number=0, Y:Number=0, maxxHealth:int = 0, maxxWidth:int = 0)
		{
			super(X, Y, null);
			
		
			/*var bar:FlxSprite = new FlxSprite(5,5);
			bar.createGraphic(1,8,0xffff0000); //The red bar itself
			bar.scrollFactor.x = bar.scrollFactor.y = 0;
			bar.origin.x = bar.origin.y = 0; //Zero out the origin
			bar.scale.x = 48; //Fill up the health bar all the way
			add(bar);
			
			bar.scale.x = 24; */
			
			//this.loadGraphic(Util.assets[Assets.CURSOR]);
			
		}
		
		public function start(X:Number=0, Y:Number=0, maxxHealth:int = 0, maxxWidth:int = 0): void {
			this.x = X;
			this.y = Y-6;
			this.width = maxxWidth;
			this.height = 6;
			this._maxHealth = maxxHealth;
			this._curHealth = maxxHealth;
			this._maxWidth = maxxWidth;
			//this.createGraphic(maxxWidth,5,0x33ff0000);
			this.color = 0xffff0000;
			this.alpha = 1;
			trace("" +_maxWidth);
			
			/*var bar:FlxSprite = new FlxSprite(5,5);
			bar.createGraphic(1,8,0xffff0000); //The red bar itself
			bar.scrollFactor.x = bar.scrollFactor.y = 0;
			bar.origin.x = bar.origin.y = 0; //Zero out the origin
			bar.scale.x = 48; //Fill up the health bar all the way
			add(bar);
			
			bar.scale.x = 24; */
			
			//this.loadGraphic(Util.assets[Assets.CURSOR]);
			
		}
		
		public function hit(newHealth:Number):void {
			_curHealth = newHealth;
			var healthPercent:Number = _curHealth / _maxHealth;
			this.width =  healthPercent * _maxWidth;
			if( healthPercent > .66) {
				this.fill(0x33ff0000);
			} else if (healthPercent > .33) {
				this.fill(0xffcc0000);
			} else {
				this.fill(0xff000000);
			}
			
			
		}
		
		public function updateLoc(x:int, y:int, newHealth:Number, maxSize:int):void {
			
			this.x = x;
			this.y = y-6;
			_curHealth = newHealth;
			var healthPercent:Number = _curHealth / _maxHealth;
			if (healthPercent <= 0 ) {
				return;
			}
			this.width =  healthPercent * maxSize;
			this.createGraphic(this.width,5,0x33ff0000);
			this._alpha = 1;
			trace("health at " +this.width + " at " + x +"," + y);
			trace("" + healthPercent + " " + _maxWidth); 

			if( healthPercent > .66) {
				this.fill(0x33ff0000);
			} else if (healthPercent > .33) {
				this.fill(0xffcc0000);
			} else {
				this.fill(0xff000000);
			}
			
		}
		
		
	}
}