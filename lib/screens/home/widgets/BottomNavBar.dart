import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function onItemTapped;
  const CustomBottomNavBar(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    var _selectedIndex = widget.selectedIndex;
    var _onItemTapped = widget.onItemTapped;
    ThemeData themeData = Theme.of(context);
    return new BottomNavigationBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Marketplace',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: new Image.asset(
            "assets/icons/metamask_icon.png",
            height: 20,
            width: 20,
          ),
          activeIcon: new Image.asset(
            "assets/icons/metamask_icon.png",
            height: 24,
            width: 24,
          ),
          label: 'Metamask',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: themeData.iconTheme.color,
      onTap: (index) => widget.onItemTapped(index),
    );
  }
}
