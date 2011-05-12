package {
	
	import flash.display.BitmapData;

	 /**
	 * Helper class for loading images from the internet in a flixel loadGraphic compatible way. 
	 * @author royman
	 * 
	 */
	public class ExternalImage {
		
		public static var data:BitmapData;
		public static var url:String;
		private var _data:BitmapData;
		private var _url:String;
		
		public function ExternalImage():void {
			_data = data.clone();
			_url = url;
		}
		
		public static function setData(newData:BitmapData, newUrl:String):void {
			data = newData.clone();
			url = newUrl.toString();
		}
		
		public static function toString():String {
			return url;
		}
		
		public function get url():String {
			return _url;
		}
		
		public function get bitmapData():BitmapData {
			return _data;
		}
	}
}