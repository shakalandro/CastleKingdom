package com.Logging 
{
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Dmitri/Yun-En
	 * 
	 * Conains all constants necessary for CGSClient operation.
	 */
	public class CGSClientConstants 
	{
		public static const URL:String = "http://centerforgamescience.com/cgs/apps/games/ws/index.php/";
		
		public static const URL_UID:String = "muser/get/";
		public static const URL_DQID:String = "logging/getdynamicquestid/";
		public static const URL_LEVEL:String = "logging/setquest/";
		public static const URL_ACTION:String = "logging/set/";
		
		public static const bufferFlushIntervalMin:int = 5000; //(ms) minimum time between log buffer flushes to server 
		public static const bufferSizeMin:int = 0;	//minimum number of logs that have to be in the buffer before a flush will occur
		public static const bufferFlushForceCount:int = 100;	//number of attempts after which minimum buffer size is ignored
		
		public static const urlDataSuffix:String = "?data=";
		
		//game IDs
		public static const CASTLEKD:uint = 3;
		public static const ELEMENTAL:uint = 4;
		public static const GETACROSS:uint = 5;
		public static const MARBLEOUS:uint = 6;
		public static const SIMECO:uint = 7;
		public static const SKETCHALLEY:uint = 8;
		public static const ZOOMERSW:uint = 9;
		
		//Game names
		public static var NAME_DICT:Dictionary = new Dictionary();
		NAME_DICT[CASTLEKD] = "castlekd";
		NAME_DICT[ELEMENTAL] = "elemental";
		NAME_DICT[GETACROSS] = "getacross";
		NAME_DICT[MARBLEOUS] = "marbleous";
		NAME_DICT[SIMECO] = "simeco";
		NAME_DICT[SKETCHALLEY] = "sketchalley";
		NAME_DICT[ZOOMERSW] = "zoomersw";
		
		//Keys sent on a per-game basis; these are generated to be hard to guess (gids are easy)
		public static var SKEY_DICT:Dictionary = new Dictionary();
		SKEY_DICT[CASTLEKD] = "686246affc247204c0504d4a2bbabb91";
		SKEY_DICT[ELEMENTAL] = "2a6cfe026d195049175fd5468b104bd0";
		SKEY_DICT[GETACROSS] = "f182af442839a39aae9ec8adce99d6fc";
		SKEY_DICT[MARBLEOUS] = "6911790c292678905f52d87a49a75f0a";
		SKEY_DICT[SIMECO] = "95729134c01a44d59effb6e318da90d4";
		SKEY_DICT[SKETCHALLEY] = "26e4cfbb0c927a9ed82d69586c5f611d";
		SKEY_DICT[ZOOMERSW] = "0f89bbbb38401834e49ad6edabbb99f3";
	}

}