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
            // Tombol Back dan Edit di atas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),

            const SizedBox(height: 10),

            // Foto dan Nama
            Column(
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
            ),

            const SizedBox(height: 30),

            // Menu List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Edit Profil
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blueGrey),
                    title: const Text(
                      'Edit Profil',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditProfilePage()),
                      );
                    },
                  ),

                  const Divider(height: 0),

                  // Tentang Aplikasi
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.blueGrey),
                    title: const Text(
                      'Tentang Aplikasi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
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
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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
                    },
                  ),

                  const Divider(height: 0),

                  // Logout
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
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
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
