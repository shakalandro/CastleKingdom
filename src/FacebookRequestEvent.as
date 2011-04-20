package facebook
{
	import flash.events.Event;
	
	/**
	 * The event that is fired from the FacebookClient to indicate that a call has finished.
	 * The relevant properties from this class are:
	 * <ul>
	 *   <li>success - whether or not the call was successful, if so check the result property else the failureMessage property
	 *   <li>result - The result from the call, XML returned by facebook.  
	 *   <li>failureMessage - Facebook returns a failureMessage if a call to their servers fall.  This is the parsed message.
	 * </ul>
	 */
	public class FacebookRequestEvent
		extends Event
	{
		public var success:Boolean = false;
		public var result:XML;
		public var failureMessage:String;
		
		public static const CALL_RESULT_EVENT:String = "CallResultEvent";
		
		public function FacebookRequestEvent(pResult:XML, pSuccess:Boolean, pFailureMessage:String):void {
			super(CALL_RESULT_EVENT);
			success = pSuccess;
			result = pResult;
			failureMessage = pFailureMessage;
		}
	}
}