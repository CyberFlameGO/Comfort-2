package objects {
	import egg82.enums.OptionsRegistryType;
	import egg82.patterns.Observer;
	import egg82.patterns.prototype.interfaces.IPrototype;
	import egg82.registry.RegistryUtil;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import objects.components.custom.ShieldedStressBallGraphicsComponent;
	import objects.components.PhysicsComponent;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class ShieldedStressBall extends BaseObject implements IPrototype {
		//vars
		private var registryUtilObserver:Observer = new Observer();
		
		private var gameType:String;
		
		//constructor
		public function ShieldedStressBall(gameType:String) {
			this.gameType = gameType;
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			physicsComponent = new PhysicsComponent(BodyType.DYNAMIC);
			graphicsComponent = new ShieldedStressBallGraphicsComponent(gameType);
			
			physicsComponent.setShapes([new Circle(14)]);
			
			physicsComponent.body.allowRotation = false;
			physicsComponent.body.allowMovement = true;
			physicsComponent.body.isBullet = false;
			
			physicsComponent.body.applyAngularImpulse(100);
		}
		
		//public
		public function clone():IPrototype {
			var c:ShieldedStressBall = new ShieldedStressBall(gameType);
			c.create();
			return c;
		}
		
		//private
		private function onRegistryUtilObserverNotify(sender:Object, event:String, data:Object):void {
			if (data.registry == "optionsRegistry") {
				checkOptions(data.type as String, data.name as String, data.value as Object);
			}
		}
		private function checkOptions(type:String, name:String, value:Object):void {
			if (type == OptionsRegistryType.VIDEO && name == "textureQuality") {
				if (graphicsComponent["resetTexture"] && graphicsComponent["resetTexture"] is Function) {
					(graphicsComponent["resetTexture"] as Function).call();
				}
			}
		}
	}
}