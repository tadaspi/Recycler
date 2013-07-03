/**
 * Created with IntelliJ IDEA.
 * User: TP
 * Date: 13.3.19
 * Time: 14.38
 * To change this template use File | Settings | File Templates.
 */
package com.recycle.controllers {
import com.recycle.Game;
import com.recycle.views.TrashView;

import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class InputController {
  private var game: Game;

  public function InputController(game: Game) {
    this.game = game;
  }

  public function onTouch(event: TouchEvent) {
    var currentTrash: TrashView = TrashView(event.currentTarget);
    var touchON: Touch = event.getTouch(currentTrash, TouchPhase.BEGAN);
    var touchOFF: Touch = event.getTouch(currentTrash, TouchPhase.ENDED);

    if (touchON) game.startScaling(currentTrash);
    if (touchOFF) game.throwAtBin(currentTrash, touchOFF);
  }
}
}
