import 'package:edumath/app/core/constants.dart';
import 'package:edumath/app/modules/challenge/ui/controllers/challenge_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lottie/lottie.dart';

import '../../challenge_module.dart';

class SucessPage extends StatelessWidget {
  final ChallengeController controller =
      ChallengeModule.to.get<ChallengeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 50),
        child: Container(
          decoration: BoxDecoration(
              color: frColor, borderRadius: BorderRadius.circular(16)),
          child: Center(
            child: Column(
              children: [
                Spacer(),
                Icon(Feather.award, color: Colors.white, size: 80),
                SizedBox(height: 30),
                Text(
                  "Parabéns",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    "Você cumpriu o desafio, não se preocupe se não acertou todas de primeira. O importante é sempre tentar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: Lottie.asset(
                    "assets/animation/sucess.json",
                    height: 100,
                    width: 100,
                    repeat: false,
                  ),
                ),
                Spacer(),
                Container(
                  height: 50,
                  width: 200,
                  child: MaterialButton(
                    color: bgColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Text("Acessar correções",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    onPressed: () {
                      Modular.to.popAndPushNamed('/resolutions',
                          arguments: controller.questions);
                    },
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
