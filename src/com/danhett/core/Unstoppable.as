package com.danhett.core
{
	import away3d.debug.AwayStats;
	import away3d.primitives.WireframePlane;

	import com.com.danhett.entities.Bullet;

	import com.com.danhett.entities.EnemyFighter;
	import com.com.danhett.entities.Explosion;

	import com.com.danhett.entities.Ship;

	import com.greensock.TweenMax;
	import com.greensock.easing.*;

	import flash.display.Sprite;
	import flash.events.Event;
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;

	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;

	[SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
	public class Unstoppable extends Sprite
	{
		private const DEBUG_MODE:Boolean = true;

		private var gameStarted:Boolean = false;

		private const FLOOR_COLOUR:uint = 0x999999;
		private const WALLS_COLOUR:uint = 0x00FF00;

		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var holder:ObjectContainer3D= new ObjectContainer3D();
		private var enemies:ObjectContainer3D = new ObjectContainer3D();
		private var bullets:ObjectContainer3D = new ObjectContainer3D();
		private var bangs:ObjectContainer3D = new ObjectContainer3D();
		private var block:WireframePlane;
		private var strip:ObjectContainer3D;
		private var ship:Ship
		private var stripCount:int = 30;
		private var speed:int = 25;
		private var i:int;
		private var j:int;
		private var intro:IntroScreen;
		private var enemy:EnemyFighter;
		private var enemyCount:int = 50;

		private var bullet:Bullet;
		private var maxBullets:int = 5;
		private var bulletsInFlight:int = 0;
		private var bulletRange:int = 3000;
		private var bulletSpeed:int = 25;

		private var point1:Vector3D;
		private var point2:Vector3D;
		private var hitRange:int = 200;
		private var isHit:Boolean;
		private var dist:Number;

	    public function Unstoppable()
	    {
		    self_reference = this;

			init();
	    }

		private function init():void
		{
			create3DStuff();

			createScenery();

			addPlayer();

			if(DEBUG_MODE)
				addChild(new AwayStats(view));

			this.addEventListener(Event.ENTER_FRAME, tick);
		}

		private function create3DStuff():void
		{
			this.scene = new Scene3D();
			this.camera = new Camera3D();
			this.view = new View3D();

			camera.z = -50;
			camera.y = 150;
			camera.lens.far = 5000;

			view.backgroundColor = 0x000000;
			view.antiAlias = 4;

			view.scene = this.scene;
			view.camera = this.camera;

			this.addChild(view);

			view.scene.addChild(holder);
			view.scene.addChild(enemies);
			view.scene.addChild(bullets);
			view.scene.addChild(bangs);
		}


		private function createScenery():void
		{
			for(var i:int = 0; i < stripCount; i++)
			{
				// create holder for everything on the row
				strip = new ObjectContainer3D();
				strip.z = 200 * i;

				// create floor
				block = new WireframePlane(200, 1200, 1, 1, FLOOR_COLOUR, 1);
				block.rotationZ = 90;
				strip.addChild(block)

				// left wall
				block = new WireframePlane(200, 200, 1, 1, WALLS_COLOUR, 1);
				block.height = randRange(150, 600);
				block.x = -600;
				block.y = block.height * 0.5;
				strip.addChild(block);

				// right wall
				block = new WireframePlane(200, 200, 1, 1, WALLS_COLOUR, 1);
				block.height = randRange(150, 600);
				block.x = 600;
				block.y = 100;
				block.y = block.height * 0.5;
				strip.addChild(block);

				strip.scaleX = 0;
				strip.scaleY = 0;
				strip.scaleZ = 0;
				strip.y = -500;

				holder.addChild(strip);
			}

			createIntro();
		}

		private function addPlayer():void
		{
			ship = new Ship();
			ship.z = 350;
			view.scene.addChild(ship);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		}

		private function createIntro():void
		{
			intro = new IntroScreen();
			addChild(intro);
		}

		public function doIntoAnimation():void
		{
			for(var i:int = 0; i < stripCount; i++)
			{
				strip = holder.getChildAt(i);
				TweenMax.to(strip, 2, {scaleX:1, scaleY:1, scaleZ:1, y:0, ease:Expo.easeOut, delay:0.5 + (i/10)})
			}

			TweenMax.delayedCall(3, ship.descendShip);
		}


		public function startGame():void
		{
			stage.focus = stage;
			removeChild(intro);
			gameStarted = true;

			spawnEnemies();
		}

		private function spawnEnemies():void
		{
			for(i = 0; i < enemyCount; i++)
			{
				var enemy:EnemyFighter = new EnemyFighter();
				enemy.z = 5000 + ( randRange(200, 1500) * i );
				enemy.x = randRange(-500, 500);
				enemy.y = randRange(50, 400);
				enemy.name = "enemy"+i;
				enemies.addChild(enemy);
			}
		}

		private var bulletCount:int = 0;
		private function shoot():void
		{
			if(gameStarted)
			{
				if(bulletsInFlight < maxBullets)
				{
					bulletCount++;

					bulletsInFlight++;
					var bullet:Bullet = new Bullet();
					bullet.x = ship.x;
					bullet.y = ship.y;
					bullet.z = ship.z;
					bullet.name = "bullet"+bulletCount;
					bullets.addChild(bullet);
				}
			}
		}

		private function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:       ship.UP = true;     break;
				case Keyboard.DOWN:     ship.DOWN = true;   break;
				case Keyboard.LEFT:     ship.LEFT = true;   break;
				case Keyboard.RIGHT:    ship.RIGHT = true;  break;

				case Keyboard.SPACE:    shoot();            break;
			}
		}

		private function onKeyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:       ship.UP = false;    break;
				case Keyboard.DOWN:     ship.DOWN = false;  break;
				case Keyboard.LEFT:     ship.LEFT = false;  break;
				case Keyboard.RIGHT:    ship.RIGHT = false; break;
			}
		}

		private function tick(e:Event):void
		{
			if(gameStarted)
			{
				scrollWorld();
				scrollEnemies();
				scrollBullets();
				checkCollisions();
				scrollBangs();
				ship.update();
			}

			this.view.render();
		}

		private function scrollWorld():void
		{
			for(i = 0; i < stripCount; i++)
			{
				holder.getChildAt(i).z -= speed;

				if(holder.getChildAt(i).z < 0)
					holder.getChildAt(i).z = 200 * stripCount;
			}
		}

		private function scrollEnemies():void
		{
			var _enemy:EnemyFighter;

			for(i = 0; i < enemies.numChildren; i++)
			{
				_enemy = EnemyFighter(enemies.getChildAt(i));
				_enemy.update();
				_enemy.z -= speed;

				if(_enemy.z < 0)
				{
					_enemy.z = 5000 + ( randRange(200, 1500) * i );
					_enemy.x = randRange(-500, 500);
					_enemy.y = randRange(50, 400);
				}
			}
		}

		private function scrollBullets():void
		{
			for(i = 0; i < bullets.numChildren; i++)
			{
				bullet = Bullet(bullets.getChildAt(i));

				bullet.z += bulletSpeed;

				if(bullet.z > bulletRange)
				{
					bullets.removeChild(bullet);
					bulletsInFlight--;
				}
			}
		}

		private function scrollBangs():void
		{
			for(i = 0; i < bangs.numChildren; i++)
			{
				bangs.getChildAt(i).z -= speed;
			}
		}

		private function checkCollisions():void
		{
			for(i = 0; i < bullets.numChildren; i++)
			{
				bullet = bullets.getChildAt(i) as Bullet;

				for(j = 0; j < enemies.numChildren; j++)
				{
					enemy = enemies.getChildAt(j) as EnemyFighter;

					if(checkHit(bullet, enemy))
					{
						enemy.z = 5000 + ( randRange(200, 1500) * i );
						enemy.x = randRange(-500, 500);
						enemy.y = randRange(50, 400);

						createExplosion(new Vector3D(bullet.x, bullet.y, bullet.z));
					}
				}
			}
		}

		private function createExplosion(loc:Vector3D):void
		{
			var explosion:Explosion = new Explosion();
			explosion.x = loc.x;
			explosion.y = loc.y;
			explosion.z = loc.z;

			bangs.addChild(explosion);
		}

		public function removeExplosion(exp:Explosion):void
		{
			bangs.removeChild(exp);
		}

		private function checkHit(theBullet:Bullet, theEnemy:EnemyFighter):Boolean
		{
			isHit = false;

			point1 = new Vector3D(theBullet.x, theBullet.y, theBullet.z)
			point2 = new Vector3D(theEnemy.x, theEnemy.y, theEnemy.z)

			dist = Vector3D.distance(point1,  point2);

			if(dist < hitRange && theEnemy.z < 5000) // don't shoot enemies off-screen
				isHit = true;

			return isHit;
		}


		// MATH
		private function randRange($min:Number, $max:Number):Number
		{
			return (Math.floor(Math.random() * ($max - $min + 1)) + $min);
		}

		// DIRTY SINGLETON
		private static var self_reference:Unstoppable;
		public static function get Instance():Unstoppable { return self_reference; }
		public static function set Instance(value:Unstoppable) { self_reference = value; }
	}
}
