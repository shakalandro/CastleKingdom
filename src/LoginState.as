package
{
	import com.facebook.graph.*;
	
	import org.flixel.*;
	
	public class LoginState extends GameState
	{
		public function LoginState()
		{
			super();
			Util.facebookConnect(function(ready:Boolean):void {
				Util.facebookFriends(function(result:Array, fail:Object):void {
					if (result) {
						for (var i:int = 0; i < result.length; i++) {
							FlxG.log(result[i].name);
						}
					}
				});
			});			
		}
	}
}