import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
        ),
        SizedBox(height: defaultPadding),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 5,
              child: LottieBuilder.asset('android/assets/medicine4.json',fit:BoxFit.cover,animate: true),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}