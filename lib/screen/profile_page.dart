import 'package:flutter/material.dart';
import 'package:vireo/screen/edit_profile.dart';
import 'package:vireo/db/db_helper.dart';
import 'package:vireo/models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final dbHelper = DatabaseHelper();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await dbHelper.getUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            buildUserInfo(),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  buildMenuItem(
                    icon: Icons.edit,
                    label: 'Edit Profil',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfilePage()),
                      );
                      if (!context.mounted) return;
                      if (result == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profil berhasil diperbarui')),
                        );
                        _loadUserData();
                      }
                    },
                  ),
                  const Divider(height: 0),
                  buildMenuItem(
                    icon: Icons.info_outline,
                    label: 'Tentang Aplikasi',
                    onTap: () => showTentangAplikasiDialog(context),
                  ),
                  const SizedBox(height: 180),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserInfo() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 45,
          backgroundColor: Color(0xFFECECEC),
          child: Icon(Icons.person, size: 45, color: Colors.blueGrey),
        ),
        const SizedBox(height: 12),
        Text(
          _user?.name ?? 'Nama Pengguna',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          _user?.email ?? 'email@example.com',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void showTentangAplikasiDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: const [
            Icon(Icons.info_outline, color: Colors.blueGrey),
            SizedBox(width: 10),
            Text('Tentang Aplikasi'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Vireo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Versi 1.0.0'),
            SizedBox(height: 8),
            Text(
              'Aplikasi ini membantu Anda mengelola daftar impian, menulis jurnal harian, dan melacak progres hidup Anda dengan mudah.',
            ),
            SizedBox(height: 16),
            Text('© 2025 Vireo Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
