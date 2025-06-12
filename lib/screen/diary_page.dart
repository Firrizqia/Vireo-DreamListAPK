import 'package:flutter/material.dart';
import 'package:vireo/constants/primary_colors.dart';
import 'package:vireo/db/db_helper.dart';
import 'package:vireo/models/diary_model.dart';
import 'package:vireo/screen/add_diary.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  List<DiaryModel> _diaries = [];

  @override
  void initState() {
    super.initState();
    _loadDiaries();
  }

  Future<void> _loadDiaries() async {
    final data = await DatabaseHelper().getAllDiary();
    setState(() {
      _diaries = data;
    });
  }

  void _navigateToAddDiary() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddDiaryPage(),
      ),
    );
    _loadDiaries();
  }

  void _navigateToEditDiary(DiaryModel diary) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddDiaryPage(diary: diary),
      ),
    );
    _loadDiaries();
  }

  Future<void> _confirmDelete(DiaryModel diary) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Diary"),
        content: const Text("Apakah Anda yakin ingin menghapus diary ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper().deleteDiary(diary.id!);
      _loadDiaries();
    }
  }

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
        child: _diaries.isEmpty
            ? const Center(
                child: Text(
                  'Diary kosong',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: _diaries.length,
                itemBuilder: (context, index) {
                  final diary = _diaries[index];
                  return GestureDetector(
                    onTap: () => _navigateToEditDiary(diary),
                    child: _DiaryItem(
                      diary: diary,
                      onDelete: () => _confirmDelete(diary),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddDiary,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _DiaryItem extends StatelessWidget {
  final DiaryModel diary;
  final VoidCallback onDelete;

  const _DiaryItem({
    required this.diary,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.4),
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  diary.judul,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  diary.isi,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
