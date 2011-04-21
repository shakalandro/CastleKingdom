package
{
	import org.flixel.FlxState;
	
	public class GameState extends FlxState
	{
		/**
		 * Constructs a new GameState. This is a helper superclass state All persistent gamestate materials are held here. 
		 * @param tutorial
		 * @param menusActive
		 * 
		 */		
		public function GameState(tutorial:Boolean, menusActive:Boolean) {
			
		}
		/**
		 * Establishes persistent UI components.
		 */
		override public function create():void {
			super.create();
		}
		
		/**
		 * Updates GamesState's state every game loop tick
		 */
		override public function update():void {
			super.update();
		}
	}
}