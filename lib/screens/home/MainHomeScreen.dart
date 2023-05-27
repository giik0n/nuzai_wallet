import 'package:exomal_wallet/screens/home/widgets/Header.dart';
import 'package:exomal_wallet/screens/home/widgets/TabSection.dart';
import 'package:flutter/material.dart';

import '../../podo/User.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({
    Key? key,
    required this.textTheme,
    required this.colorScheme,
    required this.themeData,
    required this.user,
  }) : super(key: key);

  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final ThemeData themeData;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        header(context, textTheme, colorScheme, themeData, user!),
        Expanded(child: tabSection(context, user!)),
      ],
    );
  }
}
