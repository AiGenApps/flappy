import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 导入本地化包
import 'package:flame/game.dart'; // 导入 Flame 包
import 'flappy_game.dart';
import 'language_controller.dart';
import 'translations.dart'; // 导入翻译文件

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.put(LanguageController());

    return Obx(() {
      return GetMaterialApp(
        locale: languageController.locale.value,
        translations: AppTranslations(), // 设置翻译
        supportedLocales: const [
          Locale('en'),
          Locale('zh'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: const Color(0xFFE0E5EC),
        ),
        home: Scaffold(
          body: GameWidget<FlappyGame>.controlled(
            gameFactory: FlappyGame.new,
            overlayBuilderMap: {
              'initial': (_, game) => InitialOverlay(game: game),
              'gameOver': (_, game) => GameOverOverlay(game: game),
              'score': (_, game) => ScoreOverlay(game: game),
            },
            initialActiveOverlays: const ['initial'],
          ),
        ),
      );
    });
  }
}

class NeumorphicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const NeumorphicButton(
      {super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(4, 4),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            offset: const Offset(-4, -4),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: child,
          ),
        ),
      ),
    );
  }
}

class InitialOverlay extends StatelessWidget {
  final FlappyGame game;

  const InitialOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.find();

    return Stack(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'flappy_bird'.tr,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                NeumorphicButton(
                  onPressed: () {
                    game.setDifficulty(Difficulty.easy);
                    game.startGame();
                    game.overlays.remove('initial');
                  },
                  child: Text(
                    'easy'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                NeumorphicButton(
                  onPressed: () {
                    game.setDifficulty(Difficulty.medium);
                    game.startGame();
                    game.overlays.remove('initial');
                  },
                  child: Text(
                    'medium'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                NeumorphicButton(
                  onPressed: () {
                    game.setDifficulty(Difficulty.hard);
                    game.startGame();
                    game.overlays.remove('initial');
                  },
                  child: Text(
                    'hard'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: () {
              languageController.toggleLanguage();
            },
          ),
        ),
      ],
    );
  }
}

class GameOverOverlay extends StatelessWidget {
  final FlappyGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'game_over'.tr,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${'score'.tr}: ${game.score}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${'difficulty'.tr}: ${_getDifficultyLabel(game.difficulty)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            NeumorphicButton(
              onPressed: () {
                game.resetGame();
                game.overlays.remove('gameOver');
              },
              child: Text(
                'restart'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            NeumorphicButton(
              onPressed: () {
                game.overlays.remove('gameOver');
                game.overlays.add('initial');
              },
              child: Text(
                'back_to_difficulty_selection'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyLabel(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'easy'.tr;
      case Difficulty.medium:
        return 'medium'.tr;
      case Difficulty.hard:
        return 'hard'.tr;
      default:
        return '';
    }
  }
}

class ScoreOverlay extends StatelessWidget {
  final FlappyGame game;

  const ScoreOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(0.3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(4, 4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              offset: const Offset(-4, -4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          '${'score'.tr}: ${game.score}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
