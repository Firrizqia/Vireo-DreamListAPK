import 'package:flutter/material.dart';
import 'package:vireo/constants/primary_colors.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Field state
  String _name = 'Ahmad User';
  String _username = 'ahmad123';
  String _email = 'ahmad@example.com';
  String _age = '25';
  String _gender = 'Laki-laki';

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan', 'Lainnya'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: 'Nama Lengkap',
                initialValue: _name,
                onSaved: (val) => _name = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              SizedBox(height: 15),
              _buildTextField(
                label: 'Username',
                initialValue: _username,
                onSaved: (val) => _username = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Username tidak boleh kosong' : null,
              ),
              SizedBox(height: 15),
              _buildTextField(
                label: 'Email',
                initialValue: _email,
                onSaved: (val) => _email = val ?? '',
                validator: (val) =>
                    val == null || !val.contains('@') ? 'Masukkan email yang valid' : null,
              ),
              SizedBox(height: 15),
              _buildTextField(
                label: 'Umur',
                initialValue: _age,
                keyboardType: TextInputType.number,
                onSaved: (val) => _age = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Umur tidak boleh kosong' : null,
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                items: _genderOptions
                    .map((gender) =>
                        DropdownMenuItem(value: gender, child: Text(gender)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _gender = val!;
                  });
                },
                onSaved: (val) => _gender = val ?? '',
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profil berhasil diperbarui')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Simpan Perubahan', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }
}
