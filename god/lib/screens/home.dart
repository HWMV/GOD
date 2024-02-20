import 'package:god/screens/feed.dart';
import 'package:god/screens/myPage.dart';
import 'package:god/screens/play.dart';
import 'package:god/screens/practiceMode.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _likeCount = 5;
  int _selectedIndex = 0;

  // 바텀 네비게이션 아이템의 아이콘 및 라벨 목록
  static const List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.queue_play_next,
        color: Colors.black,
      ),
      label: 'Feed',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.play_circle,
        color: Colors.black,
      ),
      label: 'Play',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.people,
        color: Colors.black,
      ),
      label: 'Practice',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.favorite,
        color: Colors.black,
      ),
      label: 'Favorite',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {},
            ),
            Text('$_likeCount/5'),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/homeBackground.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const Center(
            child: Text('hi'),
          ),
          _getBody(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onNavBarItemTapped,
        showSelectedLabels: true, //(1)
        showUnselectedLabels: false, //(1)
      ),
    );
  }

  // 바텀 네비게이션 아이템이 탭되었을 때 호출되는 콜백 함수
  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 현재 선택된 인덱스에 따라 해당 화면을 반환
  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return const FeedScreen();
      case 1:
        return const PlayScreen();
      case 2:
        return const PracticeScreen();
      case 3:
        return const myPageScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}
