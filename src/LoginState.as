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
			FaceBook.connect(function(ready:Boolean):void {
				if (ready) {
					FaceBook.userInfo(function(info:Object):void {
						if (info) {
							_loginText.text = "Hi " + info.name + "!";
						} else {
							Util.log("Failed to get user info");
						}
					});
				} else {
					_loginText.text = "Try again :(";
					Util.log("LoginState.login failed: " + ready);
				}
			}, CastleKingdom.flashVars.accessToken);
		}
		
		private function start():void {
			FlxG.state = new ActiveState(false, true, this.map);
		}
	}
}