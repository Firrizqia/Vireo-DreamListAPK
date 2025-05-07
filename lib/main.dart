import 'package:flutter/material.dart';
import 'package:vireo/screen/diary_page.dart';
import 'package:vireo/screen/dream_list.dart';
import 'package:vireo/screen/home_page.dart';
import 'package:vireo/screen/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vireo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;

  final List<Widget> _page = [
    const HomePage(),
    const DreamList(),
    const SizedBox(),
    const DiaryPage(),
    const ProfilePage()
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _showBottomDialog();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showBottomDialog(){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              ListTile(
                leading:  const Icon(Icons.auto_awesome_sharp),
                title: const Text('Add Dream'),
                onTap: () {
                  Navigator.pop(context);
                  // Add your action here
                }
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Add Diary'),
                onTap: () {
                  Navigator.pop(context);
                  // Add your action here
                }
              )
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vireo'),
      ),
      body: _page[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Dreams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
      ),
     
    );
  }
}