/**
 * @package com.danhett.core
 * @author  Dan Hett <hellodanhett@gmail.com>
 * @date    29/03/2013
 */
package com.com.danhett.entities
{
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.WireframeCube;

	public class Column extends ObjectContainer3D
	{
		private const SHIP_COLOUR:uint = 0x999999;
		private const SHIP_THICKNESS:int = 1;
		private var column:WireframeCube;

		public function Column()
		{
			init();
		}

		private function init():void
		{
			column = new WireframeCube(50, 400, 50, SHIP_COLOUR, SHIP_THICKNESS);
			addChild(column);

			randomise();
		}

		public function randomise():void
		{
			column.x = randRange(-500, 500);
			column.height = randRange(50, 600);
			column.width = randRange(100, 500);
			column.height = randRange(100, 500);
			column.y = column.height * 0.5;
			column.rotationY = randRange(0, 360);
		}

		private function randRange($min:Number, $max:Number):Number
		{
			return (Math.floor(Math.random() * ($max - $min + 1)) + $min);
		}
	}
}
