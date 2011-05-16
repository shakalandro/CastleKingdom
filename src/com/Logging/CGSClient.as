package com.Logging 
{
	import com.adobe.serialization.json.*;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * ...
	 * @author Dmitri/Yun-En
	 * 
	 * Provides server communication/logging
	 * Typically...
	 * You'll want to initialize CGSClient.message's cid, vid, and gid in the constructor.
	 * Then call SetUid as the very first thing you'll do.
	 * 
	 * Then every time you start a level you'll want to SetDqid and ReportLevel.
	 * Then in each level, use LogAction() to log an action with server.
	 * 
	 * In general, functions that send data to the server will rely on some 
	 * combination of gid, qid, vid, cid, dqid, and uid. The functions will
	 * assume that cid, vid, and gid are set because they generally do not change
	 * and were specified in the constructor; in that sense these are basically
	 * "default" arguments.  They will NOT assume that qid or dqid are set,
	 * because those two will usually change many times over the game.
	 *
	 * You can also use SendObjectToServer() to send a generic message to server.
	 * 
	 */
	public class CGSClient 
	{
		protected var _serverURL:String;
		
		protected var _timer:Timer;
		protected var _timerCounter:int;
		protected var _callbackDict:Dictionary;
		
		protected var _message:Message;
		
		//----------- Constructor -------------------------------------------------------------------------------
		public function CGSClient(serverURL:String, gid:int, cid:int, vid:Number=0, bufferLogs:Boolean = true):void
		{
			if (!serverURL)
				throw new Error("Server URL must not be null!!!");
			_serverURL = serverURL;
			
			_message = new Message(bufferLogs);
			_message.gid = gid;
			_message.cid = cid;
			_message.vid = vid;
			_callbackDict = new Dictionary();
			
			//set up timer
			_timer = new Timer(CGSClientConstants.bufferFlushIntervalMin, 0);
			_timer.addEventListener(TimerEvent.TIMER, FlushBufferToServer)
			_timer.start();
			_timerCounter = CGSClientConstants.bufferFlushForceCount;
		}
		
		//----------- message -----------------------------------------------------------------------------------
		///Returns clients message. Use this getter to set message header variables.
		public function get message():Message
		{
			return(_message);
		}
		
		//----------- SetUid -----------------------------------------------------------------------------------
		///Either find the username in the flash cache or get a new one from the server.
		///Potentially blocks waiting for the server, so to be safe give it a callback
		///that can be called when the user is definitely set up.
		///callback should take a string - the username, or null if there is a catastrophic failure. 
		public function SetUid(callback:Function):void
		{
			var so:SharedObject = SharedObject.getLocal("logging");
			if (so.data.uid != null) {
				_message.uid = so.data.uid;
				callback(_message.uid);
				trace("Stored user found: " + _message.uid);
			}
			else {
				function done(obj:Object):void {
					if (obj == null) {
						//failure
						callback(null);
						return;
					}
					_message.uid = obj["uid"];
					so.data.uid = _message.uid;
					so.flush();
					trace("new user grabbed from server: " + _message.uid);
					callback(_message.uid);
				}
				var o:Object = new Object();
				o["gid"] = _message.gid;
				SendObjectToServer(_serverURL + CGSClientConstants.URL_UID + CGSClientConstants.urlDataSuffix, o, done);
			}
		}
		
		//----------- SetDqid -----------------------------------------------------------------------------------
		///Get a new dqid to use from the server; typically this happens when playing a new level.
		///callback should take a string - the dqid, or null if there is a catastrophic failure. 
		public function SetDqid(callback:Function):void
		{
			function done(obj:Object):void {
				if (obj == null) {
					//failure
					callback(null);
					return;
				}
				_message.dqid = obj["dqid"];
				trace("new dqid grabbed from server: " + _message.dqid);
				callback(_message.dqid);
			}
			var o:Object = new Object();
			o["gid"] = _message.gid;
			SendObjectToServer(_serverURL + CGSClientConstants.URL_DQID + CGSClientConstants.urlDataSuffix, o, done);
		}
		
		//----------- ReportLevel -----------------------------------------------------------------------------------
		///Report a new level to the server.  Typically you'll also call setDqid right before this.
		///Note that this will set message's qid because it assumes you'll start to send actions to the server
		///for this new quest.  That's probably what you want, but if it isn't remember to change qid back.
		///callback should take a String - the dqid, or null if there is a catastrophic failure. 
		public function ReportLevel(dqid:String, qid:int, callback:Function):void
		{
			function done(obj:Object):void {
				if (obj == null) {
					//failure
					callback(null);
					return;
				}
				trace("Reported a new level to the server: " + dqid);
				callback(_message.dqid);
			}
			var o:Object = new Object();
			o["qid"] = qid;
			o["dqid"] = dqid;
			o["gid"] = _message.gid;
			o["uid"] = _message.uid;
			o["cid"] = _message.cid;
			o["vid"] = _message.vid;
			_message.qid = qid;
			SendObjectToServer(_serverURL + CGSClientConstants.URL_LEVEL + CGSClientConstants.urlDataSuffix, o, done);
			trace("this is the end of the ReportLevel function");
		}
		
		//----------- LogAction ---------------------------------------------------------------------------------
		///Logs given Client Action on the server.
		///This function automatically encodes action.details, if it isn't null.
		public function LogAction(action:ClientAction, forceFlush:Boolean = false):void
		{
			if (!_message.BufferAction(action) || forceFlush)
			{
				// _message is not bufferable or a flush is being forced, so send it now
				var messageStr:String = EncodeObject(_message);
				messageStr = _serverURL + CGSClientConstants.URL_ACTION + CGSClientConstants.urlDataSuffix + messageStr;
				SendToServer(messageStr);
			}
		}
		
		//----------- SendObjectToServer ------------------------------------------------------------------------
		///Encodes a given object and sends it to server at given url.
		///If no url was given _serverURL with CGSClientConstants.urlDataSuffics suffics
		public function SendObjectToServer(url:String, obj:Object, callback:Function):void
		{
			var messageStr:String;
			if (url && url != "")
				messageStr = url;	//url does not look invalid, so use it
			else
				messageStr = _serverURL + CGSClientConstants.urlDataSuffix;
			if (obj)
				messageStr += EncodeObject(obj);
			
			var urlLoader:URLLoader = new URLLoader();
			_callbackDict[urlLoader] = callback;
			SendToServer(messageStr, urlLoader);
		}
		
		//----------- FlushBufferToServer -----------------------------------------------------------------------
		///Flushes action buffer to server on a timer event.
		protected function FlushBufferToServer(e:TimerEvent):void
		{
			if (_message.IsBufferable())
			{
				_timerCounter--;
				var buffer:Array = _message.actions as Array;
				if(buffer.length > 0 && (buffer.length > CGSClientConstants.bufferSizeMin || _timerCounter <= 0))
				{
					//too many actions are buffered or _timeCounter reached 0. Send what we have to server
					var messageStr:String = EncodeObject(_message);
					messageStr = _serverURL + CGSClientConstants.URL_ACTION + CGSClientConstants.urlDataSuffix + messageStr;
					SendToServer(messageStr);
					_timerCounter = CGSClientConstants.bufferFlushForceCount;
				}
			}
		}
		
		//----------- SendToServer ------------------------------------------------------------------------------
		///Creates a URLRequest and sends it so server.
		protected function SendToServer(messageURL:String, urlLoader:URLLoader = null):void
		{
			var request:URLRequest = new URLRequest(messageURL);
			request.method = URLRequestMethod.POST;
			
			if(!urlLoader)
				urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, HandleResponse);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, HandleError);
			
			urlLoader.load(request);
			trace("Sent to server: " + messageURL);
		}
		
		//----------- HandleResponse ----------------------------------------------------------------------------
		///Handles server response.
		protected function HandleResponse(e:Event):void
		{
			trace("Server response");
			var urlLoader:URLLoader = URLLoader(e.target);
			var serverVariables:URLVariables = new URLVariables(urlLoader.data);
			var serverReply:String = serverVariables.data;
			if (serverReply.length > 0)
			{
				// server gave us something back, let's decode and process that
				var serverObj:Object = DecodeObject(serverReply);
				
				//====== Schema Specific =======================================
				if (serverObj.hasOwnProperty("tstatus"))
				{
					//this is a log post status
					if (serverObj["tstatus"] == "t")
					{
						_message.ClearBuffer();
					}
					else
					{
						// add code to handle log post failures
					}
				}
				//==============================================================
				
				if (_callbackDict[urlLoader] != undefined)
				{
					// someone else wants to see the result. Give it to them.
					var callback:Function = _callbackDict[urlLoader];
					callback(serverObj);
					delete _callbackDict[urlLoader];
				}
			}
		}
		
		//----------- HandleError -------------------------------------------------------------------------------
		///Handles I/O errors for server communication
		protected function HandleError(e:Event):void
		{
			trace("Server error!");
			var urlLoader:URLLoader = URLLoader(e.target);
			if (_callbackDict[urlLoader] != undefined)
			{
				// someone else wants to see the result. Give it to them.
				var callback:Function = _callbackDict[urlLoader];
				callback(null);
				delete _callbackDict[urlLoader];
			}
		}
		
		//----------- EncodeObject ------------------------------------------------------------------------------
		///Encodes given object. Returns encoded string
		protected function EncodeObject(obj:Object):String
		{
			//add you own encoding code here
			return(JSON.encode(obj));
		}
		
		//----------- DecodeObject ------------------------------------------------------------------------------
		///Decodes given string. Returns decoded object
		protected function DecodeObject(str:String):Object
		{
			//add you own decoding code here
			return(JSON.decode(str));
		}
	}

}