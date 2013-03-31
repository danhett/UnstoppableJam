/**
 * @package com.danhett.core
 * @author  Dan Hett <hellodanhett@gmail.com>
 * @date    29/03/2013
 */
package com.com.danhett.entities
{
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.WireframeCube;

	public class Bullet extends ObjectContainer3D
	{
		private const SHIP_COLOUR:uint = 0xFA1919;
		private const SHIP_THICKNESS:int = 1;
		private var bullet:WireframeCube;

		public function Bullet()
		{
			init();
		}

		private function init():void
		{
			bullet = new WireframeCube(10, 10, 10, SHIP_COLOUR, SHIP_THICKNESS);
			bullet.rotationX = randRange(0, 360);
			bullet.rotationY = randRange(0, 360);
			bullet.rotationZ = randRange(0, 360);
			addChild(bullet);

		}

		private function randRange($min:Number, $max:Number):Number
		{
			return (Math.floor(Math.random() * ($max - $min + 1)) + $min);
		}
	}
}