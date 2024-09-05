import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'bird.dart';
import 'pipe.dart';

enum GameState { initial, playing, gameOver }

enum Difficulty { easy, medium, hard }

class FlappyGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  GameState gameState = GameState.initial;
  Difficulty difficulty = Difficulty.medium;
  int _score = 0;
  Timer pipeTimer = Timer(4, repeat: true); // 增加管道生成间隔

  int get score => _score;
  set score(int value) {
    _score = value;
    if (gameState == GameState.playing) {
      overlays.remove('score');
      overlays.add('score');
    }
  }

  void setDifficulty(Difficulty difficulty) {
    this.difficulty = difficulty;
    switch (difficulty) {
      case Difficulty.easy:
        pipeTimer = Timer(4, repeat: true);
        break;
      case Difficulty.medium:
        pipeTimer = Timer(3, repeat: true);
        break;
      case Difficulty.hard:
        pipeTimer = Timer(2, repeat: true);
        break;
    }
    pipeTimer.onTick = _spawnPipe;
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
  }

  void gameOver() {
    gameState = GameState.gameOver;
    overlays.remove('score');
    overlays.add('gameOver');
  }

  void resetGame() {
    children.whereType<PipePair>().forEach((pipe) => pipe.removeFromParent());
    startGame();
  }

  void _spawnPipe() {
    add(PipePair(difficulty: difficulty));
  }

  void _checkCollisions() {
    if (gameState != GameState.playing) return;

    if (bird.position.y > size.y - bird.size.y / 2) {
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

        if (birdRect.overlaps(adjustedPipeRect)) {
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
      }
    }
  }
}
