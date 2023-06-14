import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign Up".toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
        ),
        SizedBox(height: defaultPadding),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 6,
              child: LottieBuilder.asset('android/assets/medicine4.json',fit: BoxFit.contain),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding),
      ],
    );
  }
}
