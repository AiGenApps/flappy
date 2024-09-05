import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Pipe extends PositionComponent with HasGameRef {
  static const double pipeWidth = 50; // 减小管道宽度
  final double height;
  final bool isBottom;
  late Paint _paint;
  bool isCollided = false;

  Pipe({required this.height, required this.isBottom})
      : super(size: Vector2(pipeWidth, height)) {
    _paint = Paint()..color = Colors.green;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox()); // 添加碰撞箱
  }

  @override
  void render(Canvas canvas) {
    _paint.color = isCollided ? Colors.red : Colors.green;
    canvas.drawRect(size.toRect(), _paint);
    // 移除碰撞箱的绘制
  }

  void markAsCollided() {
    isCollided = true;
  }
}

class PipePair extends PositionComponent with HasGameRef {
  static const double initialGap = 250;
  static const double minGap = 120;
  static const double speed = 60;
  static const double gapDecreaseRate = 0.3;
  static const double minPipeHeight = 50; // 最小管道高度
  static const double maxVerticalOffset = 150; // 最大垂直偏移
  bool scored = false;
  double currentGap;

  PipePair()
      : currentGap = initialGap,
        super(size: Vector2(Pipe.pipeWidth, 0));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position.x = gameRef.size.x;
    _createPipes();
  }

  void _createPipes() {
    final random = Random();
    final availableHeight = gameRef.size.y - currentGap - 2 * minPipeHeight;
    final topPipeHeight =
        minPipeHeight + random.nextDouble() * (availableHeight - minPipeHeight);
    final bottomPipeHeight = gameRef.size.y - topPipeHeight - currentGap;

    // 限制垂直偏移范围
    final maxOffset = min(maxVerticalOffset, availableHeight / 4);
    final offset = random.nextDouble() * (2 * maxOffset) - maxOffset;

    add(Pipe(height: topPipeHeight, isBottom: false)..y = offset);
    add(Pipe(height: bottomPipeHeight, isBottom: true)
      ..y = topPipeHeight + currentGap + offset);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;

    // 减小间隙
    currentGap = max(currentGap - gapDecreaseRate * dt, minGap);

    if (position.x < -Pipe.pipeWidth) {
      removeFromParent();
    }
  }
}
