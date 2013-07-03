/**
 * Created with IntelliJ IDEA.
 * User: Tado
 * Date: 13.2.18
 * Time: 19.19
 * To change this template use File | Settings | File Templates.
 */
package com.recycle {

import com.greensock.TweenMax;
import com.greensock.data.TweenMaxVars;
import com.greensock.easing.Linear;
import com.recycle.controllers.InputController;
import com.recycle.models.BinModel;
import com.recycle.models.TrashModel;
import com.recycle.utils.RandomUtils;
import com.recycle.views.BinView;
import com.recycle.views.TrashView;

import flash.geom.Point;

import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.text.TextField;
import starling.textures.Texture;

public class Game extends Sprite {
  [Embed (source = "/com/recycle/assets/play.png")]
  private static const PlayImg: Class;
  private var playTexture: Texture = Texture.fromBitmap(new PlayImg);

  [Embed (source = "/com/recycle/assets/again.png")]
  private static const AgainImg: Class;
  private var againTexture: Texture = Texture.fromBitmap(new AgainImg);

  [Embed (source = "/com/recycle/assets/back.jpg")]
  private static const BgImage: Class;

  private var score: TextField;
  private var lives: TextField;
  private var playButton: Button = new Button(playTexture, " ");
  private var liveCounter: int = 3;
  private var scoreCounter: int = 0;
  private var gameOver: TextField;
  private var playAgain: Button;
  private const binGlass: BinView = new BinView(createGlassBin());
  private const binPaper: BinView = new BinView(createPaperBin());
  private const binPlastic: BinView = new BinView(createPlasticBin());
  private var input: InputController;

  public function Game() {
    super();
    input = new InputController(this);
    var texture: Texture = Texture.fromBitmap(new BgImage);
    var image: Image = new Image(texture);
    addChild(image);
    addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
  }

  private function onAddedToStage(event: Event): void {
    this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    playButton.x = 640 - playButton.width / 2;
    playButton.y = 360 - playButton.height / 2;
    addChild(playButton);

    function handler(event: Event): void {
      playButton.removeEventListener(Event.TRIGGERED, handler);
      removeChild(playButton);
      doTheGame();
    }

    playButton.addEventListener(Event.TRIGGERED, handler);
  }

  private function doTheGame(): void {
    binGlass.x = 250; binGlass.y = 500; addChild(binGlass);
    binPaper.x = 450; binPaper.y = 500; addChild(binPaper);
    binPlastic.x = 650; binPlastic.y = 500; addChild(binPlastic);

    placeScore();
    placeLives();
    addEventListener(Event.ENTER_FRAME, toDo);
  }

  private function toDo(event: Event): void {
    if (liveCounter > 0) {
      if (Math.random() > 0.992) trashMaker();
    } else {
      gameOverFun();
    }
    score.text = "SCORE: " + scoreCounter;
    lives.text = "LIVES: " + liveCounter;
  }

  private function gameOverFun(): void {
    gameOver = new TextField(400, 100, "GAME OVER!!!", "Arial", 50);
    gameOver.x = 640 - gameOver.width / 2;
    gameOver.y = 360 - gameOver.height / 2;
    this.removeEventListener(Event.ENTER_FRAME, toDo);
    this.removeChild(binGlass);
    this.removeChild(binPaper);
    this.removeChild(binPlastic);
    this.removeChild(lives);
    this.addChild(gameOver);
    playAgainFun();
  }

  private function playAgainFun(): void {
    playAgain = new Button(againTexture, " ");
    playAgain.x = 640 - playAgain.width / 2;
    playAgain.y = 240 - playAgain.height / 2;
    this.addChild(playAgain);
    playAgain.addEventListener(Event.TRIGGERED, onAgain);
  }

  private function onAgain(event: Event): void {
    removeEventListener(Event.TRIGGERED, onAgain);
    removeChild(gameOver);
    removeChild(playAgain);
    removeChild(score);
    liveCounter = 3;
    scoreCounter = 0;
    doTheGame();
  }

  private function placeLives(): void {
    lives = new TextField(200, 50, "LIVES: 3", "Arial", 30);
    lives.x = 800;
    lives.y = 50;
    this.addChild(lives);
  }

  private function placeScore(): void {
    score = new TextField(200, 50, "SCORE: 0", "Arial", 30);
    score.x = 50;
    score.y = 50;
    this.addChild(score);
  }

  private function createGlassBin(): BinModel {
    return new BinModel(BinModel.KIND_GLASS);
  }
  private function createPaperBin(): BinModel {
    return new BinModel(BinModel.KIND_PAPER);
  }
  private function createPlasticBin(): BinModel {
    return new BinModel(BinModel.KIND_PLASTIC);
  }

  private var trashConstructors: Array = [
    function (): TrashModel {
      return new TrashModel(TrashModel.KIND_GLASS);
    },
    function (): TrashModel {
      return new TrashModel(TrashModel.KIND_PAPER);
    },
    function (): TrashModel {
      return new TrashModel(TrashModel.KIND_PLASTIC);
    }
  ];

  private function createTrash(): TrashModel {
    return trashConstructors[
      RandomUtils.between(-1, trashConstructors.length - 2)
    ]();
  }

  private function trashMaker(): void {
    var trash: TrashView = new TrashView(createTrash());
    trash.x = 10;
    trash.y = 50;
    trash.pivotX = trash.width / 2;
    trash.pivotY = trash.height / 2;
    var tweenMaxVars: TweenMaxVars = new TweenMaxVars();
    tweenMaxVars.bezierThrough([
      {x: RandomUtils.between(600, 1000), y: RandomUtils.between(100, 300)},
      {x: 1200, y: 600}
    ]);
    tweenMaxVars.ease(Linear.easeNone);
    tweenMaxVars.onComplete(minusLive, [trash]);
    trash.tweenCurve =
      TweenMax.to(trash, RandomUtils.between(5, 8), tweenMaxVars);
    trash.tweenSpin = TweenMax.to(trash, RandomUtils.between(5, 8), {
      rotation: RandomUtils.between(-25, 25)
    });
    trash.addEventListener(TouchEvent.TOUCH, input.onTouch);
    addChild(trash);
  }

  private function minusLive(currentTrash: TrashView): void {
    liveCounter--;
    removeChild(currentTrash);
  }

  private function destroyTrash(trash: TrashView): void {
    if (trash.tweenCurve != null) trash.tweenCurve.kill();
    if (trash.tweenSpin != null) trash.tweenSpin.kill();
    trash.removeEventListener(TouchEvent.TOUCH, input.onTouch);
    removeChild(trash);
  }

  private function moveToBin(
    trash: TrashView, bin: BinView, scored: Boolean
  ): void {
    trash.tweenCurve.kill();
    TweenMax.to(trash, 0.5, {
      x: bin.x + bin.width / 2,
      y: bin.y,
      onComplete: function() {
        if (scored) scoreCounter++;
        else liveCounter--;

        destroyTrash(trash);
      }
    });
    TweenMax.to(trash, RandomUtils.between(5, 8), {
      rotation: RandomUtils.between(-5, 5)
    });
  }

  public function throwAtBin(currentTrash: TrashView, touchOFF: Touch): void {
    var localPos: Point = touchOFF.getLocation(this);
    //check the closest bin
    var closestBin:BinView = getClosestBin(currentTrash, localPos);
    if (closestBin != null) {
      if (closestBin.model.isGlass) {
        moveToBin(currentTrash, binGlass, currentTrash.model.isGlass);
      } else if (closestBin.model.isPaper) {
        moveToBin(currentTrash, binPaper, currentTrash.model.isPaper);
      } else if (closestBin.model.isPlastic) {
        moveToBin(currentTrash, binPlastic, currentTrash.model.isPlastic);
      }
      else throw new Error("Should not be able to get here!");
    }
    else {
      currentTrash.tweenCurve.kill();
      TweenMax.to(currentTrash, 0.5,
        {x: localPos.x, y: localPos.y, onComplete:
          destroyTrash, onCompleteParams: [currentTrash]
        });
      TweenMax.to(currentTrash, RandomUtils.between(5, 8), {
        rotation: RandomUtils.between(-5, 5)
      });
    }
  }

  private function getClosestBin(trash: TrashView, localPos: Point): BinView {
    var cosPhiGlass: int = binGlass.getThrowAwayAngle(trash, localPos);
    var cosPhiPaper: int = binPaper.getThrowAwayAngle(trash, localPos);
    var cosPhiPlastic: int = binPlastic.getThrowAwayAngle(trash, localPos);

    if (cosPhiGlass != -1 || cosPhiPaper != -1 || cosPhiPlastic != -1) {
      if (cosPhiGlass < cosPhiPaper && cosPhiGlass < cosPhiPlastic) {
        return cosPhiGlass > 30 ? null : binGlass;
      }
      else if (cosPhiPaper<cosPhiGlass && cosPhiPaper<cosPhiPlastic) {
        return binPaper;
      }
      else if (cosPhiPlastic<cosPhiGlass && cosPhiPlastic<cosPhiPaper) {
        return cosPhiPlastic > 30 ? null : binPlastic;
      }
    }

    return null;
  }

  public function startScaling(trash: TrashView): void {
    trash.tweenCurve.pause();
    TweenMax.to(trash, 1.5, {
      scaleX: 1.5, scaleY: 1.5,
      onComplete: destroyTrash, onCompleteParams: [trash]
    });
  }
}
}