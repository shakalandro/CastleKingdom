package com.Logging 
{
	/**
	 * ...
	 * @author Dmitri/Yun-En
	 * 
	 * Container class, which contains information about user action.
	 * In general...
	 * aid will be a ClientActionType value,
	 * ts will be some informative timestamp (often time since the level began),
	 * te will be some informative timestamp about when the action ended (unlikely you'll use it),
	 * uid will be CGSClient.message.uid,
	 * details will be an object that contains any information about the action,
	 *    such as where it occurred or what its target is.
	 * and you probably won't care about the rest of the fields.
	 * 
	 * NOTE:
	 * If you are using JSON encoding, do not create getters to protected/private properties that you do not want to encode.
	 */
	public class ClientAction 
	{
		//----------- Action Variables (schema specific) --------------------------------------------------------
		//required
		public var aid:int;			//action id (must be defined in ClentActionType.as)
		public var ts:int;			//action start time
		//add more required action variables here
		
		//optional
		public var te:int;			//action end time
		public var stid:int;		//status id
		public var tid:int;			//logging type id
		public var uid:String;		//user id
		public var detail:Object	//object containing details about an action
		//add more optional action variables here
	}

}