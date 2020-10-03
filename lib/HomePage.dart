import 'package:flutter/material.dart';

import 'PhotoPage.dart';
import 'VideoPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int bottomSelectedIndex = 0;
  bool nav;

  pageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        PhotoPage(),
        VideoPage(),
      ],
    );
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void _onItemTapped(index) {
    setState(() {
      pageController = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Flutter crop'),
      ),
      body: pageView(),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          onTap: (index) {
            bottomTapped(index);
            _onItemTapped(index);
          },
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          //backgroundColor: Colors.greenAccent,
          items: [
            BottomNavigationBarItem(
              icon: Tooltip(message: 'Photo', child: Icon(Icons.photo_library, color: Colors.black38,)),
              title: Text('Photo'),
              activeIcon: Tooltip(message: 'Photo', child: Icon(Icons.photo_library, color: Colors.black,)),
            ),
            BottomNavigationBarItem(
              icon: Tooltip(message: 'Video', child: Icon(Icons.video_library, color: Colors.black38,)),
              title: Text('Video'),
              activeIcon: Tooltip(message: 'Video', child: Icon(Icons.video_library, color: Colors.black,)),
            ),
          ],
          selectedItemColor: Colors.black87,
          currentIndex: bottomSelectedIndex,
        ),
      ),
    );
  }
}