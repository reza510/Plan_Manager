import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'history_screen.dart';
// import 'current_program_screen.dart'; // بعداً اضافه می‌شود

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    // const CurrentProgramScreen(), // موقتاً یک صفحه placeholder
    Container(
        color: Colors.black,
        child: const Center(child: Text('برنامه جاری (به زودی)'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'خانه',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'تاریخچه',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'برنامه جاری',
          ),
        ],
      ),
    );
  }
}
