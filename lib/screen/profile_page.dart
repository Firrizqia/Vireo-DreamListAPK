import 'package:flutter/material.dart';
import 'package:vireo/screen/edit_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditProfilePage()),
                    ),
                  ),
                  const Divider(height: 0),
                  buildMenuItem(
                    icon: Icons.info_outline,
                    label: 'Tentang Aplikasi',
                    onTap: () => showTentangAplikasiDialog(context),
                  ),
                  const SizedBox(height: 180),
                  buildLogoutButton(context),
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
      children: const [
        CircleAvatar(
          radius: 45,
          backgroundColor: Color(0xFFECECEC),
          child: Icon(Icons.person, size: 45, color: Colors.blueGrey),
        ),
        SizedBox(height: 12),
        Text(
          'Ahmad User!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          'ahmaduser@email.com',
          style: TextStyle(color: Colors.grey),
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

  Widget buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Align(
        alignment: Alignment.center,
        child: TextButton.icon(
          onPressed: () => showLogoutDialog(context),
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah kamu yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Berhasil logout')),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
