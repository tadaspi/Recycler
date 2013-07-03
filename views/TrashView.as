package com.recycle.views {

import com.greensock.TweenMax;
import com.recycle.models.TrashModel;

import flash.geom.Rectangle;

import starling.display.Image;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class TrashView extends Image {
  [Embed(source="/com/recycle/assets/atlas_v1.xml", mimeType="application/octet-stream")]
  public static const AtlasXml:Class;

  [Embed(source="/com/recycle/assets/atlas_v1.png")]
  public static const AtlasTexture:Class;

  // create atlas
  private static var atlasTexture:Texture = Texture.fromBitmap(new AtlasTexture());
  private static var xml:XML = XML(new AtlasXml());
  private static var atlas:TextureAtlas = new TextureAtlas(atlasTexture, xml);

  //frame for a bigger bounds
  public static var frameOfGlass:Rectangle = new Rectangle(
    -atlas.getTexture("glass").width * 0.5,
    -atlas.getTexture("glass").height * 0.5,
    atlas.getTexture("glass").width * 2,
    atlas.getTexture("glass").height * 2);
  public static var frameOfPaper:Rectangle = new Rectangle(
    -atlas.getTexture("paper").width * 0.5,
    -atlas.getTexture("paper").height * 0.5,
    atlas.getTexture("paper").width * 2,
    atlas.getTexture("paper").height * 2);
  public static var frameOfPlastic:Rectangle = new Rectangle(
    -atlas.getTexture("plastic").width * 0.5,
    -atlas.getTexture("plastic").height * 0.5,
    atlas.getTexture("plastic").width * 2,
    atlas.getTexture("plastic").height * 2);

  // display a sub-texture
  public static var glassTexture:Texture = Texture.fromTexture(
    atlas.getTexture("glass"), null,  frameOfGlass);
  public static var paperTexture:Texture = Texture.fromTexture(
    atlas.getTexture("paper"), null,  frameOfPaper);
  public static var plasticTexture:Texture = Texture.fromTexture(
    atlas.getTexture("plastic"), null,  frameOfPlastic);

  trace(glassTexture);
  trace(paperTexture);
  trace(plasticTexture);

  private var _model: TrashModel;

  private var _tweenCurve: TweenMax;
  private var _tweenSpin: TweenMax;


  public function TrashView(model:TrashModel) {
    super(determineTexture(model));
    this._model = model;
  }

  private static function determineTexture(model:TrashModel):Texture {
    if (model.isGlass) return glassTexture;
    else if (model.isPaper) return paperTexture;
    else if (model.isPlastic) return plasticTexture;
    else throw new Error("What the hell is trash?");
  }

  public function get tweenCurve():TweenMax {
    return _tweenCurve;
  }

  public function set tweenCurve(value:TweenMax):void {
    _tweenCurve = value;
  }

  public function get tweenSpin():TweenMax {
    return _tweenSpin;
  }

  public function set tweenSpin(value:TweenMax):void {
    _tweenSpin = value;
  }

  public function get model():TrashModel {
    return _model;
  }
}
}