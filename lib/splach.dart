import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/assets.dart';
import 'package:todo/widgets/bottom_bar.dart';

class SplachScreen extends StatelessWidget {
  static const String routeName = '/splach';
  const SplachScreen({super.key});

  Future<void> _navigateToHome(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed(BottomBarScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    _navigateToHome(context);

    return Scaffold(
      body: Center(
        child: Container(
          width: 189.w,
          height: 211.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.logo),
              fit: BoxFit.fill,
            ),
            border: Border.all(width: 1),
          ),
        ),
      ),
    );
  }
}
