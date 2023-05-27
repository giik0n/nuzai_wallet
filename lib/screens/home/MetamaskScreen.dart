import 'package:flutter/material.dart';

class MainMetamaskScreen extends StatelessWidget {
  const MainMetamaskScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/metamask_icon.png',
            scale: 7,
          ),
          SizedBox(
            height: 20,
          ),
          Text("Comming soon..."),
        ],
      ),
    );
  }
}
