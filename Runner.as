package com.recycle
{
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import com.recycle.Game;

import flash.geom.Rectangle;

import starling.core.Starling;
import flash.events.Event;

[SWF(backgroundColor="#FFFFFF", frameRate="60")]
public class Runner extends Sprite
{
    private var mStarling:Starling;

    public function Runner()
    {
      super();

      Starling.handleLostContext = true;

      // These settings are recommended to avoid problems with touch handling
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;

      Starling.multitouchEnabled = true;

      var viewPortRectangle:Rectangle = new Rectangle();
      viewPortRectangle.width = 1280;
      viewPortRectangle.height = 720;

      // Create a Starling instance that will run the "Game" class
      mStarling = new Starling(Game, stage, viewPortRectangle);

      stage.addEventListener(Event.RESIZE, resizeStage);

      mStarling.simulateMultitouch = true;

      // show the stats window (draw calls, memory)
      mStarling.showStats = true;
      // set anti-aliasing (higher the better quality but slower performance)
      mStarling.antiAliasing = 1;

      mStarling.start();
    }
    protected function resizeStage(event:Event):void
    {
      var viewPortRectangle:Rectangle = new Rectangle();
      viewPortRectangle.width = stage.stageWidth;
      viewPortRectangle.height = stage.stageHeight;
      Starling.current.viewPort = viewPortRectangle;

    }
}
}