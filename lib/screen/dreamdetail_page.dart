import 'package:flutter/material.dart';
import 'package:vireo/models/dream_model.dart';
import 'package:vireo/db/db_helper.dart'; // pastikan import DB Helper

class DreamDetailPage extends StatefulWidget {
  final Dream dream;

  const DreamDetailPage({super.key, required this.dream});

  @override
  State<DreamDetailPage> createState() => _DreamDetailPageState();
}

class _DreamDetailPageState extends State<DreamDetailPage> {
  late List<bool> stepStatus;

  @override
  void initState() {
    super.initState();
    // decode step status dari progress sebelumnya (estimasi kasar: kalau 0.6 dan 5 step, berarti 3 selesai)
    int completed = (widget.dream.progress * widget.dream.steps.length).round();
    stepStatus = List<bool>.generate(widget.dream.steps.length, (i) => i < completed);
  }

  double getProgress() {
    int completed = stepStatus.where((e) => e).length;
    return stepStatus.isEmpty ? 0 : completed / stepStatus.length;
  }

  Future<void> _updateProgressInDatabase() async {
    double newProgress = getProgress();

    Dream updatedDream = Dream(
      id: widget.dream.id,
      title: widget.dream.title,
      desc: widget.dream.desc,
      date: widget.dream.date,
      steps: widget.dream.steps,
      progress: newProgress,
    );

    await DatabaseHelper().updateDream(updatedDream);
  }

  @override
  Widget build(BuildContext context) {
    final dream = widget.dream;

    return Scaffold(
      appBar: AppBar(title: Text(dream.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal: ${dream.date}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(dream.desc, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: getProgress()),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: dream.steps.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(dream.steps[index]),
                    value: stepStatus[index],
                    onChanged: (bool? value) async {
                      setState(() {
                        stepStatus[index] = value ?? false;
                      });
                      await _updateProgressInDatabase(); // simpan perubahan ke DB
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
