import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Saline Detector ",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
        ),
        SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: LottieBuilder.asset('android/assets/medicine5.json'),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}