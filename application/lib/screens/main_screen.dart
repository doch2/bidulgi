import 'package:bidulgi/screens/show_cctv.dart';
import 'package:bidulgi/screens/home.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    List pages = [
      Home(),
      ShowCctv(),
    ];

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.withOpacity(0.6),
          selectedFontSize: 12,
          currentIndex: _selectIndex,
          onTap: (int index) {
            setState(() {
              _selectIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                label: "홈",
                icon: Icon(Icons.home_filled)
            ),
            BottomNavigationBarItem(
                label: "CCTV",
                icon: Icon(Icons.camera_alt_rounded)
            ),
          ],
        ),
        body: pages[_selectIndex]
    );
  }
}