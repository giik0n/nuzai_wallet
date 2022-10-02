import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    ColorScheme _colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('New Screen')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: _textTheme.headline4,
                text: "",
                children: [
                  TextSpan(
                      text: "C", style: TextStyle(color: _colorScheme.secondary)),
                  TextSpan(text: "urrent balance "),
                ],
              ),
            ),
            Text(
              'Wallet address',
              style: _textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
