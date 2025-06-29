import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:vireo/constants/primary_colors.dart';
import 'package:vireo/db/db_helper.dart';
import 'package:vireo/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _mottoController = TextEditingController();
  String _gender = 'Laki-laki';
  String? _imagePath;

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final user = await dbHelper.getUser();
    if (user != null) {
      setState(() {
        _nameController.text = user.name;
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _ageController.text = user.age;
        _mottoController.text = user.motto;
        _gender = user.gender;
        _imagePath = user.profileImagePath;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _imagePath = savedImage.path;
      });
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        id: 1,
        name: _nameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        age: _ageController.text,
        motto: _mottoController.text,
        gender: _gender,
        profileImagePath: _imagePath ?? '',
      );

      final existingUser = await dbHelper.getUser();

      if (existingUser == null) {
        await dbHelper.insertUser(user);
      } else {
        await dbHelper.updateUser(user);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    }
  }

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
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _imagePath != null && _imagePath!.isNotEmpty
                          ? FileImage(File(_imagePath!))
                          : null,
                  child: _imagePath == null || _imagePath!.isEmpty
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(label: 'Nama Lengkap', controller: _nameController),
              SizedBox(height: 15),
              _buildTextField(label: 'Username', controller: _usernameController),
              SizedBox(height: 15),
              _buildTextField(label: 'Motto', controller: _mottoController),
              SizedBox(height: 15),
              _buildTextField(
                label: 'Email',
                controller: _emailController,
                validator: (val) {
                  if (val == null || !val.contains('@')) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                label: 'Umur',
                controller: _ageController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                items: _genderOptions
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _gender = val!),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: _saveProfile,
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
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator ??
          (val) {
            if (val == null || val.isEmpty) return '$label tidak boleh kosong';
            return null;
          },
    );
  }
}
