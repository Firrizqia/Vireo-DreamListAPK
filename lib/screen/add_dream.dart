// file: add_dream_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddDreamPage extends StatefulWidget {
  const AddDreamPage({super.key});

  @override
  State<AddDreamPage> createState() => _AddDreamPageState();
}

class _AddDreamPageState extends State<AddDreamPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String desc = '';
  DateTime? selectedDate;
  List<String> progressSteps = [];  // Menyimpan langkah-langkah kecil

  final TextEditingController progressController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Mimpi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => title = value!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                onSaved: (value) => desc = value ?? '',
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(selectedDate == null
                    ? "Tanggal"
                    : DateFormat('d MMMM yyyy').format(selectedDate!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 12),
              // Bagian Progress yang sekarang berupa langkah-langkah kecil
              TextFormField(
                controller: progressController,
                decoration: const InputDecoration(labelText: 'Tambah Progress yang harus dilakukan'),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      progressSteps.add(value); // Menambahkan langkah baru
                    });
                    progressController.clear(); // Mengosongkan input setelah ditambahkan
                  }
                },
              ),
              const SizedBox(height: 12),
              // Menampilkan langkah-langkah kecil yang telah dimasukkan
              if (progressSteps.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text("Progress Steps:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...progressSteps.map((step) => ListTile(
                      leading: const Icon(Icons.check_circle_outline),
                      title: Text(step),
                    )),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && selectedDate != null && progressSteps.isNotEmpty) {
                    _formKey.currentState!.save();
                    Navigator.pop(context, {
                      'date': DateFormat('d MMMM yyyy').format(selectedDate!),
                      'title': title,
                      'desc': desc,
                      'progress': progressSteps, // Menyimpan langkah-langkah kecil sebagai list
                    });
                  }
                },
                child: const Text("Save Dream"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
