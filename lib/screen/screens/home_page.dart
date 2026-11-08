import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/profile_service.dart';
import 'login_page.dart';
import '../components/role_guard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
Widget build(BuildContext context) {
  return FutureBuilder<UserProfile?>(
    future: _profileFuture,
    builder: (context, snap) {
      if (snap.connectionState != ConnectionState.done) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      final p = snap.data;
      if (snap.hasError || p == null) {
        return const Scaffold(
          body: Center(child: Text('Gagal memuat profil')),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text('KosFinder (${p.role})'),
          actions: [
            IconButton(
              tooltip: 'Logout',
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        // menu yang tampil berbeda untuk tiap role
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(p.name.isEmpty ? p.email : p.name),
              subtitle: Text('${p.email} • ${p.role}'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.list),
              title: Text('Daftar Kos'),
            ),
            if (p.isOwner || p.isAdmin)
              const ListTile(
                leading: Icon(Icons.home_work),
                title: Text('My Kos'),
              ),
            if (p.isAdmin)
              const ListTile(
                leading: Icon(Icons.admin_panel_settings),
                title: Text('Kelola Data (Admin)'),
              ),
          ],
        ),
        // tombol "Tambah Kos" hanya untuk owner/admin
        floatingActionButton: RoleGuard(
          role: p.role,
          allowed: const ['owner', 'admin'],
          child: FloatingActionButton.extended(
            onPressed: () {
              // TODO: buka halaman Add Kos
            },
            icon: const Icon(Icons.add_home),
            label: const Text('Tambah Kos'),
          ),
        ),
      );
    },
  );
}

}
