package com.Logging 
{
	/**
	 * ...
	 * @author Dmitri
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
	}

}