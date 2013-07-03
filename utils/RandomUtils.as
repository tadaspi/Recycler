package com.recycle.utils {
public class RandomUtils {
  public static function between(from: int, to: int): int {
    var randNum: int = Math.round(Math.random() * (to - from) + from + 1);
    return randNum;
  }
}
}
