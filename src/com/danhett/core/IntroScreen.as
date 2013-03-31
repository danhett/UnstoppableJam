/**
 * @package com.danhett.core
 * @author  Dan Hett <hellodanhett@gmail.com>
 * @date    30/03/2013
 */
package com.danhett.core
{
	import com.greensock.easing.Expo;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import com.greensock.TweenMax;

	public class IntroScreen extends Sprite
	{
		private var line:GreenLine;
		private var title:TitleText;
		private var coin:InsertCoin;

		public function IntroScreen()
		{
			init()
		}

		private function init():void
		{
			line = new GreenLine();
			line.x = 400;
			line.y = -300;
			TweenMax.to(line,  2, {y:300})
			addChild(line);

			title = new TitleText();
			title.x = 400;
			title.y = -200;
			TweenMax.to(title,  1, {y:200, ease:Expo.easeOut,  delay:2})
			addChild(title);

			coin = new InsertCoin();
			coin.x = 400;
			coin.y = 650;
			TweenMax.to(coin,  1, {y:300, ease:Expo.easeOut,  delay:2.2})
			addChild(coin)

			coin.buttonMode = true;
			coin.addEventListener(MouseEvent.CLICK, initGame);
		}

		private function initGame(e:MouseEvent):void
		{
			TweenMax.to(title, 0.5, {y:-100, ease:Expo.easeIn});
			TweenMax.to(coin, 0.5, {y:700, ease:Expo.easeIn});
			TweenMax.to(line, 0.5, {alpha:0})

			Unstoppable.Instance.doIntoAnimation();
		}
	}
}
