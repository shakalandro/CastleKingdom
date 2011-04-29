package
{
	import com.facebook.graph.*;
	
	import org.flixel.*;
	
	public class LoginState extends GameState
	{
		private var _beginButton:FlxButton;
		private var _loginButton:FlxButton;
		private var _loginText:FlxText;
		
		public function LoginState()
		{
			super();
		}
		
		override public function create():void {
			super.create();
			
			_beginButton = new FlxButton(0, 0, start);
			_beginButton.loadText(new FlxText(0, 0, 100, "Begin"));
			Util.center(_beginButton);
			add(_beginButton);
			
			if (CastleKingdom.FACEBOOK_ON) {
				_loginButton = new FlxButton(0, 0, login);
				_loginText = new FlxText(0, 0, 100, "Log in to Facebook");
				_loginButton.loadText(_loginText);
				Util.center(_loginButton);
				_loginButton.y += _beginButton.height * 2;
				add(_loginButton);
			}
		}
		
		private function login():void {
			Util.facebookConnect(function(ready:Boolean):void {
				if (ready) {
					Util.facebookFriends(function(result:Array, fail:Object):void {
						if (result) {
							for (var i:int = 0; i < result.length; i++) {
								superLog(result[i].name);
							}
						} else {
							superLog("failed to connect: " + fail);
						}
					});
					Util.facebookUserInfo(function(info:Object):void {
						if (info) {
							_loginText.text = "Hi " + info.name + "!";
						} else {
							superLog("Failed to get user info");
						}
					});
				} else {
					_loginText.text = "Try again :(";
					superLog("LoginState.login failed: " + ready);
				}
			});
		}
		
		private function start():void {
			FlxG.state = new ActiveState(false, true, this.map);
		}
	}
}