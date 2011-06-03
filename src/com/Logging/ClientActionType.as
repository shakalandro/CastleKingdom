package com.Logging 
{
	/**
	 * ...
	 * @author Dmitri/Yun-En
	 * 
	 * Contains action IDs for all user actions in the game. Think of this class as a global enum.
	 * Replace with your own IDs.
	 * 
	 * IMPORTANT NOTES:
	 * 1.) Don't reuse ids.  This will make for really weird server logs, as
	 * old data will get reinterpretated as new data.
	 * Just make new ids and use those instead.
	 * 2.) When you add a new id, make sure to add it to the server as well.
	 * That way when it generates reports it can know which id maps to which actions.
	 */
	public final class ClientActionType 
	{
		
		public static const ENEMY_KILLED:int = 0;
		public static const CASTLE_UPGRADE:int = 1;
		public static const BARRACKS_UPGRADE:int = 2;
		public static const FOUNDRY_UPGRADE:int = 3;
		public static const AVIARY_UPGRADE:int = 4;
		public static const WIN_ATTACK:int = 5;
		public static const LOSE_ATTACK:int = 6;
		public static const MINE_UPGRADE:int = 7;
	}

}