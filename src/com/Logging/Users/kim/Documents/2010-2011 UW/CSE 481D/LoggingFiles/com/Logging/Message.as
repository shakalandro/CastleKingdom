package com.Logging 
{
	/**
	 * ...
	 * @author Dmitri/Yun-En
	 * 
	 * Message class contains a list of header variables (logging schema specific) and an optional action buffer.
	 * You'll need to set gid, cid, and qid yourself.
	 *   Gid will be the same for each game, always; look in the database to find yours.
	 *   Cid will be set by you to whatever you want, although it will probably change for new events or releases.
	 *   Qid depends on what quest in the game you're currently playing.
	 * 
	 * You may also want to use vid, although cid most likely suffices.
	 * 
	 * In general you'll call CGSClient's setUser to set the uid, and setDqid to set the dqid.
	 * You also probably don't care about the optional fields.
	 * 
	 * What is cid, you ask?  It's typically used when you want to segregate data from some particular real-life event.
	 * For instance, you ask 50 people to playtest your game.  It's going to be a pain to look through the database
	 * for those exact 50 people.  However, if you compile a version of the game with a new cid, you can simply
	 * do one database call to get every action with cid 5.  Then you can bump cid again for new builds.
	 * 
	 * What's the difference between vid and cid, then?
	 * Vid is conceptually the version of your game; new versions may have new levels or mechanics.
	 * You might use the same vid for several different real life events, each with their own cid.
	 * It's also possible that you'd have different versions of the game for the same cid -
	 * imagine playtesting three different versions of the game at once.
	 * That being said, as long as you write down what each cid is, you can probably do everything just
	 * by bumping cids for each version, in which case you can ignore vid and just let it default to 0.  
	 * 
	 * NOTE:
	 * If you are using JSON encoding, do not create getters protected/private properties that you do not want to encode.
	 * 
	 */
	public class Message 
	{
		//----------- Header Variables (schema specific) --------------------------------------------------------
		//required, probably only set once
		public var gid:int = -1;	//game id
		public var g_name:String;	//game name
		public var skey:String;		//authentication key
		public var vid:Number = 0;	//version id
		public var cid:int = -1;	//category id (for event tracking)
		public var uid:String;		//user id
		
		//required, probably set once per level
		public var qid:int;			//quest id (quest is a collection of levels)
		public var dqid:String;		//dynamic quest id (for tracking quest replay)
		// add additional required header variables here
		
		//optional
		public var lid:int;			//level id (within the quest)
		public var sid:int;			//session id
		public var eid:int;			//event id
		public var tid:int;			//type id
		// add additional optional header variables here
		
		//----------- Action Variables --------------------------------------------------------------------------
		protected var _isBufferable:Boolean;	//indicates whether this message is bufferable or not
		protected var _actionBuffer:Array;		//buffer of actions
		protected var _action:ClientAction;		//non-buffered action
		
		//----------- Constructor -------------------------------------------------------------------------------
		public function Message(useBuffer:Boolean)
		{
			_isBufferable = useBuffer;
			_actionBuffer = new Array();
			_action = null;
		}
		
		//----------- IsBufferable ------------------------------------------------------------------------------
		///Returns whether this message uses an action buffer or not.
		public function IsBufferable():Boolean
		{
			return(_isBufferable);
		}
		
		//----------- actions -----------------------------------------------------------------------------------
		///Returns an action or array of actions if this message uses an action buffer.
		public function get actions():Object
		{
			var result:Object = null;
			if (_isBufferable)
				result = _actionBuffer;
			else
				result = _action;
			return(result);
		}
		
		//----------- BufferAction ------------------------------------------------------------------------------
		///Bufferes a given action. Returns true if this message uses a buffer, false otherwise.
		public function BufferAction(action:ClientAction):Boolean
		{
			var result:Boolean = false;
			if (action)
			{
				if (_isBufferable)
				{
					result = true;
					actions.push(action);
				}
				_action = action;
			}
			return(result);
		}
		
		//----------- ClearBuffer -------------------------------------------------------------------------------
		///Clears a buffer of this message.
		public function ClearBuffer():void
		{
			_action = null;
			if (_isBufferable)
				_actionBuffer = new Array();
		}
	}

}