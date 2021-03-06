import 'package:edumath/app/modules/challenge/ui/controllers/challenge_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../../core/constants.dart';

class AlternativeWidget extends StatelessWidget {
  final ChallengeController challengeController;
  final int index;
  final Function onPressed;

  const AlternativeWidget({
    Key key,
    this.challengeController,
    this.index,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Observer(builder: (_) {
        var asnwers = challengeController
            .questions[challengeController.currentQuestion].anwers[index];
        return AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: challengeController.currentIndex == null
                ? frColor
                : index == challengeController.currentIndex &&
                        asnwers['isRight']
                    ? correctColor
                    : challengeController.currentIndex == index &&
                            !asnwers['isRight']
                        ? incorrectColor
                        : frColor,
          ),
          duration: Duration(milliseconds: 200),
          child: MaterialButton(
            minWidth: double.infinity,
            height: 60,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  asnwers['title'],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                if (challengeController.currentIndex != null)
                  Icon(
                    index == challengeController.currentIndex &&
                            asnwers['isRight']
                        ? Feather.check_square
                        : challengeController.currentIndex == index &&
                                !asnwers['isRight']
                            ? Feather.x_circle
                            : null,
                    color: Colors.white,
                  ),
              ],
            ),
            onPressed: onPressed,
          ),
        );
      }),
    );
  }
}
