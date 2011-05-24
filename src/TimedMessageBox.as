package
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flixel.*;

	public class TimedMessageBox extends MessageBox
	{
		private var _callback:Function;
		
		public function TimedMessageBox(message:String, time:Number = 4000, callback:Function = null, padding:Number=10, borderColor:uint=FlxG.RED, borderThickness:Number=3)
		{
			super(message, null, null, null, null, padding, borderColor, borderThickness);
			var _timer:Timer = new Timer(time, 1);
			var _fadeTimer:Timer = new Timer(100, 20);
			_callback = callback;

			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void {
				_fadeTimer.start();
			});
			_fadeTimer.addEventListener(TimerEvent.TIMER, function():void {
				_box.alpha -= .05;
				_text.alpha -= .05;
			});
			_fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void {
				if (alive && visible && this.members != null) {
					close(_callback);
				}
			});
			
			_timer.start();
		}
	}
}