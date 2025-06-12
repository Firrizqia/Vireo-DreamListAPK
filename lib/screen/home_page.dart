import 'package:flutter/material.dart';
import 'package:vireo/constants/primary_colors.dart';
import 'package:vireo/db/db_helper.dart';
import 'package:vireo/models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _user = await dbHelper.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Home Page'), backgroundColor: Colors.white),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Text('Mimpi ku', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              _buildDreamList(),
              const SizedBox(height: 20),
              Text('Diary Ku', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              _buildProgressList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo,',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        Text(
          _user?.name ?? 'Nama Pengguna',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        Text(
          _user?.motto ?? 'Satu Langkah Lebih Dekat Menuju Mimpi',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> dreams = [
    {'date': '5 Juli 2025', 'title': 'Punya Mobil Sport', 'progress': 0.6},
    {
      'date': '20 Agustus 2027',
      'title': 'Bisa Beli Rumah Cash',
      'progress': 0.4,
    },
    {
      'date': '12 Januari 2033',
      'title': 'Pergi ke Planet Mars',
      'progress': 0.1,
    },
    {'date': '21 Maret 2047', 'title': 'Pergi antar universe', 'progress': 0.0},
  ];

  Widget _buildDreamList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dreams.length,
        itemBuilder: (context, index) {
          final dream = dreams[index];
          final Color cardColor = index.isEven ? primaryColor : secondaryColor;
          return _dreamCard(
            dream['date'],
            dream['title'],
            dream['progress'],
            cardColor,
          );
        },
      ),
    );
  }

  Widget _dreamCard(String date, String title, double progress, Color color) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(date, style: TextStyle(color: Colors.white)),
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressList() {
    return Column(
      children: [
        _progressItem('12 Januari 2023', 'Bangun lebih pagi'),
        _progressItem('14 Januari 2023', 'Olahraga 30 menit'),
        _progressItem('14 Januari 2023', 'Menabung 10k Tiap Hari'),
        _progressItem('27 Maret 2023', 'Beli Emas'),
      ],
    );
  }

  Widget _progressItem(String date, String tittle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.redAccent.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.playlist_add_check_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tittle, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert),
        ],
      ),
    );
  }
}
