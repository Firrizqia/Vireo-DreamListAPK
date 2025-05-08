import 'package:flutter/material.dart';
import 'package:vireo/constants/primary_colors.dart';
import 'package:vireo/screen/isi_diary.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final List<Map<String, String>> _diaryEntries = const [
    {'title': 'Samle-', 'date': '8 Oktober 2025'},
    {'title': 'Shiba-', 'date': '15 Oktober 2025'},
    {'title': 'Menge- ', 'date': '20 November 2025'},
    {'title': 'Menge-', 'date': '30 November 2025'},
    {'title': 'Berke-', 'date': '15 Desember 2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Diary',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListView.builder(
          itemCount: _diaryEntries.length,
          itemBuilder: (context, index) {
            final entry = _diaryEntries[index];
            return _DiaryItem(
              title: entry['title'] ?? '',
              date: entry['date'] ?? '',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const IsiDiaryPage(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _DiaryItem extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback onTap;

  const _DiaryItem({
    required this.title,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: accentColor,
              offset: const Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DiaryInfo(title: title, date: date),
            const Icon(Icons.more_vert),
          ],
        ),
      ),
    );
  }
}

class _DiaryInfo extends StatelessWidget {
  final String title;
  final String date;

  const _DiaryInfo({
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
