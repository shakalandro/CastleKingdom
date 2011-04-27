package
{
	import com.facebook.graph.*;
	import org.flixel.*;
	
	public class LoginState extends GameState
	{
		
		private static const FACEBOOK_APP_ID:String = "197220693652461";
		private static const FACEBOOK_SECRET_KEY:String = "592b9006282d5442f9d042b56fe04913";
		
		public function LoginState()
		{
			super();
			Facebook.init(LoginState.FACEBOOK_APP_ID, function(success:Object, fail:Object):void {
				FlxG.log("initalized" + success + ", " + fail);
			});
		}
	}
}