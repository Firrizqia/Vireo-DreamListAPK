import 'package:flutter/material.dart';

class DreamDetailPage extends StatelessWidget {
  final String title;
  final String desc;
  final String date;
  final double progress;

  const DreamDetailPage({
    super.key,
    required this.title,
    required this.desc,
    required this.date,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: $date',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Description: $desc',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
             CheckboxListTile(
                title: Text('Bangun lebih pagi'),
                value: false, // Nilai awal checkbox
                onChanged: (bool? newValue) {
                  // Handle perubahan status checkbox
                },
              ),
              CheckboxListTile(
                title: Text('Olahraga 30 menit'),
                value: false,
                onChanged: (bool? newValue) {
                  // Handle perubahan status checkbox
                },
              ),
              CheckboxListTile(
                title: Text('Nabung'),
                value: false,
                onChanged: (bool? newValue) {
                  // Handle perubahan status checkbox
                },
              )
          ],
        ),
      ),
    );
  }
}
