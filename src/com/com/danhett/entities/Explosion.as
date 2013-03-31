/**
 * @package com.danhett.core
 * @author  Dan Hett <hellodanhett@gmail.com>
 * @date    29/03/2013
 */
package com.com.danhett.entities
{
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.WireframeCube;

	import com.danhett.core.Unstoppable;

	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;

	public class Explosion extends ObjectContainer3D
	{
		private const SHIP_COLOUR:uint = 0x00FFFF;
		private const SHIP_THICKNESS:int = 1;

		private var boxCount:int = 10;
		private var rad:int = 1000;

		public function Explosion()
		{
			init();
		}

		private function init():void
		{
			for(var i:int = 0; i < boxCount; i++)
			{
				var box:WireframeCube = new WireframeCube(10, 10, 10, SHIP_COLOUR, SHIP_THICKNESS);
				box.scaleX = box.scaleY = box.scaleZ = 0;
				addChild(box);

				TweenMax.to(box,  3, {x:randRange(-rad,  rad),
									  y:randRange(-rad,  rad),
									  z:randRange(-rad,  rad),
									  scaleX:1,
									  scaleY:1,
									  scaleZ:1,
									  rotationX:randRange(-360, 360),
									  rotationY:randRange(-360, 360),
									  rotationZ:randRange(-360, 360),
									  ease:Expo.easeOut});

				TweenMax.to(box,  randRange(0.5, 2), {
					scaleX:0,
					scaleY:0,
					scaleZ:0,
					delay:0.8});
			}

			TweenMax.delayedCall(1, destroy);
		}

		private function destroy():void
		{
			Unstoppable.Instance.removeExplosion(this);
		}

		private function randRange($min:Number, $max:Number):Number
		{
			return (Math.floor(Math.random() * ($max - $min + 1)) + $min);
		}
	}
}