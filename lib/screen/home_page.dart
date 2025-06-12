import 'package:flutter/material.dart';
import 'package:vireo/constants/primary_colors.dart';
import 'package:vireo/db/db_helper.dart';
import 'package:vireo/models/dream_model.dart';
import 'package:vireo/models/user_model.dart';
import 'package:vireo/screen/dreamdetail_page.dart';
import 'package:vireo/models/diary_model.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onSelengkapnyaTap;

  const HomePage({super.key, this.onSelengkapnyaTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DiaryModel> _diaries = [];
  final dbHelper = DatabaseHelper();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadDreams();
    _loadDiaries();
  }

  Future<void> _loadUserData() async {
    _user = await dbHelper.getUser();
    setState(() {});
  }

  Future<void> _loadDreams() async {
    _dreams = await dbHelper.getDreams();
    setState(() {});
  }

  Future<void> _loadDiaries() async {
    final data = await DatabaseHelper().getAllDiary();
    setState(() {
      _diaries = data;
    });
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mimpi ku',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: widget.onSelengkapnyaTap,
                    child: Text(
                      'Selengkapnya',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildDreamList(),
              const SizedBox(height: 20),
              Text('Diary Ku', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              _buildDiaryList(),
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

  List<Dream> _dreams = [];

  Widget _buildDreamList() {
    if (_dreams.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(
          "Belum ada mimpi yang kamu buat. Yuk mulai membuat mimpimu!",
          style: TextStyle(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _dreams.length > 5 ? 5 : _dreams.length,
            itemBuilder: (context, index) {
              final dream = _dreams[index];
              final Color cardColor =
                  index.isEven ? primaryColor : secondaryColor;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DreamDetailPage(dream: dream),
                    ),
                  );
                },
                child: _dreamCard(
                  dream.date,
                  dream.title,
                  dream.progress,
                  cardColor,
                ),
              );
            },
          ),
        ),
      ],
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

  Widget _buildDiaryList() {
    if (_diaries.isEmpty) {
      return Center(
        child: Text("Diary kosong", style: TextStyle(color: Colors.grey[600])),
      );
    }

    return Column(
      children:
          _diaries.map((diary) {
            return _diaryItem(diary.judul, diary.isi);
          }).toList(),
    );
  }

  Widget _diaryItem(String judul, String isi) {
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
                Text(judul, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  isi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
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
