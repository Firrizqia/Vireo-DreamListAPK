import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/constants/primary_colors.dart';
import 'package:vireo/models/diary_model.dart';
import 'package:vireo/db/db_helper.dart';

class AddDiaryPage extends StatefulWidget {
  final DiaryModel? diary;

  const AddDiaryPage({super.key, this.diary});

  @override
  State<AddDiaryPage> createState() => _AddDiaryPageState();
}

class _AddDiaryPageState extends State<AddDiaryPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool get _isEditMode => widget.diary != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _judulController.text = widget.diary!.judul;
      _isiController.text = widget.diary!.isi;
    }
  }

  void _saveDiary() async {
    final String judul = _judulController.text.trim();
    final String isi = _isiController.text.trim();

    if (judul.isEmpty && isi.isEmpty) return;

    final now = DateTime.now();
    final String tanggal = DateFormat('yyyy-MM-dd').format(now);
    final String jam = DateFormat('HH:mm').format(now);

    if (_isEditMode) {
      final updatedDiary = DiaryModel(
        id: widget.diary!.id,
        judul: judul,
        isi: isi,
        tanggal: tanggal,
        jam: jam,
      );
      await _dbHelper.updateDiary(updatedDiary);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diary berhasil diperbarui')),
      );
    } else {
      final newDiary = DiaryModel(
        judul: judul,
        isi: isi,
        tanggal: tanggal,
        jam: jam,
      );
      await _dbHelper.insertDiary(newDiary);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diary berhasil disimpan')),
      );
    }
    if (!mounted) return;
    Navigator.pop(context, true); // True menandakan ada perubahan
  }

  void _confirmDelete() async {
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
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.diary != null) {
      await _dbHelper.deleteDiary(widget.diary!.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diary dihapus')),
      );
      Navigator.pop(context, true); // Beri sinyal perubahan ke DiaryPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isEditMode ? 'Edit Diary' : 'Tambah Diary',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            color: primaryColor,
            onPressed: _saveDiary,
          ),
          if (_isEditMode)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'hapus') _confirmDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'hapus',
                  child: Text('Hapus'),
                ),
              ],
              icon: Icon(Icons.more_vert, color: primaryColor),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(
                hintText: 'Judul',
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textInputAction: TextInputAction.next,
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _isiController,
                decoration: const InputDecoration(
                  hintText: 'Tulis isi diary di sini...',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
