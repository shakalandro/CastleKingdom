package {
	import flash.display.Sprite;
	
	// PushButton Engine Imports
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.*;
	import com.pblabs.rendering2D.*;
	import com.pblabs.rendering2D.ui.*;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	[SWF(width="800", height="600", frameRate="60")]
	public class CastleKingdom extends Sprite {
		public function CastleKingdom()
		{
			PBE.startup(this);
			Logger.print(this, "Hello World!");
			createScene();
			createCircle();
		}
		
		public function createScene():void {
			var sceneView:SceneView = new SceneView();
			sceneView.width = 800;
			sceneView.height = 600; 
			PBE.initializeScene(sceneView);	
		}
		
		public function createCircle():void {
			var hero:IEntity = allocateEntity();
			
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			
			spatial.position = new Point(0,0); 
			spatial.size = new Point(50,50);
			spatial.spatialManager = PBE.spatialManager;
			
			hero.addComponent( spatial, "Spatial" );
			
			var render:SimpleShapeRenderer = new SimpleShapeRenderer();
			render.fillColor = 0x0000FF0;
			render.isCircle = true;
			render.lineSize = 2;
			render.radius = 25;
			render.lineColor = 0x000000;
			render.scene = PBE.scene;
			
			render.positionProperty = new PropertyReference("@Spatial.position");
			render.rotationProperty = new PropertyReference("@Spatial.rotation");
			
			hero.addComponent( render, "Render" ); 
			
			var controller:PracticeController = new PracticeController();
			controller.positionReference = new PropertyReference("@Spatial.position");
			hero.addComponent( controller, "Controller" );
			
			hero.initialize("Hero");     
		}
	}
}