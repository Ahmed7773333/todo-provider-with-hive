import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/l_d_mode.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // Get the ThemeProvider

    Color containerColor = themeProvider.isDarkMode
        ? AppTheme.darkColor // Use dark color when the theme is dark
        : AppTheme.lightColor; // Use light color when the theme is light

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * (272 / 870),
          color: AppTheme.blueColor,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * (598 / 870),
            color: containerColor, // Use the determined color
          ),
        ),
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}
