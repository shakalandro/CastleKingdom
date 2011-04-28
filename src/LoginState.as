package
{
	import com.facebook.graph.*;
	
	import org.flixel.*;
	
	public class LoginState extends GameState
	{
		private var _loginButton:FlxButton;
		private var _loginText:FlxText;
		
		public function LoginState()
		{
			super();
		}
		
		override public function create():void {
			super.create();
			_loginButton = new FlxButton(0, 0, login);
			_loginText = new FlxText(0, 0, 100, "Log in to Facebook");
			_loginButton.loadText(_loginText);
			Util.center(_loginButton);
			add(_loginButton);
		}
		
		private function login():void {			
			Util.facebookConnect(function(ready:Boolean):void {
				if (ready) {
					Util.facebookFriends(function(result:Array, fail:Object):void {
						if (result) {
							for (var i:int = 0; i < result.length; i++) {
								FlxG.log(result[i].name);
							}
						} else {
							FlxG.log("failed to connect: " + fail);
						}
					});
					Util.facebookUserInfo(function(info:Object):void {
						if (info) {
							_loginText.text = "Hi " + info.name + "!";
						} else {
							FlxG.log("Failed to get user info");
						}
					});
				} else {
					_loginText.text = "Try again :(";
					FlxG.log("LoginState.login failed: " + ready);
				}
			});
		}
	}
}