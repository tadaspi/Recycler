/**
 * Created with IntelliJ IDEA.
 * User: Tado
 * Date: 13.2.20
 * Time: 13.40
 * To change this template use File | Settings | File Templates.
 */
package com.recycle.models {

public class TrashModel {
  static public const KIND_GLASS:uint = 0;
  static public const KIND_PAPER:uint = 1;
  static public const KIND_PLASTIC:uint = 2;

  private var kind:uint;

  public function TrashModel(kind:uint) {
    this.kind = kind;
  }

  public function get isGlass():Boolean {
    return kind == KIND_GLASS;
  }

  public function get isPaper():Boolean {
    return kind == KIND_PAPER;
  }

  public function get isPlastic():Boolean {
    return kind == KIND_PLASTIC;
  }
}
}