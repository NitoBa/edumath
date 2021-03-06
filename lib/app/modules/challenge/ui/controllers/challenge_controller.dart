import 'package:edumath/app/modules/challenge/domain/entities/question_entity.dart';
import 'package:edumath/app/modules/challenge/domain/entities/score_entity.dart';

import 'package:edumath/app/modules/challenge/domain/usecases/get_questions.dart';
import 'package:edumath/app/modules/challenge/domain/usecases/next_question.dart';
import 'package:edumath/app/modules/challenge/domain/usecases/save_user_score.dart';
import 'package:edumath/app/modules/challenge/domain/usecases/select_asnwers.dart';
import 'package:edumath/app/modules/home/domain/entities/categories_entity.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'challenge_controller.g.dart';

@Injectable()
class ChallengeController = _ChallengeControllerBase with _$ChallengeController;

abstract class _ChallengeControllerBase with Store {
  final IGetQuestions getQuestions;
  final INextQuestion nextQuestionUseCase;
  final ISelectAsnwers selectAsnwers;
  final ISaveUserScore saveUserScore;

  _ChallengeControllerBase(this.getQuestions, this.nextQuestionUseCase,
      this.selectAsnwers, this.saveUserScore);
  @observable
  int currentQuestion = 0;

  @observable
  ObservableList<QuestionEntity> questions;

  @observable
  String timer = '00:00';

  bool _wasAnswered = false;

  @observable
  double progressTimer = 150;

  @observable
  int currentIndex;

  int _minutes = 0;
  int _seconds = 0;
  int _scoreCorrect = 0;
  int _scoreIncorrect = 0;

  String _userId = '';
  String _categorieName = '';

  @action
  goToChallenge(CategoriesEntity categorie, String userId) async {
    questions =
        await getQuestions(categorie.id).then((value) => value.asObservable());
    this._userId = userId;
    this._categorieName = categorie.title;
    Modular.link.pushReplacementNamed('/challengePage');
  }

  @action
  nextQuestion() {
    if (nextQuestionUseCase.isOver(
        questionsLenght: questions.length,
        currentQuestion: currentQuestion)) return;

    if (progressTimer > 0 && currentIndex != null) {
      currentQuestion = nextQuestionUseCase(
        questionsLenght: questions.length,
        currentQuestion: currentQuestion,
      );
    }
    _wasAnswered = false;
    currentIndex = null;
  }

  @action
  selectAnswer(int index) {
    if (progressTimer > 0 && !_wasAnswered) {
      _wasAnswered = selectAsnwers(questions[currentQuestion].anwers[index]);
      if (_wasAnswered) {
        _scoreCorrect++;
        currentIndex = index;
        _wasAnswered = true;
      } else {
        _scoreIncorrect++;
        currentIndex = index;
        _wasAnswered = true;
      }
    }
  }

  @action
  countTimer({int timeToMinutes}) async {
    var hate = _calcTimerProgress(timeToMinutes);
    _clock(timeToMinutes: timeToMinutes, hate: hate);
  }

  Future<void> _clock({int timeToMinutes, int timeSeconds, double hate}) async {
    int timeToSec;

    if (selectAsnwers.isOver(
      questionsLenght: questions.length,
      currentQuestion: currentQuestion,
      wasAnswered: _wasAnswered,
    )) {
      // Future.delayed(Duration(seconds: 1), () {
      await _saveScore();
      // });
      return;
    }

    if (timeToMinutes != null) {
      timeToSec = timeToMinutes * 60;
      progressTimer = progressTimer - hate;
    } else {
      timeToSec = timeSeconds;
      progressTimer = progressTimer - hate;
    }

    Future.delayed(
      Duration(seconds: 1),
      () {
        timeToSec--;
        if (_seconds == 0) {
          _minutes = (timeToSec / 60).floor();
        }

        _seconds = timeToSec % 60;
        timer =
            "${_minutes < 10 ? '0$_minutes' : '$_minutes'}:${_seconds < 10 ? '0$_seconds' : '$_seconds'}";

        if (timeToSec > 0 && progressTimer > 0)
          _clock(timeSeconds: timeToSec, hate: hate);
      },
    );
  }

  double _calcTimerProgress(int timeToMinutes) {
    return (150 / (timeToMinutes * 60.0));
  }

  Future<void> _saveScore() async {
    await saveUserScore(ScoreEntity(
      userId: _userId,
      categorieName: _categorieName,
      correctScore: _scoreCorrect,
      incorrectScore: _scoreIncorrect,
    ));
    Modular.to.pushReplacementNamed('challenge/sucessPage');
  }
}
