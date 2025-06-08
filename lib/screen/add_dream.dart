import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/db/db_helper.dart';
import 'package:vireo/models/dream_model.dart';

class AddDreamPage extends StatefulWidget {
  final Dream? existingDream;

  const AddDreamPage({super.key, this.existingDream});

  @override
  State<AddDreamPage> createState() => _AddDreamPageState();
}

class _AddDreamPageState extends State<AddDreamPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController progressController = TextEditingController();

  DateTime? selectedDate;
  double _progress = 0.0;
  List<String> progressSteps = [];

  @override
  void initState() {
    super.initState();
    final dream = widget.existingDream;
    if (dream != null) {
      _titleController.text = dream.title;
      _descController.text = dream.desc;
      selectedDate = DateFormat('d MMMM yyyy').parse(dream.date);
      progressSteps = List<String>.from(dream.steps);
      _progress = dream.progress;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _dateController.dispose();
    progressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _saveDream() async {
    if (_formKey.currentState!.validate() &&
        selectedDate != null &&
        progressSteps.isNotEmpty) {
      final formattedDate = DateFormat('d MMMM yyyy').format(selectedDate!);

      final dream = Dream(
        id: widget.existingDream?.id,
        title: _titleController.text,
        desc: _descController.text,
        date: formattedDate,
        steps: progressSteps,
        progress: _progress,
      );

      try {
        if (widget.existingDream == null) {
          await DatabaseHelper().insertDream(dream);
        } else {
          await DatabaseHelper().updateDream(dream);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan mimpi: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi semua kolom dan langkah progress'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingDream != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Mimpi" : "Tambah Mimpi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                  selectedDate == null
                      ? "Pilih Tanggal"
                      : DateFormat('d MMMM yyyy').format(selectedDate!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: progressController,
                decoration: const InputDecoration(
                  labelText: 'Tambah Langkah Progress',
                ),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      progressSteps.add(value);
                    });
                    progressController.clear();
                  }
                },
              ),
              const SizedBox(height: 12),
              if (progressSteps.isNotEmpty) ...[
                const Text(
                  "Langkah-langkah:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...progressSteps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  return ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(step),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          progressSteps.removeAt(index);
                        });
                      },
                    ),
                  );
                }),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveDream,
                child: Text(isEditing ? "Update Dream" : "Save Dream"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
