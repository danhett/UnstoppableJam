/**
 * @package com.danhett.core
 * @author  Dan Hett <hellodanhett@gmail.com>
 * @date    29/03/2013
 */
package com.com.danhett.entities
{
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.WireframeCube;

	import flash.geom.Point;

	public class EnemyFighter extends ObjectContainer3D
	{
		public var SHIP_COLOUR:uint = 0x00FFFF;
		private const SHIP_THICKNESS:int = 1;

		private var speed:int = randRange(5, 10);
		private var velocity:Point = new Point();

		private var body:WireframeCube;
		private var cross1:WireframeCube;
		private var cross2:WireframeCube;

		public function EnemyFighter()
		{
			init();
		}

		private function init():void
		{
			//SHIP_COLOUR = Math.random() * 0xFFFFFF;
			SHIP_COLOUR = 0x00FFFF;

			velocity.x = randRange(-4, 4);
			velocity.y = randRange(-1, 1);

			body = new WireframeCube(50, 50, 50, SHIP_COLOUR, SHIP_THICKNESS);
			body.rotationZ = 45;
			addChild(body);

			cross1 = new WireframeCube(100, 10, 10, SHIP_COLOUR, SHIP_THICKNESS);
			cross1.rotationZ = 45;
			addChild(cross1);

			cross2 = new WireframeCube(100, 10, 10, SHIP_COLOUR, SHIP_THICKNESS);
			cross2.rotationZ = -45;
			addChild(cross2);
		}

		public function update():void
		{
			cross1.rotationZ += speed;
			cross2.rotationZ -= speed;

			if(this.z < 5000)
			{
				this.x += velocity.x;
				this.y += velocity.y;
			}
		}

		private function randRange($min:Number, $max:Number):Number
		{
			return (Math.floor(Math.random() * ($max - $min + 1)) + $min);
		}
	}
}
