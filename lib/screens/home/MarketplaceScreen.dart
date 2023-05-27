import 'package:flutter/material.dart';

class MainMarketplaceScreen extends StatelessWidget {
  const MainMarketplaceScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/Logo.png',
            scale: 4,
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
