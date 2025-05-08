import 'package:flutter/material.dart';
import 'package:vireo/constants/primary_colors.dart';

class IsiDiaryPage extends StatefulWidget {
  const IsiDiaryPage({super.key});

  @override
  State<IsiDiaryPage> createState() => _IsiDiaryPageState();
}

class _IsiDiaryPageState extends State<IsiDiaryPage> {
  final TextEditingController _controller = TextEditingController();

  void _simpanDiary() {
    final isi = _controller.text.trim();
    if (isi.isNotEmpty) {
      // Simulasi menyimpan diary
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dalam perbaikan')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildDiaryContainer(),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Diary',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildDiaryContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // biru muda
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(child: _buildTextField()),
          const SizedBox(height: 10),
          _buildSimpanButton(),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      maxLines: null,
      expands: true,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(fontSize: 16),
      decoration: const InputDecoration(
        hintText: 'Tulis Diary kamu',
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildSimpanButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: _simpanDiary,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Enter'),
      ),
    );
  }
}
