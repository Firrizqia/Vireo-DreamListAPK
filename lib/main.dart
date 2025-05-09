import 'package:flutter/material.dart';
import 'package:vireo/screen/diary_page.dart';
import 'package:vireo/screen/dream_list.dart';
import 'package:vireo/screen/home_page.dart';
import 'package:vireo/screen/profile_page.dart';
import 'package:vireo/constants/primary_colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vireo/screen/onboarding_page.dart';

// Inisialisasi plugin notifikasi
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
   
  WidgetsFlutterBinding.ensureInitialized();

  // Pengaturan awal notifikasi untuk Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_notify');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Inisialisasi plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

Future<void> showNotification() async {
  // Ambil waktu saat ini
  

  // Buat notifikasi
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Mohon Maaf',
    'Aplikasi sedang dalam pengembangan',
    platformChannelSpecifics,
  );
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      
      title: 'Vireo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
        highlightColor: Colors.transparent,
        
      ),
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  void _notifPengembang(){
    showNotification();
  }
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const DreamList(),
    const HomePage(), // Placeholder supaya indeks tetap konsisten
    const DiaryPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _showBottomDialog();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showBottomDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.auto_awesome_sharp),
                title: const Text('Add Dream'),
                onTap: () {
                  _notifPengembang();
                },
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Add Diary'),
                onTap: () {
                  _notifPengembang();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 2 ? _pages[0] : _pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),

        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          backgroundColor: Colors.grey[100],
          unselectedItemColor: Colors.grey[800],
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          showUnselectedLabels: true,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome),
              label: 'Dreams',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Diary',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
