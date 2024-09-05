import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Bird extends SpriteComponent with HasGameRef, CollisionCallbacks {
  static const double gravity = 500;
  static const double jumpSpeed = -350;
  double velocity = 0;

  Bird() : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bird.png');
    position = Vector2(50, gameRef.size.y / 2);
    anchor = Anchor.center;

    // 使用更小的碰撞箱
    final hitboxSize = size * 0.7;
    final hitboxOffset = (size - hitboxSize) / 2;
    add(RectangleHitbox(
      size: hitboxSize,
      position: hitboxOffset,
    ));
    print(
        'Bird loaded: position=$position, size=$size, hitboxSize=$hitboxSize');
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity += gravity * dt;
    position.y += velocity * dt;
    angle = velocity * 0.0015;
  }

  void jump() {
    velocity = jumpSpeed;
    print('Bird jumped: velocity=$velocity');
  }

  void reset() {
    position = Vector2(50, gameRef.size.y / 2);
    velocity = 0;
    angle = 0;
    print('Bird reset: position=$position');
  }

  // 移除 render 方法，不再绘制碰撞箱
}
