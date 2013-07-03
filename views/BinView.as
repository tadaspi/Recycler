/**
 * Created with IntelliJ IDEA.
 * User: Tado
 * Date: 13.2.25
 * Time: 12.50
 * To change this template use File | Settings | File Templates.
 */
package com.recycle.views {
import com.recycle.models.BinModel;

import flash.geom.Point;

import starling.display.Image;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class BinView extends Image {
  [Embed(source="/com/recycle/assets/atlas_v1.xml", mimeType="application/octet-stream")]
  public static const AtlasXml:Class;

  [Embed(source="/com/recycle/assets/atlas_v1.png")]
  public static const AtlasTexture:Class;

  // create atlas
  private static var atlasTexture:Texture = Texture.fromBitmap(new AtlasTexture());
  private static var xml:XML = XML(new AtlasXml());
  private static var atlas:TextureAtlas = new TextureAtlas(atlasTexture, xml);

  // display a sub-texture
  public static var glassTexture:Texture = atlas.getTexture("glassBin");
  public static var paperTexture:Texture = atlas.getTexture("paperBin");
  public static var plasticTexture:Texture = atlas.getTexture("plasticBin");

  private var _model: BinModel;

  public function BinView(model:BinModel) {
    super(determineTexture(model));
    this._model = model;
  }

  public function get model():BinModel {
    return _model;
  }

  private static function determineTexture(model:BinModel):Texture {
    if (model.isGlass) return glassTexture;
    else if (model.isPaper) return paperTexture;
    else if (model.isPlastic) return plasticTexture;
    else throw new Error("What the hell is bin?");
  }

  /**
   * Gets an angle between two vectors, which are defined as vector1 and vector2.
   *
   * @param trash
   * @param locPos
   * @return
   */
  public function getThrowAwayAngle(trash: TrashView, locPos: Point): int {
    var vector1:Object = {x: locPos.x - trash.x, y:  locPos.y - trash.y};
    var vector2:Object = {x: (x + width / 2) - trash.x, y: y - trash.y};
    var dotProduct:Number = vector1.x * vector2.x + vector1.y * vector2.y;
    var A: Point = new Point(trash.x, trash.y);
    var D: Point = new Point(x + width / 2,  y);
    var magAB:Number = Point.distance(A, locPos);
    var magCD:Number = Point.distance(A, D);
    if (magAB > 100) {
      var tempNumb:Number = dotProduct / (magAB * magCD);
      if (tempNumb>1) tempNumb = 2 - tempNumb;
      var angle:Number = Math.acos(tempNumb);
      return Math.round(angle*180/Math.PI*100)/100;
    } else {
      return -1;
    }
  }
}
}