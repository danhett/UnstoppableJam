/**
 * @package com.danhett.core
 * @author  Dan Hett <hellodanhett@gmail.com>
 * @date    29/03/2013
 */
package com.com.danhett.entities
{
	import com.danhett.core.*;
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.WireframeCube;

	import flash.geom.Point;

	import com.greensock.TweenMax;
	import com.greensock.easing.*;

	public class Ship extends ObjectContainer3D
	{
		private const SHIP_COLOUR:uint = 0xFA1919;
		private const SHIP_THICKNESS:int = 2;

		public var UP:Boolean = false;
		public var DOWN:Boolean = false;
		public var LEFT:Boolean = false;
		public var RIGHT:Boolean = false;
		private var maxTilt:int = 15;
		private var target:Point = new Point();
		private var boundsX:int = 300;
		private var boundsY:int = 400;
		private var diffX:int;
		private var diffY:int;
		private var damping:Number = 0.05;

		private var speed:int = 7;

		public function Ship()
		{
			init();
		}

		private function init():void
		{
			this.y = 450;

			// ship body
			var body:WireframeCube = new WireframeCube(50, 20, 100, SHIP_COLOUR, SHIP_THICKNESS);
			addChild(body);

			// left wing
			var left:WireframeCube = new WireframeCube(20, 5, 70, SHIP_COLOUR, SHIP_THICKNESS);
			left.rotationZ = 20;
			left.x = -30;
			left.y = -5;
			left.z = -30;
			addChild(left);

			// right wing
			var right:WireframeCube = new WireframeCube(20, 5, 70, SHIP_COLOUR, SHIP_THICKNESS);
			right.rotationZ = -20;
			right.x = 30;
			right.y = -5;
			right.z = -30;
			addChild(right);
		}

		public function descendShip():void
		{
			this.y = 450;
			TweenMax.to(this,  3, {y:0, onComplete:readyToStart})
		}

		public function readyToStart():void
		{
			Unstoppable.Instance.startGame();
		}

		public function update():void
		{
		    if(LEFT)
		    {
			    if(this.x > (-boundsX))
			    {
				    this.target.x -= speed;
			    }

			    if(this.rotationZ < maxTilt)
			        this.rotationZ += 1;
		    }

			if(RIGHT)
			{
				if(this.x < boundsX)
				{
					this.target.x += speed;
				}

				if(this.rotationZ > (-maxTilt))
					this.rotationZ -= 1;
			}

			if(UP)
			{
				if(this.y < boundsY)
					this.target.y += speed;

				if(this.rotationX > (-maxTilt))
					this.rotationX -= 1;
			}

			if(DOWN)
			{
				if(this.y > 0)
					this.target.y -= speed;

				if(this.rotationX < maxTilt)
					this.rotationX += 1;
			}

			// right the ship if we're not pressing anything
			if(!LEFT && !RIGHT)
			{
			   	if(this.rotationZ > 0)
				   this.rotationZ--;

				if(this.rotationZ < 0)
					this.rotationZ++;
			}

			if(!UP && !DOWN)
			{
				if(this.rotationX > 0)
					this.rotationX--;

				if(this.rotationX < 0)
					this.rotationX++;
			}

			diffX = this.target.x - this.x
			diffX *= damping;
			this.x += diffX;

			diffY = this.target.y - this.y
			diffY *= damping;
			this.y += diffY;
		}
	}
}
