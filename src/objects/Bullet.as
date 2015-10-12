package objects {
	import egg82.custom.CustomAtlasImage;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.events.custom.CustomAtlasImageEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.prototype.interfaces.IPrototype;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.interfaces.IRegistryUtil;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import objects.base.BasePolyPhysicsObject;
	import objects.interfaces.ITriggerable;
	import physics.IPhysicsData;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class Bullet extends BasePolyPhysicsObject implements IPrototype, ITriggerable {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService("registryUtil") as IRegistryUtil;
		private var physicsRegistry:IRegistry = ServiceLocator.getService("physicsRegistry") as IRegistry;
		
		private var customAtlasImageObserver:Observer = new Observer();
		
		private var gameType:String;
		
		//constructor
		public function Bullet(gameType:String, triggerCallback:Function) {
			this.gameType = gameType;
			this.triggerCallback = triggerCallback;
			
			customAtlasImageObserver.add(onCustomAtlasImageObserverNotify);
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			super(registryUtil.getFile(FileRegistryType.TEXTURE, gameType), registryUtil.getFile(FileRegistryType.XML, gameType), physicsRegistry.getRegister("bullet_" + registryUtil.getOption(OptionsRegistryType.PHYSICS, "shapeQuality")) as IPhysicsData, 0);
			
			body.allowRotation = false;
			body.allowMovement = true;
			body.scaleShapes(0.6, 0.6);
			body.translateShapes(Vec2.weak(0, -168));
			body.isBullet = true;
		}
		
		//public
		public function clone():IPrototype {
			var c:Bullet = new Bullet(gameType, triggerCallback);
			c.create();
			return c;
		}
		
		//private
		private function onCustomAtlasImageObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== this) {
				return;
			}
			
			Observer.remove(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			if (event == CustomAtlasImageEvent.COMPLETE) {
				setTextureFromName("bullet");
			} else if (event == CustomAtlasImageEvent.ERROR) {
				
			}
			
			scaleX = scaleY = 0.6;
			
			alignPivot();
			this.pivotY = 316;
		}
	}
}