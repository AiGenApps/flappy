import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'bird.dart';
import 'pipe.dart';

enum GameState { initial, playing, gameOver }

class FlappyGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  GameState gameState = GameState.initial;
  int _score = 0;
  Timer pipeTimer = Timer(2, repeat: true); // 将间隔从 3 秒减少到 2 秒

  int get score => _score;
  set score(int value) {
    _score = value;
    if (gameState == GameState.playing) {
      overlays.remove('score');
      overlays.add('score');
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final parallax = await loadParallaxComponent(
      [ParallaxImageData('background.png')],
      baseVelocity: Vector2(50, 0),
      velocityMultiplierDelta: Vector2(1.1, 1.0),
    );
    add(parallax);

    bird = Bird();
    add(bird);

    pipeTimer.onTick = _spawnPipe;

    // 立即生成第一个管道
    _spawnPipe();

    print('Game loaded successfully');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameState == GameState.playing) {
      pipeTimer.update(dt);
      _checkCollisions();
      _updateScore();
    }
  }

  @override
  void onTap() {
    if (gameState == GameState.playing) {
      bird.jump();
      print('Bird jumped');
    }
  }

  void startGame() {
    gameState = GameState.playing;
    bird.reset();
    score = 0;
    children.whereType<PipePair>().forEach((pipe) => pipe.removeFromParent());
    overlays.add('score');
    pipeTimer.reset();
    // 立即生成第一个管道
    _spawnPipe();
    print('Game started');
  }

  void gameOver() {
    gameState = GameState.gameOver;
    overlays.remove('score');
    overlays.add('gameOver');
    print('Game over');
  }

  void resetGame() {
    children.whereType<PipePair>().forEach((pipe) => pipe.removeFromParent());
    startGame();
    print('Game reset');
  }

  void _spawnPipe() {
    add(PipePair());
    print('Pipe spawned');
  }

  void _checkCollisions() {
    if (gameState != GameState.playing) return;

    if (bird.position.y > size.y - bird.size.y / 2) {
      print('Bird hit the ground');
      gameOver();
      return;
    }

    final birdRect = bird.toRect();
    for (final pipePair in children.whereType<PipePair>()) {
      for (final pipe in pipePair.children.whereType<Pipe>()) {
        final adjustedPipeRect = Rect.fromLTWH(
            pipePair.position.x + pipe.position.x,
            pipe.position.y,
            pipe.size.x,
            pipe.size.y);

        print('Bird rect: $birdRect');
        print('Pipe rect: $adjustedPipeRect');

        if (birdRect.overlaps(adjustedPipeRect)) {
          print('Bird collided with pipe');
          pipe.markAsCollided();
          gameOver();
          return;
        }
      }
    }
  }

  void _updateScore() {
    for (final pipe in children.whereType<PipePair>()) {
      if (!pipe.scored && pipe.position.x + Pipe.pipeWidth < bird.position.x) {
        score++;
        pipe.scored = true;
        print('Score updated: $score');
      }
    }
  }
}
