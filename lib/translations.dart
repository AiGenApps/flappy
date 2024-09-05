import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'flappy_bird': 'Flappy Bird',
          'easy': 'Easy',
          'medium': 'Medium',
          'hard': 'Hard',
          'game_over': 'Game Over',
          'score': 'Score',
          'difficulty': 'Difficulty',
          'restart': 'Restart',
          'back_to_difficulty_selection': 'Back to Difficulty Selection',
        },
        'zh': {
          'flappy_bird': 'Flappy Bird',
          'easy': '简单',
          'medium': '一般',
          'hard': '困难',
          'game_over': '游戏结束',
          'score': '得分',
          'difficulty': '难度',
          'restart': '重新开始',
          'back_to_difficulty_selection': '返回选择难度',
        },
      };
}
